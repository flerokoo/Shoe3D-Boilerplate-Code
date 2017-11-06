package shoe3d.core;
import shoe3d.util.Assert;
import js.three.Camera;
import js.three.OrthographicCamera;
import js.three.Vector3;

/**
 * ...
 * @author as
 */
class UILayer extends Layer
{
	
	override function reconfigureCamera() 
	{
		if ( camera != null ) 
		{
			var cam = cast( camera, OrthographicCamera );
			
			var scale = 0.005;
			scale = 1;
			cam.left = -System.window.width / 2  *  scale;
			cam.right = System.window.width / 2  *  scale;
			cam.top = System.window.height / 2  *  scale;
			cam.bottom = -System.window.height / 2  *  scale;
			cam.far = 1000;
			cam.near = 0.1;
			
			cam.position.set( 0, 0, 600 );
			cam.lookAt( new Vector3(0, 0, 0) );
			cam.updateProjectionMatrix();
			cam.updateMatrix();
		}
	}

	public function new(?name) 
	{
		super(name);
	}
	
	override public function setCamera( cam:Camera )
	{
		#if debug
		Assert.that( Std.is(cam, OrthographicCamera ), "UILayer allows only ortho camera" );
		#end
		
		camera = cam;
		camera.up = new Vector3( 0, 0, 1);
		reconfigureCamera();
		return this;
	}
	
}