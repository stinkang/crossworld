const WebSocket = require("ws");

const wss = new WebSocket.Server({ port: 8082 });

wss.on("connection", ws => {

	console.log("New client connected!");
	ws.on("close", () => {
		console.log("Client has disconnected!");
	});
	
	ws.on("message", data => {
		console.log(`Cliennt has sent us ${data}`);
	});
});
