package shoe3d.asset;
import shoe3d.asset.AssetPack.GeomDef;
import shoe3d.asset.AssetPack.TexDef;
import shoe3d.util.Log;

/**
 * ...
 * @author as
 */
class Res
{

	static var _packMap:Map<String,AssetPack>;
	
	
	public static function registerPack( pack:AssetPack, ?name:String ) 
	{
		if ( _packMap == null ) _packMap = new Map();
		if ( name == null || StringTools.replace( name, ' ', '' ) == '' ) {
			var gen = getRandomName();
			Log.warn("No name for asset pack provided. Generated name: " + gen );
			_packMap.set( gen, pack );	
		} else {
			_packMap.set( name, pack );
		}		
	}
	
	static function getRandomName():String
	{
		var e = 'abcdefgh0123456789';
		var r = '';
		while ( r.length < 30 ) r += e.charAt( Math.floor( Math.random() * e.length ) );
		return r;
	}
	
	public static function getTexDef( name:String ):TexDef
	{		
		if ( _packMap == null ) throw 'No asset packs';
		for ( i in _packMap )
		{
			var ret = i.getTexDef( name, false );
			if ( ret != null) return ret;
		}
		
		throw 'No texDef $name found';
		return null;	
	}
	
	public static function getGeomDef( name:String ):GeomDef
	{
		if ( _packMap == null ) throw 'No asset packs';
		for ( i in _packMap )
		{
			var ret = i.getGeomDef( name, false );
			if ( ret != null) return ret;
		}
		
		throw 'No geomDef $name found';
		return null;	
	}
	
	public static function getFile( name:String ):File
	{
		if ( _packMap == null ) throw 'No asset packs';
		for ( i in _packMap )
		{
			var ret = i.getFile( name, false );
			if ( ret != null) return ret;
		}
		
		throw 'No file $name found';
		return null;	
	}
	
}