package shoe3d.util;

class DeviceInfo
{

	public static function isMobileBrowser():Bool
	{
		return untyped __js__("window.orientation === Number(window.orientation)" );
	}
	
}