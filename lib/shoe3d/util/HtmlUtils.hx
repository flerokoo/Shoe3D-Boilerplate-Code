package shoe3d.util;
import js.Boot;
import js.html.EventTarget;
#if !macro
import js.Browser;
#end

/**
 * ...
 * @author as
 */

class HtmlUtils
{
	public static var HIDE_MOBILE_BROWSER = Browser.window.top == Browser.window &&
        ~/Mobile(\/.*)? Safari/.match(Browser.navigator.userAgent);
	public static var VENDOR_PREFIXES = ["webkit", "moz", "ms", "o", "khtml"];
	
	public static function loadExtension ( name :String, ?obj :Dynamic) :{ prefix :String, field :String, value :Dynamic }
    {
        if (obj == null) {
            obj = Browser.window;
        }

        var extension = Reflect.field(obj, name);
        if (extension != null) {
            return {prefix: "", field: name, value: extension};
        }

        var capitalized = name.charAt(0).toUpperCase() + name.substr(1);
        for (prefix in VENDOR_PREFIXES) {
            var field = prefix + capitalized;
            var extension = Reflect.field(obj, field);
            if (extension != null) {
                return {prefix: prefix, field: field, value: extension};
            }
        }

        return {prefix: null, field: null, value: null};
    }
	
	public static function loadFirstExtension (
        names :Array<String>, ?obj :Dynamic) :{ prefix :String, field :String, value :Dynamic }
    {
        for (name in names) {
            var extension = loadExtension(name, obj);
            if (extension.field != null) {
                return extension;
            }
        }

        // Not found
        return {prefix: null, field: null, value: null};
    }
	
    public static function addVendorListener (dispatcher :EventTarget, type :String,
        listener :Dynamic -> Void, useCapture :Bool)
    {
        for (prefix in VENDOR_PREFIXES) {
            dispatcher.addEventListener(prefix + type, listener, useCapture);
        }
        dispatcher.addEventListener(type, listener, useCapture);
    }
	
	public static function hideMobileBrowser()
	{
		Browser.window.scrollTo(1, 0);
	}
	
    public static function polyfill (name :String, ?obj :Dynamic) :Bool
    {
        if (obj == null) {
            obj = Browser.window;
        }

        var value = loadExtension(name, obj).value;
        if (value == null) {
            return false;
        }
        Reflect.setField(obj, name, value);
        return true;
    }
	
	static public function fixAndroidMath() 
	{
		// THANK YOU BRUNO
		// Some versions of V8 on ARM (like the one in the stock Android 4 browser) are affected by
        // this nasty bug: https://code.google.com/p/v8/issues/detail?id=2234
        //
        // So, hack around it. This doesn't affect Android 2. Hopefully 5 will use an updated V8
        // with the real fix.

        if (Browser.navigator.userAgent.indexOf("Linux; U; Android 4") >= 0) {
            Log.warn("Monkey patching around Android sin/cos bug");
            var sin = Math.sin, cos = Math.cos;
            (untyped Math).sin = function (x) {
                return (x == 0) ? 0 : sin(x);
            };
            (untyped Math).cos = function (x) {
                return (x == 0) ? 1 : cos(x);
            }
        }
	}

}