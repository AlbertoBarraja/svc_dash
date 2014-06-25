var http = require("http"),
    url = require("url");

function startServer(route) {
	function onRequest(request, response) {
		var pathname = url.parse(request.url).pathname;
		route(pathname, response, request); 			
	}
	http.createServer(onRequest).listen(8080);
	console.log("Download server listening on port 8080.\n => http://localhost:8080/\nCTRL + C to shutdown");
}

exports.startServer = startServer;

