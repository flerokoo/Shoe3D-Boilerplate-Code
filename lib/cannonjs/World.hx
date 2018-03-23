package cannonjs;

/**
 * ...
 * @author asd
 */
@:native("CANNON.World")
extern class World extends EventTarget
{

    public function new(); 
    public function addBody( body:Body ):Void ;
    public function removeBody( body:Body ):Void ;
    public function addConstraint( c:Dynamic ) :Void ;
    public function removeConstraint( c:Dynamic ) :Void ;
    public function addContactMaterial( cmat:ContactMaterial ) :Void ;
    public function getContactMaterial ( m1:Material, m2:Material  ) :Void ;
    public function addMaterial ( mat:Material ) :Void ;
    public function clearForces  ( ) :Void ;
    public function collisionMatrixTick   ( ) :Void ;
    public function step(timestep:Float, ?totalTimeToTick:Float, ?maxSubSteps:Int ):Void;
    
    public var gravity:Vec3;
    public var bodies:Array<Body>;
    public var constraints:Array<Dynamic>;
    public var broadphase:Dynamic;
        
    
    
}