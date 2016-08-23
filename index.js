var Elm = require('elm!./src/Main.elm');
var cssStyle = require('css!./styles/MyStyle.css')
var mountNode = document.getElementById('main');
var app = Elm.Main.embed(mountNode);
