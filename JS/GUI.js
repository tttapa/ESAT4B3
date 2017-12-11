let mainpanel = document.getElementById("main");  

let activeButton = null;
let activePanel = mainpanel;

let ECGButton = document.getElementById("ECGButton");
ECGButton.onclick = selectPanel;
let PPGButton = document.getElementById("PPGButton");
PPGButton.onclick = selectPanel;
let StepsButton = document.getElementById("StepsButton");
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

// PLOTS
/* ---------------------------------------------------------------------- */

// ECG

let ECGPlotContainer = document.getElementById("ECGplot");
let ECGPlot = new ScanningPlot(ECGPlotContainer, 200, "turquoise", true);

var ws = new WebSocket("ws://localhost:8080");
ws.onopen = function(ev) { 
  console.log("Connected");
};
ws.onmessage = function (e) {
  // console.log(e.data);
  let floatVal = parseFloat(e.data)/200;
  ECGPlot.add(floatVal);
};

// PPG

// Steps

google.charts.load("current", {packages:["corechart","bar"]});
google.charts.setOnLoadCallback(drawChart);
function drawChart() {
    let data = google.visualization.arrayToDataTable([
        ['Time', 'Steps'],
        [new Date((1512990000)*1000), 12],
        [new Date((1512990000+15*60)*1000), 36],
        [new Date((1512990000+2*15*60)*1000), 24],
        [new Date((1512990000+3*15*60)*1000), 3],
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
            minValue: new Date((1512990000)*1000),
            maxValue: new Date((1512990000+24*60*60)*1000),
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
    console.log(getMethods(chart));

    window.onresize = function(ev) {
        clearTimeout(window.resizeTimeout);
        window.resizeTimeout = setTimeout(function() {
            chart.clearChart();
            chart.draw(data, options);  
            console.log('resize');
        }, 200);
    };
}

function getMethods(obj) {
    var res = [];
    for(var m in obj) {
        if(typeof obj[m] == "function") {
            res.push(m)
        }
    }
    return res;
}