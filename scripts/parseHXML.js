
var fs = require("fs")
var path = require("path")

var filepath = path.join(__dirname, "../build.hxml")

if (!fs.existsSync(filepath)) {
    console.error("Couldn't parse build.hxml: file not found")
}

var file = fs.readFileSync(filepath).toString();

// strip comments
file = file.replace(/(?!\B"[^"]*)#(?![^"]*"\B).*/gi, "")


// will fill it with everything
var output = {
    libs: [],
    classpaths: [],
    flags: {},
    params: {}
}

// parsing libs
var libre = /-lib[\s]+([\S]+)/gi;
var lib = libre.exec(file)
while (lib != null) {
    output.libs.push(lib[1]);
    lib = libre.exec(file)
}
file = file.replace(libre, "");

// parsing classpaths
var cpre = /-cp[\s]+([\S]+)/gi;
var cp = cpre.exec(file)
while (cp != null) {
    output.classpaths.push(cp[1]);
    cp = cpre.exec(file)
}
file = file.replace(cpre, "");

// parsing flags
var flagre = /-D[\s]+(.+)/gi;
var flag = flagre.exec(file)
while (flag != null) {
    var a = flag[1].split("=");
    output.flags[a[0]] = a[1] == null ? undefined :
        a[1].replace(/"+$/, "").replace(/^"+/gi, "")
    flag = flagre.exec(file)
}
file = file.replace(flagre, "");


var paramre = /-([\S]+)[\s]+([\S]+)/gi;
var param = paramre.exec(file)
while (param != null) {
    output.params[param[1]] = param[2] == null ? undefined :
        param[2].replace(/"+$/, "").replace(/^"+/gi, "")
    param = paramre.exec(file)
}
file = file.replace(paramre, "");

module.exports = output
