# Shoe3D Boilerplate

Framework I use to develop WebGL games with Haxe. 
Utilizes three.js for rendering, SPE.js for GPU-powered particles, SoundJS for playback and Gulp for various tasks.


## Features

* Unity-like GameObject-Component system
* Support for GPU-accelerated particle systems
* Uses SoundJS for sounds/music playback
* Support for 2D/UI rendering (unlike three.js)
* Easy work with keyboard/mouse/touch input
* Automatic assets management
    * Framework is smart enough to load blender-exported Three.js objects/geometries as objects/geometries (yeah, that's right!)
    * Same thing with atlases (from ShoeBox) — they are detected at compile-time and loaded as atlases automatically 
    * Support for multiple formats of the same asset: for instance, framework loads texture.webp only if supported by browser, texture.png otherwise. Same with sound formats

## How to use

1) Clone this repo: `git clone https://github.com/flerokoo/Shoe3D-Boilerplate-Code.git` 
2) Build the game: `gulp build [--release]`
3) Test the game: `gulp serve`

Check build.hxml for framework/compiler configuration.
Use `gulp help` to know what more you can do.

You can create _FlashDevelop_ project by running `node ./scripts/createFDProject`

## Project structure

Folders you could be interested in:
* `assets/` — All assets should go here. Direct children of this folder are considered as assetpacks
* `build/` — Folder with last build of the game
* `scripts/` — Various useful scripts that could help in development process
* `web/` — Static resources go here
* `src/` — Your code
* `build.hxml` — Build configuration for Haxe compiler. Edit this to add libraries/classpaths/additional flags. Framework configuration is performed from here too.


## API

_...WIP..._

## Example games

#### [3D Solitaire](https://play.famobi.com/3d-solitaire)
![](http://shodiev.ru/img/games/solitaire.jpg)

#### [Juggle Town](https://www.youtube.com/watch?v=q-AoEeA231w&feature=youtu.be)
![](http://shodiev.ru/games/juggletown/thumb.png)

#### [Endless Hallway](https://www.youtube.com/watch?v=ZS5KA8Joz70)
![](http://shodiev.ru/games/endlesshallway/thumb.png)


## Credits
Special thanks to the creator of Flambe, Bruno Garcia.


## TODO
- [x] Create simple tweener, that works in context of current screen (so that all tweens are disposed, when screen is changed&disposed)
- [x] Add possibility to dispose assetpacks
- [x] Dispose screen after it is hidden (dispose children also)
- [ ] Add support for loading msgpack-compressed objects
- [ ] Add antialias flag for threejs (or maybe autodetect that bitch?)
- [ ] Fix type of parameter of Log.log (when building in release mode)
- [ ] Add getGeometry/getBufferGeometry to both Assets and AssetPack
- [x] Fix sourcemaps bundling
- [ ] Refactor layer camera settings
- [ ] Refactor EasyDebug
- [ ] Implement index.html tags autoreplace (i.e. <%%shoe3d_game_name%%> to what defined in build.hxml)
- [ ] Fix double loading of the same texture, when shoe3d_allow_textures (maybe get it from three.js internal cache?)
- [ ] Refactor input event propagation code
- [ ] Add batching for 2D layers
- [ ] Pass dt to gameobject/component update method (and think of some system to affect dt, that will be received by children gameobjects) 
- [ ] Support for GLTF auto loading (i kinda added it already, but it seems that there's a problem with texture loading in three's GLTFLoader.js) Also have to decide what to do if theres not only scene loaded (probably just push all meshes/scenes to object3d map of assetpack)
- [x] Add webp encoding for jpeg/png (for size reduction)
    - [x] Encoding itself
    - [x] Replace png/jpg image urls in threejs object json files (now replacing links before loading (in runtime) only if webp is supported -- assuming that webp version exists when shoe3d_generate_webp flag is enabled)