package cannonjs;

@:native("CANNON.Trimesh")
extern class Trimesh extends Shape
{

    public function new( verts:Array<Float>, indices:Array<Int>);
    
}