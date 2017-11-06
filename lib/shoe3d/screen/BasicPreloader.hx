package shoe3d.screen;
import shoe3d.asset.AssetPack;
import shoe3d.component.AutoPosition;
import shoe3d.component.FillSprite;
import shoe3d.core.game.GameObject;
import shoe3d.core.Layer2D;
import shoe3d.System;
import shoe3d.util.promise.Promise;
import shoe3d.util.Value;

/**
 * ...
 * @author as
 */
class BasicPreloader extends GameScreen
{
	
	public static var WIDTH_PERCENT = 1 / 3;
	public static var HEIGHT = 5;
	
	static var progress:Value<Float>;
	var layer:Layer2D;
	static var loading = false;
	@:keep
	public function new() 
	{
		super();		
		layer = newLayer2D("main", true );
		var spr = new FillSprite( 0, HEIGHT, 0xEB9C25 );
		var go = new GameObject().add( spr );
		var spr2 =  new FillSprite( 0, HEIGHT, 0x964910 );
		var go2 = new GameObject().add( spr2 );
		
		layer.addChild( go2 );
		layer.addChild( go );
		
		init();
		progress.change.connect( function ( n, p) {
			n = Math.max(n, p);
			spr.owner.transform.position.set( (1-WIDTH_PERCENT)/2 * System.window.width , System.window.height / 2, 0 );
			spr.width = n * System.window.width * WIDTH_PERCENT;
			spr2.owner.transform.position.set( (1-WIDTH_PERCENT)/2 * System.window.width , System.window.height / 2, 0 );
			spr2.width = System.window.width * WIDTH_PERCENT;
		} );
	}
	
	static function init()
	{
		if ( progress == null ) {
			progress = new Value(0.0);
		}
	}
	
	public static function loadFolderFromAssets( folder:String, onSuccess:AssetPack->Void, ?registerThisPackWithName:String ):Promise<AssetPack>
	{
		if ( loading ) throw 'Can not load more that one asset pack at time';
		
		System.screen.addScreen( 'basic_preloader', BasicPreloader );
		System.screen.show( 'basic_preloader' );
		init();
		progress._ = 0;
		loading = true;
		
		return System.loadFolderFromAssets(
			folder, 
			function(a:AssetPack) {
				loading = false;
				onSuccess(a);
			},
			function( p:Float ) progress._ = p , 
			registerThisPackWithName);
		
	}

	
}