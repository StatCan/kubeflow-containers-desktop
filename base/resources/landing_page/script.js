// document.getElementById("page-path-debug").innerHTML = "Page path is: " + window.location.pathname;

function launch(button)
{
    var target = window.location.pathname + button.getAttribute('data-path');
    window.open(target, '_blank');
}

function ifEnterLaunch(key, button)
{
  if (event.code === 'Enter') 
  {
    launch(button);
  }
}

//accessPortModal includes the lightbox
var accessPortModal = document.getElementById("access-port-modal");
var accessPortButton = document.getElementById("access-port-button");
var closeModal = document.getElementById("close-access-port-modal");

accessPortButton.onclick = function() 
{
  accessPortModal.style.display = "block";
  document.getElementById("port-input").focus();

  //Remove tab focus from launcher buttons
  var launchers = document.querySelectorAll(".launcher");
  var i = launchers.length;
  while (i--)
  {
    launchers[i].setAttribute("tabindex", "-1");
  }
}

accessPortButton.onkeypress = function(event) 
{
  if (event.code === 'Enter')
  {
    accessPortModal.style.display = "block";
    document.getElementById("port-input").focus();
  } 
}

closeModal.onclick = function() 
{
  closeAccessPortModal();
}

window.onclick = function(event) 
{
  //Click lightbox outside of modal-content
  if (event.target == accessPortModal) 
  {
    closeAccessPortModal();
  }
} 

function accessPortInput() 
{
    var port = document.getElementById("port-input").value;
    if(port)
    {
        if (isNaN(port) || port < 1 || port > 655335) 
        {
          document.getElementById("port-error").innerHTML = (port + " is not a valid port.");
        }
        else 
        {
            window.open(window.location.pathname + '/tools/' + port, '_blank');
            closeAccessPortModal();
        }
    }
}

function closeAccessPortModal()
{
  accessPortModal.style.display = "none";
  document.getElementById("port-error").innerHTML = "";

  //Return tab focus to launcher buttons
  var launchers = document.querySelectorAll(".launcher");
  var i = launchers.length;
  while (i--)
  {
    launchers[i].setAttribute("tabindex", "0");
  }
}

document.getElementById("port-input").addEventListener('keyup', function(event) 
{
  if (event.code === 'Enter') 
  {
    accessPortInput();
  }
});

window.addEventListener('keyup', function(event) 
{
  if (event.code === 'Escape')
  {
    closeAccessPortModal();
  }
});