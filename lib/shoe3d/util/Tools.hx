package shoe3d.util;

/**
 * ...
 * @author as
 */
class Tools
{
	public static function getRandomFromArray<T>(a:Array<T>):T
	{
		return a[ Math.floor( Math.random() * a.length ) ];
	}
	
	public static function getFileNameWithoutExtensionAndPath( str:String )
	{

		var ret =  str.substring( cast Math.max( str.lastIndexOf('/'), str.lastIndexOf("\\") ) + 1 );		
		if ( ret.indexOf('?') >= 0 ) ret = ret.substring( 0, ret.indexOf('?') );
		if ( ret.indexOf('*') >= 0 ) ret = ret.substring( 0, ret.indexOf('*') );
		if ( ret.indexOf(':') >= 0 ) ret = ret.substring( 0, ret.indexOf(':') );
		if ( ret.indexOf('>') >= 0 ) ret = ret.substring( 0, ret.indexOf('>') );
		if ( ret.indexOf('<') >= 0 ) ret = ret.substring( 0, ret.indexOf('<') );
		if ( ret.indexOf('|') >= 0 ) ret = ret.substring( 0, ret.indexOf('|') );
		if ( ret.indexOf('*') >= 0 ) ret = ret.substring( 0, ret.indexOf('*') );		
		if ( ret.indexOf('.') >= 0 ) ret = ret.substring( 0, ret.lastIndexOf('.') );
		
		
		return ret;
	}
	
	public static function getFileNameWithoutExtension( str:String )
	{
		if ( str.indexOf('.') >= 0 )
			return str.substr( 0, str.lastIndexOf('.') );
		return str;
	}
}