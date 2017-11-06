package shoe3d.core;
import ext.RenderStats;
import js.Browser;
import js.html.DivElement;
import shoe3d.screen.ScreenManager;
import shoe3d.util.Log;
import js.three.OrthographicCamera;
import js.three.PerspectiveCamera;
import js.three.WebGLRenderer;

/**
 * ...
 * @author as
 */
@:allow(shoe3d)
class RenderManager
{

	public static var clearColor:Int = 0x3D2E2E;
	public static var container:DivElement;
	public static var renderer:WebGLRenderer;
	
	
	private static var stats:RenderStats;
	
	private static function init() 
	{		
		container = Browser.document.createDivElement();
		container.id = "game";
		Browser.document.body.appendChild( container );			
		
		if( checkWebGLSupport() ) {			
			renderer = new WebGLRenderer({antialias:true});
			renderer.setSize( 800, 600);			
			container.appendChild( renderer.domElement );
			renderer.autoClear = false;	
			return true;
		} else {
			throw 'WebGL is not supported';
			return false;
		}
	
		
	}
	
	static public function checkWebGLSupport():Bool
	{
		if ( ! Reflect.hasField( Browser.window, "WebGLRenderingContext" ) ) {
			showMessage('Your browser is not supported. <br/>Please, try with another one.<br/><a href="http://get.webgl.org">More info</a>');
			return false;
		} else {
			var canv = Browser.document.createCanvasElement();
			var cont = canv.getContext("webgl");
			
			if ( cont == null ) cont = canv.getContext("experimental-webgl");
						
			if ( cont == null ) {
				showMessage('Ooops, something wrong with your browser.<br/><a href="http://get.webgl.org/troubleshooting">More info</a>');
				return false;
			} else {
				return true;
			}
		}
	}
	
	static function showMessage(text:String) {
		var element = Browser.document.createDivElement();
		element.id = 'webgl-error-message';
		element.style.fontFamily = 'monospace';
		element.style.fontSize = '13px';
		element.style.fontWeight = 'normal';
		element.style.textAlign = 'center';
		element.style.background = '#fff';
		element.style.color = '#000';
		element.style.padding = '1.5em';
		element.style.width = '100%';
		element.style.height = '100%';
		element.style.margin = '0';
		element.style.position = "absolute";
		element.style.backgroundColor = "#ADA7A7";
		element.style.color = "#3C2626";
		element.innerHTML = text;
		Browser.document.body.appendChild( element );		
		
	}
	
	
	private static function render() 
	{		
		renderer.setClearColor(clearColor);
		renderer.clear( );
		if ( System.screen._currentScreen != null  ) {
			if( System.screen._currentScreen.layers != null )
				for ( layer in System.screen._currentScreen.layers )
					if( layer.visible ) layer.render( renderer );
					//if( layer.camera != null /*&& layer.visible*/ )
						//renderer.render( layer, layer.camera );
		}
		if ( stats != null ) stats.update( renderer );		
	}
	
	public static function showStats()
	{
		if ( stats == null ) 
		{
			stats = new RenderStats();
			stats.domElement.style.position = "absolute";
			stats.domElement.style.left = "0px";
			stats.domElement.style.bottom = "0px";						
		}		
		Browser.document.body.appendChild( stats.domElement );
	}
	
}