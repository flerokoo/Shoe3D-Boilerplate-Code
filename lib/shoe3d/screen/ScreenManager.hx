package shoe3d.screen;
import shoe3d.core.game.GameObject;
import shoe3d.core.Time;
import shoe3d.screen.transition.Transition;
import shoe3d.util.Assert;
import shoe3d.util.signal.*;
import js.three.Scene;

/**
 * ...
 * @author as
 */
@:allow(shoe3d)
class ScreenManager
{
    private static var _currentScreenName:String = "";
    private static var _currentScreen:GameScreen = null;
    private static var _targetScreen:GameScreen = null;
    public static var defaultTransition:Transition;
    private static var _transitions:Map<String,Transition>;
    private static var _prepared:Map<String,GameScreen>;
    private static var _screens:Map<String,Class<GameScreen>>;
    //private static var _base:GameObject;
    public static var onScreenChange(default,null):SingleSignal<String>;

    /**
     * Original game width
     */
    public static var width(default, null):Int = 0;

    /**
     * Original game height
     */
    public static var height(default, null):Int = 0;

    /**
     * Original-sized screen scale to fit current window size
     */
    public static var scale(default, null):Float = 1;

    private static function init()
    {

        _transitions = new Map();
        _screens = new Map();
        _prepared = new Map();
        //_base = new GameObject();
        defaultTransition = new Transition();
        //defaultTransition.setHolder(_base);
        //System._baseScene.add( _base );

        onScreenChange = new SingleSignal();
        System.window._prePublicResize.connect( recalcScale );
        return true;
    }

    static function recalcScale()
    {
        scale = Math.min(System.window.width / width,  System.window.height / height);
    }

    /**
     *  Creates screen but doesn't show it until show is called (screen.onShow is not called until show called too)
     *  Warning: there may be problems, if created screen uses same assets/resources as current screen
     *  (new screen onCreate function can modify GameObjects, existing in current screen)
     *  
     *  Generally used to prepare first screen after loading (to show it without delay on `startup` button press)
     *  @param name - 
     */
    public static function prepare( name:String )
    {
        if ( _screens[name] == null ) return;
        _prepared[name] = Type.createInstance( _screens.get( name ), [] );
        _prepared[name].onCreate();
    }

    public static function show( name:String, ?changeFn:Void->Void )
    {
        #if debug
        Assert.that( _screens.exists( name ), "Screen not exists: " + name );
        #else
        if ( ! _screens.exists( name ) ) return;
        #end

        function getTargetScreen():GameScreen
        {
            var ret;
            if ( _prepared[name] != null )
            {
                ret = _prepared[name];
                _prepared[name] = null;
            }
            else
            {
                ret = Type.createInstance( _screens.get( name ), [] );
                ret.onCreate();
            }

            return ret;
        }


        if ( _currentScreen != null )
        {
            _currentScreen.onHide();
            _currentScreen.dispose();
            if ( changeFn != null ) changeFn(); 
            
            onScreenChange.emit(name);

            _currentScreen = getTargetScreen();
            _currentScreen.onShow();
            
        }
        else
        {
            //_base.add( _targetScreen.scene );
            if ( changeFn != null ) changeFn();
            onScreenChange.emit(name);
            _currentScreen = getTargetScreen();
            _currentScreen.onShow();
            
        }

    }

    public static function addScreen( name:String, scr:Class<GameScreen> )
    {
        if ( _screens == null ) _screens = new Map();
        _screens.set( name, scr );
    }

    /**
     * Sets original game size (usually game is designed for
     * @param	w Width of the game
     * @param	h Height of the game
     */
    public static function setSize( w:Int, h:Int )
    {
        width = w;
        height = h;
    }

}