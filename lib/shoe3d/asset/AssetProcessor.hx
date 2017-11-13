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

	static var _remove:Array<String>;
	static var _webpSources = ["png", "jpg", "jpeg"];

	public static function build( localBase:String = "assets"):Array<Field> 
	{

		_remove = [];

		var fields = Context.getBuildFields();

		var packs:Map<String,AssetCollection> = new Map();
		

		// Iterating packs
		for (packName in FileSystem.readDirectory(localBase)) {			
			if (FileSystem.isDirectory(Path.join([localBase, packName]))) {
				var out:AssetCollection = [];
				processPackRecursive( localBase, packName, out );
				packs[packName] =  out ;
				for ( i in out ) i.pack = packName;
			}
		}


		var prepared = [ for (i in packs) for (j in i) j ];

		for( rm in _remove ){
			var i = prepared.length-1;
			while(i >= 0) {
				if(prepared[i].path == rm) {
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
		
		
		/*switch( Context.getType("shoe3d.asset.AssetPackLoader")) {
			case TInst( cl, _ ):				
				var data = { packs: prepared };
				var cl = cl.get();
				var meta = cl.meta;
				meta.remove("assets");
				meta.add("assets", [ macro $v { data } ], cl.pos );
			default:
				throw 'WAT';
		}
		*/
		
		fields.push( field );
		return fields;
	}
	
	static function processPackRecursive( localBase:String, packName:String, out:AssetCollection, pathToCurrentFolderFromPack = '' ) {		
		var pathToCurrentFolderFromCWD = Path.join([localBase, packName, pathToCurrentFolderFromPack]);		
		// iterating pack files recursively
		for (name in FileSystem.readDirectory(pathToCurrentFolderFromCWD)) {
			var pathToCurrentAssetFromCWD = Path.join([pathToCurrentFolderFromCWD, name]);
			if ( FileSystem.isDirectory(pathToCurrentAssetFromCWD) ) {
				processPackRecursive( localBase, packName, out, Path.join([pathToCurrentFolderFromPack, name]) );
			} else {		
				var extra = [];
				#if shoe3d_include_pack_name
					extra.push(packName);
				#end

				var result = getFormat( pathToCurrentAssetFromCWD );

				out.push({
					path: pathToCurrentAssetFromCWD,
					name: Path.join(extra.concat([pathToCurrentFolderFromPack, name])),
					bytes: FileSystem.stat(pathToCurrentAssetFromCWD).size,
					format: result != null ? result.format : null,
					extra: result != null ? result.extra : null
				});


				#if shoe3d_generate_webp
				if (_webpSources.indexOf(Path.extension(pathToCurrentAssetFromCWD)) > -1) {					
					out.push({
						path: Path.withoutExtension(pathToCurrentAssetFromCWD) + ".webp",
						name: Path.join(extra.concat([pathToCurrentFolderFromPack, name])),
						bytes: FileSystem.stat(pathToCurrentAssetFromCWD).size,
						format: WEBP,
						extra: result != null ? result.extra : null
					});
				} 
				#end
			}
		}
	}

	static function getFormat( path:String ) : FormatCheckResult 
	{		
		var ext = Path.extension(path).toLowerCase();
		
		if(ext == "json") {
			var content = sys.io.File.getContent(path);
			var parsed = null;
			try {
				parsed = haxe.Json.parse(content);
			}

			if( parsed != null ) {
				
				var result:FormatCheckResult = isThreeJsEntity( parsed, path );
				if( result != null ) return result;

				result = isAtlas( parsed, path );
				if( result != null ) return result;
			}
						
		}
		return null;
	}

	static function isAtlas( parsed:Dynamic, path:String ) : FormatCheckResult {
		var image = getDynamicValue(parsed, ['meta', 'image']).toLowerCase();
		if( image != null ) {
			var imgPath = Path.join( [Path.directory(path), image] );
			#if !shoe3d_allow_textures
			_remove.push(imgPath);			
			#end
			return { format: ATLAS, extra: {image: imgPath} };
		}
		return null;
	}

	static function isThreeJsEntity(parsed:Dynamic, path:String) : FormatCheckResult {
		var type:String = getDynamicValue(parsed, ["metadata", "type"]);				
		if( type != null ) {
			switch(type.toLowerCase()){
				case "object":
					#if !shoe3d_allow_textures
					var images:Array<Dynamic> = getDynamicValue(parsed, ["images"]);
					for( i in images ) {
						var dir = Path.directory(path);
						var name = i.name;
						_remove.push(Path.join([dir, name]));
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

	static function getDynamicValue(o:Dynamic, path:Array<String>):Dynamic 
	{
		var cur = o;
		while( path.length > 0 ) {
			var nextField = path.shift();
			cur = Reflect.field(cur, nextField);
			if(cur == null) return null;
		}
		return cur;
	}
	
}