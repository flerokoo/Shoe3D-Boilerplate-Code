package cannonjs;


@:native("CANNON.Vec3")
extern class Vec3 
{

    public function new(?x:Float, ?y:Float, ?z:Float);
    public function set(x:Float, y:Float, z:Float):Vec3;
    public function setZero():Void;
    
    public function almostEquals(vv:Vec3, precision:Float):Bool;
    public function isAntiparallelTo (vv:Vec3, precision:Float):Bool;
    
    public function cross(vv:Vec3, ?target:Vec3):Bool;
    public function lerp (vv:Vec3, t:Float, ?target:Vec3):Void;
    
    public function negate  (?target:Vec3):Vec3;
    public function unit   (?target:Vec3):Vec3;
    public function vadd   (v:Vec3, ?target:Vec3):Vec3;
    public function vsub   (v:Vec3, ?target:Vec3):Vec3;
    
    public function distanceSquared (vv:Vec3):Float;
    public function distanceTo (vv:Vec3):Float;
    public function dot (vv:Vec3):Float;
    public function tangents  (v1:Vec3, v2:Vec3):Float;
    
    public function copy (vv:Vec3):Vec3;
    
    public function almostZero (precision:Float):Bool;
    public function isZero  ():Bool;
    public function length   ():Float;
    public function normalize   ():Float;
    public function scale   ( scalar:Float, ?target:Vec3):Float;
    
    public function clone ():Vec3;
    
    public static var UNIT_X:Vec3;
    public static var UNIT_Y:Vec3;
    public static var UNIT_Z:Vec3;
    
    public var x:Float;
    public var y:Float;
    public var z:Float;
    
}