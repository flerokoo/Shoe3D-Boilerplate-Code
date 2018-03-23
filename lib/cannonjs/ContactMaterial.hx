package cannonjs;
import cannonjs.Material.MaterialOptions;

@:native("CANNON.ContactMaterial")
extern class ContactMaterial 
{

    public function new( m1:Material, m2:Material, ?options:ContactMaterialOptions);
    
    public var friction:Float;
    public var restitution:Float;
    public var contactEquationStiffness:Float;
    public var contactEquationRelaxation:Float;
    public var frictionEquationStiffness:Float;
    public var frictionEquationRelaxation:Float;
    public var name:String;
    public var id:Int;
    public var materials:Array<Material>;

    
}

typedef ContactMaterialOptions = {
    > MaterialOptions,
    ? contactEquationStiffness:Float,
    ? contactEquationRelaxation:Float,
    ? frictionEquationStiffness:Float,
    ? frictionEquationRelaxation:Float
}