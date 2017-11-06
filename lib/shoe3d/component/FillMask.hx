package shoe3d.component;
import motion.Actuate;
import motion.easing.Linear;
import motion.easing.Quad;
import shoe3d.component.FillSprite;
import shoe3d.core.game.Component;
import shoe3d.System;
import shoe3d.util.Disposable;
import shoe3d.util.signal.SingleSignal;

/**
 * ...
 * @author as
 */
class FillMask extends Component
{
	public var sprite:FillSprite;
	public var actionComplete:SingleSignal<Float>;
	public var conn:Disposable;
	
	public function new( clr:Int  = 0xffffff) 
	{
		super();
		sprite = new FillSprite( 0, 0, clr );
		actionComplete = new SingleSignal();
	}
	
	override public function onAdded() 
	{
		super.onAdded();
		owner.add( sprite );
		reoverlay();
		conn = System.window.resize.connect( reoverlay );
	}
	
	override public function onRemoved() 
	{
		super.onRemoved();
		owner.remove(sprite);
		if ( conn != null ) conn.dispose();
		conn = null;
	}
	
	public function fadeIn( duration:Float = 0.3 ) {
		sprite.alpha._ = 0;
		Actuate.tween( sprite.alpha, duration, { _: 1 } ).ease(Quad.easeIn).onComplete( function() actionComplete.emit( sprite.alpha._ ) );
		return this;
	}
	
	
	public function fadeOut( duration:Float = 0.3 ) {
		sprite.alpha._ = 1;
		Actuate.tween( sprite.alpha, duration, { _: 0 } ).ease(Quad.easeIn).onComplete( function() actionComplete.emit( sprite.alpha._ ) );
		return this;
	}
	
	public function fadeTo( to:Float, duration:Float = 0.3 ) {
		Actuate.tween( sprite.alpha, duration, { _: to } ).ease(Quad.easeIn).onComplete( function() actionComplete.emit( sprite.alpha._ ) );
		return this;
	}
	
	public function fadeFromTo( from:Float, to:Float, duration:Float = 0.3 ) {
		sprite.alpha._ = from;		
		Actuate.tween( sprite.alpha, duration, { _: to } ).ease(Quad.easeIn).onComplete( function() actionComplete.emit( sprite.alpha._ ) );
		return this;
	}
	
	public function setInstant( to:Float ) {
		sprite.alpha._ = to;
		return this;
	}
	
	public function reoverlay() {
		sprite.width = System.window.width;
		sprite.height = System.window.height;
		return this;
	}
	
	public function transition( fn:Void->Void, inDuration:Float = 0.3, outDuration:Float = 0.3 ) {
		sprite.alpha._ = 0;
		Actuate.tween( sprite.alpha, inDuration, { _: 1 } )
			.ease(Quad.easeIn)
			.onComplete( function() {
				fn();
				Actuate.tween( sprite.alpha, outDuration, { _: 0 } )
					.ease(Quad.easeIn)
					.onComplete( function() actionComplete.emit( sprite.alpha._ ) );
			} );
			
		return this;
	}
}