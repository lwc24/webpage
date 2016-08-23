var Elm = require('./src/Main.elm');
require('./styles/MyStyle.css')
var mountNode = document.getElementById('main');
var app = Elm.Main.embed(mountNode);
