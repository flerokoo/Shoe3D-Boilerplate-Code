package shoe3d.util;

/**
 * ...
 * @author as
 */

using StringTools;
class StringHelp
{

	public static function getFileExtension (fileName :String) :String
    {		
        var dot = fileName.lastIndexOf(".");
        return (dot > 0) ? fileName.substr(dot + 1) : null;
		
    }
	
    public static function removeFileExtension (fileName :String) :String
    {
        var dot = fileName.lastIndexOf(".");
        return (dot > 0) ? fileName.substr(0, dot) : fileName;
    }
	
    public static function getUrlExtension (url :String) :String
    {
        var question = url.lastIndexOf("?");
        if (question >= 0) {
            url = url.substr(0, question);
        }
        var slash = url.lastIndexOf("/");
        if (slash >= 0) {
            url = url.substr(slash+1);
        }
        return getFileExtension(url);
    }
	
    public static function joinPath (base :String, relative :String) :String
    {
        if (base.length > 0 && base.fastCodeAt(base.length-1) != "/".code) {
            base += "/"; // Ensure base ends with a trailing slash
        }
        return base + relative;
    }
	
    public static function hashCode (str :String) :Int
    {
        var code = 0;
        if (str != null) {
            for (ii in 0...str.length) {
                code = Std.int(31*code + str.fastCodeAt(ii));
            }
        }
        return code;
    }

	
	
}