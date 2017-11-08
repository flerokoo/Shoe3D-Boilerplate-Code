package shoe3d.component.view2d;
import shoe3d.component.view2d.Element2D;
import shoe3d.core.game.Component;
import shoe3d.util.SMath;
import js.three.Blending;
import js.three.Color;
import js.three.Colors;
import js.three.Geometry;
import js.three.Mesh;
import js.three.MeshBasicMaterial;
import js.three.PlaneGeometry;
import js.three.Side;
import js.three.Vector3;

/**
 * ...
 * @author as
 */
class FillSprite extends Element2D
{
	var mesh:Mesh;
	var geom:Geometry;
	var material:MeshBasicMaterial;
	public var width(default, set):Float = 0;
	public var height(default, set):Float = 0;
	public var color(default, set):Int = 0;
	
	public function new( width:Float, height:Float, ?color:UInt ) 
	{
		super();
		geom = new PlaneGeometry(width, height, 1, 1);
		material = new MeshBasicMaterial( { side: js.Three.DoubleSide, transparent: true, depthTest: false, depthWrite: false  } );
		mesh = new Mesh( geom, material );	
		
		this.width = width;
		this.height = height;
		this.color = color == null ? 0xffff00 : color;
	}
	
	public override function contains( x:Float, y:Float ):Bool
	{
		//y = System.window.height - y;
		var v = mesh.worldToLocal( new Vector3( x, y, 0 ) );
		x = v.x;
		y = v.y;		
		return ( 	x > 0 && x < width 
				 && y > 0 && y < height );
	}
	
	function redefineSprite()
	{	
		
		var w = width;
		var h = height;		
		
		//geom.uvsNeedUpdate = true;	
		geom.verticesNeedUpdate = true;

		/*geom.vertices[0].set( -w / 2, h / 2, 0 );
		geom.vertices[1].set( w / 2, h / 2, 0 );
		geom.vertices[2].set( -w / 2, -h / 2, 0 );
		geom.vertices[3].set( w / 2, -h / 2, 0 );*/
		
		// new flipped and top left angle anchored
		geom.vertices[0].set( 0, 0, 0 );
		geom.vertices[1].set( w, 0, 0 );
		geom.vertices[2].set( 0, h, 0 );
		geom.vertices[3].set( w, h, 0 );

		
		
		
		/*uvs[0][0].set( 0, 1 );
		uvs[0][1].set(0, 0 );
		uvs[0][2].set( 1, 1 );
		
		uvs[1][0].set( 0,0 );
		uvs[1][1].set( 1, 0 );
		uvs[1][2].set( 1, 1 );*/
		
	}
	
	override function updateAnchor() 
	{
		mesh.position.x = -anchorX;
		mesh.position.y = -anchorY;
	}
	
	override public function centerAnchor() 
	{
		mesh.position.x = -width/2;
		mesh.position.y = -height/2;
		return this;
	}
	
	override public function onAdded()
	{
		owner.transform.add( mesh );		
	}
	
	override public function onRemoved()
	{ 
		owner.transform.remove( mesh );
	}
	
	function set_width(value:Float):Float 
	{
		width = value;
		redefineSprite();
		return width;
	}
	
	function set_height(value:Float):Float 
	{
		height = value;
		redefineSprite();
		return height;
	}
	
	function set_color(value:Int):Int 
	{
		color = value;
		material.color = new Color( value );
		return color;
	}
	
	override function setPremultipliedAlpha(alpha:Float):Element2D 
	{		
		material.opacity = alpha;
		return this;
	}
	
}