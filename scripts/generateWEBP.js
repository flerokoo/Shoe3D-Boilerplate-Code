
var fs = require("fs")
var path = require("path")
var webp = require("webp-converter")

module.exports.generate = function (quality, callback) {
	if (!fs.existsSync("./build/assets")) {
		console.log("No build/assets folder")
		callback()
		return
	}
	generateRecursive("build/assets", quality)
	callback();
}


function generateRecursive(curpath, quality) {
	var files = fs.readdirSync(curpath)
	for (var i = 0; i < files.length; i++) {
		var file = files[i]
		var filePath = path.join(curpath, file)
		if (fs.statSync(filePath).isDirectory()) {
			generateRecursive(filePath, quality)
		} else {
			var parsedPath = path.parse(file)
			var newFilePath = path.join(curpath, parsedPath.name + '.webp')		
			switch (parsedPath.ext.toLowerCase()) {
				case '.jpeg':
				case '.jpg':
				case '.png':
				case '.bmp':
					webp.cwebp(
						filePath,
						newFilePath,
						'-q ' + quality,
						function (status) {
							if (status == 101) console.error("Couln't convert to webp: " + filePath)
						})
				case '.json':
						// replace png/jpg links to webp alternatives (cant just replace -- need to load jpg/png if webp is not supported)
					
			}
		}
	}
}
