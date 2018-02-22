package shoe3d.core.game;

import js.three.Vector3;
import js.three.Euler;
import js.three.Object3D;
import shoe3d.core.game.Component;
import shoe3d.util.Assert;
import shoe3d.util.Disposable;
import shoe3d.util.Log;

typedef Transform = Object3D;

@:allow(shoe3d)
#if debug
@:keep
#end
@:final
class GameObject implements ComponentContainer implements GameObjectContainer implements Disposable
{

    public var components(default,null):Array<Component>;
    public var children(default,null):Array<GameObject>;
    public var name:String;
    public var transform(default, null):Transform;
    public var layer:Layer;
    public var parent:GameObject;
    
    /**
     * If true, only direct call to gameobject.dispose will dispose this gameobject
     * Other objects (parent gameobjects and layers) will not dispose it and it's hierarchy
     * This can be useful on global (static) gameobjects, that can be used on different screens
     * This variable prevents disposing, when changing screens
     */
    public var doNotDispose:Bool = false;
    
    private var _compMap:Map<String,Component>;

    public static function with ( comp:Component, name:String = '')
    {
        return new GameObject(name).add( comp );
    }

    public static function find( name:String, maxDepth:Int = -1 )
    {
        if ( System.screen._currentScreen != null )
        {
            for ( i in System.screen._currentScreen.layers )
            {
                var t = findInContainer(i, name, maxDepth );
                if ( t != null ) return t;
            }
        }

        return null;
    }

    static function findInContainer( cont:GameObjectContainer, name:String, depth:Int = -1 ):GameObject
    {

        depth--;
        for ( i in cont.children )
        {
            if ( i.name == name )
            {
                return i;
            }
        }

        if ( depth != 0 )
            for ( i in cont.children )
            {
                var ret = findInContainer( i, name, depth );
                if ( ret != null) return ret;
            }

        return null;
    }

    public function findChild( name:String, depth:Int = -1 ):GameObject
    {
        return findInContainer( this, name, depth );
    }

    
    
    var i = 0;
    static var ii = 0;
    public function new( name:String = '' )
    {
        i = ii++;
        Log.warn("CREATE " + i);
        this.name = name;
        components = [];
        children = [];
        _compMap = new Map();
        #if !macro
        transform = new Transform();
        transform.userData = { gameObject: this };
        #end

    }

    public function add (component :Component) :GameObject
    {
        if (component.owner != null)
        {
            component.owner.remove(component);
        }

        var name = component.name;
        var prev = getComponent(name);
        if (prev != null)
        {
            remove(prev);
        }

        untyped _compMap[name] = component;

        components.push( component );

        component.owner = this;
        component.onAdded();

        return this;
    }

    public function has<T:Component>( cl:Class<T> ) : Bool
    {
        return get(cl) != null;
    }

    public function remove (component :Component) :Bool
    {

        var i = components.indexOf( component );
        if ( i >= 0 )
        {
            components.splice( i, 1 );
            if ( component._started )
            {
                component.onStop();
                component._started = false;
            }
            component.onRemoved();
            component.owner = null;

            _compMap.remove(component.name);

            return true;
        }
        return false;
    }

    public function get<T:Component>( cl:Class<T> ): T
    {
        var t = _compMap[Reflect.getProperty(cl, "NAME")];
        return Std.instance( t, cl );
    }

    inline function getComponent (name :String) :Component
    {
        return untyped _compMap[name];
    }

    public function addChild( child:GameObject )
    {
        #if debug
        Assert.that( children.indexOf(child) < 0, "Provided GameObject is already a child" );
        #end
        children.push( child );
        child.parent = this;
        child.setLayerReferenceRecursive( layer );
        transform.add( child.transform );
    }

    public function removeChild( child:GameObject )
    {
        children.remove( child );
        child.parent = null;
        child.setLayerReferenceRecursive( null );
        transform.remove( child.transform );
    }

    public function removeChildAt( i:Int )
    {
        var c = children[i];
        children.splice( i, 1 );
        c.parent = null;
        c.setLayerReferenceRecursive( null );
        transform.remove( c.transform );
    }

    public function getChild( i:Int )
    {
        if ( children[i] == null ) throw 'No child at specified index i=' + i;
        return children[i];
    }

    private function onAdded()
    {
        // TODO Make onAddedToStage()
        //for ( i in components ) i.onAdded();
        //for ( i in _children ) i.onAdded();
    }

    private function onRemoved()
    {
        //for ( i in components ) i.onRemoved();
        //for ( i in _children ) i.onRemoved();
    }

    private function setLayerReferenceRecursive( l:Layer )
    {
        layer = l;
        
        for ( i in children )
            i.setLayerReferenceRecursive( l );
    }

    public function setPos( x:Float, y:Float, z:Float = 0 )
    {
        transform.position.set(x, y, z);
        return this;
    }

    public function setX( x:Float )
    {
        transform.position.x = x;
        return this;
    }

    public function setY( y:Float )
    {
        transform.position.y = y;
        return this;
    }

    public function setZ( x:Float )
    {
        transform.position.z = x;
        return this;
    }

    public function setScale( x:Float = 1 )
    {
        transform.scale.set(x, x, x);
        return this;
    }

    public function setScaleXYZ( x:Float = 1, y:Float = 1, z:Float = 1 )
    {
        transform.scale.set(x, y, z);
        return this;
    }

    public function setRotation( x:Float = 0, y:Float = 0, z:Float = 0 )
    {
        transform.setRotationFromEuler( new Euler( x, y, z ) );
        return this;
    }

    public function rotateX( a:Float )
    {
        transform.rotateX( a );
        return this;
    }

    public function rotateY( a:Float )
    {
        transform.rotateY( a );
        return this;
    }

    public function rotateZ( a:Float )
    {
        transform.rotateZ( a );
        return this;
    }

    public function lookAt( a:Vector3 = null )
    {
        transform.lookAt( a == null ? new Vector3() : a );
        return this;
    }

    /*
        public var components(default,null):Array<Component>;
    public var children(default,null):Array<GameObject>;
    public var name:String;
    public var transform(default, null):Transform;
    public var layer:Layer;
    public var parent:GameObject;
    private var _compMap:Map<String,Component>;*/

    public function dispose()
    {
        if ( parent != null )
        {
            parent.removeChild( this );
        } 
        else if( layer != null ) 
        {
            layer.removeChild( this );
        }

        for ( i in components )
            i.dispose();

        disposeChildren();

        components = null;
        children = null;
        transform.userData = null;
        transform = null;
        layer = null;
        parent = null;
        _compMap = null;
    }

    public function disposeChildren()
    {
        for ( i in children )
        {
            if( ! i.doNotDispose )
                i.dispose();
        }
    }

    public var numComponents(get, null):Int;	function get_numComponents() return components.length;
    public var numChildren(get, null):Int;	function get_numChildren() return children.length;

}