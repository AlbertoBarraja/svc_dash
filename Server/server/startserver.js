//test variables
//var serverUpload = require("./server");
//var router = require("./router");
//var requestHandlers = require("./requestHandlers");

//Upload variables
var serverUpload = require("./serverUpload");
//var routerUpload = require("./routerUpload"); 	//TO DO
//var handlersUpload = require("./HandlersUpload"); 	//TO DO



//Download variables
var serverDownload = require("./serverDownload");
var routerDownload = require("./routerDownload"); 	
//var handlersDownload = require("./requestHandlers"); //TO DO

//var handle = {}
//handle["/"] = requestHandlers.startRequest;
//handle["/upload"] = requestHandlers.uploadRequest;
//handle["/show"] = requestHandlers.showRequest;
//handle["/download"] = requestHandlers.downloadRequest;

//serverUpload.startServer(router.route,handle);
serverDownload.startServer(routerDownload.route);
serverUpload.startServer();

