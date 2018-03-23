package cannonjs;
import js.three.Scene;

@:native("THREE.CannonDebugRenderer")
extern class CannonDebugRenderer 
{

    public function new( scene:Scene, world:World );
    public function update():Void;
    
}