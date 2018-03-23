package cannonjs;

@:native("CANNON.Shape")
extern class Shape 
{

    public function new();
    public var boundingSphereRadius:Float;
    public var collisionResponse:Bool;
    public var id:Int;
    public var type:Int;
    public static var types:Dynamic;
    
}