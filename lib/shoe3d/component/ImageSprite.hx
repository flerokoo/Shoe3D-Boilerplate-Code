package shoe3d.component;
import shoe3d.asset.AssetPack.TexDef;
import shoe3d.asset.Assets;
import shoe3d.util.Assert;
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
class ImageSprite extends Element2D
{
	var mesh:Mesh;
	var geom:Geometry;
	var texDef:TexDef;
	var material:MeshBasicMaterial;


	public function new( textureName:String ) 
	{
		super();
		
		texDef = Assets.getTexDef( textureName );
		geom = new PlaneGeometry(0, 0, 1, 1);
		material = new MeshBasicMaterial( { transparent: true, side: js.Three.DoubleSide, depthTest: false, depthWrite: false } );	
		mesh = new Mesh( geom, material );		
		redefineSprite();			
	}
	
	function redefineSprite()
	{	
		if ( texDef == null ) return;
		
		var w = texDef.width;
		var h = texDef.height;
		var uv = texDef.uv;
		
		
		
		geom.uvsNeedUpdate = true;	
		geom.verticesNeedUpdate = true;
		
		/*geom.vertices[0].set( -w / 2, h / 2, 0 );
		geom.vertices[1].set( w / 2, h / 2, 0 );
		geom.vertices[2].set( -w / 2, -h / 2, 0 );
		geom.vertices[3].set( w / 2, -h / 2, 0 );
		
		var uvs = geom.faceVertexUvs[0];
		uvs[0][0].set( uv.umin, uv.vmax );
		uvs[0][1].set( uv.umin, uv.vmin );
		uvs[0][2].set( uv.umax, uv.vmax );
		
		uvs[1][0].set( uv.umin, uv.vmin );
		uvs[1][1].set( uv.umax, uv.vmin );
		uvs[1][2].set( uv.umax, uv.vmax );*/
		
		// flipped
		
		geom.vertices[0].set( 0, 0, 0 );
		geom.vertices[1].set( w, 0, 0 );
		geom.vertices[2].set( 0, h, 0 );
		geom.vertices[3].set( w, h, 0 );
		
		// scheme
		// | 2   3 |
		// |   \   |
		// | 0   1 |
		// faces 0-2-1  2-3-1

		var uvs = geom.faceVertexUvs[0];
		uvs[0][0].set( uv.umin, uv.vmax );
		uvs[0][1].set( uv.umin, uv.vmin );
		uvs[0][2].set( uv.umax, uv.vmax );
		
		uvs[1][0].set( uv.umin, uv.vmin );
		uvs[1][1].set( uv.umax, uv.vmin );
		uvs[1][2].set( uv.umax, uv.vmax );
		
		
		material.map = texDef.texture;
	}
	
	public function setTexture( tex:TexDef ) 
	{
		Assert.that(tex != null, "Texture is null" );
		texDef = tex;
		redefineSprite();
	}
	
	override function updateAnchor() 
	{
		mesh.position.x = -anchorX;
		mesh.position.y = -anchorY;
	}
	
	override public function centerAnchor() 
	{
		mesh.position.x = -texDef.width/2;
		mesh.position.y = -texDef.height/2;
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
		
	public override function contains( x:Float, y:Float ):Bool
	{
		if ( texDef == null ) return false;
		//y = System.window.height - y;
		var v = mesh.worldToLocal( new Vector3( x, y, 0 ) );
		x = v.x;
		y = v.y;		
		/*return ( 	texDef.width * 0.5 >= SMath.fabs(x) &&
					texDef.height * 0.5 >= SMath.fabs(y) );*/
		return ( 	x > 0 && x < texDef.width 
				 && y > 0 && y < texDef.height );
	}
	
	override function setLevel( level:Float ):Element2D
	{
		mesh.renderOrder = level;
		return this;
	}
	
	override function setPremultipliedAlpha( alpha:Float ):Element2D
	{
		material.opacity = alpha;
		return this;
	}
}