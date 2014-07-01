function route(filename, response, request) {
	var fs = require("fs");
        var path = require("path");
	var pathname = path.join(process.cwd(),filename);			//process.cwd(), Returns the current working directory of the process.	
	
	//check if the path exist on the server
	path.exists(pathname, function(exists) {
		console.log("Donwnload: request for " + pathname + " received.");
		if(!exists) {
			console.log("File Not Found");			
			response.writeHead(404, {"Content-Type": "text/plain"});
			response.write("404 Not Found\n");
			response.end();
			return;
		}
		if (fs.statSync(pathname).isDirectory()){
			console.log("here is"+pathname);
			if (pathname=='/home/barraja1/NodeJs_Server_tests/')			 
				pathname += 'video_folder';
			pathname += '/index.html';
		}
		fs.readFile(pathname, "binary", function(err, file) {
			if(err) {
				console.log("Error"); 
			 	response.writeHead(500, {"Content-Type": "text/plain"});
				response.write(err + "\n");
				response.end();
				return;
			}
			console.log("ok"); 
			response.writeHead(200);
			response.write(file, "binary");
			response.end();			
		});
	});
}
exports.route = route;
