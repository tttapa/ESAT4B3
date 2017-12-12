const mainpanel = document.getElementById("main");

let activeButton = null;
let activePanel = mainpanel;

const ECGButton = document.getElementById("ECGButton");
ECGButton.onclick = selectPanel;
const PPGButton = document.getElementById("PPGButton");
PPGButton.onclick = selectPanel;
const StepsButton = document.getElementById("StepsButton");
StepsButton.onclick = selectPanel;

function selectPanel() {
    let detailPanel = document.getElementById(this.dataset.panel);
    if (this.classList.toggle("active")) {
        detailPanel.classList.remove("invisible");
        activePanel.classList.add("invisible");
        if (activeButton != null) {
            activeButton.classList.remove("active");
        }
        activeButton = this;
        activePanel = detailPanel;
    } else {
        detailPanel.classList.add("invisible");
        mainpanel.classList.remove("invisible");
        activeButton = null;
        activePanel = mainpanel;
    }
}

var ws = new WebSocket("ws://localhost:8080");
ws.binaryType = 'arraybuffer';
ws.onopen = function (ev) {
    console.log("Connected");
};

const message_type = {
    ECG: 0,
    PPG_RED: 1,
    PPG_IR: 2,
    PRESSURE_A: 3,
    PRESSURE_B: 4,
    PRESSURE_C: 5,
    PRESSURE_D: 6,
    COMMAND: 7,
    BPM: 8,
    SPO2: 9,
    STEPS: 10,
};

// PLOTS
/* ---------------------------------------------------------------------- */

const downsampleamount = 2;
const ECG_samplefreq = 360;

const PPG_samplefreq = 50;
const SPO2limit = 88;

let ECGPlotContainer = document.getElementById("ECGplot");
let ECGPlot = new ScanningPlot(ECGPlotContainer, 5 * ECG_samplefreq / downsampleamount, "turquoise", false);

let PPGDetailPanel = document.getElementById("PPGDetail");
PPGDetailPanel.classList.remove("invisible");
let PPGPlotContainerIR = document.getElementById("PPGplotIR");
let PPGPlotIR = new ScanningPlot(PPGPlotContainerIR, 5 * PPG_samplefreq, "#FF11EE", false);

let PPGPlotContainerRD = document.getElementById("PPGplotRD");
let PPGPlotRD = new ScanningPlot(PPGPlotContainerRD, 5 * PPG_samplefreq, "#FF11EE", false);
PPGDetailPanel.classList.add("invisible");

let BPMtxt = document.getElementById("BPM");
let SPO2txt = document.getElementById("SPO2");

ws.onmessage = function (e) {
    let dataArray = new Uint16Array(e.data);
    // console.log(dataArray);  
    switch (dataArray[0]) {
        case message_type.ECG:
            for (i = 1; i < dataArray.length; i++) {
                ECGPlot.add(dataArray[i] / 1023);
            }
            break;
        case message_type.PPG_IR:
            for (i = 1; i < dataArray.length; i++) {
                PPGPlotIR.add(dataArray[i] / 1023);
            }
            break;
        case message_type.PPG_RED:
            for (i = 1; i < dataArray.length; i++) {
                PPGPlotRD.add(dataArray[i] / 1023);
            }
            break;
        case message_type.BPM:
            let BPM = '--,-';
            if (dataArray[1] !== 0) {
                BPM = (Math.round(dataArray[1] / 10) / 10).toFixed(1);
            }
            BPMtxt.textContent = BPM;
            break;
        case message_type.SPO2:
            let SPO2perc = Math.round(dataArray[1] / 10) / 10;
            let SPO2 = '--,-';
            if (SPO2perc < SPO2limit) {
                PPGButton.classList.add('alarm');
            } else {
                PPGButton.classList.remove('alarm');
            }
            if (dataArray[1] !== 0) {
                SPO2 = SPO2perc.toFixed(1);
            }
            SPO2txt.textContent = SPO2;
            break;
        case message_type.PRESSURE_A:
            setFootPressure(1, dataArray[1]/1023);
            break;
        case message_type.PRESSURE_B:
            setFootPressure(2, dataArray[1]/1023);
            break;
        case message_type.PRESSURE_C:
            setFootPressure(3, dataArray[1]/1023);
            break;
        case message_type.PRESSURE_D:
            setFootPressure(4, dataArray[1]/1023);
            break;
    }
};

// Steps

google.charts.load("current", { packages: ["corechart", "bar"] });
google.charts.setOnLoadCallback(drawChart);
function drawChart() {
    let data = google.visualization.arrayToDataTable([
        ['Time', 'Steps'],
        [new Date((1512990000) * 1000), 12],
        [new Date((1512990000 + 15 * 60) * 1000), 36],
        [new Date((1512990000 + 2 * 15 * 60) * 1000), 24],
        [new Date((1512990000 + 3 * 15 * 60) * 1000), 3],
    ]);

    let options = {
        // title: 'Number of steps per 15 minutes',
        legend: { position: 'none' },
        bar: { groupWidth: '84%' },
        backgroundColor: 'none',
        colors: ['yellow'],
        hAxis: {
            // title: 'Time',
            color: '#FFFFFF',
            textStyle: {
                color: '#FFFFFF'
            },
            gridlines: {
                color: 'none',
                // count: 24
            },
            minValue: new Date((1512990000) * 1000),
            maxValue: new Date((1512990000 + 24 * 60 * 60) * 1000),
            // format: 'H:00',

        },
        vAxis: {
            // title: 'Time',
            textStyle: {
                color: '#FFFFFF'
            },
            gridlines: {
                // color: '#333', 
                // count: 4
            }
        }

    };

    let chart = new google.visualization.ColumnChart(document.getElementById('StepsBar'));
    chart.draw(data, options);

    window.onresize = function (ev) {
        clearTimeout(window.resizeTimeout);
        window.resizeTimeout = setTimeout(function () {
            chart.clearChart();
            chart.draw(data, options);
            console.log('resize');
        }, 200);
    };
}

// Pressure 
function HSVtoRGB(h, s, v) { // https://stackoverflow.com/questions/17242144/javascript-convert-hsb-hsv-color-to-rgb-accurately
    let r, g, b, i, f, p, q, t;
    i = Math.floor(h * 6);
    f = h * 6 - i;
    p = v * (1 - s);
    q = v * (1 - f * s);
    t = v * (1 - (1 - f) * s);
    switch (i % 6) {
        case 0: r = v, g = t, b = p; break;
        case 1: r = q, g = v, b = p; break;
        case 2: r = p, g = v, b = t; break;
        case 3: r = p, g = q, b = v; break;
        case 4: r = t, g = p, b = v; break;
        case 5: r = v, g = p, b = q; break;
    }
    return {
        r: Math.round(r * 255),
        g: Math.round(g * 255),
        b: Math.round(b * 255)
    };
}

function pressureToColor(pressure) {
    let c = HSVtoRGB((1 - pressure) / 3, 1, 1);
    return `rgb(${c.r},${c.g},${c.b})`;
}

function pressureToCenterColor(pressure) {
    let c = HSVtoRGB((1 - pressure) / 3, 0.33, 1);
    return `rgb(${c.r},${c.g},${c.b})`;
}

function setFootPressure(foot, pressure) {
    let footgrad = document.getElementById("feetgrad" + foot);
    console.log(footgrad.childNodes);
    footgrad.childNodes[3].setAttribute("stop-color", pressureToColor(pressure));
    footgrad.childNodes[1].setAttribute("stop-color", pressureToCenterColor(pressure));
}