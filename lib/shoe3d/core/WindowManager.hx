package shoe3d.core;
import shoe3d.screen.ScreenManager;
import js.html.DivElement;
import shoe3d.util.HtmlUtils;
import shoe3d.util.DeviceInfo;
import shoe3d.util.Log;
import shoe3d.util.signal.ZeroSignal;
import js.Browser;
import js.html.CanvasElement;
import shoe3d.util.Value;
import soundjs.SoundManager;

/**
 * ...
 * @author as
 */
@:allow(shoe3d)
class WindowManager
{
    private static var _prePublicResize(default,null):ZeroSignal;
    public static var resize(default,null):ZeroSignal;
    public static var orientation(default, null):Value<Orientation>;
    public static var mode(default, set):WindowMode = Fill;
    public static var width(get, null):Int;
    public static var height(get, null):Int;
    public static var hidden(default, null):Value<Bool>;
    public static var fullscreen(default, null):Value<Bool>;
    public static var targetOrientation:Orientation;

    public static function init()
    {
        hidden = new Value( false );
        fullscreen = new Value( false );
        _prePublicResize = new ZeroSignal();
        resize = new ZeroSignal();
        orientation = new Value( Portrait );

        Browser.window.addEventListener( "orientationchange", function(_) callLater( onOrientationChange ) );
        Browser.window.addEventListener( "resize", function(_) callLater( onResize ) );

        // HIDDEN API
        var api = HtmlUtils.loadExtension("hidden", Browser.document );

        if ( api.value != null )
        {
            var onVisibilityChange = function(e)
            {
                hidden._ = Reflect.field( Browser.document, api.field );
            };

            onVisibilityChange(null);

            Browser.document.addEventListener(api.prefix + "visibilitychange", onVisibilityChange, false );
            Log.sys( "Visibility API supported" );
        }
        else
        {

            var onPageTransition = function (e)
            {
                hidden._ = e.type == 'pagehide';
            }
            Browser.window.addEventListener("pageshow", onPageTransition, false);
            Browser.window.addEventListener("pagehide", onPageTransition, false);
            Log.sys( "No Visibility API. Using pageshow/pagehide fallback" );
        }

        // FULLSCREEN CHANGE
        HtmlUtils.addVendorListener(Browser.document, "fullscreenchange", function (_)
            {
                updateFullscreen();
            }, false);

        var wasMutedBeforeHide = false;
        hidden.change.connect( function( a, b )
            {

                if ( a )   // hidden
                {
                    wasMutedBeforeHide = SoundManager.muted;
                    SoundManager.muted = true;
                }

                if ( ! a )   //shown
                {
                    SoundManager.muted = wasMutedBeforeHide;
                }

            } );

        updateOrientation();
        return true;
    }

    private static function updateFullscreen()
    {
        var state :Dynamic = HtmlUtils.loadFirstExtension(
                                 ["fullscreen", "fullScreen", "isFullScreen"], Browser.document).value;
        fullscreen._ = (state == true); // state will be null if fullscreen not supported
    }

    private static function onResize()
    {

        updateLayout();

        _prePublicResize.emit();

        resize.emit();
    }

    private static function onOrientationChange()
    {

        updateLayout();

        _prePublicResize.emit();

        updateOrientation() ;
    }

    private static function updateOrientation()
    {
        orientation.set(
            switch ( (untyped Browser.window).orientation )
            {
                case -90, 90, 270, -270: Landscape;
                default: Portrait;
            } );
    }

