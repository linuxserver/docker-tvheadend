[linuxserverurl]: https://linuxserver.io
[forumurl]: https://forum.linuxserver.io
[ircurl]: https://www.linuxserver.io/irc/
[podcasturl]: https://www.linuxserver.io/podcast/
[appurl]: https://www.tvheadend.org/
[hub]: https://hub.docker.com/r/linuxserver/tvheadend/

[![linuxserver.io](https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/linuxserver_medium.png)][linuxserverurl]

The [LinuxServer.io][linuxserverurl] team brings you another container release featuring easy user mapping and community support. Find us for support at:
* [forum.linuxserver.io][forumurl]
* [IRC][ircurl] on freenode at `#linuxserver.io`
* [Podcast][podcasturl] covers everything to do with getting the most from your Linux Server plus a focus on all things Docker and containerisation!

# linuxserver/tvheadend
[![](https://images.microbadger.com/badges/version/linuxserver/tvheadend.svg)](https://microbadger.com/images/linuxserver/tvheadend "Get your own version badge on microbadger.com")[![](https://images.microbadger.com/badges/image/linuxserver/tvheadend.svg)](https://microbadger.com/images/linuxserver/tvheadend "Get your own image badge on microbadger.com")[![Docker Pulls](https://img.shields.io/docker/pulls/linuxserver/tvheadend.svg)][hub][![Docker Stars](https://img.shields.io/docker/stars/linuxserver/tvheadend.svg)][hub][![Build Status](https://ci.linuxserver.io/buildStatus/icon?job=Docker-Builders/x86-64/x86-64-tvheadend)](https://ci.linuxserver.io/job/Docker-Builders/job/x86-64/job/x86-64-tvheadend/)

[Tvheadend](https://www.tvheadend.org/) is a TV streaming server and recorder for Linux, FreeBSD and Android supporting DVB-S, DVB-S2, DVB-C, DVB-T, ATSC, ISDB-T, IPTV, SAT>IP and HDHomeRun as input sources.
Tvheadend offers the HTTP (VLC, MPlayer), HTSP (Kodi, Movian) and SAT>IP streaming.
Multiple EPG sources are supported (over-the-air DVB and ATSC including OpenTV DVB extensions, XMLTV, PyXML).

[![tvheadend](https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/tvheadend-big.png)][appurl]

## Usage

```
docker create \
  --name=tvheadend \
  --net=bridge \
  -v <path to data>:/config \
  -v <path to recordings>:/recordings \
  -e PGID=<gid> -e PUID=<uid>  \
  -e RUN_OPTS=<parameter> \
  -p 9981:9981 \
  -p 9982:9982 \
  --device=/dev/dvb
  linuxserver/tvheadend
```
The --device=/dev/dvb is only needed if you want to pass through a DVB card to the container. If you use IPTV or HDHomeRun you can leave it out.


You can choose between ,using tags, latest (default, and no tag required or a specific release branch of tvheadend.

Add one of the tags, if required, to the linuxserver/tvheadend line of the run/create command in the following format, linuxserver/tvheadend:release-4.2

#### Tags

+ **release-4.2** : latest release from 4.2 branch. Freshly built every friday night uk time.
+ **stable-4.2.1** : old stable version. Will not be updated anymore!
+ **stable-4.0.9** : old stable version. Will not be updated anymore!

#### Host vs. Bridge

If you use IPTV, SAT>IP or HDHomeRun, you need to create the container with --net=host and remove the -p flags. This is because of a limitation in docker and multicast.

## Parameters

`The parameters are split into two halves, separated by a colon, the left hand side representing the host and the right the container side. 
For example with a port -p external:internal - what this shows is the port mapping from internal to external of the container.
So -p 8080:80 would expose port 80 from inside the container to be accessible from the host's IP on port 8080
http://192.168.x.x:8080 would show you what's running INSIDE the container on port 80.`


* `-p 1234` - the port(s)
* `-v /config` - Where TVHeadend show store it's config files
* `-v /recordings` - Where you want the PVR to store recordings
* `-e PGID` for GroupID - see below for explanation
* `-e PUID` for UserID - see below for explanation
* `-e RUN_OPTS` additional runtime parameters - see below for explanation
* `--device=/dev/dvb` - for passing through DVB-cards
* `--net=host` - for IPTV, SAT>IP and HDHomeRun
* `-e TZ` - for timezone information *eg Europe/London, etc*

It is based on alpine linux with s6 overlay, for shell access whilst the container is running do `docker exec -it tvheadend /bin/bash`.

### User / Group Identifiers

Sometimes when using data volumes (`-v` flags) permissions issues can arise between the host OS and the container. We avoid this issue by allowing you to specify the user `PUID` and group `PGID`. Ensure the data volume directory on the host is owned by the same user you specify and it will "just work" ™.

In this instance `PUID=1001` and `PGID=1001`. To find yours use `id user` as below:

```
  $ id <dockeruser>
    uid=1001(dockeruser) gid=1001(dockergroup) groups=1001(dockergroup)
```

## Additional runtime parameters

In some cases it might be necessary to start tvheadend with additional parameters, for example to enable debugging or specify webroot for reverse proxy. Be sure to have the right parameters set, as adding the wrong once might lead to the container not starting correctly.


## Setting up the application

The setup depends if you run the one of the stable tags or use latest. Running latest is the easiest as it has a setup wizard.

**Stable**

First thing to do is to go to Configuration --> DVB Inputs --> TV adapters and add your LNB/switch info. Then create a new network in the Networks tab and set the correct pre-defined muxes and orbital position.
Go back to the TV adapters tab and add the newly created network under universal LNB. Go back to the Networks tab and mark the network you created earlier and press the Force Scan button. Tvheadend will now scan the muxes for services.

After the scan is done, head to the Services tab and find the services you want as channels, mark them, and press map services. They should now appear under Configuration --> Channel/EPG.

**Latest**

The first thing to do is to run the setup wizard. If it doesn't pop up at first login, you can find it in Configuration --> General --> Base and click Start Wizard. This will guide you to set up the basic parts of tvheadend.

**Configuring XMLTV grabber**

To configure the XMLTV grabber, first check if your grabber is listed in Configuration --> Channel/EPG --> EPG Grabber Modules. If it's listed, you will have to configure the grabber before enabling.
Find the path in the path field of your grabber. We will use the last part. It starts with tv_grab_. Add it after /usr/bin/ in the below command. There should be no space between Usr/bin/ and the part you added. 

```
docker exec -it -u abc tvheadend /usr/bin/for_you_to_fill_out --configure
```

Now follow the onscreen progress. If you get asked about cache, just accept the default. After you have configured your grabber, you can go back and enable your grabber.

If you allready have a configuration file, you can add it in the .xmltv folder where you mapped the /config volume. If it's not created, create it.

**Comskip**
This container comes with Comskip for commercial flagging of recordings. This you have to add in the recording config of tvheadend.
Go to Configuration --> Recording. Change the view level to advanced in the top right corner, and add the below in the Post-processor command field.

```
/usr/bin/comskip --ini=/config/comskip/comskip.ini "%f"
```

Now comskip will run after each recording is finished. You will find comskip.ini in the comskip folder of your /config volume mapping. See the [Comskip](http://www.kaashoek.com/comskip/) homepage for tuning of the ini file.


**FFmpeg**

FFmpeg is installed in /usr/bin/ in case you need to use it with pipe.

**EPG XML file**

If you have EPG data in XML format from a supplier, you can drop it in the data folder of your /config volume mapping. If it doesn't exist, create it. Then choose the XML file grabber in Configuration --> Channel/EPG --> EPG Grabber Modules.
If you use WebGrab+Plus, choose the WebGrab+Plus XML file grabber. The XML file goes in the same path as above.
The xml file has to be named guide.xml.

For advanced setup of tvheadend, go to [Tvheadend][appurl]

**Picons**

We have added all the picons from [picons.xyz](https://picons.xyz/) in the folder /picons. To enable the use of these picons, add the path to the Channel icon path in Configuration --> General --> Base.
You need to enable minimum advanced view level to see the picons options.

## Info

* Shell access whilst the container is running: `docker exec -it tvheadend /bin/bash`
* To monitor the logs of the container in realtime: `docker logs -f tvheadend`

* container version number 

`docker inspect -f '{{ index .Config.Labels "build_version" }}' tvheadend`

* image version number

`docker inspect -f '{{ index .Config.Labels "build_version" }}' linuxserver/tvheadend`

## Versions

+ **04.01.18:** Deprecate cpu_core routine lack of scaling.
+ **11.12.17:** Rebase to alpine 3.7, linting fixes.
+ **02.09.17:** Add codec dependencies.
+ **13.07.17:** Increase uniformity across all archs.
+ **08.07.17:** Update README with full path for comskip.
+ **02.07.17:** Move to one branch for all 4.2 releases.
+ **27.05.17:** Rebase to alpine 3.6.
+ **01.05.17:** Update to tvheadend 4.2.1 stable.
+ **18.04.17:** Use repo version of gnu-libiconv rather than compiling.
+ **09.04.17:** Chain cpanm installs in one block and use --installdeps.
+ **09.02.17:** Perl changes, add picons file to gitignore and update XMLTV to 0.5.69.
+ **07.02.17:** Add variable to add additional runtime paramters.
+ **05.02.17:** Update to alpine 3.5 and change dvb-apps to only compile needed libs.
+ **14.11.16:** Add picons from picons.xyz to /picons folder and add info to README.
+ **22.09.16:** Fix broken tv_grab_wg, libs for xmltv and update README.
+ **18.09.16:** Update XMLTV to 0.5.68 and update README.
+ **10.09.16:** Add layer badges to README.
+ **05.09.16:** Initial release.
