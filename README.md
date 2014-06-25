svc_dash
========

Project that try to solve the challenges during the client-server uploading and server-client downloading of mobile videos proposing a new approach involving SVC and DASH with the final goal to improve content availability by reducing the end-to-end delay from the recording time of the modile videos to the publishing of the first segment of the encoded version of the video in the Server in order to be available and playable on other devices.

#1) Video producer and uploader
The video producer and uploader uses the [JSVM](http://www.hhi.fraunhofer.de/de/kompetenzfelder/image-processing/research-groups/image-video-coding/svc-extension-of-h264avc/jsvm-reference-software.html)(Joint Scalable Video Model) software that is the reference software for the Scalable Video Coding (SVC) project of the Joint Video Team (JVT) of the ISO/IEC Moving Pictures Experts Group (MPEG) and the ITU-T Video Coding Experts Group (VCEG).

###1.1) Building the JSVM software
Documantation file for how to make build and make the first steps with the encoder is in the .doc file in the following path "/svc/server/jsvm/SoftwareManual.doc". The step of building this project on Linux O.S. are the following:
	
	cd JSVM/H264AVCExtension/build/linux
	make
