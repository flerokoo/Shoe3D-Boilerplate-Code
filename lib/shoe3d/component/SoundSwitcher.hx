package shoe3d.component;
import shoe3d.core.game.Component;

/**
 * ...
 * @author as
 */
class SoundSwitcher extends Component
{

	public var onAlpha:Float = 1;
	public var offAlpha:Float = .5;
	
	public function new( ) {
		super();
	}
	
	override public function onAdded() {
		owner.add( new ScaleButton( switchSound) );
	}
	
	public function switchSound(?e) {
		System.sound.muted._ = !System.sound.muted._;
		owner.get(Element2D).setAlpha( System.sound.muted._ ? offAlpha : onAlpha );
	}
	
	override public function dispose() {
		super.dispose();
	}
}