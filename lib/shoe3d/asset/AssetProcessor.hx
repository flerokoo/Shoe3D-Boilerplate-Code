package shoe3d.asset;
import haxe.macro.Context;
import haxe.macro.Expr.Field;
import shoe3d.asset.AssetEntry;
import sys.FileSystem;
import haxe.io.Path;

private typedef AssetInfo = { path:String, name:String, bytes:Int, ?pack:String, ?format:AssetFormat, ?extra:Dynamic };
private typedef AssetCollection = Array<AssetInfo>;
private typedef FormatCheckResult = { format:AssetFormat, ?extra:Dynamic }

class AssetProcessor
{

    // assets with urls listed in this array will be removed from final asset list (used in runtime)
    static var _remove:Array<String>;
    static var _webpSourceFormats = ["png", "jpg", "jpeg"];

    public static function build( localBase:String = "assets"):Array<Field>
    {

        _remove = [];

        var fields = Context.getBuildFields();

        var packs:Map<String,AssetCollection> = new Map();

        // Iterating packs
        for (packName in FileSystem.readDirectory(localBase))
        {
            if (FileSystem.isDirectory(Path.join([localBase, packName])))
            {
                var out:AssetCollection = [];
                processPackRecursive( localBase, packName, out );
                packs[packName] =  out ;
                for ( i in out ) i.pack = packName;
            }
        }

        var prepared = [ for (i in packs) for (j in i) j ];

        for ( rm in _remove )
        {
            var i = prepared.length-1;
            while (i >= 0)
            {
                if (prepared[i].path == rm)
                {
                    prepared.splice(i, 1);
                }
                i--;
            }
        }

        // for(i in prepared) trace(i);

        var field:Field = {
            name: "localPacks",
            access: [ APrivate, AStatic ],
            kind: FVar( macro : Array<Dynamic>, macro $v{prepared} ),
            pos: Context.currentPos()
        };

        fields.push( field );
        return fields;
    }

    static function processPackRecursive( localBase:String, packName:String, out:AssetCollection, pathToCurrentFolderFromPack = '' )
    {
        var pathToCurrentFolderFromCWD = Path.join([localBase, packName, pathToCurrentFolderFromPack]);
        // iterating pack files recursively
        for (name in FileSystem.readDirectory(pathToCurrentFolderFromCWD))
        {
            var pathToCurrentAssetFromCWD = Path.join([pathToCurrentFolderFromCWD, name]);
            if ( FileSystem.isDirectory(pathToCurrentAssetFromCWD) )
            {
                processPackRecursive( localBase, packName, out, Path.join([pathToCurrentFolderFromPack, name]) );
            }
            else
            {
                var extra = [];
                #if shoe3d_include_pack_name
                extra.push(packName);
                #end

                var result = processFormat( pathToCurrentAssetFromCWD );
               
                out.push(
                {
                    path: pathToCurrentAssetFromCWD,
                    name: Path.join(extra.concat([pathToCurrentFolderFromPack, name])),
                    bytes: FileSystem.stat(pathToCurrentAssetFromCWD).size,
                    format: result != null ? result.format : null,
                    extra: result != null ? result.extra : null
                });
                
                /*
                #if shoe3d_generate_webp
                // assume that webp-version is generated for every asset format which extension is contained in _webpSourceFormats
                if (_webpSourceFormats.indexOf(Path.extension(pathToCurrentAssetFromCWD)) > -1)
                {
                    out.push(
                    {
                        path: Path.withoutExtension(pathToCurrentAssetFromCWD) + ".webp",
                        name: Path.join(extra.concat([pathToCurrentFolderFromPack, name])),
                        bytes: FileSystem.stat(pathToCurrentAssetFromCWD).size,
                        format: WEBP,
                        extra: result != null ? result.extra : null
                    });
                }
                #end
                */
            }
        }
    }

