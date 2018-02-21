package shoe3d.asset;
import js.Three;
import js.three.*;
/**
 * ...
 * @author as
 */
class AtlasLoader extends Loader
{

    var _loader:FileLoader;
    var _manager:LoadingManager;
    var _jsonUrl:String;
    var _imageUrl:String;
    var _pack:AssetPack;
    var _id:String;
    var _loaded = false;
    var _tex:Texture;
    var _json:String;

    public function new( manager:LoadingManager)
    {
        super();
        _manager = manager;
    }

    public function load( jsonUrl:String, imageUrl:String, id:String, pack:AssetPack, onError:js.html.ErrorEvent->Void ) : Void
    {
        _pack = pack;
        _jsonUrl = jsonUrl;
        _imageUrl = imageUrl;
        _manager.itemStart( jsonUrl );
        _manager.itemStart( imageUrl );
        _id = id;

        new TextureLoader().load( imageUrl, onTextureLoad, null, onError );
        new FileLoader().load( jsonUrl, onJsonLoad, null, onError );

    }

    function onTextureLoad( tex:Texture )
    {
        _tex = tex;
        tryFinish();
        _manager.itemEnd( _imageUrl );
    }

    function onJsonLoad( data:String )
    {
        _json = data;
        tryFinish();
        _manager.itemEnd( _jsonUrl );

    }

    function tryFinish()
    {
        if ( _json != null && _tex != null )
        {
            var atlas = new Atlas( shoe3d.asset.AssetPackLoader.wrapTexDef(_tex), _json );
            _pack._atlasMap.set( _id, atlas );
        }
    }

}