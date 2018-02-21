package shoe3d.util;
import shoe3d.core.input.PointerEvent;
import shoe3d.util.signal.Sentinel;
import shoe3d.util.signal.SingleSignal;

/**
 * ...
 * @author as
 */
interface Pointable
{

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
    public var pointerEnabled:Bool = true;

    private function connectHover ():Void;

    @:allow(shoe3d)
    private function onPointerDown(e:PointerEvent ):Void	;
    @:allow(shoe3d)
    private function onHover( e:PointerEvent ):Void;
    @:allow(shoe3d)
    private function onPointerMove( e:PointerEvent ):Void;
    @:allow(shoe3d)
    private function onPointerUp( event:PointerEvent ):Void;

    /*function get_pointerDown():SingleSignal<PointerEvent>;
    function get_pointerUp():SingleSignal<PointerEvent> ;
    function get_pointerMove():SingleSignal<PointerEvent> ;
    function get_pointerIn():SingleSignal<PointerEvent> ;
    function get_pointerOut():SingleSignal<PointerEvent> ;*/

    private var _hovering:Bool = false;
    private var _hoverConnection:Sentinel;
}