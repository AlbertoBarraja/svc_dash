var http = require("http"),
    url = require("url"),
    path = require("path"),
    fs = require("fs"),
    multipart = require('multipart'),
    sys = require('sys');

function startServer() {
	function onRequest(request, response) {
		var pathname = url.parse(request.url).pathname;
		var checkArray = pathname.split('/');
		var requestedFolder = checkArray[1];
		var pathToCheck = path.join(process.cwd(),requestedFolder);
		path.exists(pathToCheck, function(exists) {
			if(!exists) {
				console.log("path Not Found");			
				response.writeHead(404, {"Content-Type": "text/plain"});
				response.write("404 Not Found\n");
				response.end();
				return;
			}		
			//console.log(" path is: " + pathToCheck );
			/*----------CREATE A NEW FOLDER-----------------*/		
			pathArray = pathname.split('.');
			var newPathname = pathArray[0];
			newPathname = newPathname.slice(1,newPathname.length);
			//console.log("new path is: " + newPathname );
	
			if(!fs.existsSync(newPathname)){
	     			fs.mkdirSync(newPathname, 0766, function(err){
	       				if(err){ 
		 			console.log(err);
		 			response.send("ERROR! Can't make the directory! \n");    // echo the result back
	       				}
	     			});   
	 		}
				
			fileArray = pathname.split('/');
			fullFileName = fileArray[(fileArray.length)-1];
			//console.log("file is: " + fullFileName );
	
			/*-------STORE FILES IN THE FOLDER -----*/			
	  	
			var filePath = path.join(process.cwd(),newPathname,fullFileName);
			//console.log("Uploading: " + filePath ); 
			response.writeHead(200);
			var destinationFile = fs.createWriteStream(filePath);
			request.pipe(destinationFile);
			var fileSize = request.headers['content-length'];
			var uploadedBytes = 0 ;
			request.on('data',function(d){
				uploadedBytes += d.length;
				var p = (uploadedBytes/fileSize) * 100;
				response.write("Uploading " + parseInt(p)+ " %\n");
			});
			request.on('end',function(){
	 			response.end("File Upload Complete");
				/*create index file */
	 		});
		});					
	}
	http.createServer(onRequest).listen(8888);
	console.log("Upload server listening on port 8888.\n => http://localhost:8888/\nCTRL + C to shutdown");
}
exports.startServer = startServer;