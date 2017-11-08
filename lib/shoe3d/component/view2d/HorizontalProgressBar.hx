package shoe3d.component.view2d;
import shoe3d.util.signal.DoubleSignal;
import shoe3d.util.SMath;
import shoe3d.util.Value;
import js.three.Vector3;

/**
 * ...
 * @author as
 */
class ProgressBar extends ImageSprite
{
	public var progressChange(get, null):DoubleSignal<Float,Float>;	
	
	
	public var progress(default, set):Float = 1;
	
	public function new( textureName:String ) 
	{
		super( textureName );
	}
	
	function get_progressChange():DoubleSignal<Float, Float> 
	{
		if ( progressChange == null ) progressChange = new DoubleSignal();
		return progressChange;
	}	
	
	override function redefineSprite()
	{	
		if ( texDef == null ) return;
		
		var w = texDef.width;
		var h = texDef.height;
		var uv = texDef.uv;
		
		
		
		geom.uvsNeedUpdate = true;	
		geom.verticesNeedUpdate = true;
		
		/*geom.vertices = [
			new Vector3( -w/2, h/2 ),
			new Vector3( w/2, h/2 ),
			new Vector3( -w/2, -h/2 ),
			new Vector3( w/2, -h/2 )
		];
		
		geom.faceVertexUvs = [[
			[
				new Vector2( uv.umin, uv.vmax ),
				new Vector2( uv.umin, uv.vmin ),
				new Vector2( uv.umax, uv.vmax )
			],
			[
				new Vector2( uv.umin, uv.vmin ),
				new Vector2( uv.umax, uv.vmin ),
				new Vector2( uv.umax, uv.vmax )
			]
		]];		*/
		
		geom.vertices[0].set( 0, 0, 0 );
		geom.vertices[1].set( progress * w, 0, 0 );
		geom.vertices[2].set( 0, h, 0 );
		geom.vertices[3].set( progress * w, h, 0 );
		
		
		var uvs = geom.faceVertexUvs[0];
		uvs[0][0].set( uv.umin, uv.vmax );
		uvs[0][1].set( uv.umin, uv.vmin );
		uvs[0][2].set( SMath.lerp( progress, uv.umin, uv.umax), uv.vmax );
		
		uvs[1][0].set( uv.umin, uv.vmin );
		uvs[1][1].set( SMath.lerp( progress, uv.umin, uv.umax), uv.vmin );
		uvs[1][2].set( SMath.lerp( progress, uv.umin, uv.umax), uv.vmax );
		
		material.map = texDef.texture;
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
	
	function set_progress(value:Float):Float 
	{		
		var newValue = SMath.clamp01(value);
		if ( newValue != progress && progressChange != null ) 
		{
			var oldValue = progress;
			progress = newValue;
			progressChange.emit( newValue, oldValue ); 
			redefineSprite();
		}
		return progress;
	}
	
	public function setProgress( v:Float )
	{
		progress = v;
		return this;
	}
	
	public override function contains( x:Float, y:Float ):Bool
	{
		if ( texDef == null ) return false;
		y = System.window.height - y;
		var v = mesh.worldToLocal( new Vector3( x, y, 0 ) );
		x = v.x;
		y = v.y;		
		/*return ( 	x > -texDef.width / 2 && 
					x < SMath.lerp( progress, -texDef.width/2, texDef.width/2 ) &&
					texDef.height * 0.5 >= SMath.fabs(y) );*/
		return ( 	x > 0 && x < texDef.width*progress 
				 && y > 0 && y < texDef.height );
	}
}