const fs = require('fs');
const path = require('path');

const WebSocket = require('ws');

const SerialPort = require('serialport');

const http = require('http');


const datafolder = 'Data';
const hostingFolder = '../html';

if (!fs.existsSync(path.join(__dirname, datafolder))) {
  fs.mkdirSync(path.join(__dirname, datafolder));
}

/* -----------------------------------WEBSOCKET----------------------------------- */

const wss = new WebSocket.Server({ port: 1425 });

// Broadcast to all: loop over all connected clients and send the data
wss.broadcast = function broadcast(data) {
  try {
    wss.clients.forEach(function each(client) {
      if (client.readyState === WebSocket.OPEN) {
        client.send(data, function ack(er) {
          if (er) {
            console.error("Error in WebSocket send: ");
            console.error(er);
          }
        });
      }
    });
  } catch (e) {
    console.error("Exception in WebSocket send: ");
    console.error(e);
  }
};

// When a new client connects: attach some events
wss.on('connection', function connection(ws, req) {
  ws.ip = req.connection.remoteAddress;
  console.log("Connected " + ws.ip);
  sendSteps();
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

// Send ping frames every 10 seconds. Clients should respond with a pong frame within
// 10 seconds. If not, terminate client.
const interval = setInterval(function ping() {
  wss.clients.forEach(function each(ws) {
    if (ws.isAlive === false) {
      console.warn(ws.ip + ' has been inactive for 10 seconds. Terminated.')
      return ws.terminate();
    }
    ws.isAlive = false;
    ws.ping('', false, true); // fail silently
  });
}, 10000);

/* -----------------------------------STEPCOUNTERS--BPMCOUNTER--AVERAGES------------------------------------- */

const framerate = 30;

const ECGdownsampleamount = 2;

const ECG_samplefreq = 360;

const PPG_samplefreq = 50;
const PPG_samplesPerFrame = 2;

const ECG_DC_offset = 250;
const RpeakThres = 30; // of square !
const diffThres = 12; // of square !

const minBPM = 30;
const maxBPM = 240;

const BPMCounter = require('./BPMCounter.js');
const bpmctr = new BPMCounter.BPMCounter(ECG_samplefreq, RpeakThres, minBPM, maxBPM, diffThres);

const PPG_DC_offset = 511;

const Average = require('./Average.js');
const BPMaverage = new Average.Average();
const SPO2average = new Average.Average();

const PPG_averageSecondsVRMS = 2;
const SPO2_IR_MA = new Average.MovingAverage(PPG_samplefreq * PPG_averageSecondsVRMS);
const SPO2_RD_MA = new Average.MovingAverage(PPG_samplefreq * PPG_averageSecondsVRMS);

const StepCounter = require('./StepCounter.js');
const LeftStepCounter = new StepCounter.StepCounter();
const RightStepCounter = new StepCounter.StepCounter();

let stepsToday = getStepsToday();

function getStepsToday() {
  let today_12am = new Date();
  today_12am.setHours(0);
  today_12am.setMinutes(0);
  today_12am.setSeconds(0);
  today_12am.setMilliseconds(0);
  console.log(today_12am);
  console.log(today_12am.getTime() / 1000);
  return getSumRecords('Steps.csv', today_12am.getTime() / 1000);
}

function getSumRecords(file, start, end) {
  let sum = 0;
  try {
    let data = fs.readFileSync(path.join(__dirname, datafolder, file), 'utf8');
    let lines = data.split(/\n|\r\n|\r/);
    let startIndex = null;
    let endIndex = null;
    let i = 0;
    let timestamp = parseInt(lines[i].split(',', 2)[0]);
    console.log(lines);
    while ((isNaN(timestamp) || timestamp < start) && i < lines.length - 1) {
      i++;
      timestamp = parseInt(lines[i].split(',', 2)[0]);
    }
    while ((isNaN(timestamp) || timestamp <= end || !end) && i < lines.length - 1) {
      let value = parseInt(lines[i].split(',', 2)[1]);
      if (!isNaN(value))
        sum += value;
      console.log(timestamp + ': ' + value);
      i++;
      if (i < lines.length)
        timestamp = parseInt(lines[i].split(',', 2)[0]);
    }
  } catch (e) {
    console.log(e);
  }
  return sum;
}

//#region /* -----------------------------------SERIAL-PORT----------------------------------- */

let port;
SerialPort.list(function (err, ports) {
  if (ports.length == 0) {
    console.log("No serial ports available");
    return;
  }
  let comName = null;
  ports.forEach(function(port) {
    console.log(port.comName);
    console.log('\t'+port.pnpId);
    console.log('\t'+port.manufacturer);
    if (port.manufacturer == 'Arduino LLC (www.arduino.cc)') {
      comName = port.comName;
      console.log('\tFound Arduino');
      console.log('');
    }
  });
  if (comName == null)
    comName = ports[0].comName;
  port = new SerialPort(comName, {
    baudRate: 115200,
  }, function (err) {
    if (err) {
      return console.log('Serial port error: ', err.message);
    }
  });
  port.on('data', receiveSerial);
});

const ECG_samplesPerFrame = Math.floor(ECG_samplefreq / ECGdownsampleamount / framerate);

console.log("Downsample by " + ECGdownsampleamount + " samples.");
console.log(ECG_samplesPerFrame + " samples per frame.");

let ECGctr = 0; // For downsampling
let ECGsum = 0;

const Receiver = require('./Receiver.js');
const receiver = new Receiver.Receiver();

const Sender = require('./Sender.js');
const ECGsender = new Sender.BufferedSender(wss, Sender.message_type.ECG, ECG_samplesPerFrame);
const PPGSenderIR = new Sender.BufferedSender(wss, Sender.message_type.PPG_IR, PPG_samplesPerFrame);
const PPGSenderRD = new Sender.BufferedSender(wss, Sender.message_type.PPG_RED, PPG_samplesPerFrame);

function receiveSerial(dataBuf) {
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
          let ECG_squared = (message.value - ECG_DC_offset)*(message.value - ECG_DC_offset);
          if (bpmctr.run(ECG_squared / 1023)) { // Square to make R-peaks higher
            let BPMbuf = new Uint16Array(2);
            BPMbuf[0] = Sender.message_type.BPM;
            let BPM = bpmctr.getBPM();
            BPMbuf[1] = Math.round(BPM * 100);
            wss.broadcast(BPMbuf);
            BPMaverage.add(BPM);
          }
          break;
        case Receiver.message_type.PPG_IR:
          PPGSenderIR.send(message.value);
          let PPGvoltageIR = (message.value - PPG_DC_offset) * 5 / 1023.0;
          SPO2_IR_MA.add(PPGvoltageIR * PPGvoltageIR); // Calculate Mean Square
          break;
        case Receiver.message_type.PPG_RED:
          PPGSenderRD.send(message.value);
          let PPGvoltageRD = (message.value - PPG_DC_offset) * 5 / 1023.0;
          SPO2_RD_MA.add(PPGvoltageRD * PPGvoltageRD); // Calculate Mean Square          
          break;
        case Receiver.message_type.PRESSURE_A:
          let pressbufA = new Uint16Array(2);
          pressbufA[0] = Sender.message_type.PRESSURE_A;
          pressbufA[1] = message.value;
          wss.broadcast(pressbufA);
          if (LeftStepCounter.add(message.value)) {
            sendSteps();
          }
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
          if (RightStepCounter.add(message.value)) {
            sendSteps();
          }
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
}

function sendSteps() {
  let steps = stepsToday + LeftStepCounter.steps + RightStepCounter.steps;
  let stepsbuf = new Uint16Array(2);
  stepsbuf[0] = Sender.message_type.STEPS;
  stepsbuf[1] = steps;
  wss.broadcast(stepsbuf);
}

//#endregion

//#region /* -----------------------------------MINUTE-INTERVAL----------------------------------- */

let findMinuteInterval = setInterval(function () {
  let now = new Date();
  if (now.getSeconds() == 0) {
    console.log('min');
    everyMinute();
    clearInterval(findMinuteInterval);
    setInterval(everyMinute, 60 * 1000);
  }
}, 500);

function everyMinute() {
  let now = new Date();
  appendRecord('SPO2.csv', now, SPO2average.getAverage());
  appendRecord('BPM.csv', now, BPMaverage.getAverage());
  SPO2average.reset();
  BPMaverage.reset();
  if (now.getMinutes() % 15 === 0) {
    every15Minutes(now);
  }
}

function every15Minutes(now) {
  let steps = LeftStepCounter.steps + RightStepCounter.steps;
  appendRecord('Steps.csv', now, steps);
  stepsToday += steps;
  LeftStepCounter.reset();
  RightStepCounter.reset();
}

function appendRecord(file, now, value) {
  let timestamp = Math.round(now.getTime() / 1000);
  let entry =  new Buffer(`${timestamp},${value}\r\n`);
  fs.appendFile(path.join(__dirname, datafolder, file), entry, function (err) {
    if (err) {
      return console.log(err);
    }
    console.log(file + ' saved');
  });
}

//#endregion

//#region /* -----------------------------------SPO2-Calculation----------------------------------- */

let V_DC_IR = 6.15;
let V_DC_RD = 1.89;

let SPO2Interval = setInterval(function () {
  let SPO2buf = new Uint16Array(2);
  SPO2buf[0] = Sender.message_type.SPO2;
  let SPO2 = getSPO2();
  SPO2buf[1] = Math.round(SPO2 * 100);
  SPO2average.add(SPO2);
  wss.broadcast(SPO2buf);
}, 1000);

function getSPO2() {
  let V_AC_RMS_RD = Math.sqrt(SPO2_RD_MA.getAverage());
  let V_AC_RMS_IR = Math.sqrt(SPO2_IR_MA.getAverage());
  // console.log(`PPG Red V_RMS = ${V_AC_RMS_RD}`);
  // console.log(`PPG IR  V_RMS = ${V_AC_RMS_IR}\r\n`);
  // return 96 + 2 * Math.random(); // ;)
  let SPO2 = 110 - 25 * (V_AC_RMS_RD / V_DC_RD) / (V_AC_RMS_IR / V_DC_IR);
  console.log(SPO2);
  return SPO2;
}

//#endregion

//#region /* -----------------------------------HTTP-SERVER---------------------------------------- */

http.createServer(HTTPhandler).listen(8080);  // Start an HTTP server that listens on port 8080

function HTTPhandler(req, res) {
  // req.url = '/filename.ext?start=1234&end=5678'
  let URIparts = req.url.split('?', 2); // '/filename.ext', 'start=1234&end=5678'
  let URIfile = URIparts[0];            // '/filename.ext'
  URIfile = URIfile.replace(/^\//, ''); // 'filename.ext' (remove '/' at the start)
  let URIoptions = URIparts[1];         // 'start=1234&end=5678'

  if (URIfile === 'Steps.csv' ||
    URIfile === 'SPO2.csv' ||
    URIfile === 'BPM.csv') {
    let start = null;
    let end = null;
    if (URIoptions) {
      start = URIoptions.match(/.*start=(\d+).*/) ? parseInt(URIoptions.replace(/.*start=(\d+).*/, '$1')) : null;
      end = URIoptions.match(/.*end=(\d+).*/) ? URIoptions.replace(/.*end=(\d+).*/, '$1') : null;

      if (start != null && end != null && end < start) {
        res.write('400'); // 400: Bad request
        res.end();
        return;
      }
    }
    sendCSV(res, URIfile, start, end);
  } else {
    sendFile(res, URIfile);
  }
}

function sendFile(res, file) {
  file = file.replace(/\.\.\//, '');
  fs.readFile(path.join(__dirname, hostingFolder, file), function (err, data) {
    if (err) {
      res.writeHead(404);  // Error, file not found
      res.end();
      return console.log(err);
    }
    let contentType = getContentType(file);
    res.writeHead(200, { 'Content-Type': contentType }); // 200: OK
    res.write(data); // Send the file
    res.end(); // Finish response and close connection
  });
}

function getContentType(filename) {  // Get MIME type based on file extension
  let extname = path.extname(filename);
  let contentType = 'application/octet-stream';
  switch (extname) {
    case '.js':
      contentType = 'text/javascript';
      break;
    case '.css':
      contentType = 'text/css';
      break;
    case '.html':
      contentType = 'text/html';
      break;
  }
  return contentType;
}

function sendCSV(res, file, start, end) {
  fs.readFile(path.join(__dirname, datafolder, file), 'utf8', function (err, data) {
    if (err) {
      res.writeHead(404);  // Error, file not found
      res.end();
      return console.log(err);
      console.log();
    }
    let lines = data.split(/\n|\r\n|\r/);
    let [startIndex, endIndex] = getRecordsBetween(lines, start, end);
    res.writeHead(200, { 'Content-Type': 'text/csv' });
    for (i = startIndex; i <= endIndex; i++) { // Write out the selected records
      res.write(lines[i] + '\r\n');
    }
    res.end();
  });
}

function getRecordsBetween(lines, start, end) {
  let startIndex = null;
  let endIndex = null;
  for (i = 0; i < lines.length; i++) {
    if (lines[i] == '') {
      continue; // ignore empty lines
    }
    let timestamp = parseInt(lines[i].split(',', 2)[0]);  // Read timestamp (first value in entry)
    if (start != null &&
      startIndex == null && timestamp >= start) {  // if this is the first timestamp greater than or equal to start timestamp
      startIndex = i;
    }
    if (end != null && end != 0 &&
      endIndex == null && timestamp > end) { // if this is the first timestamp greater than the end timestamp
      endIndex = i - 1;
      break;
    }
    if (end != null && end != 0
      && endIndex == null && timestamp === end) { // if the timestamp is the end timestamp
      endIndex = i;
      break;
    }
  }
  if (start == null || startIndex == null) {
    startIndex = 0;
  }
  if (end == null || endIndex == null) {
    endIndex = lines.length - 1;
  }
  let firstTimestamp = parseInt(lines[0].split(',', 2)[0]);
  if (end != null && end < firstTimestamp) {
    endIndex = -1;
  }
  return [startIndex, endIndex];
}
//#endregion