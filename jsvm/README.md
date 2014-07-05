# JSVM Reference Software
The JSVM (Joint Scalable Video Model) software is the reference software for the Scalable Video Coding (SVC) project of the Joint Video Team (JVT) of the ISO/IEC Moving Pictures Experts Group (MPEG) and the ITU-T Video Coding Experts Group (VCEG). Since the SVC project is still under development, the JSVM Software as is also under development and changes frequently.
The JSVM software is written in C++ and is provided as source code. Section 1.1 describes how the JSVM software can be obtained via a CVS server.
Section 1.2 describes how the JSVM software can be build on Win32 and Linux platforms.


###1.1) Accessing the latest JSVM Software
In order to keep track of the changes in software development and to always provide an up-to-date version of the JSVM software, a CVS server for the JSVM software has been set up at the Rheinisch-Westfälische Technische Hochschule (RWTH) Aachen. The CVS server can be accessed using WinCVS or any other CVS client. The server is configured to allow read access only using the parameters specified in Table 1. Write access to the JSVM software server is restricted to the JSVM software coordinators group.

##### CVS access parameters
	
	authentication:	pserver
	host address:	garcon.ient.rwth-aachen.de
	path:		/cvs/jvt
	user name:	jvtuser
	password:	jvt.Amd.2
	module name:	jsvm or jsvm_red

Accessing the JSVM software with a command line CVS client:
	
	cvs –d :pserver:jvtuser:jvt.Amd.2@garcon.ient.rwth-aachen.de:/cvs/jvt login
	cvs –d :pserver:jvtuser@garcon.ient.rwth-aachen.de:/cvs/jvt checkout jsvm


###1.2) Building the JSVM software
It shall be possible to build the JSVM software on a Linux platform with gcc version 4.
All libraries are static libraries and all executable are statically linked to the libraries.
Makefiles for the Linux with gcc compiler are provided in the folder JSVM/H264Extension/build/linux and the corresponding sub-folders. Supposing that the current folder is the main folder jsvm of the JSVM repository, the commands specified below should be executed to build all project files.

	cd JSVM/H264AVCExtension/build/linux
	make

By replacing make with make release or make debug it can be specified that only the release or debug versions of the libraries and executables should be build.


###1.3) Encoder “H264AVCEncoderLibTestStatic”
Configure files examples are in folder "/svc/server/jsvm/example/". For semplicity sake is reccomended to copy the configuration files to "/svc/server/jsvm/bin". 
The H264AVCEncoderLibTestStatic encoder can be used for generating SVC bit-streams. The basic encoder call is illustrated below.

	cd /svc/server/jsvm/bin
	./H264AVCEncoderLibTestStatic -pf mcfg.cfg

The mcfg.cfg file represents the filename of the main configuration file. The main configuration file shall be specified for each encoder call. In addition to the configuration file, several command line options can be specified.


###1.4) Bitstream extractor “BitStreamExtractorStatic”
The bit-stream extractor can be used to extract sub-streams of an SVC stream. The sub-streams represent streams with a reduced spatial and/or temporal resolution and/or a reduced bit-rate. The usage of the bit-stream extractor is illustrated below. A printout of the options that are provided by the bit-stream extractor can be obtained by calling the extractor without any command line parameter. The bit-stream extractor can only be used with SVC bit-streams that contain a scalability information SEI message in the first NAL unit of the bit-stream.

	./BitStreamExtractorStatic input.svc output.svc –e 176x144@15:600

The output SVC file generated in the above process can be directly played in mplayer (check the detail in "Mplayer" section). And also it can be parsed to seperate .264 files representing the base layer plus several enhanched layers.

The extraction step is the following:
    
    ./BitStreamExtractorStatic inputFile.264  outputFile.264 -e widhtxheight@frequency:bitrate 

for example:

    ./BitStreamExtractorStatic input.svc output.svc –e 176x144@15:600

The most powerful option for operating the bit-stream extractor is option “-e”. When using this option, the spatial resolution, the frame rate, and the bit-rate of the sub-stream to be extracted can be specified. This extraction option has to be specified in the form “-e AxB@C:D”. At this, the parameters A and B represent the spatial resolution expressed by the frame width A and the frame height B. The frame rate of the sub-stream to be extracted is specified by the parameter C, and the target bit-rate is specified by the parameter D. When MGS data is present, some of the corresponding packets might be discarded in order to match the given target bit-rate. Note that each scalable stream only supports a specific range of target bit-rates for each spatio-temporal resolution, the supported bit-rate range is dependent on the encoder configuration. The command above shows an extractor call, in which a sub-stream in QCIF resolution (176x144 samples) with a frame rate of 15Hz and a bit-rate of 600 kbit/s is extracted.
