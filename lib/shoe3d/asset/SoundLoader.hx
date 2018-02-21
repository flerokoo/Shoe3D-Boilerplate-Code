package shoe3d.asset;
import haxe.Timer;
import js.Browser;
import shoe3d.sound.Sound;
import shoe3d.util.Tools;
import soundjs.SoundManager;
import js.three.Loader;
import js.three.LoadingManager;
import js.Three;
import js.three.FileLoader;

/**
 * ...
 * @author as
 */
class SoundLoader extends Loader
{

    var _loader:FileLoader;
    var _manager:LoadingManager;
    var _url:String;
    var _pack:AssetPack;
    var _id:String;
    var _loaded = false;
    var _listener:Dynamic = null;
    public function new( manager:LoadingManager)
    {
        super();
        _manager = manager;
    }

    public function load( url:String, id:String, pack:AssetPack) : Void
    {
        _pack = pack;
        _url = url;
        _manager.itemStart( _url );
        _id = id;
        _listener = SoundManager.on("fileload", onLoad );
        SoundManager.registerSound( url, id );
    }

    private function onLoad( evt )
    {
        // TODO Redo sound registration in pack
        // (Why id to url map?)
        if ( evt.src.indexOf( _id ) >= 0 )
        {
            _pack._soundMap.set( _id, _url );
            _manager.itemEnd(_url);
            SoundManager.off( "fileload", _listener );
        }
    }

}