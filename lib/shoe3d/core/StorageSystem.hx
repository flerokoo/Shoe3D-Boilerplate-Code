package shoe3d.core;
import haxe.Serializer;
import haxe.Unserializer;
import js.Browser;
import shoe3d.util.Log;

/**
 * ...
 * @author as
 */
@:allow(shoe3d)
class StorageSystem
{

    static inline var PREFIX = "SHOE3D::";
    static var _storage:Dynamic;

    static function init()
    {
        var localStorage = Browser.getLocalStorage();
        if ( localStorage != null )
        {
            _storage = localStorage;
            Log.sys("Local storage init");
        }
        else
        {
            Log.sys("No local storage");
        }
        return true;
    }

    public static function set (key :String, value :Dynamic) :Bool
    {
        var encoded :String;
        try {
            var serializer = new Serializer();
            serializer.useCache = true; // Allow circular references
            serializer.useEnumIndex = false; // Ensure persistence-friendly enums
            serializer.serialize(value);
            encoded = serializer.toString();
        }
        catch (error :Dynamic)
        {
            Log.warn("Storage serialization failed");
            return false;
        }

        try {
            _storage.setItem(PREFIX + key, encoded);
        }
        catch (error :Dynamic)
        {
            // setItem may throw a QuotaExceededError:
            // http://dev.w3.org/html5/webstorage/#dom-localstorage
            Log.warn("localStorage.setItem failed");
            return false;
        }
        return true;
    }

    public static function get<A> (key :String, defaultValue :A = null) :A
    {
        var encoded :String = null;
        try {
            encoded = _storage.getItem(PREFIX + key);
        }
        catch (error :Dynamic)
        {
            // This should never happen, but it sometimes does in Firefox and IE
            Log.warn("localStorage.getItem failed");
        }

        if (encoded != null)
        {
            try
            {
                return Unserializer.run(encoded);
            }
            catch (error :Dynamic)
            {
                Log.warn("Storage unserialization failed");
            }
        }
        return defaultValue;
    }

    public static function remove (key :String)
    {
        try
        {
            _storage.removeItem(PREFIX + key);
        }
        catch (error :Dynamic)
        {
            // This should never happen, but it sometimes does in Firefox and IE
            Log.warn('localStorage.removeItem failed; message=${error.message}');
        }
    }

    public static function clear ()
    {
        try
        {
            _storage.clear();
        }
        catch (error :Dynamic)
        {
            // This should never happen, but it sometimes does in Firefox and IE
            Log.warn("localStorage.clear failed");
        }
    }

}