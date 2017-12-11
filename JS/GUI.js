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
let ECGPlotContainer = document.getElementById("ECGplot");
let ECGPlot = new ScanningPlot(ECGPlotContainer, 200, "turquoise", true);

var ws = new WebSocket("ws://localhost:8080");
ws.onopen = function(ev) { 
  console.log("Connected");
  ws.send('Test'); 
};
ws.onmessage = function (e) {
  // console.log(e.data);
  let floatVal = parseFloat(e.data)/200;
  ECGPlot.add(floatVal);
};
