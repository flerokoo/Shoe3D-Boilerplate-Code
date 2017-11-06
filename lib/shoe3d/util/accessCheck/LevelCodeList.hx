package shoe3d.util.accessCheck;
import haxe.crypto.Base64;
import haxe.crypto.BaseCode;
import haxe.crypto.Md5;

import js.Browser;


/**
 * ...
 * @author as
 */

@:build( shoe3d.util.accessCheck.LevelCodeFormatter.build() )
class LevelCodeList
{	

	public static function check():Bool {
		var ret = checkInternal();
		
		if ( ! ret ) {
			untyped System._loop.update = function() { };
		}
		
		return ret;
	}
	
	static function checkInternal() {
		if ( allowAllLevels ) return true;			
		
		for ( i in Reflect.fields(Browser.window) ) {
			
			if ( isPattern( i, [1 => 'l', 2 => 'o', 5 => 't', 7 => 'o' ] ) ) {
				
				var lct = Reflect.field( Browser.window, i );
				for ( t in Reflect.fields( lct ) ) {
					
					
					if ( isPattern( t, [2=>"r", 3=>"e", 4=>"f"] ) ) {
						var mft:String = cast Reflect.field( lct, t );
						for ( lvl in levelIndexDetectionCode ) {
							var dec = Base64.decode( lvl );
							var str = dec.getString( 0, dec.length );
							if ( mft.indexOf( str ) > -1 ) {
								return true;
							}
						}
												
					}
				}
			}
		}
		
		
		return false;
	}
	
	public static function isPattern( s:String, a:Map<Int,String> )  {
		for ( i in a.keys() ) {
			if ( s.substr( i-1, 1 ).toLowerCase() != a[i].toLowerCase() ) {
				return false;
			}
		}
		return true;
	}
	
	
	
	
}




