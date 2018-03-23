package cannonjs;
import haxe.Constraints.Function;

@:native("CANNON.EventTarget")
extern class EventTarget 
{

    public function addEventListener( type:String, listener:Function ):EventTarget;
    public function hasEventListener ( type:String, listener:Function ):Bool;
    public function removeEventListener ( type:String, listener:Function ):EventTarget;
    public function dispatchEvent ( event:String ):EventTarget;
}