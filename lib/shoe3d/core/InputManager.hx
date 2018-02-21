package shoe3d.core;
import js.Browser;
import js.html.CanvasElement;
import js.html.DivElement;
import js.html.KeyboardEvent;
import js.html.MouseEvent;
import shoe3d.core.input.KeyboardManager;
import shoe3d.core.input.MouseManager;
import shoe3d.core.input.PointerManager;
import shoe3d.core.input.TouchManager;
import shoe3d.util.HtmlUtils;

/**
 * ...
 * @author as
 */
@:allow(shoe3d)
class InputManager
{

    public static var pointer(default, null):PointerManager;
    public static var mouse(default, null):MouseManager;
    public static var touch(default, null):TouchManager;
    public static var keyboard(default, null):KeyboardManager;

    public static var pointerEnabled:Bool = true;

    static var _canvas:CanvasElement;
    static var _div:DivElement;
    static var _lastTouchTime:Float = 0;

    public static function init()
    {
        pointer = new PointerManager( );
        mouse = new MouseManager( );
        touch = new TouchManager( );
        keyboard = new KeyboardManager();
        _canvas = System.renderer.renderer.domElement;
        _div = System.renderer.container;

        // MOUSE SYSTEM
        var onMouse = function(event:MouseEvent)
        {
            if ( ! pointerEnabled ) return;
            if ( event.timeStamp - _lastTouchTime < 1000 )
            {
                // filter events emulated by browser: http://www.w3.org/TR/touch-events/#mouse-events
                return;
            }

            var bounds = _canvas.getBoundingClientRect();
            var x = getX( event, bounds );
            var y = getY( event, bounds );
            switch ( event.type )
            {
                case "mousedown":
                    if ( event.target == _canvas )
                    {
                        event.preventDefault();
                        mouse.submitDown( x, y, event.button );
                        _canvas.focus();
                    }
                case "mousemove":
                    mouse.submitMove( x, y );
                case "mouseup":
                    mouse.submitUp(x, y, event.button);
                case "mousewheel", "DOMMouseScroll":
                    var vel = (event.type == "mousewheel" ? (untyped event).wheelDelta / 40 : -event.detail );
                    if ( mouse.submitScroll(x, y, vel))
                        event.preventDefault();
            }
        };

        Browser.window.addEventListener("mousedown", onMouse, false );
        Browser.window.addEventListener("mouseup", onMouse, false );
        Browser.window.addEventListener("mousemove", onMouse, false );
        _canvas.addEventListener("mousewheel", onMouse, false );
        _canvas.addEventListener("DOMMouseScroll", onMouse, false );
        _canvas.addEventListener("contextmenu", function(e) e.preventDefault(), false );

        // TOUCH SYSTEM
        var isStandartTouch = untyped __js__("typeof")(Browser.window.ontouchstart) != "undefined";
        var isMsTouch = untyped __js__("'msMaxTouchPoints' in window.navigator && (window.navigator.msMaxTouchPoints > 1 )" );
        if ( isStandartTouch || isMsTouch )
        {
            touch.maxPoints = isStandartTouch ? 4 : (untyped Browser.navigator).msMaxTouchPoints ;

            var onTouch = function ( e:Dynamic )
            {
                if ( ! pointerEnabled ) return;
                var changedTouches:Array<Dynamic> = isStandartTouch ? e.changedTouches : [e];
                var bounds = e.target.getBoundingClientRect();
                _lastTouchTime = e.timeStamp;
                switch ( e.type )
                {
                    case "touchstart", "MSPointerDown", "pointerdown":
                        e.preventDefault();
                        if ( HtmlUtils.HIDE_MOBILE_BROWSER ) HtmlUtils.hideMobileBrowser();
                        for ( t in changedTouches )
                        {
                            var x = getX( t, bounds );
                            var y = getY( t, bounds );
                            var id = Std.int( isStandartTouch ? t.identifier : t.pointerId );
                            touch.submitDown( id, x, y );
                        }
                    case "touchmove", "MSPointerMove", "pointermove":
                        e.preventDefault();
                        for ( t in changedTouches )
                        {
                            var x = getX( t, bounds );
                            var y = getY( t, bounds );
                            var id = Std.int( isStandartTouch ? t.identifier : t.pointerId );
                            touch.submitMove( id, x, y );
                        }
                    case "touchend", "touchcancel", "MSPointerUp", "pointerup":
                        for (t in changedTouches)
                        {
                            var x = getX(t, bounds);
                            var y = getY(t, bounds);
                            var id = Std.int(isStandartTouch ? t.identifier : t.pointerId);
                            touch.submitUp(id, x, y);
                        }
                }
            }

            // I DONT KNOW WHY SAMSUNG I HATE YOU
            if ( js.Browser.navigator.userAgent.toLowerCase().indexOf("samsung") >= 0 )
                js.Browser.window.addEventListener("touchstart", function(e:Dynamic) {} );

            if ( isStandartTouch )
            {
                _canvas.addEventListener("touchstart", onTouch, false);
                _canvas.addEventListener("touchmove", onTouch, false);
                _canvas.addEventListener("touchend", onTouch, false);
                _canvas.addEventListener("touchcancel", onTouch, false);
            }
            else
            {
                _canvas.addEventListener("MSPointerDown", onTouch, false);
                _canvas.addEventListener("MSPointerMove", onTouch, false);
                _canvas.addEventListener("MSPointerUp", onTouch, false);
            }

        }
        else
        {
            touch._disabled = true;
        }

        // KEYBOARD
        keyboard = new KeyboardManager();
        var onKey = function( event:KeyboardEvent )
        {
            switch ( event.type )
            {
                case "keydown":
                    if ( keyboard.submitDown( event.keyCode ) )
                        event.preventDefault();
                case "keyup":
                    keyboard.submitUp( event.keyCode );
            }
        }
        Browser.window.addEventListener("keydown", onKey, false);
        Browser.window.addEventListener("keyup", onKey, false);
        return true;
    }

    private static inline function getX (event :Dynamic, bounds :Dynamic) :Float
    {
        return (event.clientX - bounds.left)*System.window.width/bounds.width;
    }

    private static inline function getY (event :Dynamic, bounds :Dynamic) :Float
    {
        return (event.clientY - bounds.top)*System.window.height/bounds.height;
    }
}