package shoe3d.asset;
import haxe.macro.Context;
import haxe.macro.Expr.Field;
import haxe.Serializer;
import haxe.Unserializer;
import shoe3d.asset.AssetEntry;
import shoe3d.util.Tools;
import sys.FileSystem;
import haxe.io.Path;

using StringTools;


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

		trace(prepared);
		
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
		trace(pathToCurrentFolderFromCWD);
		// iterating pack files recursively
		for (name in FileSystem.readDirectory(pathToCurrentFolderFromCWD)) {
			var pathToCurrentAssetFromCWD = Path.join([pathToCurrentFolderFromCWD, name]);
			if ( FileSystem.isDirectory(pathToCurrentAssetFromCWD) ) {
				processPackRecursive( localBase, packName, out, Path.join([pathToCurrentFolderFromPack, name]) );
			} else {				
				out.push( {
					path: pathToCurrentAssetFromCWD,
					name: Path.join([packName, pathToCurrentFolderFromPack, name]),
					bytes: FileSystem.stat(pathToCurrentAssetFromCWD).size,
					format: getFormat()		
				});
			}
		}
	}

	static function getFormat() : AssetFormat {
		return null;
	}
	
}