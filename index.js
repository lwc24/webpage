var Elm = require('elm!./src/Main.elm');
var mountNode = document.getElementById('main');
var app = Elm.Main.embed(mountNode);
