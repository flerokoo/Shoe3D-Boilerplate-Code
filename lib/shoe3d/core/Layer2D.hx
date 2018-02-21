package shoe3d.core;
import shoe3d.core.input.PointerEvent;
import shoe3d.util.Assert;
import shoe3d.util.Log;
import shoe3d.util.Pointable;
import shoe3d.util.signal.Sentinel;
import shoe3d.util.signal.SingleSignal;
import js.three.Camera;
import js.three.OrthographicCamera;
import js.three.Vector3;
import js.three.WebGLRenderer;

/**
 * ...
 * @author as
 */
class Layer2D extends Layer implements Pointable
{
    public var pointerEnabled:Bool = false;
    public var pointerUp(get, null):SingleSignal<PointerEvent>;
    public var pointerDown(get, null):SingleSignal<PointerEvent>;
    public var pointerMove(get, null):SingleSignal<PointerEvent>;
    public var pointerIn(get, null):SingleSignal<PointerEvent>;
    public var pointerOut(get, null):SingleSignal<PointerEvent>;
    public var _pointerUp:SingleSignal<PointerEvent>;
    public var _pointerDown:SingleSignal<PointerEvent>;
    public var _pointerMove:SingleSignal<PointerEvent>;
    public var _pointerIn:SingleSignal<PointerEvent>;
    public var _pointerOut:SingleSignal<PointerEvent>;

    private var _hovering:Bool = false;
    private var _hoverConnection:Sentinel;

    override public function dispose()
    {
        _pointerUp = null;
        _pointerDown = null;
        _pointerMove = null;
        _pointerIn = null;
        _pointerOut = null;
        
        if( _hoverConnection != null ) _hoverConnection.dispose();

        super.dispose();
    }

    override function reconfigureCamera()
    {
        if ( camera != null )
        {
            var cam = cast( camera, OrthographicCamera );

            var scale = 0.005;
            scale = 1;
            /*cam.left = -System.window.width / 2  *  scale;
            cam.right = System.window.width / 2  *  scale;
            cam.top = System.window.height / 2  *  scale;
            cam.bottom = -System.window.height / 2  *  scale;*/

            cam.left = 0;
            cam.right = System.window.width;

            cam.top = System.window.height;
            cam.bottom = 0;

            /*cam.bottom = 0;
            cam.top = System.window.height;*/

            cam.far = 2001;
            cam.near = 0.5;

            //-----new
            cam.bottom = System.window.height;
            cam.top = 0;

            cam.position.set( 0, 0, 2000 );
            cam.up = new Vector3( 0, 1, 0 );
            cam.lookAt( new Vector3(0, 0, 0) );

            cam.updateMatrix();
            cam.updateProjectionMatrix();

        }
    }

    override public function render( renderer:WebGLRenderer )
    {
        if ( camera == null ) return;
        renderer.sortObjects = false;
        //renderer.setDepthTest( false );
        //renderer.setDepthWrite( false );
        //Log.log( renderer);
        //throw "ERR";
        if ( clearDepthBeforeRender  ) renderer.clearDepth();
        renderer.render( scene, camera );
    }

    public function new(?name)
    {
        super(name);
        clearDepthBeforeRender = true;
    }

    override public function setCamera( cam:Camera )
    {
        Assert.that( Std.is(cam, OrthographicCamera ), "UILayer allows only ortho camera" );
        camera = cam;
        camera.up = new Vector3( 0, 1, 0);
        reconfigureCamera();
        return this;
    }

    @:allow(shoe3d)
    private function onPointerDown(e:PointerEvent )
    {
        onHover(e);
        if ( pointerDown != null )
        {
            pointerDown.emit( e );
        }
    }

    @:allow(shoe3d)
    private function onHover( e:PointerEvent )
    {
        if ( _hovering ) return;
        _hovering = true;
        if ( _pointerIn != null || _pointerOut != null )
        {
            if ( _pointerIn != null )
                _pointerIn.emit( e );
            connectHover();
        }
    }

    private function connectHover ()
    {
        if (_hoverConnection != null)
        {
            return;
        }
        _hoverConnection = System.input.pointer.move.connect(function (event)
        {
            // Return early if this sprite was in the event chain
            var hit = event.layer;
            if ( hit == this )
                return;

            // This sprite is not under the pointer
            if (_pointerOut != null && _hovering)
            {
                _pointerOut.emit(event);
            }
            _hovering = false;
            _hoverConnection.dispose();
            _hoverConnection = null;
        });
    }

    @:allow(shoe3d)
    private function onPointerMove( e:PointerEvent )
    {
        onHover(e);
        if ( _pointerMove != null )
            _pointerMove.emit(e);
    }

    @:allow(shoe3d)
    private function onPointerUp( event:PointerEvent )
    {
        switch (event.source)
        {
            case Touch(touchpoint):
                if ( _pointerOut != null && _hovering )
                    _pointerOut.emit(event);
                _hovering = false;
                if ( _hoverConnection != null )
                {
                    _hoverConnection.dispose();
                    _hoverConnection = null;
                }
            default:
        }

        if ( _pointerUp != null )
            _pointerUp.emit(event);
    }

    function get_pointerDown():SingleSignal<PointerEvent>
    {
        if ( _pointerDown == null ) _pointerDown = new SingleSignal();
        return _pointerDown;
    }

    function get_pointerUp():SingleSignal<PointerEvent>
    {
        if ( _pointerUp == null ) _pointerUp = new SingleSignal();
        return _pointerUp;
    }

    function get_pointerMove():SingleSignal<PointerEvent>
    {
        if ( _pointerMove == null ) _pointerMove = new SingleSignal();
        return _pointerMove;
    }

    function get_pointerIn():SingleSignal<PointerEvent>
    {
        if ( _pointerIn == null ) _pointerIn = new SingleSignal();
        return _pointerIn;
    }

    function get_pointerOut():SingleSignal<PointerEvent>
    {
        if ( _pointerOut == null ) _pointerOut = new SingleSignal();
        return _pointerOut;
    }

}