var gulp = require("gulp")
var exec = require("child_process").exec
var args = require("yargs").argv
var changed = require("gulp-changed")
var concat = require("gulp-concat")
var gulpif = require("gulp-if")
var uglify = require("gulp-uglify")
var sequence = require("gulp-sequence")
var del = require("del")
var tap = require("gulp-tap")
var browserSync = require("browser-sync").create()
var sourcemaps = require("gulp-sourcemaps")
require('gulp-help')(gulp)


var settings = {
    includeSourceMaps: true,
    bundleOrder: [
        "build/js/es6-promise-polyfill.js",
        "build/js/typedarray.js", 
        "build/js/soundjs-0.6.2.min.js", 
        "build/js/three.js", 
        "build/js/spe.min.js",
        "build/js/GLTFLoader.js"
    ]
}

var hxml = require("./scripts/parseHXML")

var debug = args.release === undefined || !args.release;

gulp.task( "compile", "Compile haxe code into js", function( callback ) {
    exec("haxe build.hxml" + ( debug ? ' -debug' : ''), function(err, sout, serr) {
        console.log(sout)
        callback(err)
    })
})

gulp.task( "copy-assets", "Copy all assets to build folder", function() {
    return gulp.src("assets/**/*")
        .pipe(changed("build/assets/"))
        .pipe(gulp.dest( "build/assets/"))
})

gulp.task( "generate-webp", "Converts all textures to webp format", function(callback) {
	var quality = hxml.flags["shoe3d_generate_webp"];
    if (quality && parseInt(quality) != null) {
        require("./scripts/generateWEBP").generate(quality, callback)
    } else {
        console.log("Flag shoe3d_generate_webp is not enabled. Skipping this task...")
        callback()
    }
})

gulp.task( "copy-bootstrap", "Copy static files to build folder",  function() {
    return gulp.src("web/**/*")
        .pipe(changed("build/"))
        .pipe(gulp.dest( "build/"))
})

gulp.task( "bundle", "Concat all js files contained in build folder into one", function() {
    var bundleList = settings.bundleOrder.concat(["build/js/game.js"]);
    return gulp.src(bundleList)
        .pipe(sourcemaps.init({loadMaps: settings.includeSourceMaps}))    
        .pipe(concat("bundle.js"))
        .pipe(gulpif(!debug, uglify()))
        .pipe(gulpif(debug && settings.includeSourceMaps, sourcemaps.write()))
        .pipe(gulp.dest("build/js/"))
        .pipe(tap(function(){
                if(!debug) {
                    del(bundleList);                
                }
            }))
})

gulp.task( "serve", "Start development server", function(){
    browserSync.init({
        port: 11100,
        server: './build/'
    })
    browserSync.watch( "./build/js/bundle.js" ).on('change', browserSync.reload )
})

gulp.task( "build", "Compile, copy and bundle", sequence( ["compile", "copy-assets", "copy-bootstrap"], ["bundle", "generate-webp"] ), {
    options: { 
        "release" : "Also minify final bundle and remove already bundled js files" 
    }
})

gulp.task( "clean", "Cleans build folder", function() {
    del("build");
})

gulp.task( "default", false, ["help"])



