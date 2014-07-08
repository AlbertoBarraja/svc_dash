Dynamic Adaptive Video Streaming over HTTP SVC compatible 
========

Project that try to solve the most common challenges during the client-server upload and server-client download of videos proposing a new approach compatible with [SVC](http://en.wikipedia.org/wiki/Scalable_Video_Coding)(Scalable Video Coding) and [DASH](http://en.wikipedia.org/wiki/Dynamic_Adaptive_Streaming_over_HTTP)(Dynamic Adaptive Streaming over HTTP) having as a final goal  to improve content availability by reducing the end-to-end delay from the recording time of the video to the publishing of the first segment of the encoded version of the video in the Server in order to be available and playable on other devices and also to improve the storage of the video in the Server providing an bandwidth adaptable video file instead of multiple representation of the same file .

The architecture of this project is divided in multiple modules:

#1) Video encoder
The device uses the [JSVM](http://www.hhi.fraunhofer.de/de/kompetenzfelder/image-processing/research-groups/image-video-coding/svc-extension-of-h264avc/jsvm-reference-software.html)(Joint Scalable Video Model) software in order to encode the video from the '.yuv' encoded video file to the '.264' MPEG-4 SVC encoded video file.


#2) Video uploader client
The client in order to send the '.264' encoded video file according to the DASH protocol, it has to provide the file in multiple representations and an '.mpd' file that describe the multimeda content.
SVC can be deployed in DASH as follow, each representation contains an SVC layer.Normally an SVC bitstream has enhancement layers located at each frame. For an SVC-DASH compatible file each temporal segment have to be splitted into multiple chunks, one per layer. In such a way each of the chunks contains several frames for one layer. Then agter this the '.mpd' file is generated according to the information of the generated chunks.
After those operations the video uploader client send the video chunks through HTTP post messages selecting the layers per segment according to the bandwidth available.


#3) Web Server
A web server deveopeld using the framework node.js and is composed in 3 modules:
- a file uploader server listening the port 8888
- a static file server listeng the posrt 8080
- a  web hosting server serving web pages listening on the port 3000


#4)Video downloader client
The client downloads the whole video segment by segment according to the available bandwidth and selecting the most suitable representation (layer) for the segment that has to be dowloaded, then muxes the layers of the segment together and finally decodes and plays it using a specific video player meanwhile the next segment is downloaded.

#5) Video player
MPlayer is a free software and open source media player.Moreover, this player is compatible with all major operating systems, including Linux and other Unix-like systems, Microsoft Windows and Mac OS X, and has been tested over different platforms. The mplayer version proposed in this project is based on the 31411th revision of the mplayer SVN repository.
In this version of the software no major changes have been done except for the interfacing of the [Open SVC Decoder]((http://sourceforge.net/projects/opensvcdecoder/)) library into the mplayer.


