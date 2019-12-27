FROM lsiobase/alpine:3.10 as buildstage
############## build stage ##############

# package versions
ARG ARGTABLE_VER="2.13"
ARG TVH_VER="release/4.2"
ARG XMLTV_VER="v0.6.1"
ARG TVHEADEND_COMMIT

# environment settings
ARG TZ="Europe/Oslo"
ENV HOME="/config"

# copy patches
COPY patches/ /tmp/patches/

RUN \
 echo "**** install build packages ****" && \
 apk add --no-cache \
	autoconf \
	automake \
	bsd-compat-headers \
	bzip2 \
	cmake \
	curl \
	ffmpeg-dev \
	file \
	findutils \
	g++ \
	gcc \
	gettext-dev \
	git \
	gzip \
	jq \
	libgcrypt-dev \
	libhdhomerun-dev \
	libressl-dev \
	libtool \
	libvpx-dev \
	libxml2-dev \
	libxslt-dev \
	linux-headers \
	make \
	mercurial \
	opus-dev \
	patch \
	pcre2-dev \
	perl-archive-zip \
	perl-boolean \
	perl-capture-tiny \
	perl-cgi \
	perl-compress-raw-zlib \
	perl-data-dumper \
	perl-date-manip \
	perl-datetime \
	perl-datetime-format-strptime \
	perl-datetime-timezone \
	perl-dbd-sqlite \
	perl-dbi \
	perl-dev \
	perl-digest-sha1 \
	perl-doc \
	perl-file-slurp \
	perl-file-temp \
	perl-file-which \
	perl-getopt-long \
	perl-html-parser \
	perl-html-tree \
	perl-http-cookies \
	perl-io \
	perl-io-compress \
	perl-io-html \
	perl-io-socket-ssl \
	perl-io-stringy \
	perl-json \
	perl-libwww \
	perl-lingua-en-numbers-ordinate \
	perl-lingua-preferred \
	perl-list-moreutils \
	perl-module-build \
	perl-module-pluggable \
	perl-net-ssleay \
	perl-parse-recdescent \
	perl-path-class \
	perl-scalar-list-utils \
	perl-term-progressbar \
	perl-term-readkey \
	perl-test-exception \
	perl-test-requires \
	perl-timedate \
	perl-try-tiny \
	perl-unicode-string \
	perl-xml-libxml \
	perl-xml-libxslt \
	perl-xml-parser \
	perl-xml-sax \
	perl-xml-treepp \
	perl-xml-twig \
	perl-xml-writer \
	pkgconf \
	pngquant \
	python \
	sdl-dev \
	tar \
	uriparser-dev \
	wget \
	x264-dev \
	x265-dev \
	zlib-dev && \
 apk add --no-cache \
	--repository http://dl-cdn.alpinelinux.org/alpine/edge/community \
	gnu-libiconv-dev

RUN \
 echo "**** remove musl iconv.h and replace with gnu-iconv.h ****" && \
 rm -rf /usr/include/iconv.h && \
 cp /usr/include/gnu-libiconv/iconv.h /usr/include/iconv.h

RUN \
 echo "**** install perl modules for xmltv ****" && \
 curl -L http://cpanmin.us | perl - App::cpanminus && \
 cpanm --installdeps /tmp/patches

RUN \
 echo "**** compile XMLTV ****" && \
 git clone https://github.com/XMLTV/xmltv.git /tmp/xmltv && \
 cd /tmp/xmltv && \
 git checkout ${XMLTV_VER} && \
 echo "**** fix test for xmltv alpine 3.11 ****" && \
 patch -p1 -i /tmp/patches/test_tv_imdb.t.patch && \
 echo "**** Perl 5.26 fixes for XMTLV ****" && \
 sed "s/use POSIX 'tmpnam';//" -i filter/tv_to_latex && \
 sed "s/use POSIX 'tmpnam';//" -i filter/tv_to_text && \
 sed "s/\(lib\/set_share_dir.pl';\)/.\/\1/" -i grab/it/tv_grab_it.PL && \
 sed "s/\(filter\/Grep.pm';\)/.\/\1/" -i filter/tv_grep.PL && \
 sed "s/\(lib\/XMLTV.pm.in';\)/.\/\1/" -i lib/XMLTV.pm.PL && \
 sed "s/\(lib\/Ask\/Term.pm';\)/.\/\1/" -i Makefile.PL && \
 PERL5LIB=`pwd` && \
 echo -e "yes" | perl Makefile.PL PREFIX=/usr/ INSTALLDIRS=vendor && \
 make -j 2 && \
 make test && \
 make DESTDIR=/tmp/xmltv-build install

