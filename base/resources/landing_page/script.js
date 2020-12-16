//accessPortModal includes the lightbox
var accessPortModal = document.getElementById("access-port-modal");
var accessPortButton = document.getElementById("access-port-button");
var closeModal = document.getElementById("close-access-port-modal");

accessPortButton.onclick = function () {
  accessPortModal.style.display = "block";
  document.getElementById("port-input").focus();
  removeFocus();
};

accessPortButton.onkeypress = function (event) {
  if (event.code === "Enter") {
    accessPortModal.style.display = "block";
    document.getElementById("port-input").value = "";
    document.getElementById("port-input").focus();
    removeFocus();
  }
};

closeModal.onclick = function () {
  closeAccessPortModal();
};

window.onclick = function (event) {
  //Click lightbox outside of modal-content
  if (event.target == accessPortModal) {
    closeAccessPortModal();
  }
};

window.addEventListener("load", (event) => {
  var xmlHttp = new XMLHttpRequest();
  const url = window.location.href + "/tools/42536/";
  xmlHttp.open("GET", url);
  xmlHttp.onreadystatechange = function () {
    if (this.readyState == 4 && this.status == 200) {
      console.log(xmlHttp.responseText);
    }
  };
  xmlHttp.send();
});

function removeFocus() {
  //Remove tab focus from launcher buttons
  var launchers = document.querySelectorAll(".launcher, .launcherlink");
  var i = launchers.length;
  while (i--) {
    launchers[i].setAttribute("tabindex", "-1");
  }
}

function accessPortInput() {
  var port = document.getElementById("port-input").value;
  if (port) {
    if (isNaN(port) || port < 1024 || port > 655335) {
      document.getElementById("port-error").innerHTML =
        port + " is not a valid port.";
    } else {
      window.open(window.location.pathname + "/tools/" + port, "_blank");
      closeAccessPortModal();
    }
  }
}

function closeAccessPortModal() {
  accessPortModal.style.display = "none";
  document.getElementById("port-error").innerHTML = "";

  //Return tab focus to launcher buttons
  var launchers = document.querySelectorAll(".launcher, .launcherlink");
  var i = launchers.length;
  while (i--) {
    launchers[i].setAttribute("tabindex", "0");
  }
}

document
  .getElementById("port-input")
  .addEventListener("keyup", function (event) {
    if (event.code === "Enter") {
      accessPortInput();
    }
  });

window.addEventListener("keyup", function (event) {
  if (event.code === "Escape") {
    closeAccessPortModal();
  }
});
