package shoe3d.asset;
import haxe.io.Path;
import js.three.BufferGeometry;
import js.three.Object3D;
import js.three.Material;
import js.three.Geometry;
import js.Browser;
import js.html.ArrayBuffer;
import shoe3d.asset.AssetEntry.AssetFormat;
import shoe3d.util.Log;
import shoe3d.util.promise.Promise;
import shoe3d.util.Tools;
import shoe3d.util.Value;
import js.three.JSONLoader;
import js.three.LoadingManager;
import js.three.Scene;
import js.three.Texture;
import js.three.FileLoader;
import js.three.TextureLoader;
import js.three.ObjectLoader;

/**
 * ...
 * @author as
 */
using Lambda;
using shoe3d.util.StringHelp;

@:allow(shoe3d)
@:build(shoe3d.asset.AssetProcessor.build())
class AssetPackLoader
{
    private static var _webpSourceFormats = [ PNG, JPG, GIF ];
    private static var _supportedFormats:Array<AssetFormat>;
    private var _entries:Array<AssetEntry>;
    private var _pack:AssetPack;
    private var _loading:Bool = false;
    private var _entriesToLoad:Array<AssetEntry>;
    private var _entriesToPick:Value<Int>;
    private var _manager:LoadingManager;
    private var _onCompleteCallback:AssetPack->Void;
    private var _onProgressChangeCallback:Float->Void;
    private var _promise:Promise<AssetPack>;

    public function new()
    {
        _pack = new AssetPack();
        _entries = [];
    }

    public function add( name:String, url:String, bytes:Int, ?format:AssetFormat, ?params:Dynamic )
    {
        if ( format == null ) format = getFormat( url );
        //if ( format != RAW ) name = Tools.getFileNameWithoutExtension( name );
        if ( format != RAW ) name = haxe.io.Path.withoutExtension( name );
        var ext = name.getUrlExtension();

        // TODO Придумать какой-то другой способ отличать геометрию от сцены и от просто json
        if ( ext != null &&( ext.toLowerCase() == 'geom' || ext.toLowerCase() == 'scene' ) ) name = Tools.getFileNameWithoutExtension( name );
        _entries.push( new AssetEntry( name, url, format, bytes, params ) );
        
        #if shoe3d_generate_webp
        if ( _webpSourceFormats.indexOf( format ) > -1 )
        {
            var webpURL = Path.withoutExtension(url) + '.webp';
            _entries.push( new AssetEntry(name, webpURL, WEBP, bytes, params )); //bytes are wrong!
        }
        #end
    }

    function getFormat( url:String ):AssetFormat
    {
        var extension = url.getUrlExtension();
        if (extension != null)
        {
            switch (extension.toLowerCase())
            {
                case "jpg", "jpeg": return JPG;
                case "png": return PNG;
                case "webp": return WEBP;

                case "m4a": return M4A;
                case "mp3": return MP3;
                case "ogg": return OGG;
                case "opus": return OPUS;
                case "wav": return WAV;
                case "aac": return AAC;
                case "gltf": return GLTF;

            }
        }
        else {
            throw 'No asset format: $url';
        }
        return RAW;
    }

    public function start( ?onComplete:AssetPack->Void, ?onProgress:Float->Void ):Promise<AssetPack>
    {
        if ( _entries.length == 0 ) throw 'Cant load empty pack';
        if ( _loading ) throw 'This asset pack is already loading';
        _loading = true;
        _onCompleteCallback = onComplete;
        _onProgressChangeCallback = onProgress;

        var groups:Map<String,Array<AssetEntry>> = new Map();

        for ( i in _entries )
        {
            if ( ! groups.exists( i.name ) ) groups.set( i.name, [] );
            groups.get(i.name).push( i );
        }

        _entriesToLoad = [];
        _entriesToPick = new Value( groups.count() );

        _entriesToPick.change.connect( function( cur:Int, prev:Int )
            {
                if ( cur <= 0 ) load();
            });

        for ( groupName in groups.keys() )
        {
            var group = groups.get(groupName);
            pickBestEntry( group, function( e:AssetEntry )
            {
                if ( e == null ) throw 'Asset format is not supported: ${groupName} ';
                _entriesToLoad.push( e );
                _entriesToPick._ --;
            });
        }

        return _promise = new Promise<AssetPack>();
    }

