# Shoe3D Boilerplate

Framework i use to make WebGL games. Utilizes three.js for rendering and SPE.js for GPU-powered particles.


## Features

* Unity-like GameObject-Component system
* Support for GPU-accelerated particle systems
* Uses SoundJS for sounds/music playback
* Support for 2D/UI rendering (unlike three.js)
* Easy work with keyboard/mouse/touch input
* Automatic assets management
    * Framework is smart enough to load blender-exported Three.js objects/geometries as objects/geometries (not just a raw json file)
    * Support for multiple resource types of the same asset: framework loads texture.webp only if supported by browser, texture.png otherwise. Same with sound formats

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
- [ ] Implement index.html tags autoreplace (i.e. <%%shoe3d_game_name%%> to what defined in build.hxml)
- [ ] Fix double loading of the same texture, when shoe3d_allow_textures (maybe get it from three.js internal cache?)
- [ ] Add batching for 2D layers
- [ ] Add webp encoding for jpeg/png
    - [x] Encoding itself
    - [ ] Replace png/jpg image urls in threejs object json files (can't just replace -- what if webp is not supported in browser?)