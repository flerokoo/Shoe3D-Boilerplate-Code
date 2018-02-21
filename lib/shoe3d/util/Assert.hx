package shoe3d.util;

/**
 * ...
 * @author as
 */
class Assert
{

    public static function that( cond:Bool, ?msg:String )
    {
        if ( ! cond ) fail( msg );
    }

    public static function fail( msg:String )
    {
        throw msg;
    }

}