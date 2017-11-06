package shoe3d.util;

/**
 * ...
 * @author as
 */
class Info
{

	public static function isMobileBrowser():Bool
	{
		return untyped __js__("window.orientation === Number(window.orientation)" );
	}
	
}