RUN \
 echo "**** compile dvb-apps ****" && \
 hg clone http://linuxtv.org/hg/dvb-apps /tmp/dvb-apps && \
 cd /tmp/dvb-apps && \
 make -C lib && \
 make -C lib DESTDIR=/tmp/dvbapps-build install && \
 cp -pr /tmp/dvbapps-build/usr/* /usr/

RUN \
 echo "**** compile tvheadend ****" && \
 if [ -z ${TVHEADEND_COMMIT+x} ]; then \
	TVHEADEND_COMMIT=$(curl -sX GET https://api.github.com/repos/tvheadend/tvheadend/commits/${TVH_VER} \
	| jq -r '. | .sha'); \
 fi && \
 mkdir -p \
        /tmp/tvheadend && \
 git clone https://github.com/tvheadend/tvheadend.git /tmp/tvheadend && \
 cd /tmp/tvheadend && \
 git checkout ${TVHEADEND_COMMIT} && \
 ./configure \
	--disable-avahi \
	--disable-bintray_cache \
	--disable-dbus_1 \
	--disable-ffmpeg_static \
	--disable-hdhomerun_static \
	--disable-libfdkaac_static \
	--disable-libmfx_static \
	--disable-libtheora_static \
	--disable-libvorbis_static \
	--disable-libvpx_static \
	--disable-libx264_static \
	--disable-libx265_static \
	--enable-hdhomerun_client \
	--enable-libav \
	--enable-pngquant \
	--infodir=/usr/share/info \
	--localstatedir=/var \
	--mandir=/usr/share/man \
	--prefix=/usr \
	--sysconfdir=/config && \
 make -j 2 && \
 make DESTDIR=/tmp/tvheadend-build install

RUN \
 echo "**** compile argtable2 ****" && \
 ARGTABLE_VER1="${ARGTABLE_VER//./-}" && \
 mkdir -p \
	/tmp/argtable && \
 curl -o \
 /tmp/argtable-src.tar.gz -L \
	"https://sourceforge.net/projects/argtable/files/argtable/argtable-${ARGTABLE_VER}/argtable${ARGTABLE_VER1}.tar.gz" && \
 tar xf \
 /tmp/argtable-src.tar.gz -C \
	/tmp/argtable --strip-components=1 && \
 cp /tmp/patches/config.* /tmp/argtable && \
 cd /tmp/argtable && \
 ./configure \
	--prefix=/usr && \
 make -j 2 && \
 make check && \
 make DESTDIR=/tmp/argtable-build install && \
 echo "**** copy to /usr for comskip dependency ****" && \
 cp -pr /tmp/argtable-build/usr/* /usr/

RUN \
 echo "***** compile comskip ****" && \
 git clone git://github.com/erikkaashoek/Comskip /tmp/comskip && \
 cd /tmp/comskip && \
 ./autogen.sh && \
 ./configure \
	--bindir=/usr/bin \
	--sysconfdir=/config/comskip && \
 make -j 2 && \
 make DESTDIR=/tmp/comskip-build install

############## runtime stage ##############
FROM lsiobase/alpine:3.10

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="saarg"

# environment settings
ENV HOME="/config"

RUN \
 echo "**** install runtime packages ****" && \
 apk add --no-cache \
	bsd-compat-headers \
	bzip2 \
	curl \
	ffmpeg \
	ffmpeg-libs \
	gzip \
	libcrypto1.1 \
	libcurl	\
	libhdhomerun-libs \
	libressl \
	libssl1.1 \
	libvpx \
	libxml2 \
	libxslt \
	linux-headers \
	opus \
	pcre2 \
	perl \
	perl-archive-zip \
	perl-boolean \
	perl-capture-tiny \
	perl-cgi \
	perl-compress-raw-zlib \
	perl-data-dumper \
	perl-date-manip \
	perl-datetime \
	perl-datetime-format-strptime \
	perl-datetime-timezone \
	perl-dbd-sqlite \
	perl-dbi \
	perl-digest-sha1 \
	perl-doc \
	perl-file-slurp \
	perl-file-temp \
	perl-file-which \
	perl-getopt-long \
	perl-html-parser \
	perl-html-tree \
	perl-http-cookies \
	perl-io \
	perl-io-compress \
	perl-io-html \
	perl-io-socket-ssl \
	perl-io-stringy \
	perl-json \
	perl-libwww \
	perl-lingua-en-numbers-ordinate \
	perl-lingua-preferred \
	perl-list-moreutils \
	perl-module-build \
	perl-module-pluggable \
	perl-net-ssleay \
	perl-parse-recdescent \
	perl-path-class \
	perl-scalar-list-utils \
	perl-term-progressbar \
	perl-term-readkey \
	perl-test-exception \
	perl-test-requires \
	perl-timedate \
	perl-try-tiny \
	perl-unicode-string \
	perl-xml-libxml \
	perl-xml-libxslt \
	perl-xml-parser \
	perl-xml-sax \
	perl-xml-treepp \
	perl-xml-twig \
	perl-xml-writer \
	python \
	tar \
	uriparser \
	wget \
	x264 \
	x265 \
	zlib && \
 apk add --no-cache \
	--repository http://dl-cdn.alpinelinux.org/alpine/edge/community \
	gnu-libiconv && \
 echo "**** Add Picons ****" && \
 mkdir -p /picons && \
 curl -o \
        /picons.tar.bz2 -L \
        https://lsio-ci.ams3.digitaloceanspaces.com/picons/picons.tar.bz2

# copy local files and buildstage artifacts
COPY --from=buildstage /tmp/argtable-build/usr/ /usr/
COPY --from=buildstage /tmp/comskip-build/usr/ /usr/
COPY --from=buildstage /tmp/dvbapps-build/usr/ /usr/
COPY --from=buildstage /tmp/tvheadend-build/usr/ /usr/
COPY --from=buildstage /tmp/xmltv-build/usr/ /usr/
COPY --from=buildstage /usr/local/share/man/ /usr/local/share/man/
COPY --from=buildstage /usr/local/share/perl5/ /usr/local/share/perl5/
COPY root/ /

# ports and volumes
EXPOSE 9981 9982
VOLUME /config /recordings