    private static function detectImageFormats ( ret:Array<AssetFormat>->Void)
    {
        var formats = [PNG, JPG, GIF];

        var formatTests = 2;
        var checkRemaining = function ()
        {
            // Called when an image test completes
            --formatTests;
            if (formatTests == 0)
            {
                ret( formats );
            }
        };

        // Detect WebP-lossless support (and assume that lossy works where lossless does)
        // https://github.com/Modernizr/Modernizr/blob/master/feature-detects/img/webp-lossless.js
        var webp = Browser.document.createImageElement();
        webp.onload = webp.onerror = function (_)
        {
            if (webp.width == 1)
            {
                formats.unshift(WEBP);
            }
            checkRemaining();
        };
        webp.src = "data:image/webp;base64,UklGRhoAAABXRUJQVlA4TA0AAAAvAAAAEAcQERGIiP4HAA==";

        // Detect JPEG XR support
        var jxr = Browser.document.createImageElement();
        jxr.onload = jxr.onerror = function (_)
        {
            if (jxr.width == 1)
            {
                formats.unshift(JXR);
            }
            checkRemaining();
        };
        // The smallest JXR I could generate (where pixel.tif is a 1x1 black image)
        // ./jpegxr pixel.tif -c -o pixel.jxr -f YOnly -q 255 -b DCONLY -a 0 -w
        jxr.src = "data:image/vnd.ms-photo;base64,SUm8AQgAAAAFAAG8AQAQAAAASgAAAIC8BAABAAAAAQAAAIG8BAABAAAAAQAAAMC8BAABAAAAWgAAAMG8BAABAAAAHwAAAAAAAAAkw91vA07+S7GFPXd2jckNV01QSE9UTwAZAYBxAAAAABP/gAAEb/8AAQAAAQAAAA==";
    }

    private static function detectAudioFormats () :Array<AssetFormat>
    {
        // Detect basic support for HTML5 audio
        var audio = Browser.document.createAudioElement();
        if (audio == null || audio.canPlayType == null)
        {
            Log.warn("Audio is not supported at all in this browser!");
            return [];
        }

        // Reject browsers that claim to support audio, but are too buggy or incomplete
        var blacklist = ~/\b(iPhone|iPod|iPad|Windows Phone)\b/;

        var userAgent = Browser.navigator.userAgent;
        // TODO Add webaudio support check
        if (/*!WebAudioSound.supported &&*/ blacklist.match(userAgent) && false)
        {
            Log.warn("HTML5 audio is blacklisted for this browser " + userAgent);
            return [];
        }

        // Select what formats the browser supports
        var types = [
        { format: M4A,  mimeType: "audio/mp4; codecs=mp4a" },
        { format: MP3,  mimeType: "audio/mpeg" },
        { format: OPUS, mimeType: "audio/ogg; codecs=opus" },
        { format: OGG,  mimeType: "audio/ogg; codecs=vorbis" },
        { format: WAV,  mimeType: "audio/wav" },
        ];

        var result = [];
        for (type in types)
        {
            // IE9's canPlayType() will throw an error in some rare cases:
            // https://github.com/Modernizr/Modernizr/issues/224
            var canPlayType = "";
            try canPlayType = audio.canPlayType(type.mimeType)
                catch (_ :Dynamic) {}

            if (canPlayType != "")
            {
                result.push(type.format);
            }
        }
        return result;
    }

