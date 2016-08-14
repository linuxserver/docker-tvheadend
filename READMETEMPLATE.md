![https://linuxserver.io](https://www.linuxserver.io/wp-content/uploads/2015/06/linuxserver_medium.png)

The [LinuxServer.io](https://linuxserver.io) team brings you another container release featuring auto-update on startup, easy user mapping and community support. Find us for support at:
* [forum.linuxserver.io](https://forum.linuxserver.io)
* [IRC](https://www.linuxserver.io/index.php/irc/) on freenode at `#linuxserver.io`
* [Podcast](https://www.linuxserver.io/index.php/category/podcast/) covers everything to do with getting the most from your Linux Server plus a focus on all things Docker and containerisation!

# linuxserver/tvheadend-unstable

[Tvheadend] (https://www.tvheadend.org/) is a TV streaming server and recorder for Linux, FreeBSD and Android supporting DVB-S, DVB-S2, DVB-C, DVB-T, ATSC, ISDB-T, IPTV, SAT>IP and HDHomeRun as input sources.
Tvheadend offers the HTTP (VLC, MPlayer), HTSP (Kodi, Movian) and SAT>IP streaming.
Multiple EPG sources are supported (over-the-air DVB and ATSC including OpenTV DVB extensions, XMLTV, PyXML).


## Usage

```
docker create \
  --name=tvheadend-unstable \
  -v <path to data>:/config \
  -e PGID=<gid> -e PUID=<uid>  \
  -p 9981:9981 \
  -p 9982:9982 \
  --device=/dev/dvb
  linuxserver/tvheadend-unstable
```
The --device=/dev/dvb is only needed if you want to pass through a DVB card to the container. If you use IPTV or HDHomeRun you can leave it out.

**Parameters**

* `-p 1234` - the port(s)
* `-v /config` - explain what lives here
* `-e PGID` for GroupID - see below for explanation
* `-e PUID` for UserID - see below for explanation

It is based on alpine linux with s6 overlay, for shell access whilst the container is running do `docker exec -it tvheadend-unstable /bin/bash`.

### User / Group Identifiers

Sometimes when using data volumes (`-v` flags) permissions issues can arise between the host OS and the container. We avoid this issue by allowing you to specify the user `PUID` and group `PGID`. Ensure the data volume directory on the host is owned by the same user you specify and it will "just work" ™.

In this instance `PUID=1001` and `PGID=1001`. To find yours use `id user` as below:

```
  $ id <dockeruser>
    uid=1001(dockeruser) gid=1001(dockergroup) groups=1001(dockergroup)
```

## Setting up the application

The first thing to do is to create your admin user as by default everyone is allowed to access tvheadend. Go to Configuration --> Users --> Access Entries and click Add and fill in all the required fields.
Then go to the password tab and click Add and fill in the user name you created in the previous step and enter your password.
Click the (login) button in the top of the webgui and check that your user is configured properly. After you have logged in, deleteor disable the * user.
Then you can start configuring tvheadend with the wizard foun in Configuration --> General --> Base and click Start Wizard.

**Configuring XMLTV grabber**

To configure the XMLTV grabber, first check if your grabber is listed in Configuration --> Channel/EPG --> EPG Grabber Modules. If it's listed, you will have to configure the grabber before enabling.
Find the path in the path field of your grabber. We will use the last part. It starts with tv_grab_. Add it after /usr/bin/ in the below command. There should be no space between Usr/bin/ and the part you added. 

```
docker exec -it -u abc tvheadend-unstable /usr/bin/ --configure
```

Now follow the onscreen progress. If you get asked about cache, just accept the default. After you have configured your grabber, you can go back and enable your grabber.

If you allready have a configuration file, you can add it in the .xmltv folder where you mapped the /config volume. If it's not created, create it.

**Comskip**
This container comes with Comskip for commercial flagging of recordings. This you have to add in the recording config of tvheadend.
Go to Configuration --> Recording and add the below in the Post-processor command field.

```
comskip "%f"
```

Now comskip will run after each recording is finished. You will find comskip.ini in the comskip folder of your /config volume mapping. See the [Comskip] (http://www.kaashoek.com/comskip/) homepage for tuning of the ini file.


**FFmpeg**

FFmpeg is installed in /usr/bin/ in case you need to use it with pipe.

**EPG XML file**

If you have EPG data in XML format from a supplier, you can drop it in the data folder of your your /config volume mapping. Then choose the XML file grabber in Configuration --> Channel/EPG --> EPG Grabber Modules.
If you use WebGrab+Plus, choose the WebGrab+Plus XML file grabber. The XML file goes in the same path as above.

For advanced setup of tvheadend, go to [tvheadend.org] (https://www.tvheadend.org)

## Info

* Shell access whilst the container is running: `docker exec -it tvheadend-unstable /bin/bash`
* To monitor the logs of the container in realtime: `docker logs -f tvheadend-unstable`

## Versions

+ **14.08.2016:** Initial release.
