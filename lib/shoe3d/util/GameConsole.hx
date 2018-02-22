package shoe3d.util;
import haxe.macro.Context;
import haxe.macro.Expr;
import js.Browser;
import shoe3d.core.game.GameObject;
import shoe3d.core.input.Key;
import shoe3d.core.input.KeyboardEvent;
import shoe3d.core.Time;
import shoe3d.System;

/**
 * ...
 * @author as
 */

 typedef Cmd = {fn:Void->Void, hotkey:Key};
 
@:expose("gamec")
@:keep
class GameConsole
{
    public static var system:Class<System> = System;
    public static var last:Dynamic;
    static var commands:Map<String, Cmd>;

    /*public var a = 1;

    macro static public function registerFunction( name:String, fn:Expr ):Expr {
    	var fields = Context.getBuildFields();

    	switch( fn.expr ) {
    		case EFunction( n, f ):
    			var func:Function = {
    				expr: fn,
    				ret: (macro:Dynamic),
    				args: f.args
    			}

    			var field:Field = {
    				name: name,
    				access: [AStatic, APublic],
    				pos: Context.currentPos(),
    				kind: FieldType.FFun( func )
    			}

    			fields.push( field );
    		default:
    			false;
    	}

    	return fields;

    }

    static public function init()
    {

    }*/

    public static function setCurrent( o:Dynamic ):Class<GameConsole>
    {
        last = o;
        return GameConsole;
    }

    public static function registerCommand( name:String, fn:Dynamic, ?hotkey:Key ):Class<GameConsole>
    {
        checkInit();
        commands.set( name, {
            fn: fn,
            hotkey: hotkey
        });
        
        return GameConsole;
    }

    static function exec( name:String, ?args:Array<Dynamic>):Class<GameConsole>
    {
        checkInit();
        var c = commands.get(name);
        if ( c != null ) Reflect.callMethod(null, c.fn, args);
        else Browser.window.console.log("No command with name=" + name );
        return GameConsole;
    }

    static public function help()
    {
        Browser.window.console.log(".find(name) Find game object with specified name and sets pointer to it");
        Browser.window.console.log(".move(name) Sets pointer to current object's field name");
        Browser.window.console.log(".get(name) Print specified property of current object");
        Browser.window.console.log(".set(name, value) Sets specified property of current object");
        Browser.window.console.log(".list(?showContent) Shows all methods and fields of current object");
        Browser.window.console.log(".call(funcName, ?args) Calls specified method of current object");
        Browser.window.console.log(".traverseScene() Prints current scenes tree view of GameObjects");
        Browser.window.console.log(".exec(name, ?args) Executes registered command with name");
        Browser.window.console.log(".setCurrent(obj) Sets pointer to obj");
        Browser.window.console.log(".print() Prints current object");
    }

    static public function find(name:String):Class<GameConsole>
    {
        if ( name == '' || name == null ) return GameConsole;
        last = GameObject.find(name);
        return GameConsole;
    }

    static public function move( name:String ):Class<GameConsole>
    {
        if ( last == null ) return GameConsole;

        if ( Reflect.hasField(last, name ) )
        {
            last = Reflect.field( last, name );
        }
        else{
            Browser.window.console.log('No field $name');
        }

        return GameConsole;
    }

    static public function set( name:String, val:Dynamic ):Class<GameConsole>
    {
        if ( last == null ) return GameConsole;

        if ( Reflect.hasField(last, name))
        {
            Reflect.setProperty( last, name, val );
        }
        else{
            Browser.window.console.log('No field $name');
        }

        return GameConsole;
    }

    static public function get( name:String, val:Dynamic ):Class<GameConsole>
    {
        if ( last == null ) return GameConsole;

        if ( Reflect.hasField(last, name))
        {
            Browser.window.console.log( name + ' = ' + Std.string(Reflect.getProperty( last, name )) );
        }
        else{
            Browser.window.console.log('No field $name');
        }

        return GameConsole;
    }

    static public function call( name:String, ?args:Array<Dynamic> ):Class<GameConsole>
    {
        if ( last == null ) return GameConsole;

        trace( Type.getInstanceFields(Type.getClass(last)) );
        if ( Type.getInstanceFields(Type.getClass(last)).indexOf(name) > -1 && Reflect.isFunction( Reflect.field( last, name )) )
        {
            Reflect.callMethod( last, Reflect.field( last, name ), args );
        }
        else{
            Browser.window.console.log('No function $name');
        }

        return GameConsole;
    }

    static public function print():Class<GameConsole>
    {
        if ( last == null ) return GameConsole;
        Browser.window.console.log( last );
        return GameConsole;
    }

    static public function list( showContent:Bool = false ):Class<GameConsole>
    {
        if ( last == null ) return GameConsole;
        for ( i in Type.getInstanceFields(Type.getClass(last)) )
        {
            if ( Reflect.isFunction( Reflect.field(last, i) ) )
                Browser.window.console.log( i + '(...)' );
            else
                Browser.window.console.log( i + (showContent? ' = ' + Reflect.field( last, i ) : '' ) );
        }
        return GameConsole;
    }

    static public function traverseScene( printComponents:Bool = false ):Class<GameConsole>
    {
        var trav:GameObject->Int->Void = null;

        trav = function( go:GameObject, level:Int = 0 )
        {
            var str = '';
            for ( i in 0...level ) str += '->';
            if ( printComponents )
            {
                Browser.window.console.groupCollapsed( ' %c $str ${go.name==""?"%noname%":go.name}', 'padding-left: ${level*10}px; color: lightblue' );
                for ( i in go.components ) Browser.window.console.log( i.name );
                Browser.window.console.groupEnd();
            }
            else
            {
                Browser.window.console.log( ' %c $str ${go.name==""?"%noname%":go.name}', 'padding-left: ${level*10}px; color: lightblue' );
            }
            level ++;
            for ( i in go.children ) trav( i, level );
        }

        for ( l in System.screen._currentScreen.layers )
        {
            Browser.window.console.groupCollapsed( '%c LAYER ${l.name}', "padding: 3px 10px; color: orange");
            for ( i in l.children )
                trav( i, 1);
            Browser.window.console.groupEnd();
        }

        return GameConsole;
    }
    
    static function checkInit()
    {
        if (_inited) return;
        init();
        _inited = true;
    }

    static function init()
    {
        commands = new Map();
        
        System.input.keyboard.up.connect( function( e:KeyboardEvent )
        {
            for ( i in commands )
            {
                if ( e.key == i.hotkey ) i.fn();
            }
        });
             
        
        return true;
    }
    
    static var _inited = false;

}