    private static function updateLayout ()
    {
        resetStyle();
        //html element
        Browser.document.body.parentElement.style.height = "100%";

        var canvas:CanvasElement = RenderManager.renderer.domElement;
        var div:DivElement = RenderManager.container;
        var isMobile = DeviceInfo.isMobileBrowser();

        if ( mode == Fill || isMobile )
        {
            Browser.document.body.style.padding = "0";
            div.style.margin = "0";

            var ratio = Browser.window.devicePixelRatio ;
            if ( Math.max( Browser.window.innerWidth, Browser.window.innerHeight) * ratio > 2300 && isMobile )
            {
                Log.sys("Falling back to devicePixelRatio=1");
                //ratio = 1;
            }

            RenderManager.renderer.setSize( Browser.window.innerWidth * ratio, Browser.window.innerHeight * ratio );

            div.style.width = canvas.style.width = Browser.window.innerWidth + "px";
            div.style.height = canvas.style.height = Browser.window.innerHeight + "px";
        }
        else
        {
            div.style.width = width + "px";
            div.style.height = height + "px";

            Browser.document.body.style.padding = "0.06px";
            Browser.document.body.style.height = "100%";

            RenderManager.renderer.setSize(ScreenManager.width, ScreenManager.height);

            var marginTop = Math.floor(Math.max(0, (Browser.window.innerHeight - height ) / 2));
            div.style.margin = marginTop + "px auto 0";
        }

    }

    private static function resetStyle()
    {
        Browser.document.body.style.margin = "0";
        Browser.document.body.style.padding = "0";
        Browser.document.body.style.width = "100%";
        Browser.document.body.style.height = "100%";

        RenderManager.container.style.padding = "0px";

        // for input systems
        RenderManager.container.style.overflow = "hidden";
        RenderManager.container.style.position = "relative";

        // http://msdn.microsoft.com/en-us/library/windows/apps/Hh767313.aspx
        (untyped RenderManager.container.style).msTouchAction = "none";

        /*Browser.document.body.style.marginBottom =
        Browser.document.body.style.marginLeft =
        Browser.document.body.style.marginRight =
        Browser.document.body.style.marginTop =*/
    }

    private static function callLater( fn:Void->Void, delay:Int = 300 )
    {
        Browser.window.setTimeout( fn, delay );
    }

    static function set_mode(value:WindowMode):WindowMode
    {
        mode = value;
        updateLayout();
        return mode;
    }

    static function get_width()
    {
        switch ( mode )
        {
            case Fill:
                return Browser.window.innerWidth;
            case Default:
                return (DeviceInfo.isMobileBrowser() ? Browser.window.innerWidth : ScreenManager.width);
        }
    }

    static function get_height()
    {
        switch ( mode )
        {
            case Fill:
                return Browser.window.innerHeight;
            case Default:
                return (DeviceInfo.isMobileBrowser() ? Browser.window.innerHeight : ScreenManager.height);
        }
    }

    static public function setSize( w:Int, h:Int, fit:Bool = false )
    {
        width = w;
        height = h;
        mode = Default;
        updateLayout();
    }

    static public function requestFullscreen (enable :Bool = true)
    {
        if (enable)
        {
            var documentElement = Browser.document.documentElement;
            var requestFullscreen = HtmlUtils.loadFirstExtension(
                                        ["requestFullscreen", "requestFullScreen"], documentElement).value;
            if (requestFullscreen != null)
            {
                Reflect.callMethod(documentElement, requestFullscreen, []);
            }
        }
        else
        {
            var cancelFullscreen = HtmlUtils.loadFirstExtension(
                                       ["cancelFullscreen", "cancelFullScreen"], Browser.document).value;
            if (cancelFullscreen != null)
            {
                Reflect.callMethod(Browser.document, cancelFullscreen, []);
            }
        }

        if ( targetOrientation != null )
        {
            var orientation = HtmlUtils.loadFirstExtension(["orientation"], Browser.window.screen).value;
            if ( orientation != null )
            {
                orientation.lock( targetOrientation == Landscape ? "landscape" : "portrait").then(
                    function(e) Log.sys("Locked orientation"),
                    function(e) Log.sys("Orientation lock error: " + e)
                );
            }
            else
            {
                Log.sys("Orientation API is not supported");
            }
        }

    }

    static public function setTargetOrientation( o:Orientation, showOnScreenMessageWhenAPIUnavaible:Bool = false )
    {
        targetOrientation = o;
        // TODO make orientation unlockable (when passed o == null)
        if ( showOnScreenMessageWhenAPIUnavaible )
        {
            // TODO show div with "rotate you screen dumbass" message when orientation api is not available
            Log.warn("Rotate-your-phone-dumbass-message not implemented");
        }

    }
}

enum Orientation { Portrait; Landscape; }

enum WindowMode { Fill;  Default; }