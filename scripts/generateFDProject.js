var haxe = require("./parseHXML.js")
var fs = require("fs")
var path = require("path")


var template = fs.readFileSync(path.join(__dirname, "files", "template.hxproj")).toString()
fs.writeFileSync(path.join(       
        __dirname,
        "..",
        "Project-" + (haxe.flags.shoe3d_game_name == null ? "" : haxe.flags.shoe3d_game_name) + ".hxproj")
    , template);