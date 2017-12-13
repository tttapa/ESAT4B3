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
    reDrawCharts();
}
console.log(window.location);
let ws = new WebSocket(`ws://${window.location.hostname}:1425`);
ws.binaryType = 'arraybuffer';
ws.onopen = function (ev) {
    console.log("Connected");
};
ws.onerror = function (er) {
    console.log(er);
    document.getElementById("mainwindow").classList.add("offline");
    setTimeout(function () { alert('Connection error.'); }, 100);
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

let SPO2PlotContainer = document.getElementById("SPO2plot");
let SPO2Plot = new MovingPlot(SPO2PlotContainer, 60, "#FF11EE", true);

let BPMtxt = document.getElementById("BPM");
let SPO2txt = document.getElementById("SPO2");
let Steptxt = document.getElementById("Steps");

let PPGAlarmInterval;

ws.onmessage = function (e) {
    clearTimeout(ws.timeOut);
    ws.timeOut = setTimeout(disconnect, 1000);
    let dataArray = new Uint16Array(e.data);
    // console.log(dataArray);  
    switch (dataArray[0]) {
        case message_type.ECG:
            for (i = 1; i < dataArray.length; i++) {
                ECGPlot.add(dataArray[i] / 1023);
                // ECGPlot.add((dataArray[i] / 1023)**2);
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
            let BPMtextval = '--,-';
            let BPM = Math.round(dataArray[1] / 10) / 10;
            if (BPM !== 0) {
                BPMtextval = BPM.toFixed(1);
            }
            updateBPMsGauge(BPM);
            BPMtxt.textContent = BPMtextval;
            break;
        case message_type.SPO2:
            let SPO2perc = Math.round(dataArray[1] / 10) / 10;
            let SPO2 = '--,-';
            if (SPO2perc < SPO2limit) {
                if (PPGAlarmInterval == null) {
                    PPGButton.classList.add('alarm');
                    PPGAlarmInterval = setInterval(function () {
                        PPGButton.classList.toggle('alarm');
                    }, 500);
                }
            } else {
                clearInterval(PPGAlarmInterval);
                PPGAlarmInterval = null;
                PPGButton.classList.remove('alarm');
            }
            if (dataArray[1] !== 0) {
                SPO2 = SPO2perc.toFixed(1);
            }
            SPO2txt.textContent = SPO2;
            SPO2Plot.add(SPO2perc / 100);
            break;
        case message_type.PRESSURE_A:
            setFootPressure(1, dataArray[1] / 1023);
            break;
        case message_type.PRESSURE_B:
            setFootPressure(2, dataArray[1] / 1023);
            break;
        case message_type.PRESSURE_C:
            setFootPressure(3, dataArray[1] / 1023);
            break;
        case message_type.PRESSURE_D:
            setFootPressure(4, dataArray[1] / 1023);
            break;
        case message_type.STEPS:
            Steptxt.textContent = dataArray[1];
            updateStepsGauge(dataArray[1]);
            break;
    }
};

function disconnect() {
    document.getElementById("mainwindow").classList.add("offline");
    setTimeout(function () { alert('Connection lost.'); }, 1000);
}

// Steps, BPM & SPO2 plots

google.charts.load("current", { packages: ["corechart", "bar", "gauge"] });
google.charts.setOnLoadCallback(drawCharts);

function drawCharts() {
    if (google.visualization == undefined) {
        return;
    }
    let nowDate = new Date();
    let now = Math.floor(nowDate.getTime() / 1000);

    {
        let xmlhttp = new XMLHttpRequest();
        xmlhttp.onreadystatechange = function () {
            if (this.readyState == 4 && this.status == 200) {
                let dataArray = parseCSV(this.responseText).data;
                updateStepsChart(dataArray);
            }
        };
        xmlhttp.open("GET", `${window.location.origin}/Steps.csv?start=${now - 24 * 60 * 60}&end=${now}`, true);
        xmlhttp.send();
    }
    {
        let BPMStatsRadioBtnTime = parseInt(document.querySelector('input[name = "timeframeBPM"]:checked').value);

        let xmlhttp = new XMLHttpRequest();
        xmlhttp.onreadystatechange = function () {
            if (this.readyState == 4 && this.status == 200) {
                let parsed = parseCSV(this.responseText);

                document.getElementById("BPMAvg").textContent = parsed.avg;
                document.getElementById("BPMMin").textContent = parsed.min;
                document.getElementById("BPMMax").textContent = parsed.max;

                updateBPMChart(parsed.data);
            }
        };
        xmlhttp.open("GET", `/BPM.csv?start=${now - BPMStatsRadioBtnTime}&end=${now}`, true);
        xmlhttp.send();
    }
    {
        let SPO02StatsRadioBtnTime = parseInt(document.querySelector('input[name = "timeframeSPO2"]:checked').value);

        let xmlhttp = new XMLHttpRequest();
        xmlhttp.onreadystatechange = function () {
            if (this.readyState == 4 && this.status == 200) {
                let parsed = parseCSV(this.responseText);

                document.getElementById("SPO2Avg").textContent = parsed.avg;
                document.getElementById("SPO2Min").textContent = parsed.min;
                document.getElementById("SPO2Max").textContent = parsed.max;

                updateSPO2Chart(parsed.data);
            }
        };
        xmlhttp.open("GET", `/SPO2.csv?start=${now - SPO02StatsRadioBtnTime}&end=${now}`, true);
        xmlhttp.send();
    }
}

let BPMStats = document.getElementById("BPMStats");
BPMStats.onchange = function () { drawCharts(); };

let SPO2Stats = document.getElementById("SPO2Stats");
SPO2Stats.onchange = function () { drawCharts(); };

function parseCSV(string) {
    var array = [];
    var max = 0;
    var min = 65535; // I'm lazy
    let sum = 0.0;
    var lines = string.split("\n");
    for (var i = 0; i < lines.length; i++) {
        var data = lines[i].split(",", 2);
        data[0] = new Date(parseInt(data[0]) * 1000);
        data[1] = parseFloat(data[1]);
        if (isNaN(data[1]))
            continue;
        if (data[1] > max)
            max = data[1];
        if (data[1] < min)
            min = data[1];
        sum += data[1];
        array.push(data);
    }
    ret = new Object();
    ret.data = array;
    ret.max = (Math.round(max * 10) / 10).toFixed(1);
    ret.min = (Math.round(min * 10) / 10).toFixed(1);;
    ret.avg = (Math.round(sum * 10 / array.length) / 10).toFixed(1);;
    return ret;
}

let barChartOptions = {
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
        maxValue: new Date(),
        minValue: new Date((new Date()).getTime() - 24 * 60 * 60 * 1000),
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

let barChart;
let stepData;

function updateStepsChart(array) {
    stepData = new google.visualization.DataTable();
    stepData.addColumn('datetime', 'Time');
    stepData.addColumn('number', 'Steps');

    stepData.addRows(array);

    let now = new Date();
    barChartOptions.hAxis.maxValue = now;
    barChartOptions.hAxis.minValue = new Date(now.getTime() - 24 * 60 * 60 * 1000);

    if (!barChart)
        barChart = new google.visualization.ColumnChart(document.getElementById('StepsBar'));
    barChart.draw(stepData, barChartOptions);
}

let stepGaugeOptions = {
    // width: 400, height: 120,
    greenFrom: 90, greenTo: 100,
    yellowFrom: 75, yellowTo: 90,
    minorTicks: 5,
};

let stepGauge;
let stepGaugeData;

let stepGoal = 6000;

function updateStepsGauge(value) {
    value *= 100;
    value /= stepGoal;
    value = Math.round(value);
    if (value != null) {
        stepGaugeData = google.visualization.arrayToDataTable([
            ['Label', 'Value'],
            ['Steps (%)', value],
        ]);
    }

    if (!stepGauge)
        stepGauge = new google.visualization.Gauge(document.getElementById('StepsGauge'));
    if (stepGaugeData)
        stepGauge.draw(stepGaugeData, stepGaugeOptions);
}

let BPMGaugeOptions = {
    // width: 400, height: 120,
    yellowFrom: 30, yellowTo: 60,
    minorTicks: 5,
    min: 30,
    max: 220,
    yellowColor: 'blue',
    greenFrom: 60, greenTo: 200,
    redFrom: 200, redTo: 220,
    forceIFrame: true,
};

let BPMGauge;
let BPMGaugeData;

function updateBPMsGauge(value) {
    if (value != null) {
        BPMGaugeData = google.visualization.arrayToDataTable([
            ['Label', 'Value'],
            ['BPM', value],
        ]);
    }

    if (!BPMGauge)
        BPMGauge = new google.visualization.Gauge(document.getElementById('BPMGauge'));
    if (BPMGaugeData)
        BPMGauge.draw(BPMGaugeData, BPMGaugeOptions);
}

let BPMChartOptions = {
    // title: 'Number of steps per 15 minutes',
    legend: { position: 'none' },
    backgroundColor: 'none',
    colors: ['turquoise'],
    hAxis: {
        // title: 'Time',
        color: '#FFFFFF',
        textStyle: {
            color: '#FFFFFF'
        },
        gridlines: {
            // color: 'none',
            // count: 24
        },
        maxValue: new Date(),
        minValue: new Date((new Date()).getTime() - 30 * 60 * 1000),
        // format: 'H:00',

    },
    vAxis: {
        title: 'BPM',
        titleTextStyle: {
            color: '#FFFFFF'
        },
        textStyle: {
            color: '#FFFFFF'
        },
        gridlines: {
            // color: '#333', 
            // count: 4
        }
    }
};

let BPMChart;
let BPMData;

function updateBPMChart(array) {
    BPMData = new google.visualization.DataTable();
    BPMData.addColumn('datetime', 'Time');
    BPMData.addColumn('number', 'Steps');

    BPMData.addRows(array);

    let BPMStatsRadioBtnTime = parseInt(document.querySelector('input[name = "timeframeBPM"]:checked').value);
    let now = new Date();
    BPMChartOptions.hAxis.maxValue = now;
    BPMChartOptions.hAxis.minValue = new Date(now.getTime() - BPMStatsRadioBtnTime * 1000);

    if (!BPMChart)
        BPMChart = new google.visualization.LineChart(document.getElementById('BPMPlot'));
    BPMChart.draw(BPMData, BPMChartOptions);
}

let SPO2ChartOptions = {
    // title: 'Number of steps per 15 minutes',
    legend: { position: 'none' },
    backgroundColor: 'none',
    colors: ['#FF55EE'],
    hAxis: {
        // title: 'Time',
        color: '#FFFFFF',
        textStyle: {
            color: '#FFFFFF'
        },
        gridlines: {
            // color: 'none',
            // count: 24
        },
        maxValue: new Date(),
        minValue: new Date((new Date()).getTime() - 30 * 60 * 1000),
        // format: 'H:00',

    },
    vAxis: {
        title: 'SPO2',
        titleTextStyle: {
            color: '#FFFFFF'
        },
        textStyle: {
            color: '#FFFFFF'
        },
        gridlines: {
            // color: '#333', 
            // count: 4
        }
    }
};

let SPO2Chart;
let SPO2Data;

function updateSPO2Chart(array) {
    SPO2Data = new google.visualization.DataTable();
    SPO2Data.addColumn('datetime', 'Time');
    SPO2Data.addColumn('number', 'Steps');

    SPO2Data.addRows(array);

    let SPO2StatsRadioBtnTime = parseInt(document.querySelector('input[name = "timeframeSPO2"]:checked').value);
    let now = new Date();
    SPO2ChartOptions.hAxis.maxValue = now;
    SPO2ChartOptions.hAxis.minValue = new Date(now.getTime() - SPO2StatsRadioBtnTime * 1000);

    if (!SPO2Chart)
        SPO2Chart = new google.visualization.LineChart(document.getElementById('SPO2Plot'));
    SPO2Chart.draw(SPO2Data, SPO2ChartOptions);
}

window.onresize = function (ev) {
    clearTimeout(window.resizeTimeout);
    window.resizeTimeout = setTimeout(function () {
        reDrawCharts();
    }, 200);
};

function reDrawCharts() {
    barChart.clearChart();
    barChart.draw(stepData, barChartOptions);
    BPMChart.clearChart();
    BPMChart.draw(BPMData, BPMChartOptions);
    SPO2Chart.clearChart();
    SPO2Chart.draw(SPO2Data, SPO2ChartOptions);
    updateBPMsGauge(null);
    updateStepsGauge(null);
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
    footgrad.childNodes[3].setAttribute("stop-color", pressureToColor(pressure));
    footgrad.childNodes[1].setAttribute("stop-color", pressureToCenterColor(pressure));
}


let findMinuteInterval = setInterval(function () {
    let now = new Date();
    if (now.getSeconds() == 1) {
        console.log('min');
        drawCharts();
        clearInterval(findMinuteInterval);
        setInterval(drawCharts, 60 * 1000);
    }
}, 500);