    private static function getSupportedFormatsAsync( fn:Array<AssetFormat>->Void )
    {
        if ( _supportedFormats == null )
            detectImageFormats( function ( imgFormats:Array<AssetFormat> )
        {
            _supportedFormats = imgFormats.concat( detectAudioFormats() ).concat( [ RAW, GEOMETRY, BUFFERGEOMETRY, OBJECT, ATLAS, GLTF ] );
            fn( _supportedFormats );
        } )
        else
            fn( _supportedFormats );
    }

    private static function pickBestEntry( entries:Array<AssetEntry>, handler:AssetEntry->Void )
    {
        getSupportedFormatsAsync(
            function( formats:Array<AssetFormat> )
            {
                for ( format in formats)
                    for ( entry in entries )
                    {
                        if ( entry.format == format )
                        {
                            handler( entry );
                            return;
                        }
                    }
                handler(null);
            }
        );
    }

    private function load()
    {
        untyped __js__('createjs.Sound.alternateExtensions = ["aac", "ogg", "mp3"]');
        
        _manager = new LoadingManager( onCompletePack, onProgress );
        for ( e in _entriesToLoad )
        {
            switch ( e.format )
            {
                case JPG, PNG, GIF, JXR, WEBP:
                    new TextureLoader( _manager ).load(e.url, function(tex) onLoadTexture(tex, e), null, onEntryLoadError);
                case MP3, M4A, OPUS, OGG, WAV:
                    new SoundLoader(_manager).load( e.url, e.name, _pack );
                case BUFFERGEOMETRY:
                    new TemporaryBufGeomLoader(_manager).load(e.url, function(data) onLoadBufferGeometry(data, e), null, onEntryLoadError);
                case GEOMETRY:
                    new TemporaryGeomLoader(_manager).load(e.url, function(data) onLoadGeometry(data, e), null, onEntryLoadError);
                case OBJECT:
                    // cant use ObjectLoader because of wrong order of events
                    // https://github.com/mrdoob/three.js/issues/12601
                    //new ObjectLoader(_manager).load( e.url, function (data) { onLoadObject( data, e ); trace(data); }, null, onEntryLoadError );
                    new FileLoader( _manager ).load( e.url, function(t) onLoadObjectFromJson(t, e), null, onEntryLoadError );
                case ATLAS:
                    var imagename = e.extra.image;
                    
                    
                    #if shoe3d_generate_webp
                    //again assuming that webp was generated
                    if ( _supportedFormats.indexOf(WEBP) > -1 )
                        imagename = haxe.io.Path.withoutExtension(imagename) + '.webp';
                    #end
                    
                    new AtlasLoader( _manager ).load( e.url, imagename, e.name, _pack, onEntryLoadError);
                case GLTF:
                    new GLTFLoader( _manager ).load(e.url, function(data) onLoadGLTF(data,e), null, onEntryLoadError);
                default:
                    new FileLoader(_manager).load( e.url, function (data) onLoadData( data, e ), null, onEntryLoadError );

            }
        }
    }

    // CALLBACKS

    function onEntryLoadError(e:js.html.ErrorEvent)
    {
        js.Browser.console.log("Error happened when loading: " + e);
    }

    function onLoadGLTF( gltf:Dynamic, e:AssetEntry )
    {
        Log.warn("GLTF Loading now only support default scene loading. See https://raw.githubusercontent.com/KhronosGroup/glTF/master/specification/2.0/figures/gltfOverview-2.0.0a.png");

        if( gltf.scene != null ) 
        {            
            _pack._objectMap.set( e.name, gltf.scene );
        } 
        else if( gltf.scenes != null && gltf.scenes.length > 0 ) 
        {
            _pack._objectMap.set( e.name, gltf.scenes[0] );
        }
    }

    function onLoadObject(object:Object3D, e:AssetEntry)
    {
        // disabled because of threejs wrong event order
        // https://github.com/mrdoob/three.js/issues/12601
        //_pack._objectMap.set(e.name, object);
    }

