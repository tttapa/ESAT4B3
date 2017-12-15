document.getElementById("userlogo").onclick = showUserPanel;

loadUserData();

function loadUserData() {
    sendGETRequest('/users', function(data) {
        getUserData(data);
    });
}

function showUserPanel() {
    sendGETRequest('/users', function(data) {
        getUserData(data);
        userpanel.classList.add("uservisible");
    });
}

function sendGETRequest(uri, cb) {
    let xhttp = new XMLHttpRequest();
    xhttp.onreadystatechange = function() {
        if (this.readyState == 4 && this.status == 200) {
            cb(xhttp.responseText);
        }
    };
    xhttp.open("GET", uri, true);
    xhttp.send();
}

function getUserData(data) {
    let formdata = JSON.parse(data);
    document.getElementById("username").value = formdata.username;
    document.getElementById("age").value = formdata.age;
    document.getElementById("weight").value = formdata.weight;
    document.getElementById("height").value = formdata.height;
    document.getElementById("stepgoal").value = formdata.stepgoal;
    updateBPMsGaugeLimits(formdata.age);
    updateStepGoal(formdata.stepgoal);
}

function hideUserPanel() {
    userpanel.classList.add("fadeout");
    userpanel.classList.remove("uservisible");
    setTimeout(function() { userpanel.classList.remove("fadeout"); }, 500);
}

function sendUserForm() {
    let formdata = new Object();
    formdata.username = document.getElementById("username").value;
    formdata.age = document.getElementById("age").value;
    formdata.weight = document.getElementById("weight").value;
    formdata.height = document.getElementById("height").value;
    formdata.stepgoal = document.getElementById("stepgoal").value;
    let data = JSON.stringify(formdata);
    console.log(data);
    let xhttp = new XMLHttpRequest();
    xhttp.onreadystatechange = function() {
        if (this.readyState == 4) {
            if (this.status == 200) {
                loadUserData();
            } else {
                alert("Sending user data failed!");
            }
        }
    };
    xhttp.open("POST", "/users", true);
    xhttp.send(data);
    hideUserPanel();
    return false;
}
