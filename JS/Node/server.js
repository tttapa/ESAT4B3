const WebSocket = require('ws');

const wss = new WebSocket.Server({ port: 8080 });

// Broadcast to all.
wss.broadcast = function broadcast(data) {
  wss.clients.forEach(function each(client) {
    if (client.readyState === WebSocket.OPEN) {
      client.send(data, sendError);
    }
  });
};

wss.on('connection', function connection(ws, req) {
  const ip = req.connection.remoteAddress;
  console.log(ip);    
  ws.on('message', function incoming(data) {
    console.log(ip + ": " + data);
  });
  ws.isAlive = true;
  ws.on('pong', heartbeat);
  let counter = 0;
  let interval = setInterval(function() {
    let value = 100 + 50*Math.sin(10*2*Math.PI*counter/360);
    counter++;
    if (counter == 360)
      counter = 0;
    ws.send(value);
  }, 1000/30);
  ws.on('close', function () {
    clearInterval(interval);
    console.log("Closed " + ip);
  });
});

function heartbeat() {
  this.isAlive = true;
}

const interval = setInterval(function ping() {
  wss.clients.forEach(function each(ws) {
    if (ws.isAlive === false) 
      return ws.terminate();
    ws.isAlive = false;
    ws.ping('', false, true);
  });
}, 10000);

function sendError(er) {
  if (typeof er !== 'undefined') {
    console.log(er);
  }
}