package shoe3d.component;
import js.html.Element;
import shoe3d.core.game.Component;
import shoe3d.core.input.PointerEvent;
import shoe3d.util.SMath;
import soundjs.SoundManager;

/**
 * ...
 * @author as
 */
class ScaleButton extends Component
{

    var target:Element2D;
    var startScale = 0;
    var activeStateScale = 0.9;
    var isDown = false;
    var fn:PointerEvent->Void = null;
    var targetScale = 1.0;

    var downSound:String;
    var upSound:String;

    public static var defaultDownSound:String;
    public static var defaultUpSound:String;
    public static var defaultSoundVolume:Float = 1;

    public var active:Bool = true;
    public var defaultSoundsDisabled:Bool = false;

    public function new( ?fn:PointerEvent->Void, activeStateScale = 0.9 )
    {
        super();
        this.activeStateScale = activeStateScale;
        this.fn = fn;
    }

    override public function onAdded()
    {
        target = owner.get(Element2D);
        target.pointerDown.connect( down );
        target.pointerUp.connect( up );
        target.pointerOut.connect( out );
    }

    function down( e:PointerEvent )
    {
        if ( downSound != null  )
        {
            SoundManager.play( downSound )
        }
        else if ( defaultDownSound != null  && ! defaultSoundsDisabled)
        {
            System.sound.play( defaultDownSound, defaultSoundVolume );
        }
        isDown = true;
        targetScale = activeStateScale;
        e.stopPropagation();
        //Actuate.tween( owner.transform.scale, 0.18, { x: activeStateScale, y:activeStateScale } ).ease( Quad.easeOut );
    }

    override public function onUpdate()
    {
        if ( owner.transform.scale.x != targetScale )
            owner.transform.scale.x = owner.transform.scale.y = SMath.lerp( 0.3, owner.transform.scale.x, targetScale );
    }

    function up( e:PointerEvent )
    {
        if ( isDown )
        {
            if ( upSound != null )
            {
                SoundManager.play( upSound )
            }
            else if ( defaultUpSound != null && ! defaultSoundsDisabled )
            {
                System.sound.play(defaultUpSound, defaultSoundVolume);
            }
            isDown = false;
            if ( fn != null) fn(e);
            //Actuate.tween( owner.transform.scale, 0.18, { x: 1, y:1 } ).ease( Quad.easeOut );
            targetScale = 1;
            e.stopPropagation();
        }
    }

    function out( e:PointerEvent )
    {
        if ( isDown )
        {
            if ( upSound != null ) SoundManager.play( upSound );
            //Actuate.tween( owner.transform.scale, 0.18, { x: 1, y:1 } ).ease( Quad.easeOut );
            targetScale = 1;
        }
    }

    override public function onRemoved()
    {

    }

    public function setSounds( ?dwn:String, ?up:String )
    {
        downSound = dwn;
        upSound = up;
        disableDefaultSounds();
        return this;
    }

    public static function setDefaultSounds( ?dwn:String, ?up:String )
    {
        defaultDownSound = dwn;
        defaultUpSound = up;
    }

    public function disableDefaultSounds()
    {
        defaultSoundsDisabled = true;
        return this;
    }

}