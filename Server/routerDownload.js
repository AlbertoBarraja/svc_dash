function route(pathname, response, request) {
	var fs = require("fs");
        var path = require("path");
	var exec = require("child_process").exec;	
	var filename = path.join(process.cwd(),pathname);	//process.cwd(), Returns the current
								//working directory of the process.
	console.log("Donwnload: request for " + filename + " received.");
	path.exists(filename, function(exists) {
		//check if file exists
		if(!exists) {
			console.log("File Not Found"); 
			response.writeHead(404, {"Content-Type": "text/plain"});
			response.write("404 Not Found\n");
			response.end();
			return;
		}
		if (fs.statSync(filename).isDirectory()){
			if (filename=='/home/barraja1/NodeJs_Server_tests/')			 
				filename += 'video_folder';
			exec("bash make_index.sh")
			filename += '/index.html';

		}
		fs.readFile(filename, "binary", function(err, file) {
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