    function onLoadObjectFromJson(data:String, e:AssetEntry)
    {
        // this callback will fire BEFORE images are loaded
        // but, object still will be available in assetPack (as opposed to ObjectLoader)
        var object = null;
        var parsed = null;
        try
        {
            parsed = haxe.Json.parse(data);
        }
        catch (t:String)
        {
            Log.warn( 'Couldnt parse object ${e.name}: $t' );
        }
        var loader = new ObjectLoader( _manager );
        loader.setTexturePath( haxe.io.Path.directory(e.url) + "/" );
        
        #if shoe3d_generate_webp
        if (_supportedFormats.indexOf(WEBP) > -1)
        {
            // assume that webp version of all images exist
            // otherwise something during build process went wrong
            if (parsed.images != null && parsed.images.length > 0)
            {
                var temp:Array<Dynamic> = untyped parsed.images;
                for (i in temp)
                {
                    i.url = Path.withoutExtension(i.url) + '.webp';
                }
            }
        }       
        #end
        
        object = loader.parse( parsed );
        _pack._objectMap.set(e.name, object);
    }

    function onProgress( nm:String, a:Float, b:Float )
    {
        _promise.progress._ = a/b;
        if ( _onProgressChangeCallback != null) _onProgressChangeCallback( _promise.progress._ );
    }

    function onCompletePack()
    {
        _promise.result = _pack;
        if ( _onCompleteCallback != null ) _onCompleteCallback( _pack );
    }

    function onLoadTexture( tex:Texture, e:AssetEntry )
    {
        _pack._texMap.set( e.name,
        {
            texture: tex,
            uv: {
                umin: 0,
                vmin: 0,
                umax: 1,
                vmax: 1
            },
            width: (tex.image.width != null ? tex.image.width : tex.image.naturalWidth ),
            height: (tex.image.height != null ? tex.image.height : tex.image.naturalHeight )
        });
        //tex.naturalWidth = (tex.image.width != null ? tex.image.width : tex.image.naturalWidth );
        //tex.naturalHeight = (tex.image.height != null ? tex.image.height : tex.image.naturalHeight );
    }

    function onLoadSound( data:ArrayBuffer, e:AssetEntry )
    {
        //trace(data);

        //trace( "SND LOAD");
    }

    function onLoadGeometry( data:Geometry, e:AssetEntry )
    {
        _pack._geomMap.set( e.name, data );
    }

    function onLoadBufferGeometry( data:BufferGeometry, e:AssetEntry )
    {
        _pack._bufGeomMap.set( e.name, data );
    }

    function onLoadData( data:String, e:AssetEntry )
    {
        _pack._fileMap.set( e.name, new File( data ) );
    }

    // GENERATORS
    public static function wrapTexDef( tex:Texture, ?uv:shoe3d.util.UVTools.UV ) : shoe3d.asset.AssetPack.TexDef
    {
        return {
            texture: tex,
            uv: uv != null
            ? uv
            : {
                umin: 0,
                vmin: 0,
                umax: 1,
                vmax: 1
            },
            width: (tex.image.width != null ? tex.image.width : tex.image.naturalWidth ),
            height: (tex.image.height != null ? tex.image.height : tex.image.naturalHeight )
        }
    }
}

// haxelib's threejs hasn't this classes :(
@:native("THREE.BufferGeometryLoader")
extern class TemporaryBufGeomLoader
{
    public function new( manager:LoadingManager );
    public function load( url:String, callback:BufferGeometry->Void, ?onProgress:Void->Void, ?onError:Dynamic->Void ):Void;
}

@:native("THREE.JSONLoader")
extern class TemporaryGeomLoader
{
    public function new( manager:LoadingManager );
    public function load( url:String, callback:Geometry->Void, ?onProgress:Void->Void, ?onError:Dynamic->Void ):Void;
}

@:native("THREE.GLTFLoader")
extern class GLTFLoader
{
    public function new( manager:LoadingManager );
    public function load( url:String, callback:Dynamic->Void, ?onProgress:Void->Void, ?onError:Dynamic->Void ):Void;
}