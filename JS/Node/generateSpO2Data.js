let starttime = new Date();
starttime.setSeconds(0);
let timestamp = Math.round(starttime.getTime() / 1000) - 6 * 60 * 60; // six hours earlier

let now = (new Date()).getTime() / 1000;

let data = '';
let i = 0;
while (timestamp < now) {
    // console.log(`${timestamp},${75 + 2 * Math.sin(Math.PI * i / 500) + 2 * Math.random()}`);
    data += `${timestamp},${96 + 1 * Math.sin(Math.PI * i / 500) + 0.1 * Math.sin(Math.PI * i / 2) + 0.1 * Math.random()}\r\n`;
    i++;
    timestamp += 60;
}

const fs = require('fs');
const path = require('path');


const datafolder = 'Data';
if (!fs.existsSync(path.join(__dirname, datafolder))) {
    fs.mkdirSync(path.join(__dirname, datafolder));
}

fs.writeFile(path.join(__dirname, datafolder,'SPO2.csv'), data, function (err) {
    if (err) {
        return console.log(err);
    }

    console.log("The file was saved!");
}); 
