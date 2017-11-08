package shoe3d.screen;
import js.html.Screen;
import shoe3d.component.CameraHolder;
import shoe3d.core.game.GameObject;
import shoe3d.core.Layer;
import shoe3d.core.Layer2D;
import shoe3d.util.Assert;
import js.three.Object3D;
import js.three.PerspectiveCamera;
import js.three.Scene;

/**
 * ...
 * @author as
 */
@:allow("shoe3d")
@:keepSub
class GameScreen
{	
	public var layers(default,null):Array<Layer>;
		
	public function new() 
	{
		layers = [];		
	}	
	
	public function onUpdate()
	{
		
	}
	
	public function onCreate() 
	{
		
	}	
	
	public function onShow() 
	{
		
	}
	
	public function onHide() 
	{
		
	}
	
	public function addLayer( lr:Layer ) 
	{
		#if debug
		Assert.that( layers.indexOf( lr ) < 0, "Layer(${scr.name}) is already on the scene" );
		#end
		layers.push( lr );
		return this;
	}
	
	public function getLayer( name:String ):Layer
	{
		for ( i in layers ) 
			if ( i.name == name )
				return i;
		return null;
	}
	
	public function newLayer( ?name:String ):Layer
	{
		var layer = new Layer( name );
		layer.addPerspectiveCamera();
		addLayer( layer );
		return layer;
	}
	
	public function newLayer2D( ?name:String, pointerEnabled:Bool = false ):Layer2D
	{
		var layer = new Layer2D( name );
		layer.addOrthoCamera();
		layer.pointerEnabled = pointerEnabled;
		addLayer( layer );
		return layer;
	}
	
}