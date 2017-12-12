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
const ECG_samplesPerFrame = Math.floor(ECG_samplefreq / ECGdownsampleamount / framerate);

const PPG_samplesPerFrame = 2;

console.log("Downsample by " + ECGdownsampleamount + " samples.");
console.log(ECG_samplesPerFrame + " samples per frame.");

const Receiver = require('./Receiver.js');
const receiver = new Receiver.Receiver();

const Sender = require('./Sender.js');
const ECGsender = new Sender.BufferedSender(wss, Sender.message_type.ECG, ECG_samplesPerFrame);
const PPGSenderIR = new Sender.BufferedSender(wss, Sender.message_type.PPG_IR, PPG_samplesPerFrame);
const PPGSenderRD = new Sender.BufferedSender(wss, Sender.message_type.PPG_RED, PPG_samplesPerFrame);

let ECGctr = 0;
let ECGsum = 0;

const BPMCounter = require('./BPMCounter.js');
const bpmctr = new BPMCounter.BPMCounter(ECG_samplefreq, 511, 30, 220);

port.on('data', function (dataBuf) {
  for (i = 0; i < dataBuf.length; i++) {
    let message = receiver.receive(dataBuf[i]);
    if (message != null) {
      switch (message.type) {
        case Receiver.message_type.ECG:
          ECGsum += message.value;
          ECGctr++;
          if (ECGctr >= ECGdownsampleamount) {
            ECGsender.send(ECGsum / ECGdownsampleamount);
            ECGsum = 0;
            ECGctr = 0;
          }
          if (bpmctr.run(message.value)) {
            let BPMbuf = new Uint16Array(2);
            BPMbuf[0] = Sender.message_type.BPM;
            BPMbuf[1] = Math.round(bpmctr.getBPM() * 100);
            wss.broadcast(BPMbuf);
          }
          break;
        case Receiver.message_type.PPG_IR:
          PPGSenderIR.send(message.value);
          break;
        case Receiver.message_type.PPG_RED:
          PPGSenderRD.send(message.value);
          break;
        case Receiver.message_type.PRESSURE_A:
          let pressbufA = new Uint16Array(2);
          pressbufA[0] = Sender.message_type.PRESSURE_A;
          pressbufA[1] = message.value;
          wss.broadcast(pressbufA);
          break;
        case Receiver.message_type.PRESSURE_B:
          let pressbufB = new Uint16Array(2);
          pressbufB[0] = Sender.message_type.PRESSURE_B;
          pressbufB[1] = message.value;
          wss.broadcast(pressbufB);
          break;
        case Receiver.message_type.PRESSURE_C:
          let pressbufC = new Uint16Array(2);
          pressbufC[0] = Sender.message_type.PRESSURE_C;
          pressbufC[1] = message.value;
          wss.broadcast(pressbufC);
          break;
        case Receiver.message_type.PRESSURE_D:
          let pressbufD = new Uint16Array(2);
          pressbufD[0] = Sender.message_type.PRESSURE_D;
          pressbufD[1] = message.value;
          wss.broadcast(pressbufD);
          break;
      }
    }
  }
});

/* -----------------------------------SPO2-Calculation----------------------------------- */

let SPO2Interval = setInterval(function () {
  let SPO2buf = new Uint16Array(2);
  SPO2buf[0] = Sender.message_type.SPO2;
  SPO2buf[1] = Math.round(getSPO2() * 100);
  wss.broadcast(SPO2buf);
}, 1000);

function getSPO2() {
  return 96 + 2 * Math.random();
}

/* -----------------------------------HTTP-SERVER----------------------------------- */

var http = require('http');
http.createServer(function (req, res) {
    res.writeHead(200, {'Content-Type': 'text/html'});
    res.write(req.url);
    res.end();
}).listen(8080);