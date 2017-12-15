header.onclick = showUserPanel;

function showUserPanel() {
    let xhttp = new XMLHttpRequest();
    xhttp.onreadystatechange = function() {
        if (this.readyState == 4 && this.status == 200) {
            let formdata = JSON.parse(xhttp.responseText);
            document.getElementById("username").value = formdata.username;
            document.getElementById("age").value = formdata.age;
            document.getElementById("weight").value = formdata.weight;
            document.getElementById("height").value = formdata.height;
            document.getElementById("stepgoal").value = formdata.stepgoal;
            userpanel.classList.add("uservisible");
        }
    };
    xhttp.open("GET", "/users", true);
    xhttp.send();
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
        if (this.readyState == 4 && this.status != 200) {
            alert("Sending user data failed!");
        }
    };
    xhttp.open("POST", "/users", true);
    xhttp.send();
    hideUserPanel();
    return false;
}
