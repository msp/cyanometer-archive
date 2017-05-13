'use strict';

// Require these so they get copied to dist
require('./common.scss');
require('./main.scss');
require ('./images/Icon_organisation.svg')
require('./index.html');

var Elm = require('./Main.elm');
var mountNode = document.getElementById('archive');

// The third value on embed are the initial values for incomming ports into Elm
var app = Elm.Main.embed(mountNode, {endpoint: process.env.API_ENDPOINT});

// subscribe to messages from Elm
// http://stackoverflow.com/documentation/elm/2200/ports-js-interop#t=201611111845538920271
app.ports.sendAlertToJs.subscribe(function(messageFromElm) {
  alert(messageFromElm);
});

var scrollDelay = 100;

app.ports.scrollThingIntoView.subscribe(function(message) {
  var targetElement = message.id + "." +message.className;
  setTimeout(function(){ doScroll(targetElement, 'exisiting-things-list'); }, scrollDelay);
});

app.ports.scrollSourceIntoView.subscribe(function(message) {
  var targetElement = message.id + "." +message.className;
  setTimeout(function(){ doScroll(targetElement, 'exisiting-source-list'); }, scrollDelay);
});

app.ports.scrollPageTop.subscribe(function(message) {
  window.scrollTo(0, 0);
});

// send messages to Elm
app.ports.sendConfirmToJs.subscribe(function(uuid) {
  var response = confirm('Are you sure you want to delete this ?');

  if (response) {
    app.ports.receiveConfirmFromJs.send(uuid);
  }
});

// Utils
function doScroll(targetElement, container) {
  removeExistingHighlightClassesFrom(container);

  var namespacedTargetElement = "#"+container + " #"+targetElement;
  var target = document.querySelector(namespacedTargetElement);

  if (target) {
    var topPos = target.offsetTop;
    document.getElementById(container).scrollTop = topPos-10;

    target.classList.remove('highlight');
    target.classList.remove('animated');

    target.classList.add('animated');
    target.classList.add('highlight');
  }
}

function removeExistingHighlightClassesFrom(container) {
  var existing = document.getElementById(container);
  var li = existing.getElementsByTagName('li')

  for (var i = 0; i < li.length; i++) {
      li[i].classList.remove('highlight');
      li[i].classList.remove('animated');
  }
}
