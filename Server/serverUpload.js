var http = require("http"),
    url = require("url"),
    path = require("path"),
    fs = require("fs"),
    multipart = require('multipart'),
    sys = require('sys');



function startServer() {
	function onRequest(request, response) {
		var pathname = url.parse(request.url).pathname;
		var filename = path.join(process.cwd(),pathname);
		console.log("Uploading: " + filename ); 
		
		response.writeHead(200);
		var destinationFile = fs.createWriteStream(filename);
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
 		});		
	}
	http.createServer(onRequest).listen(8888);
	console.log("Upload server listening on port 8888.\n => http://localhost:8888/\nCTRL + C to shutdown");
}
exports.startServer = startServer;
