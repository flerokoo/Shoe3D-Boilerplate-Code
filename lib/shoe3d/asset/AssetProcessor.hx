package shoe3d.asset;
import haxe.macro.Context;
import haxe.macro.Expr.Field;
import haxe.Serializer;
import haxe.Unserializer;
import shoe3d.util.Tools;
import sys.FileSystem;

using StringTools;
/**
 * ...
 * @author as
 */

private typedef AssetInfo = { path:String, name:String, bytes:Int, ?pack:String };
private typedef AssetCollection = Array<AssetInfo>;
class AssetProcessor
{

	public static function build( localBase:String = "assets"):Array<Field> {
		
		var fields = Context.getBuildFields();
		
		if ( ! localBase.endsWith("/") && ! localBase.endsWith("\\") ) {
			localBase += '/';
		}
		
		var packs:Map<String,AssetCollection> = new Map();
		
		for ( packName in FileSystem.readDirectory( localBase ) ) {
			
			if ( FileSystem.isDirectory( localBase + packName ) ) {
				var out:AssetCollection = [];
				processPackRecursive( localBase, packName, out );
				packs[packName] =  out ;
				for ( i in out ) i.pack = packName;
			}
		}
		var prepared = [ for ( i in packs) for (j in i) j ];
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
	
	static function processPackRecursive( localBase:String, packName:String, out:AssetCollection, packPath = '' ) {
		
		if ( ! packName.endsWith("/") && ! packName.endsWith("\\") ) {
			packName += '/';
		}
		
		for (name in FileSystem.readDirectory(localBase + packName)) {
			if ( FileSystem.isDirectory(localBase + packName + name) ) {
				processPackRecursive( localBase, packName + name, out, packPath + name + "/");
			} else {
				
				out.push( {
					path: localBase + packName + name,
					name: packPath + name,
					bytes: FileSystem.stat(localBase + packName + name ).size
				});
			}
		}
	}
	
}