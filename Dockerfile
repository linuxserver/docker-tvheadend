FROM lsiobase/alpine:3.7

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="saarg"

# package versions
ARG ARGTABLE_VER="2.13"
ARG TZ="Europe/Oslo"
ARG XMLTV_VER="0.5.69"

# environment settings
ENV HOME="/config"

# copy patches
COPY patches/ /tmp/patches/

RUN \
 echo "**** install build packages ****" && \
 apk add --no-cache --virtual=build-dependencies \
	autoconf \
	automake \
	cmake \
	ffmpeg-dev \
	file \
	findutils \
	g++ \
	gcc \
	gettext-dev \
	git \
	libdvbcsa-dev \
	libgcrypt-dev \
	libhdhomerun-dev \
	libtool \
	libva-dev \
	libvpx-dev \
	libxml2-dev \
	libxslt-dev \
	make \
	openssl-dev \
	opus-dev \
	patch \
	pcre2-dev \
	perl-dev \
	pngquant \
	pkgconf \
	sdl-dev \
	uriparser-dev \
	wget \
	x264-dev \
	x265-dev \
	zlib-dev && \
 apk add --no-cache --virtual=build-dependencies \
	--repository http://nl.alpinelinux.org/alpine/edge/testing \
	gnu-libiconv-dev && \
 echo "**** install runtime packages ****" && \
 apk add --no-cache \
	bsd-compat-headers \
	bzip2 \
	curl \
	ffmpeg \
	ffmpeg-libs \
	gzip \
	libcrypto1.0 \
	libcurl \
	libdvbcsa \
	libhdhomerun-libs \
	libssl1.0 \
	libva \
	libva-intel-driver \
	libvpx \
	libxml2 \
	libxslt \
	linux-headers \
	openssl \
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
	--repository http://nl.alpinelinux.org/alpine/edge/testing \
	gnu-libiconv && \
 echo "**** install perl modules for xmltv ****" && \
 curl -L http://cpanmin.us | perl - App::cpanminus && \
 cpanm --installdeps /tmp/patches && \
 echo "**** remove musl iconv.h and replace with gnu-iconv.h ****" && \
 rm -rf /usr/include/iconv.h && \
 cp /usr/include/gnu-libiconv/iconv.h /usr/include/iconv.h && \
 echo "**** build tvheadend ****" && \
 git clone https://github.com/tvheadend/tvheadend.git /tmp/tvheadend && \
 cd /tmp/tvheadend && \
 ./configure \
	`#Encoding` \
	--disable-ffmpeg_static \
	--disable-libfdkaac_static \
	--disable-libtheora_static \
	--disable-libopus_static \
	--disable-libvorbis_static \
	--disable-libvpx_static \
	--disable-libx264_static \
	--disable-libx265_static \
	--disable-libfdkaac \
	--enable-libopus \
	--enable-libvorbis \
	--enable-libvpx \
	--enable-libx264 \
	--enable-libx265 \
	\
	`#Options` \
	--disable-avahi \
	--disable-dbus_1 \
	--disable-bintray_cache \
	--disable-hdhomerun_static \
	--enable-hdhomerun_client \
	--enable-libav \
	--enable-pngquant \
	--enable-trace \
	--enable-vaapi \
	--infodir=/usr/share/info \
	--localstatedir=/var \
	--mandir=/usr/share/man \
	--prefix=/usr \
	--sysconfdir=/config && \
 make && \
 make install && \
 echo "**** build XMLTV ****" && \
 curl -o \
 /tmp/xmtltv-src.tar.bz2 -L \
	"https://sourceforge.net/projects/xmltv/files/xmltv/${XMLTV_VER}/xmltv-${XMLTV_VER}.tar.bz2" && \
 tar xf \
 /tmp/xmtltv-src.tar.bz2 -C \
	/tmp --strip-components=1 && \
 cd "/tmp/xmltv-${XMLTV_VER}" && \
 echo "**** Perl 5.26 fixes for XMTLV ****" && \
 sed "s/use POSIX 'tmpnam';//" -i filter/tv_to_latex && \
 sed "s/use POSIX 'tmpnam';//" -i filter/tv_to_text && \
 sed "s/\(lib\/set_share_dir.pl';\)/.\/\1/" -i grab/it/tv_grab_it.PL && \
 sed "s/\(filter\/Grep.pm';\)/.\/\1/" -i filter/tv_grep.PL && \
 sed "s/\(lib\/XMLTV.pm.in';\)/.\/\1/" -i lib/XMLTV.pm.PL && \
 sed "s/\(lib\/Ask\/Term.pm';\)/.\/\1/" -i Makefile.PL && \
 PERL5LIB=`pwd` && \
 echo -e "yes" | perl Makefile.PL PREFIX=/usr/ INSTALLDIRS=vendor && \
 make && \
 make test && \
 make install && \
 echo "**** build argtable2 ****" && \
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
 make && \
 make check && \
 make install && \
 echo "***** build comskip ****" && \
 git clone git://github.com/erikkaashoek/Comskip /tmp/comskip && \
 cd /tmp/comskip && \
 ./autogen.sh && \
 ./configure \
	--bindir=/usr/bin \
	--sysconfdir=/config/comskip && \
 make && \
 make install && \
 echo "***** cleanup ****" && \
 apk del --purge \
	build-dependencies && \
 rm -rf \
	/config/.cpanm \
	/tmp/*

# copy local files
COPY root/ /

# add picons
ADD picons.tar.bz2 /picons

# ports and volumes
EXPOSE 9981 9982
VOLUME /config /recordings
