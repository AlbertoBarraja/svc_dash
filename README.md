svc_dash
========

Project that try to solve the challenges during the client-server uploading and server-client downloading of mobile videos proposing a new approach involving SVC and DASH with the final goal to improve content availability by reducing the end-to-end delay from the recording time of the modile videos to the publishing of the first segment of the encoded version of the video in the Server in order to be available and playable on other devices.

#1) Video producer and uploader
The video producer and uploader uses the [JSVM](http://www.hhi.fraunhofer.de/de/kompetenzfelder/image-processing/research-groups/image-video-coding/svc-extension-of-h264avc/jsvm-reference-software.html)(Joint Scalable Video Model) software that is the reference software for the Scalable Video Coding (SVC) project of the Joint Video Team (JVT) of the ISO/IEC Moving Pictures Experts Group (MPEG) and the ITU-T Video Coding Experts Group (VCEG).

###1.1) Building the JSVM software
In order to build and produce the first steps with the JSVM encoder a '.doc' documentation file is in the following path "/svc/server/jsvm/SoftwareManual.doc".
The commands for building this software on Linux O.S. are the following:
	
	cd JSVM/H264AVCExtension/build/linux
	make

###1.2) Encoder and Decoder example
Configure files examples are in folder "/svc/server/jsvm/example/". For semplicity sake is reccomended to copy the configuration files to "/svc/server/jsvm/bin". 
The steps for encoding a '.yuv' file to be multiple layers are the followings:

	cd /svc/server/jsvm/bin
	./H264AVCEncoderLibTestStatic -pf encoder.cfg

After that, a .264 file will be generated, which is a SVC encoded video. 

###1.3) SVC file extraction using the JSVM parser
The output SVC file generated in the above process can be directly played in mplayer (check the detail in "Mplayer" section). And also it can be parsed to seperate .264 files representing the base layer plus several enhanched layers.

The extraction step is the following:
    
    ./BitStreamExtractorStatic input_file.264  output_file.264 -e widhtxheight@frequency:bitrate 

for example:

    ./BitStreamExtractorStatic out.264 out_lay2.264 -e 704x576@60:2310

###1.4) SVC file chunking, '.mpd' file generation and file uploading 
The client in order to send the '.264/SVC' file according to the DASH protocol has to provide the SVC layers in multiple representations.
Normally an SVC bitstream has enhancement layers located at each frame. For SVC-DASH compatible file each temporal segment have to be splitted into multiple chunks, one per layer. In such a way each of the chunks contains several frames for one layer.
So at first the client software has to demux the SVC bitstream into chunks, one per layer and at the same time has to generate an '.mpd' file.
After this step an HTTP connection is opened to the server specified by the user and first the '.mpd' and then all the chuncks are sent towared the server.
The software is in the following path "uploading_client.py" and in order to use it those are the parameter that have to be entered: 
	
	client_upload [path filename] [url server] [#frame_per_segment] [resolution_width resolution_height]
 


#2) Server
A web server is deveopeld using the framework node.js and is composed in two modules, a file upload server listening the port 8888 and a static file server listeng the posrt 8080 .
The software is the following path "server/index.js" and this is the command for starting it:
	node index.js


#3) Mplayer
###Install
Inside of [Open SVC Decoder](http://sourceforge.net/projects/opensvcdecoder/), there is a mplayer which can be installed to play the bit stream files (such as y4m and yuv format files). The step for installing the software are the followings:

	./configure
	./configure --enable-svc
	make install

### 3.1) Usage
To play a source file, for example to play a video file named "a.y4m", run:

	mplayer a.y4m

To play the yuv source file, the codec parameters have to be defined, for example to run a video file (176*144) named "akiyo_qcif.yuv", run:

	mplayer -demuxer rawvideo -rawvideo w=176:h=144:format=i420 akiyo_qcif.yuv -loop 1

To play a svc encoded file, layerId and temporalID can be set to play the exact layer of the file, check [this](http://sourceforge.net/apps/mediawiki/opensvcdecoder/index.php?title=Mplayer).
    
    mplayer -fps 25 mystream.264 -setlayer 16 -settemporalid 2

To play a extracted svc file, just run:

    mplayer -fps 25 out_lay0.264
    

# Video files
Video resources is y4m Video Sequences and some source files are in folder "/svc/server/video_data". Other source files can also be downloaded from [Xiph.org Video Test Media](http://media.xiph.org/video/derf/). 

The y4m format files can be converted to yuv format by using "ffmpeg" package, for example to convert a "akiyo_qcif.y4m" to "akiyo_qcif.yuv" can simply run:

    ffmpeg -i akiyo_qcif.y4m akiyo_qcif.yuv
    
Also, there are some online example of SVC encoded files which can be used, check [this](http://sourceforge.net/projects/opensvcdecoder/files/Video%20Streams/).

 





