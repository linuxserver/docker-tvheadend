[![linuxserver.io](https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/linuxserver_medium.png)](https://linuxserver.io)

[![Blog](https://img.shields.io/static/v1.svg?style=flat-square&color=E68523&label=linuxserver.io&message=Blog)](https://blog.linuxserver.io "all the things you can do with our containers including How-To guides, opinions and much more!")
[![Discord](https://img.shields.io/discord/354974912613449730.svg?style=flat-square&color=E68523&label=Discord&logo=discord&logoColor=FFFFFF)](https://discord.gg/YWrKVTn "realtime support / chat with the community and the team.")
[![Discourse](https://img.shields.io/discourse/https/discourse.linuxserver.io/topics.svg?style=flat-square&color=E68523&logo=discourse&logoColor=FFFFFF)](https://discourse.linuxserver.io "post on our community forum.")
[![Fleet](https://img.shields.io/static/v1.svg?style=flat-square&color=E68523&label=linuxserver.io&message=Fleet)](https://fleet.linuxserver.io "an online web interface which displays all of our maintained images.")
[![Podcast](https://img.shields.io/static/v1.svg?style=flat-square&color=E68523&label=linuxserver.io&message=Podcast)](https://anchor.fm/linuxserverio "on hiatus. Coming back soon (late 2018).")
[![Open Collective](https://img.shields.io/opencollective/all/linuxserver.svg?style=flat-square&color=E68523&label=Open%20Collective%20Supporters)](https://opencollective.com/linuxserver "please consider helping us by either donating or contributing to our budget")

The [LinuxServer.io](https://linuxserver.io) team brings you another container release featuring :-

 * regular and timely application updates
 * easy user mappings (PGID, PUID)
 * custom base image with s6 overlay
 * weekly base OS updates with common layers across the entire LinuxServer.io ecosystem to minimise space usage, down time and bandwidth
 * regular security updates

Find us at:
* [Blog](https://blog.linuxserver.io) - all the things you can do with our containers including How-To guides, opinions and much more!
* [Discord](https://discord.gg/YWrKVTn) - realtime support / chat with the community and the team.
* [Discourse](https://discourse.linuxserver.io) - post on our community forum.
* [Fleet](https://fleet.linuxserver.io) - an online web interface which displays all of our maintained images.
* [Podcast](https://anchor.fm/linuxserverio) - on hiatus. Coming back soon (late 2018).
* [Open Collective](https://opencollective.com/linuxserver) - please consider helping us by either donating or contributing to our budget

# [linuxserver/tvheadend](https://github.com/linuxserver/docker-tvheadend)
[![GitHub Release](https://img.shields.io/github/release/linuxserver/docker-tvheadend.svg?style=flat-square&color=E68523)](https://github.com/linuxserver/docker-tvheadend/releases)
[![MicroBadger Layers](https://img.shields.io/microbadger/layers/linuxserver/tvheadend.svg?style=flat-square&color=E68523)](https://microbadger.com/images/linuxserver/tvheadend "Get your own version badge on microbadger.com")
[![MicroBadger Size](https://img.shields.io/microbadger/image-size/linuxserver/tvheadend.svg?style=flat-square&color=E68523)](https://microbadger.com/images/linuxserver/tvheadend "Get your own version badge on microbadger.com")
[![Docker Pulls](https://img.shields.io/docker/pulls/linuxserver/tvheadend.svg?style=flat-square&color=E68523)](https://hub.docker.com/r/linuxserver/tvheadend)
[![Docker Stars](https://img.shields.io/docker/stars/linuxserver/tvheadend.svg?style=flat-square&color=E68523)](https://hub.docker.com/r/linuxserver/tvheadend)
[![Build Status](https://ci.linuxserver.io/view/all/job/Docker-Pipeline-Builders/job/docker-tvheadend/job/master/badge/icon?style=flat-square)](https://ci.linuxserver.io/job/Docker-Pipeline-Builders/job/docker-tvheadend/job/master/)
[![](https://lsio-ci.ams3.digitaloceanspaces.com/linuxserver/tvheadend/latest/badge.svg)](https://lsio-ci.ams3.digitaloceanspaces.com/linuxserver/tvheadend/latest/index.html)

[Tvheadend](https://www.tvheadend.org/) works as a proxy server: is a TV streaming server and recorder for Linux, FreeBSD and Android supporting DVB-S, DVB-S2, DVB-C, DVB-T, ATSC, ISDB-T, IPTV, SAT>IP and HDHomeRun as input sources.
Tvheadend offers the HTTP (VLC, MPlayer), HTSP (Kodi, Movian) and SAT>IP streaming.
Multiple EPG sources are supported (over-the-air DVB and ATSC including OpenTV DVB extensions, XMLTV, PyXML).


[![tvheadend](https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/tvheadend-big.png)](https://www.tvheadend.org/)

## Supported Architectures

Our images support multiple architectures such as `x86-64`, `arm64` and `armhf`. We utilise the docker manifest for multi-platform awareness. More information is available from docker [here](https://github.com/docker/distribution/blob/master/docs/spec/manifest-v2-2.md#manifest-list) and our announcement [here](https://blog.linuxserver.io/2019/02/21/the-lsio-pipeline-project/).

Simply pulling `linuxserver/tvheadend` should retrieve the correct image for your arch, but you can also pull specific arch images via tags.

The architectures supported by this image are:

| Architecture | Tag |
| :----: | --- |
| x86-64 | amd64-latest |
| arm64 | arm64v8-latest |
| armhf | arm32v7-latest |

## Version Tags

This image provides various versions that are available via tags. `latest` tag usually provides the latest stable version. Others are considered under development and caution must be exercised when using them.

| Tag | Description |
| :----: | --- |
| latest | Current latest release. |
| release-4.2 | Latest release from 4.2 branch. |
| stable-4.2.1 | Old stable version. Will not be updated anymore! |
| stable-4.0.9 | Old stable version. Will not be updated anymore! |

## Usage

Here are some example snippets to help you get started creating a container.

### docker

```
docker create \
  --name=tvheadend \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Europe/London \
  -e RUN_OPTS=<run options here> `#optional` \
  -p 9981:9981 \
  -p 9982:9982 \
  -v <path to data>:/config \
  -v <path to recordings>:/recordings \
  --device /dev/dri:/dev/dri `#optional` \
  --device /dev/dvb:/dev/dvb `#optional` \
  --restart unless-stopped \
  linuxserver/tvheadend
```

#### Host vs. Bridge

If you use IPTV, SAT>IP or HDHomeRun, you need to create the container with --net=host and remove the -p flags. This is because to work with these services Tvheadend requires a multicast address of `239.255.255.250` and a UDP port of `1900` which at this time is not possible with docker bridge mode.
If you have other host services which also use multicast such as SSDP/DLNA/Emby you may experience stabilty problems. These can be solved by giving tvheadend its own IP using macavlan.


### docker-compose

Compatible with docker-compose v2 schemas.

```
---
version: "2"
services:
  tvheadend:
    image: linuxserver/tvheadend
    container_name: tvheadend
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Europe/London
      - RUN_OPTS=<run options here> #optional
    volumes:
      - <path to data>:/config
      - <path to recordings>:/recordings
    ports:
      - 9981:9981
      - 9982:9982
    devices:
      - /dev/dri:/dev/dri #optional
      - /dev/dvb:/dev/dvb #optional
    restart: unless-stopped
```

## Parameters

Container images are configured using parameters passed at runtime (such as those above). These parameters are separated by a colon and indicate `<external>:<internal>` respectively. For example, `-p 8080:80` would expose port `80` from inside the container to be accessible from the host's IP on port `8080` outside the container.

| Parameter | Function |
| :----: | --- |
| `-p 9981` | WebUI |
| `-p 9982` | HTSP server port. |
| `-e PUID=1000` | for UserID - see below for explanation |
| `-e PGID=1000` | for GroupID - see below for explanation |
| `-e TZ=Europe/London` | Specify a timezone to use EG Europe/London. |
| `-e RUN_OPTS=<run options here>` | Optionally specify additional arguments to be passed. See Additional runtime parameters. |
| `-v /config` | Where TVHeadend show store it's config files. |
| `-v /recordings` | Where you want the PVR to store recordings. |
| `--device /dev/dri` | Only needed if you want to use your AMD/Intel GPU for hardware accelerated video encoding (vaapi). |
| `--device /dev/dvb` | Only needed if you want to pass through a DVB card to the container. If you use IPTV or HDHomeRun you can leave it out. |

## User / Group Identifiers

When using volumes (`-v` flags) permissions issues can arise between the host OS and the container, we avoid this issue by allowing you to specify the user `PUID` and group `PGID`.

Ensure any volume directories on the host are owned by the same user you specify and any permissions issues will vanish like magic.

In this instance `PUID=1000` and `PGID=1000`, to find yours use `id user` as below:

```
  $ id username
    uid=1000(dockeruser) gid=1000(dockergroup) groups=1000(dockergroup)
```


&nbsp;
## Application Setup

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

## Additional runtime parameters

In some cases it might be necessary to start tvheadend with additional parameters, for example to enable debugging or specify webroot for reverse proxy. Be sure to have the right parameters set, as adding the wrong once might lead to the container not starting correctly.



## Support Info

* Shell access whilst the container is running: `docker exec -it tvheadend /bin/bash`
* To monitor the logs of the container in realtime: `docker logs -f tvheadend`
* container version number
  * `docker inspect -f '{{ index .Config.Labels "build_version" }}' tvheadend`
* image version number
  * `docker inspect -f '{{ index .Config.Labels "build_version" }}' linuxserver/tvheadend`

## Updating Info

Most of our images are static, versioned, and require an image update and container recreation to update the app inside. With some exceptions (ie. nextcloud, plex), we do not recommend or support updating apps inside the container. Please consult the [Application Setup](#application-setup) section above to see if it is recommended for the image.

Below are the instructions for updating containers:

### Via Docker Run/Create
* Update the image: `docker pull linuxserver/tvheadend`
* Stop the running container: `docker stop tvheadend`
* Delete the container: `docker rm tvheadend`
* Recreate a new container with the same docker create parameters as instructed above (if mapped correctly to a host folder, your `/config` folder and settings will be preserved)
* Start the new container: `docker start tvheadend`
* You can also remove the old dangling images: `docker image prune`

### Via Docker Compose
* Update all images: `docker-compose pull`
  * or update a single image: `docker-compose pull tvheadend`
* Let compose update all containers as necessary: `docker-compose up -d`
  * or update a single container: `docker-compose up -d tvheadend`
* You can also remove the old dangling images: `docker image prune`

### Via Watchtower auto-updater (especially useful if you don't remember the original parameters)
* Pull the latest image at its tag and replace it with the same env variables in one run:
  ```
  docker run --rm \
  -v /var/run/docker.sock:/var/run/docker.sock \
  containrrr/watchtower \
  --run-once tvheadend
  ```

**Note:** We do not endorse the use of Watchtower as a solution to automated updates of existing Docker containers. In fact we generally discourage automated updates. However, this is a useful tool for one-time manual updates of containers where you have forgotten the original parameters. In the long term, we highly recommend using Docker Compose.

* You can also remove the old dangling images: `docker image prune`

## Building locally

If you want to make local modifications to these images for development purposes or just to customize the logic:
```
git clone https://github.com/linuxserver/docker-tvheadend.git
cd docker-tvheadend
docker build \
  --no-cache \
  --pull \
  -t linuxserver/tvheadend:latest .
```

The ARM variants can be built on x86_64 hardware using `multiarch/qemu-user-static`
```
docker run --rm --privileged multiarch/qemu-user-static:register --reset
```

Once registered you can define the dockerfile to use with `-f Dockerfile.aarch64`.

## Versions

* **02.10.19:** - Improve permission fixing on render & dvb devices.
* **18.08.19:** - Add AMD drivers.
* **02.08.19:** - Attempt to automatically fix permissions on /dev/dri and /dev/dvb.
* **28.06.19:** - Rebasing to alpine 3.10.
* **27.03.19:** - Rebase to Alpine 3.9, fix init logic to only chown once.
* **23.03.19:** - Switching to new Base images, shift to arm32v7 tag.
* **01.03.19:** - Bump xmltv to 0.6.1.
* **28.02.19:** - add perl-lwp-useragent-determined.
* **17.02.19:** - Bump xmltv to 5.70, ensure version tagging works by cloning tvheadend.
* **14.02.19:** - Add picons path to config.
* **15.01.19:** - Add pipeline logic and multi arch.
* **12.09.18:** - Rebase to alpine 3.8 and use buildstage type build.
* **21.04.18:** - Add JSON::XS Perl package for grab_tv_huro.
* **24.03.18:** - Add dvbcsa package.
* **04.03.18:** - Use sourceforge master rather than mirror for xmltv.
* **22.02.18:** - Add lost libva-intel-driver.
* **21.02.18:** - Fix wrong version of iconv used.
* **18.02.18:** - Add vaapi support, some cleanup and dropping of deprecated options.
* **04.01.18:** - Deprecate cpu_core routine lack of scaling.
* **11.12.17:** - Rebase to alpine 3.7, linting fixes.
* **02.09.17:** - Add codec dependencies.
* **13.07.17:** - Increase uniformity across all archs.
* **08.07.17:** - Update README with full path for comskip.
* **02.07.17:** - Move to one branch for all 4.2 releases.
* **27.05.17:** - Rebase to alpine 3.6.
* **01.05.17:** - Update to tvheadend 4.2.1 stable.
* **18.04.17:** - Use repo version of gnu-libiconv rather than compiling.
* **09.04.17:** - Chain cpanm installs in one block and use --installdeps.
* **09.02.17:** - Perl changes, add picons file to gitignore and update XMLTV to 0.5.69.
* **07.02.17:** - Add variable to add additional runtime paramters.
* **05.02.17:** - Update to alpine 3.5 and change dvb-apps to only compile needed libs.
* **14.11.16:** - Add picons from picons.xyz to /picons folder and add info to README.
* **22.09.16:** - Fix broken tv_grab_wg, libs for xmltv and update README.
* **18.09.16:** - Update XMLTV to 0.5.68 and update README.
* **10.09.16:** - Add layer badges to README.
* **05.09.16:** - Initial Release.
