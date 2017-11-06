package shoe3d.component;
import shoe3d.core.game.Component;
import shoe3d.util.Disposable;

/**
 * ...
 * @author as
 */
class FillSpriteStretcher extends Component
{

	var disp:Disposable;
	
	public function new() 	{
		super();
	}
	
	override public function onAdded() 	{
		super.onAdded();
		disp = System.window.resize.connect( stretch );
		stretch();
	}
	
	function stretch() {
		var fs = owner.get(FillSprite);
		if ( fs != null ) {
			fs.width = System.window.width;
			fs.height = System.window.height;
		}
	}
	
	override public function onRemoved() {
		super.onRemoved();
		if ( disp != null ) disp.dispose();
		disp = null;
	}
	
}