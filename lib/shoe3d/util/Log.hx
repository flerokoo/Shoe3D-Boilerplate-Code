package shoe3d.util;

/**
 * ...
 * @author as
 */
@:allow(shoe3d) 
class Log
{
	static var _color:String = 'color: #FF2291;';
	static var _bg:String = 'background: transparent;';
	static var _bold:String = '';
	static var _customParams:String = '';
	
	public static function reset() 
	{
		_bold = '';
		_color = 'color: #E8B620;';
		_bg = 'background: transparent;';
		return Log;
	}
	
	
	static function processColor( clr:String ) 
	{
		if ( StringTools.startsWith(clr, '0x') )
			clr = '#' + clr.substr( 2 );
		return clr;
	}
	
	public static function color( clr:String )
	{
		_color = 'color: ${processColor(clr)};';
		return Log;
	}
	
	public static function bg( clr:String )
	{
		_bg = clr.toLowerCase() == 'transparent' ? 'background: transparent' : 'background: ${processColor(clr)};';
		return Log;
	}
	
	public static function custom( params:String )
	{
		_customParams = params;
		return Log;
	}
	
	public static function bold( val:Bool = true )
	{
		_bold = val ? 'font-weight: bold;' : '';
		return Log;
	}
	
	#if debug
	public static var _sys:Array<String> = [];	
	
	public static function warn( msg:Dynamic ) 
	{
		untyped __js__("console").warn( msg );
	}
	
	public static function log( msg:Dynamic, ?params:String ) 
	{
		untyped __js__("console").log( msg, params );
	}
	
	public static function sys(msg:Dynamic)
	{
		_sys.push( msg );
	}
	
	public static inline function pretty( msg:String ) 
	{ 
		untyped __js__("console").log( '%c' + msg, _color + _bg + _bold + _customParams  );
	}
	
	public static inline function header( msg:String, color:String = 'white' ) 
	{ 
		var params = [
			'background: linear-gradient(#D33106, #571402)'
			, 'border: 1px solid #3E0E02'
			, 'color: ${processColor(color)}'
			, 'display: block'
			, 'text-shadow: 0 1px 0 rgba(0, 0, 0, 0.3)'
			, 'box-shadow: 0 1px 0 rgba(255, 255, 255, 0.4) inset, 0 5px 3px -5px rgba(0, 0, 0, 0.5), 0 -13px 5px -10px rgba(255, 255, 255, 0.4) inset'
			, 'line-height: 40px'
			, 'text-align: center'
			, 'font-weight: bold'
			, 'width: 100%'
			, 'margin: 0 auto'
			, 'padding: 8px 60px'
			, 'font-size: 20px'
		].join(';');
		untyped __js__("console").log( '%c' + msg, params  );
	}
	
	public static function info(msg:Dynamic) 
	{
		untyped __js__("console").info(msg);
	}
	
	public static function printSys() 
	{
		for ( i in _sys )
			log( i );
	}
	
	#else
	public static inline function warn( msg:String ) { }
	public static inline function log( msg:String ) { }
	public static inline function pretty( msg:String ) { }
	public static inline function info( msg:String ) { }
	public static inline function header( msg:String, color:String = '' ) { }
	public static function sys(msg:String) {}	
	public static function printSys() {}	
	#end
}