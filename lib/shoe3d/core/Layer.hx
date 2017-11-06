package shoe3d.core;


import shoe3d.core.game.GameObject;
import shoe3d.util.Value;
import js.three.Camera;
import js.three.OrthographicCamera;
import js.three.PerspectiveCamera;
import js.three.Renderer;
import js.three.Scene;
import js.three.Vector3;
import js.three.WebGLRenderer;

/**
 * ...
 * @author as
 */
class Layer implements GameObjectContainer
{
	public var name:String;
	public var scene(default,null):Scene;
	public var camera(default, null):Camera;
	public var children(default, null):Array<GameObject>;
	public var visible:Bool = true;	
	public var fov(default, null):Value<Float>;
	public var clearDepthBeforeRender:Bool = false;
	
	public function new( ?name:String ) 
	{
		this.name = name;
		scene = new Scene();
		children = [];
		fov = new Value(70.0);
		
		var changeFn = function(a, b) reconfigureCamera();
		
		fov.change.connect( changeFn );
		
		System.window._prePublicResize.connect( reconfigureCamera );
	}
	
	function reconfigureCamera() 
	{
		if ( camera != null ) 
		{
			if ( Std.is( camera, PerspectiveCamera ) )
			{
				var pc = cast(camera, PerspectiveCamera);
				pc.fov = fov._;
				pc.aspect = System.window.width / System.window.height;
				pc.updateProjectionMatrix();
			}
			else if ( Std.is(camera, OrthographicCamera ) ) 
			{
				var cam = cast(camera, OrthographicCamera);
				cam.left = 0;
				cam.right = System.window.width;
				cam.top = 0;
				cam.bottom = System.window.height;
				cam.updateProjectionMatrix();
				
			}
		}
	}
	
	public function addChild( child:GameObject ) 
	{
		children.push( child );
		child.setLayerReferenceRecursive( this );
		scene.add( child.transform );
		return this;
	}
	
	public function removeChild( child:GameObject ) 
	{
		children.remove( child );
		child.setLayerReferenceRecursive( null );
		scene.remove( child.transform );
		return this;
	}
	
	public function setCamera( cam:Camera )
	{
		camera = cam;
		if( camera != null ) camera.up = new Vector3( 0, 1, 0);
		reconfigureCamera();
		return this;
	}
	
	public function addPerspectiveCamera():PerspectiveCamera
	{
		var pc = new PerspectiveCamera( 70, 1, .5, 1000 );
		setCamera( pc );
		return pc;
	}

	public function addOrthoCamera():OrthographicCamera
	{
		var pc = new OrthographicCamera( 1, 1, 1, 1, 0.1, 5000 );
		setCamera( pc );
		return pc;
	}
	
	public function render( renderer:WebGLRenderer)
	{
		if ( camera == null ) return;
		renderer.sortObjects = false;
		if ( clearDepthBeforeRender ) renderer.clearDepth();
		renderer.render( scene, camera );
	}
	
	public function find( name:String, maxDepth = -1 ):GameObject {
		return GameObject.findInContainer( this, name, maxDepth );
	}
	

}