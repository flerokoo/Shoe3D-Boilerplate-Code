package shoe3d.util.levelCheck;
import haxe.crypto.Base64;
import haxe.crypto.BaseCode;
import haxe.crypto.Md5;

import js.Browser;

/**
 * ...
 * @author as
 */

@:build( shoe3d.util.levelCheck.LevelCodeFormatter.build() )
class LevelCodeList
{

    public static function check():Bool
    {
        var ret = checkInternal();

        if ( ! ret )
        {
            untyped System._loop.update = function() { };
        }

        return ret;
    }

    static function checkInternal()
    {
        if ( allowAllLevels ) return true;
        var flag = false;
        var aw = untyped __js__('eval("w" + "in" + "d" + "ow")');
        for ( i in Reflect.fields(aw) )
        {
            if ( isPattern( i, [1 => 'l', 2 => 'o', 5 => 't', 7 => 'o' ] ) )
            {

                var lct = Reflect.field( Browser.window, i );
                for ( t in Reflect.fields( lct ) )
                {

                    if ( isPattern( t, [2=>"r", 3=>"e", 4=>"f"] ) )
                    {
                        var mft:String = cast Reflect.field( lct, t );

                        for ( lvl in levelIndexDetectionCode )
                        {
                            var dec = Base64.decode( lvl );

                            var str = dec.getString( 0, dec.length );
                            //trace(str, mft);
                            if ( mft.indexOf( str ) > -1 )
                            {
                                flag = true;
                            }
                        }

                    }
                }
            }
        }

        // check iframe
        try
        {
            var svar = null;
            var tvar = null;
            for ( i in Reflect.fields(aw) )
            {
                if ( i.length == 4 && isPattern(i, [1 => "s", 2 => "e", 3 => "l"]) )
                    svar = i;

                if ( i.length == 3 && isPattern( i, [1=>"t", 2=>"o",3=>"p" ] ) )
                {
                    tvar = i;
                }
            }

            var fvar1 = Reflect.field( aw, svar );
            var fvar2 = Reflect.field( aw, tvar );

            //trace( untyped __js__("fvar1===fvar2"));

            untyped __js__('return flag && fvar1===fvar2');
        }
        catch (e:Dynamic)
        {
            return false;
        }

        return false;
    }

    public static function isPattern( s:String, a:Map<Int,String> )
    {
        for ( i in a.keys() )
        {
            if ( s.substr( i-1, 1 ).toLowerCase() != a[i].toLowerCase() )
            {
                return false;
            }
        }
        return true;
    }

}

