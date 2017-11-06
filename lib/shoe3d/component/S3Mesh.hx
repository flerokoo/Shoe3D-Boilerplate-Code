package shoe3d.component;
import shoe3d.core.game.Component;
import js.three.Geometry;
import js.three.Material;
import js.three.Mesh;
import js.three.MeshPhongMaterial;

/**
 * ...
 * @author as
 */
class S3Mesh extends Component
{

	public var geometry:Geometry;
	public var material:Material;
	public var mesh:Mesh;
	
	public function new( ?geom:Geometry, ?mat:Material ) 
	{
		super();
		geometry = geom;
		material = mat;
		mesh = new Mesh( geometry, material );
		if ( owner != null ) owner.transform.add( mesh );
	}
	
	override public function onAdded() 
	{
		owner.transform.add( mesh );
	}
	
}