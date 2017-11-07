package shoe3d.asset;
import haxe.macro.Context;
import haxe.macro.Expr.Field;
import shoe3d.asset.AssetEntry;
import sys.FileSystem;
import haxe.io.Path;



private typedef AssetInfo = { path:String, name:String, bytes:Int, ?pack:String, ?format:AssetFormat };
private typedef AssetCollection = Array<AssetInfo>;
class AssetProcessor
{

	public static function build( localBase:String = "assets"):Array<Field> 
	{
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
		var field:Field = {
			name: "localPacks",
			access: [ APrivate, AStatic ],
			kind: FVar( macro : Array<Dynamic>, macro $v{prepared} ),
			pos: Context.currentPos()
		};

		//trace(prepared);
		
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

				out.push( {
					path: pathToCurrentAssetFromCWD,
					name: Path.join(extra.concat([pathToCurrentFolderFromPack, name])),
					bytes: FileSystem.stat(pathToCurrentAssetFromCWD).size,
					format: getFormat(pathToCurrentAssetFromCWD)		
				});

				trace(Path.join(extra.concat([pathToCurrentFolderFromPack, name])));
			}
		}
	}

	static function getFormat( path:String ) : AssetFormat 
	{		
		var ext = Path.extension(path).toLowerCase();
		
		if(ext == "json") {
			var content = sys.io.File.getContent(path);
			var parsed = null;
			try {
				parsed = haxe.Json.parse(content);
			}

			if( parsed != null ) {
				var type:String = getDynamicValue(parsed, ["metadata", "type"]).toLowerCase();
				switch(type){
					case "object":
						// TODO remove maps
						return OBJECT;
					case 'geometry':
						return GEOMETRY;
					case 'buffergeometry':
						return BUFFERGEOMETRY;
				}				
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