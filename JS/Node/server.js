/* -----------------------------------WEBSOCKET----------------------------------- */

const WebSocket = require('ws');
const wss = new WebSocket.Server({ port: 8080 });

// Broadcast to all.
wss.broadcast = function broadcast(data) {
  try {
    wss.clients.forEach(function each(client) {
      if (client.readyState === WebSocket.OPEN) {
        client.send(data, function ack(er) {
          if (typeof er !== 'undefined') {
            console.error("ERROR!");
            console.error(er);
          }
        });
      }
    });
  } catch (e) {
    console.error("EXCEPTION!");
    console.error(e);
  }
};

wss.on('connection', function connection(ws, req) {
  ws.ip = req.connection.remoteAddress;
  console.log("Connected " + ws.ip);
  ws.on('message', function incoming(data) {
    console.log(this.ip + ": " + data);
  });
  ws.isAlive = true;
  ws.on('error', function (er) {
    console.error(this.ip + " Error: ");
    console.error(er);
  });
  ws.on('pong', heartbeat);
  ws.on('close', function () {
    console.log("Closed " + this.ip);
  });
});

/* -----------------------------------PING-PONG----------------------------------- */

function heartbeat() {
  this.isAlive = true;
}

const interval = setInterval(function ping() {
  wss.clients.forEach(function each(ws) {
    if (ws.isAlive === false) {
      console.warn(ip + ' has been inactive for 10 seconds. Terminated.')
      return ws.terminate();
    }
    ws.isAlive = false;
    ws.ping('', false, true); // fail silently
  });
}, 10000);

/* -----------------------------------SERIAL-PORT----------------------------------- */

const SerialPort = require('serialport');
const port = new SerialPort('/dev/ttyACM0', {
  baudRate: 115200,
}, function (err) {
  if (err) {
    return console.log('Error: ', err.message);
  }
});

const framerate = 30;

const ECGdownsampleamount = 2;

const ECG_samplefreq = 360;
const ECG_samplesPerFrame = ECG_samplefreq/ECGdownsampleamount/framerate;

console.log("Downsample over " + ECGdownsampleamount + " samples.");

const Receiver = require('./Receiver.js');
const receiver = new Receiver.Receiver();

let ECGctr = 0;
let ECGsum = 0;

let ECGoutBuffer = new Uint16Array();

port.on('data', function (dataBuf) {
  // console.log('Data:', dataBuf);
  for (i = 0; i < dataBuf.length; i++) {
    let message = receiver.receive(dataBuf[i]);
    if (message != null) {
      switch (message.type) {
        case Receiver.message_type.ECG:
          ECGsum += message.value;
          ECGctr++;
          if (ECGctr >= ECGdownsampleamount) {
            wss.broadcast(ECGsum/ECGdownsampleamount);
            ECGsum = 0;
            ECGctr = 0;
          }
          break;
        case Receiver.message_type.PRESSURE_A:
          ;
          break;
      }
    }
  }
});