package cannonjs;


@:native("CANNON.Body")
extern class Body extends EventTarget
{

    public function new(settings:BodySettings);
    
    public static var KINEMATIC:BodyType;
    public static var STATIC:BodyType;
    public static var DYNAMIC:BodyType;
    
    public var material:Material;
    public var position:Vec3;
    public var mass :Float;
    public var quaternion :Quaternion;
    public var allowSleep :Bool;
    public var aabbNeedsUpdate  :Bool;
    
    public function addShape(shape:Shape, ?offset:Vec3, ?quat:Quaternion):Body;
    
    public function applyForce(p:Vec3, worldPoint:Vec3):Body;
    
    public function applyImpulse(p:Vec3, worldPoint:Vec3):Body;
    
    public function applyLocalForce(p:Vec3, localPoint:Vec3):Body;
    
    public function applyLocalImpulse(p:Vec3, localPoint:Vec3):Body;
    
    public function computeAABB():Void;
    public function sleep():Void;
    public function wakeUp ():Void;
    public function updateBoundingRadius ():Void;
    public function updateInertiaWorld  ():Void;
    public function updateMassProperties   ():Void;
    public function updateSolveMassProperties    ():Void;
    
    public function pointToLocalFrame( worldPoint:Vec3, ?result:Vec3):Vec3;
    public function vectorToLocalFrame ( worldPoint:Vec3, ?result:Vec3):Vec3;
    public function pointToWorldFrame ( localPoint:Vec3, ?result:Vec3):Vec3;
    public function vectorToWorldFrame  ( localPoint:Vec3, ?result:Vec3):Vec3;
    
    
}


typedef BodySettings = {
    ?mass:Float,
    ?position:Vec3,
    ?velocity:Vec3,
    ?angularVelocity:Vec3,
    ?quaternion:Quaternion,
    ?shape:Shape,
    ?material:Material,
    ?type:BodyType,
    ?linearDamping:Float,
    ?angularDamping:Float,
    ?allowSleep:Bool,
    ?fixedRotation:Bool,
    ?sleepSpeedLimit:Float ,
    ?sleepTimeLimit:Float ,
    ?collisionFilterGroup:Int ,
    ?collisionFilterMask:Int
}

typedef BodyType = Int;