[linuxserverurl]: https://linuxserver.io
[forumurl]: https://forum.linuxserver.io
[ircurl]: https://www.linuxserver.io/index.php/irc/
[podcasturl]: https://www.linuxserver.io/index.php/category/podcast/

[![linuxserver.io](https://www.linuxserver.io/wp-content/uploads/2015/06/linuxserver_medium.png)][linuxserverurl]

The [LinuxServer.io][linuxserverurl] team brings you another container release featuring easy user mapping and community support. Find us for support at:
* [forum.linuxserver.io][forumurl]
* [IRC][ircurl] on freenode at `#linuxserver.io`
* [Podcast][podcasturl] covers everything to do with getting the most from your Linux Server plus a focus on all things Docker and containerisation!

# linuxserver/tvheadend
[![Docker Pulls](https://img.shields.io/docker/pulls/linuxserver/tvheadend.svg)][hub][![Docker Stars](https://img.shields.io/docker/stars/linuxserver/tvheadend.svg)][hub][![Build Status](http://jenkins.linuxserver.io:8080/buildStatus/icon?job=Dockers/LinuxServer.io/linuxserver-tvheadend)](http://jenkins.linuxserver.io:8080/job/Dockers/job/LinuxServer.io/job/linuxserver-tvheadend/)
[hub]: https://hub.docker.com/r/linuxserver/tvheadend/

[Tvheadend](https://www.tvheadend.org/) is a TV streaming server and recorder for Linux, FreeBSD and Android supporting DVB-S, DVB-S2, DVB-C, DVB-T, ATSC, ISDB-T, IPTV, SAT>IP and HDHomeRun as input sources.
Tvheadend offers the HTTP (VLC, MPlayer), HTSP (Kodi, Movian) and SAT>IP streaming.
Multiple EPG sources are supported (over-the-air DVB and ATSC including OpenTV DVB extensions, XMLTV, PyXML).

[![tvheadend](https://s31.postimg.io/8urk8vdu3/logobig.png)][tvheadendurl]
[tvheadendurl]: https://www.tvheadend.org/

## Usage

```
docker create \
  --name=tvheadend \
  -v <path to data>:/config \
  -e PGID=<gid> -e PUID=<uid>  \
  -p 9981:9981 \
  -p 9982:9982 \
  --device=/dev/dvb
  linuxserver/tvheadend
```
The --device=/dev/dvb is only needed if you want to pass through a DVB card to the container. If you use IPTV or HDHomeRun you can leave it out.


You can choose between ,using tags, latest (default, and no tag required or a specific stable version of tvheadend.

Add one of the tags, if required, to the linuxserver/tvheadend line of the run/create command in the following format, linuxserver/tvheadend:stable-4.0.9

#### Tags

+ **stable-4.0.9** : latest stable version.

#### Host vs. Bridge

If you use IPTV, SAT>IP or HDHomeRun, you need to create the container with --net=host. This is because of a limitation in docker and multicast.


**Parameters**

* `-p 1234` - the port(s)
* `-v /config` - explain what lives here
* `-e PGID` for GroupID - see below for explanation
* `-e PUID` for UserID - see below for explanation
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
comskip --ini=/config/comskip/comskip.ini "%f"
```

Now comskip will run after each recording is finished. You will find comskip.ini in the comskip folder of your /config volume mapping. See the [Comskip] (http://www.kaashoek.com/comskip/) homepage for tuning of the ini file.


**FFmpeg**

FFmpeg is installed in /usr/bin/ in case you need to use it with pipe.

**EPG XML file**

If you have EPG data in XML format from a supplier, you can drop it in the data folder of your your /config volume mapping. Then choose the XML file grabber in Configuration --> Channel/EPG --> EPG Grabber Modules.
If you use WebGrab+Plus, choose the WebGrab+Plus XML file grabber. The XML file goes in the same path as above.

For advanced setup of tvheadend, go to [tvheadend.org] (https://www.tvheadend.org)

## Info

* Shell access whilst the container is running: `docker exec -it tvheadend /bin/bash`
* To monitor the logs of the container in realtime: `docker logs -f tvheadend`

## Versions

+ **05.09.2016:** Initial release.
