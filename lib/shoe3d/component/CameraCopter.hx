package shoe3d.component;
import shoe3d.core.game.Component;
import shoe3d.core.input.Key;
import shoe3d.core.input.KeyCodes;
import shoe3d.core.input.MouseEvent.MouseButton;
import shoe3d.core.input.PointerEvent;
import shoe3d.util.Assert;
import shoe3d.util.Log;
import js.three.Camera;
import js.three.Vector3;

/**
 * ...
 * @author as
 */
class CameraCopter extends Component
{

	public var camera:Camera;
	public var speedMultiplier:Float;
	
	var _goForward:Bool = false;
	
	public function new( cam:Camera, speedMul:Float = 1, allowMouse:Bool = true ) 
	{
		super();
		
		Assert.that(cam != null, "Camera shouldn't be null" );
		camera = cam;
		speedMultiplier = speedMul;
		
		if ( allowMouse ) {
			var prevPoint:Vector3 = null;
			
			System.input.pointer.down.connect( function(e) {
				//prevPoint = new Vector3( e.viewX, e.viewY );
				switch( e.source ) {
					case Mouse(e):
						switch( e.button ) {
							case Left:
								prevPoint = new Vector3( e.viewX, e.viewY );
							case Right:
								_goForward = true;
							default:
								return;
						}
					default:
						return;
				}
			} );
			
			System.input.pointer.move.connect( function(e) {
				
				if ( prevPoint != null ) {
					var newPount = new Vector3( e.viewX, e.viewY );
					
					var dx = newPount.x - prevPoint.x;
					var dy = newPount.y - prevPoint.y;
					
					var vert = camera.worldToLocal( untyped camera.position.clone().add( new Vector3(0, 1, 0) ) );
					
					
					camera.rotateX( -dy/300 * Math.PI/2 );
					camera.rotateOnAxis( vert, -dx/300 * Math.PI/2 );
					
					prevPoint = newPount;
				}
			});
			
			System.input.pointer.up.connect( function(e) {
				//prevPoint = null;
				switch( e.source ) {
					case Mouse(e):
						switch( e.button ) {
							case Left:
								prevPoint = null;
							case Right:
								_goForward = false;
							default:
								return;
						}
					default:
						return;
				}
			});
			
			System.input.mouse.scroll.connect( function(t) {
				camera.translateZ( -t * 0.3 );
			});
		}
		
	}
	
	override public function onUpdate() 
	{
		if ( System.input.keyboard.isDown( Numpad4 ) )
			camera.translateX( -0.1 * speedMultiplier );
				
		if ( System.input.keyboard.isDown( Numpad6 ) )
			camera.translateX( 0.1 * speedMultiplier );
				
		if ( System.input.keyboard.isDown( Numpad8 ) )
			camera.translateZ( -0.1 * speedMultiplier );
				
		if ( System.input.keyboard.isDown( Numpad5 ) )
			camera.translateZ( 0.1 * speedMultiplier );
				
		if ( System.input.keyboard.isDown( NumpadAdd ) )
			camera.translateY( -0.1 * speedMultiplier );
				
		if ( System.input.keyboard.isDown( NumpadSubtract ) )
			camera.translateY( 0.1 * speedMultiplier );
				
		if ( System.input.keyboard.isDown( Numpad7 ) )
			camera.rotateY( Math.PI * 0.01 );
			
		if ( System.input.keyboard.isDown( Numpad9 ) )
			camera.rotateY( -Math.PI * 0.01 );
			
		var speed = System.input.keyboard.isDown(Shift) ? 3 : 1;	
			
		if ( System.input.keyboard.isDown( A ) )
			camera.translateX( -0.1 * speedMultiplier * speed );
				
		if ( System.input.keyboard.isDown( D ) )
			camera.translateX( 0.1 * speedMultiplier * speed );
				
		if ( System.input.keyboard.isDown( W ) || _goForward)
			camera.translateZ( -0.1 * speedMultiplier * speed );
				
		if ( System.input.keyboard.isDown( S ) )
			camera.translateZ( 0.1 * speedMultiplier * speed );	
			
		if ( System.input.keyboard.isDown( Q ) )
			camera.rotateZ( 0.02 * speedMultiplier );		
		
		if ( System.input.keyboard.isDown( E ) )
			camera.rotateZ( -0.02 * speedMultiplier );		
			
			
			
		camera.matrixAutoUpdate = true;
	}
	
}