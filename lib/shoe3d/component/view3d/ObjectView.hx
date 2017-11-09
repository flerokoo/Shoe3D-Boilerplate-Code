package shoe3d.component.view3d;

import shoe3d.asset.Assets;
import shoe3d.core.game.Component;
import js.three.Geometry;
import js.three.BufferGeometry;
import js.three.Material;
import js.three.Object3D;
import js.three.Mesh;

/**
 * ...
 * @author as
 */
class ObjectView extends Component
{

	public var object:Object3D;
	
	public function new( obj:Object3D ) 
	{
		super();
		object = obj;
	}

	public static function fromGeometry(geom:Geometry, mat:Material) 
	{
		var mesh = new Mesh(geom, mat);
		return new ObjectView(mesh);
	}
	
	public static function fromBufferGeometry(geom:BufferGeometry, mat:Material) 
	{
		// there was a mistake in Mesh extern: overload metadata was AFTER the constructor, but should've been before
		// so untyped
		var mesh = new Mesh(untyped geom, mat);
		return new ObjectView(mesh);
	}

	public static function fromAssets(name:String, clone:Bool = false)
	{
		var o = Assets.getObject3D(name);
		return new ObjectView( clone ? o.clone() : o );
	}

	override public function onAdded() 
	{
		super.onAdded();
		owner.transform.add( object );
	}
	
	override public function onRemoved()
	{
		super.onRemoved();
		owner.transform.remove( object );
	}
	
	public function setAnchor( x:Float, y:Float, z:Float )
	{
		object.position.set( -x, -y, -z );
		return this;
	}
	
}