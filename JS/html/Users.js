document.getElementById("userlogo").onclick = showUserPanel;

loadUserData();

function loadUserData() {
    sendGETRequest('/users', function (data) {
        updateUserData(data);
    });
}

function showUserPanel() {
    sendGETRequest('/users', function (data) {
        updateUserData(data);
        userpanel.classList.add("uservisible");
    });
}

function sendGETRequest(uri, cb) {
    let xhttp = new XMLHttpRequest();
    xhttp.onreadystatechange = function () {
        if (this.readyState == 4 && this.status == 200) {
            cb(xhttp.responseText);
        }
    };
    xhttp.open("GET", uri, true);
    xhttp.send();
}

document.getElementById("height").oninput = updateBMI;
document.getElementById("weight").oninput = updateBMI;

function updateBMI() {
    let height = document.getElementById("height").value / 100;
    let weight = document.getElementById("weight").value;
    document.getElementById("BMI").value = Math.round(weight / height / height * 100) / 100;
}

function updateUserData(data) {
    let usersJson = JSON.parse(data);
    updateUserFields(usersJson);
    updateUserSelector(usersJson);
}
function updateUserFields(usersJson) {
    let user = usersJson.users[usersJson.selectedUser];
    document.getElementById("username").value = user.username;
    document.getElementById("age").value = user.age;
    document.getElementById("weight").value = user.weight;
    document.getElementById("height").value = user.height;
    document.getElementById("stepgoal").value = user.stepgoal;
    updateBPMsGaugeLimits(user.age);
    updateStepGoal(user.stepgoal);
    document.getElementById("userlogo").textContent = user.username[0];
    updateBMI();
}
function updateUserSelector(usersJson) {
    let userselector = document.getElementById("userselector");
    while (userselector.firstChild) {
        userselector.removeChild(userselector.firstChild);
    }
    console.log(usersJson);
    for (let key in usersJson.users) {
        let user = usersJson.users[key];
        if (user.username == usersJson.selectedUser)
            continue;
        let userButton = document.createElement("div");
        let folder = user.folder;
        userButton.textContent = user.username;
        userButton.onclick = function () {
            usersJson.selectedUser = folder;
            updateUserFields(usersJson);
            userselector.parentElement.blur(); // TODO
        };
        userselector.appendChild(userButton);
    }

}

function hideUserPanel() {
    userpanel.classList.add("fadeout");
    userpanel.classList.remove("uservisible");
    setTimeout(function () { userpanel.classList.remove("fadeout"); }, 500);
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
    xhttp.onreadystatechange = function () {
        if (this.readyState == 4) {
            if (this.status == 200) {
                loadUserData();
                drawCharts();
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
