package shoe3d.component.script.action;
import soundjs.SoundManager;

/**
 * ...
 * @author as
 */
class PlaySound implements Action
{

    var _delay:Float = 0.0;
    var _cur:Float = 0;
    var _name:String;
    var _props:Dynamic;

    /**
     *
     * @param	name
     * @param	props Props as for SoundManager.play(...)
     * @param	delay Delay, after which action considered completed
     */
    public function new( name:String, ?props:Dynamic, delay:Float = 0 )
    {
        _delay = delay;
        _name = name;
        _props = props;
    }

    public function start()
    {
        _cur = _delay;
        SoundManager.play( _name, _props );
    }

    public function update(dt:Float )
    {
        _cur -= dt;
        return _cur <= 0;
    }

}