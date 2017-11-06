package shoe3d.component.substate;
import shoe3d.component.Element2D;
import shoe3d.core.game.Component;
import shoe3d.core.game.GameObject;
import shoe3d.util.Assert;
import shoe3d.util.signal.DoubleSignal;
import shoe3d.util.signal.SingleSignal;

/**
 * ...
 * @author as
 */
class SubstateManager extends Component
{
	
	/*
	 * This class is designed to manage substates of game
	 * Like MainMenu changes to GameMenu without changing curent GameScreen
	 * or you can use it for submenus (like pause/ingame-shop/gameOver submenu 
	 * You can even use more than one SubstateManagers in one game
	 */ 


	public var substates(default, null):Map<String,Substate>;
	public var currentSubstate(default, null):Substate = null;	
	public var currentSubstateName(default, null):String = '';
	public var onShow(default, null):SingleSignal<String>;
	
	
	var _waitingSubstateToHide:Bool = false;
	var _showSubstateAfterCurrentSubstateHide:String = null;
	
	public function new() 
	{
		super();
		substates = new Map();
		onShow = new SingleSignal();
	}
	
	public function addSubstate( sub:Substate, name:String )
	{
		Assert.that( substates[name] == null );
		Assert.that( sub != null );
		Assert.that( name != null );
		
		// create owner gameobject if none
		if ( sub.owner == null ) new GameObject("substate_root_" + name).add( sub );
		
		// this element2d will be used to disable pointer when changin state
		var e = sub.owner.get( Element2D );
		if ( e == null ) {
			e = new Element2D();
			sub.owner.add( e );
		}
		e.pointerEnabled = false;		
		
		substates[name.toLowerCase()] = sub;
		return this;		
	}
	
	public function show( name:String ) 
	{
		var sub = substates.get(name.toLowerCase());
		Assert.that( sub != null );
		
		if ( currentSubstate != null ) {						
			if ( _waitingSubstateToHide ) {
				_showSubstateAfterCurrentSubstateHide = name;
			} else if ( currentSubstate.hidableByOtherSubstate ) {
				_showSubstateAfterCurrentSubstateHide = name;
				hide();				
			} 
			return;
		} else {			
			owner.addChild( sub.owner );
			sub.onShow();
			onShow.emit( name );
			currentSubstateName = name;
			sub.owner.get(Element2D).pointerEnabled = true;
			currentSubstate = sub;
		}
	}
	
	public function hide()
	{
		if ( currentSubstate == null ) return;
		_waitingSubstateToHide = true;
		currentSubstate.owner.get(Element2D).pointerEnabled = false;
		currentSubstate.onHide( hideCallback );	
	}
	
	public function hideInstant()
	{
		if ( currentSubstate == null ) return;
		_waitingSubstateToHide = false;
		currentSubstate.owner.get(Element2D).pointerEnabled = false;
		owner.removeChild( currentSubstate.owner );		
		currentSubstate = null;
		currentSubstateName = '';
		_waitingSubstateToHide = false;
	}
	
	function hideCallback()
	{
		owner.removeChild( currentSubstate.owner );		
		currentSubstate = null;
		_waitingSubstateToHide = false;
		currentSubstateName = '';
		
		if ( _showSubstateAfterCurrentSubstateHide != null ) {
			show( _showSubstateAfterCurrentSubstateHide );
			_showSubstateAfterCurrentSubstateHide = null;
		}
	}
	
}