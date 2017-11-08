package shoe3d.util.accessCheck;
import haxe.crypto.Base64;
import haxe.crypto.BaseCode;
import haxe.crypto.Md5;
import haxe.io.Bytes;
import haxe.macro.Context;
import haxe.macro.Expr.Access;
import haxe.macro.Expr.Field;
import haxe.macro.Expr.FieldType;

/**
 * ...
 * @author as
 */
class LevelCodeFormatter
{
	
	/*
	 * HOW TO USE
	 * add -D shoe3d_allow_urls="url1.ru;url2.com"
	 * after use here and there LevelCodeList.check()
	 * 
	 */ 
	
	 
	public static function build( )
	{
		
		var fields = Context.getBuildFields();
		var flag = true;	

		
		var ret = [];
		if ( Context.defined("shoe3d_allow_urls") ) {
			var list = Context.definedValue("shoe3d_allow_urls").toLowerCase().split(";");		
			
			trace("Allow URLs: " + list );			
			for ( i in list ) ret.push( Base64.encode( Bytes.ofString(i) ) );			
			flag = false;
			
			if ( list.length <= 0 ) flag = true;
			
		} else {
			trace("Allow all URLs");
		}
		
		
		
		var fieldList:Field = {
				name : "levelIndexDetectionCode",
				access : [AStatic, APrivate],
				kind : FVar( macro : Array<String>, macro $v{ret} ),
				pos : Context.currentPos()
		};
		
		var fieldAllow:Field = {
				name : "allowAllLevels",
				access : [AStatic, APrivate],
				kind : FVar( macro : Bool, macro $v{flag} ),
				pos : Context.currentPos()
		};
		
		fields.push(fieldList);
		fields.push(fieldAllow);
		
		return fields;
	}
}