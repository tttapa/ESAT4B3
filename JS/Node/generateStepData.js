let steps = [0, 0, 0, 0,  // 0:00
    0, 0, 0, 0,  // 1:00
    0, 0, 0, 0,  // 2:00
    0, 0, 0, 0,  // 3:00
    0, 0, 0, 0,  // 4:00
    0, 0, 0, 0,  // 5:00
    50, 100, 150, 600,  // 6:00
    400, 300, 400, 150,  // 7:00
    0, 0, 0, 0,  // 8:00
    0, 300, 0, 0,  // 9:00
    150, 30, 150, 100,  // 10:00
    100, 0, 0, 0,  // 11:00
    0, 300, 150, 150,  // 12:00
    0, 0, 500, 400,  // 13:00
    0, 0, 0, 0,  // 14:00
    250, 0, 0, 0,  // 15:00
    0, 0, 0, 0,  // 16:00
    0, 0, 0, 0,  // 17:00
    0, 0, 0, 0,  // 18:00
    0, 0, 0, 0,  // 19:00
    0, 0, 0, 0,  // 20:00
    0, 0, 0, 0,  // 21:00
    0, 0, 0, 0,  // 22:00
    0, 0, 0, 0];  // 23:00

let today_12am = new Date();
today_12am.setHours(0);
today_12am.setMinutes(0);
today_12am.setSeconds(0);
today_12am.setMilliseconds(0);
let timestamp = today_12am.getTime() / 1000;

let now = (new Date()).getTime() / 1000;

let data = ''
let i = 0;
while (timestamp < now && i < steps.length) {
    // console.log(`${timestamp},${steps[i]}`);
    data += `${timestamp},${steps[i]}\r\n`;
    i++;
    timestamp += 15 * 60;
}

const fs = require('fs');
const path = require('path');


const datafolder = 'Data';
if (!fs.existsSync(path.join(__dirname, datafolder))) {
    fs.mkdirSync(path.join(__dirname, datafolder));
}

fs.writeFile(path.join(__dirname, datafolder,'Steps.csv'), data, function (err) {
    if (err) {
        return console.log(err);
    }

    console.log("The file was saved!");
}); 
