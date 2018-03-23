package cannonjs;
import js.three.Vector3;

@:native("CANNON.Quaternion")
extern class Quaternion 
{

    public function new (x:Float, y:Float, z:Float, w:Float);
    
    public function set  (x:Float, y:Float, z:Float, w:Float):Void;
    
    
    public function conjugate (?target:Quaternion):Quaternion;
    public function copy (source:Quaternion):Quaternion;
    public function inverse  (?target:Quaternion):Quaternion;
    public function normalize  ():Void;
    public function normalizeFast   ():Void;
    public function mult  (q:Quaternion, ?target:Quaternion):Quaternion;
    public function vmult (q:Vec3, ?target:Quaternion):Quaternion;
    public function setFromAxisAngle   (axis:Vec3, angle:Float):Void;
    public function setFromVectors    (u:Vec3, v:Vec3):Void;
    public function setFromEuler  (x:Float, y:Float, z:Float, ?order:String):Void;
    public function toArray   ():Array<Float>;
    public function toAxisAngle   (targetAxis :Vec3):Void;
    public function toEuler   (target:Vector3, ?order:String):Void;
    
    public var w:Float;
    public var x:Float;
    public var y:Float;
    public var z:Float;
    
}