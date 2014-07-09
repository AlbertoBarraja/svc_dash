#Server
========
Web server developer using the event-driven framework [Node.js](http://nodejs.org/).
The architecture of the server is composed of 3 main modules:
- Uploader Server: this module provides a web server listening on the port 8888 and handles the requests for uploading files by the clients.
- Downloader Server: this module provides a static file web server listening on the port 8080 that handles the request for downloading files by the clients.
- Web pages host: this module provides a web server listening on the port 3000 that show to the browser the table of content of the server.

In order to do not force the downloading clients to specify the port in which the server is listening is reccomended execute the following command:

	iptables -A PREROUTING -t nat -i eth0 -p tcp --dport 80 -j REDIRECT --to-port 8080
