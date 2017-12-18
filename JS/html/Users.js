document.getElementById("userlogo").onclick = showUserPanel;

let newuser = document.getElementById("newuser");
newuser.onclick = newUser;

document.getElementById("height").oninput = updateBMI;
document.getElementById("weight").oninput = updateBMI;

function newUser() {
    document.getElementById("username").readOnly = false;
    document.getElementById("username").value = '';
    document.getElementById("age").value = 0;
    document.getElementById("weight").value = 0;
    document.getElementById("height").value = 0;
    document.getElementById("stepgoal").value = 10000;
    document.getElementById("BMI").value = 0;
    userpanel.classList.add("uservisible");        
}

loadUserData();

function loadUserData() {
    sendGETRequest('/users', function (data) {
        updateUserData(data);
    });
//    userpanel.classList.add("uservisible");    
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

function updateBMI() {
    let height = document.getElementById("height").value / 100;
    let weight = document.getElementById("weight").value;
    document.getElementById("BMI").value = Math.round(weight / height / height * 100) / 100;
}

function updateUserData(data) {
    let usersJson = JSON.parse(data);
    updateUserFields(usersJson);
    updateUserSelector(usersJson);
    document.getElementById("userlogo").textContent = usersJson.selectedUser[0];
    let user = usersJson.users[usersJson.selectedUser];
    updateBPMsGaugeLimits(user.age);
    updateStepGoal(user.stepgoal);
}
function updateUserFields(usersJson) {
    let user = usersJson.users[usersJson.selectedUser];
    document.getElementById("username").value = user.username;
    document.getElementById("age").value = user.age;
    document.getElementById("weight").value = user.weight;
    document.getElementById("height").value = user.height;
    document.getElementById("stepgoal").value = user.stepgoal;
    updateBMI();
}
function updateUserSelector(usersJson) {
    let userselector = document.getElementById("userselector");
    let children = userselector.childNodes;
    console.log(children);
    children.forEach(child => {
        if (child != newuser)
            userselector.removeChild(child);
    });

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
            userpanel.classList.add("uservisible");
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
    document.getElementById("username").readOnly = true;
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
