package shoe3d.component;
import js.html.Float32Array;
import js.html.ImageElement;
import shoe3d.core.game.Component;
import js.three.BufferAttribute;
import js.three.ImageLoader;
import js.three.ImageUtils;
import js.three.LoadingManager;
import js.three.Mapping;
import js.three.Sprite;
import js.three.SpriteMaterial;
import js.three.Texture;
import js.three.TextureLoader;

/**
 * ...
 * @author as
 */
class S3Sprite extends Component
{

	public var sprite:Sprite;
	
	public function new( ?mat:SpriteMaterial ) 
	{
		super();
		
		//var tex = ImageUtils.loadTexture( 'assets/button1.png' );
		//mat = new SpriteMaterial( {map:tex} );
		
		var mgr = new LoadingManager();
		var l = new TextureLoader( mgr );
		l.load( 'assets/button1.png', function( tex ) {
				
			sprite = new Sprite( new SpriteMaterial({ map: tex }) );
			if ( owner != null ) {
				trace('addFrom');
				owner.transform.add( sprite );
				trace( cast(sprite.material.map.image, ImageElement).width );
			}
			sprite.scale.set( 256, 256 , 1);
			var spr = sprite;
			untyped __js__('spr.geometry.getAttribute("uv").dynamic = true;');
			sprite.geometry.getAttribute("uv").array = [[0.5, 0.5, 1, 0.5, 1, 1, 0, 1]];
			sprite.geometry.addAttribute("uv", new BufferAttribute( new Float32Array([0.5, 0.5, 1, 0.5, 1, 1, 0, 1]), 2) );
			
			trace(sprite.geometry.getAttribute("uv") );
			
		} );
		
		
		//sprite = new Sprite( mat );
		
	}
	
	
	
	override public function onAdded()
	{
		if ( sprite != null ) {
			owner.transform.add( sprite );
			trace( sprite.material.map.image );
		}
	}
	
}