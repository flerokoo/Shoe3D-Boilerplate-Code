package cannonjs;

@:native("CANNON.Material")
extern class Material 
{

    public function new( ?options:Dynamic );
    
    public var friction:Float;
    public var restitution:Float;
    public var name:String;
    public var id:Int;
    
    
}

typedef MaterialOptions = {
    ?friction:Float,
    ?restitution:Float
}