    // Used to force some JSON to be treated as geometry, buffergeometry of object3d data
    // also 
    static function processFormat( path:String ) : FormatCheckResult
    {
        var ext = Path.extension(path).toLowerCase();

        if(ext == "gltf") processGLTF(path);

        if (ext == "json")
        {
            var parsed = getParsedJson(path);

            if ( parsed != null )
            {

                var result:FormatCheckResult = isThreeJsEntity( parsed, path );
                if ( result != null ) return result;

                result = isAtlas( parsed, path );
                if ( result != null ) return result;
            }

        }
        return null;
    }

    static function isAtlas( parsed:Dynamic, path:String ) : FormatCheckResult
    {
        var image = getDynamicValue(parsed, ['meta', 'image']).toLowerCase();
        if ( image != null )
        {
            var imgPath = Path.join( [Path.directory(path), image] );
            
            // webp check will perform on runtime (if webp is supported and shoe3d_generate_webp -- it will be loaded)
            
            #if !shoe3d_allow_textures
            
            _remove.push(imgPath);
            
            // TODO
            // without this shit atlasImage.webp gets added to loading list as Image asset (webp ofcourse)
            // then AssetPackLoader picks it instead of ATLAS asset (and just loads image instead of loading atlas.json+atlasImage.json)
            // if shoe3d_allow_textures, then even png is choosen over atlas asset
            _remove.push( Path.withoutExtension(imgPath) + '.webp' ); 
            #end
            return { format: ATLAS, extra: {image: imgPath} };
        }
        return null;
    }

    static function isThreeJsEntity(parsed:Dynamic, path:String) : FormatCheckResult
    {
        var type:String = getDynamicValue(parsed, ["metadata", "type"]);
        if (type != null)
        {
            switch (type.toLowerCase())
            {
                case "object":
                    #if !shoe3d_allow_textures
                    var images:Array<Dynamic> = getDynamicValue(parsed, ["images"]);
                    if (images != null && images.length > 0)
                    {
                        var dir = Path.directory(path);
                        for (i in images)
                        {
                            var name = i.name;
                            var imagePath = Path.join([dir, name]);
                            _remove.push(imagePath);
                            /*
                            #if shoe3d_generate_webp
                            // should prevent loading of webp version of this image too
                            // it is gonna be loaded when whole object is loaded
                            _remove.push(Path.withoutExtension(imagePath) + '.webp');
                            #end
                            */
                        }
                    }
                    #end
                    return { format: OBJECT };
                case 'geometry':
                    return { format: GEOMETRY };
                case 'buffergeometry':
                    return { format: BUFFERGEOMETRY };
            }
        }
        return null;
    }


    /**
     *  Removes images already loaded by GLTFLoader
     *  @param path - 
     */
    static function processGLTF(path:String)
    {
        var parsed = getParsedJson(path);
        var images = cast( getDynamicValue(parsed, ["images"]), Array<Dynamic> );
        if( images != null ) 
        {
            var base = Path.directory(path);
            for( i in images ) 
            {
                var imageUrl = Path.join([base, i.uri]);
                _remove.push(imageUrl);
                /*
                #if shoe3d_generate_webp
                // should prevent loading of webp version of this image too
                // it is gonna be loaded when whole object is loaded
                _remove.push(Path.withoutExtension(imageUrl) + '.webp');
                #end
                */
            }
        }
    }

    /**
     *  Tries to read and parse json file at specified path
     *  @param path - 
     */
    static function getParsedJson( path:String ) 
    {
        var content = sys.io.File.getContent(path);
        var parsed = null;
        try
        {
            parsed = haxe.Json.parse(content);
        }
        return parsed;
    }

    static function getDynamicValue(o:Dynamic, path:Array<String>):Dynamic
    {
        if (o == null) return null;
        var cur = o;
        while ( path.length > 0 )
        {
            var nextField = path.shift();
            cur = Reflect.field(cur, nextField);
            if (cur == null) return null;
        }
        return cur;
    }

}