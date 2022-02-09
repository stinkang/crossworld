const WebSocket = require("ws");

const wss = new WebSocket.Server({ port: 8082 });

wss.on("connection", (ws, req) => {

	console.log("New client connected!");
	ws.on("close", () => {
		console.log("Client has disconnected!");
	});
	
	ws.on("message", data => {
		console.log(`Client has sent us ${data}`);
		wss.clients.forEach(client => {
			if (client._socket.remoteAddress != req.socket.remoteAddress) {
				client.send(data)
				console.log(client._socket.remoteAddress)
				console.log(req.socket.remoteAddress)
			};
		});
	});
});
