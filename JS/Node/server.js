const fs = require('fs');
const path = require('path');

const WebSocket = require('ws');

const SerialPort = require('serialport');



const datafolder = 'Data';

if (!fs.existsSync(path.join(__dirname,datafolder))){
  fs.mkdirSync(path.join(__dirname,datafolder));
}

/* -----------------------------------WEBSOCKET----------------------------------- */

const wss = new WebSocket.Server({ port: 1425 });

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

/* -----------------------------------SERIAL-PORT----------------------------------- */

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

const PPG_samplefreq = 50;
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
            let BPM = bpmctr.getBPM();
            BPMbuf[1] = Math.round(BPM * 100);
            wss.broadcast(BPMbuf);
            BPMaverage.add(BPM);
          }
          break;
        case Receiver.message_type.PPG_IR:
          PPGSenderIR.send(message.value);
          SPO2_IR_MA.add(message.value * message.value); // Calculate Mean Square
          break;
        case Receiver.message_type.PPG_RED:
          PPGSenderRD.send(message.value);
          SPO2_RD_MA.add(message.value * message.value); // Calculate Mean Square          
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
});

function sendSteps() {
  let steps = stepsToday + LeftStepCounter.steps + RightStepCounter.steps;
  let stepsbuf = new Uint16Array(2);
  stepsbuf[0] = Sender.message_type.STEPS;
  stepsbuf[1] = steps;
  wss.broadcast(stepsbuf);
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
/* -----------------------------------MINUTE-INTERVAL----------------------------------- */

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
  fs.appendFile(path.join(__dirname, datafolder, file), new Buffer(`${Math.round(now.getTime() / 1000)},${value}\r\n`), function (err) {
    if (err) {
      return console.log(err);
    }
    console.log(file + ' saved');
  });
}

/* -----------------------------------SPO2-Calculation----------------------------------- */

let SPO2Interval = setInterval(function () {
  let SPO2buf = new Uint16Array(2);
  SPO2buf[0] = Sender.message_type.SPO2;
  let SPO2 = getSPO2();
  SPO2buf[1] = Math.round(SPO2 * 100);
  SPO2average.add(SPO2);
  wss.broadcast(SPO2buf);
}, 1000);

function getSPO2() {
  return 60 + 2 * Math.random();
}

/* -----------------------------------HTTP-SERVER----------------------------------- */

// TODO change hosting folder 

//#region http
var http = require('http');
http.createServer(function (req, res) {
  let URIparts = req.url.split('?', 2);
  let URIfile = URIparts[0];
  // URIfile = URIfile.replace(/^.*\//, '');
  URIfile = URIfile.replace(/^\//, '');
  let URIoptions = URIparts[1];
  if (URIfile === 'Steps.csv' ||
    URIfile === 'SPO2.csv' ||
    URIfile === 'BPM.csv') {
    let start = null;
    let end = null;
    if (URIoptions) {
      start = URIoptions.match(/start=\d+/);
      if (start != null) {
        start = parseInt(start[0].split('=')[1]);
      }
      end = URIoptions.match(/end=\d+/);
      if (end != null) {
        end = parseInt(end[0].split('=')[1]);
        if (start != null && end < start) {
          res.write('400');
          res.end();
          return;
        }
      }
    }
    sendCSV(res, URIfile, start, end);
    /*} else if (URIfile === 'GUI.html' ||
               URIfile === 'GUI.js' ||
               URIfile === 'Plot.js' ||
               URIfile === 'GUI.html') {
      sendFile(res, URIfile)*/
  } else {
    sendFile(res, URIfile);
    //res.write('404');
    //res.end();
  }
}).listen(8080);

function sendFile(res, file) {
  file = file.replace(/\.\.\//, '');
  fs.readFile(path.join(__dirname, '..', file), function (err, data) {
    if (err) {
      res.writeHead(500);
      res.end();
      return console.log(err);
    }
    let extname = path.extname(file);
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
    res.writeHead(200, { 'Content-Type': contentType });
    res.write(data)
    res.end();
  });
}

function sendCSV(res, file, start, end) {
  fs.readFile(path.join(__dirname, datafolder, file), 'utf8', function (err, data) {
    if (err) {
      res.writeHead(500);
      res.end();
      return console.log(err);
    }
    let lines = data.split(/\n|\r\n|\r/);
    let startIndex = null;
    let endIndex = null;
    for (i = 0; i < lines.length; i++) {
      if (lines[i] == '') {
        continue; // ignore empty lines
      }
      let timestamp = parseInt(lines[i].split(',', 2)[0]);
      if (start != null && startIndex == null && timestamp >= start) {
        startIndex = i;
      }
      if (end != null && end != 0 && endIndex == null && timestamp > end) {
        endIndex = i - 1;
      }
      if (end != null && end != 0 && endIndex == null && timestamp === end) {
        endIndex = i;
      }
      // console.log(timestamp + ' startIndex = ' + startIndex + ' endIndex = ' + endIndex +
      //  ' start = ' + start + ' end = ' + end);
    }
    if (start == null || startIndex == null) {
      startIndex = 0;
    }
    if (end == null || endIndex == null) {
      endIndex = lines.length - 1;
    }
    if (end != null && end < parseInt(lines[0].split(',', 2)[0])) {
      // console.log('end < first enty');
      endIndex = -1;
    }
    res.writeHead(200, { 'Content-Type': 'text/csv' });
    for (i = startIndex; i <= endIndex; i++) {
      res.write(lines[i] + '\r\n');
    }
    res.end();
    // console.log(lines);
    // console.log(startIndex + ' - ' + endIndex);
  });
}
//#endregion