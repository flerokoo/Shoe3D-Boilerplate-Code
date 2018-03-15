package shoe3d.asset;
import shoe3d.asset.AssetPack.TexDef;
import shoe3d.util.Disposable;
import shoe3d.util.Assert;
import shoe3d.util.Log;
import shoe3d.util.UVTools;
import soundjs.SoundManager;
import shoe3d.util.UVTools.UV;
import js.three.Vector2;
import js.three.Geometry;
import js.three.BufferGeometry;
import js.three.Object3D;
import js.three.Texture;
import js.three.Material;
import js.three.MeshPhongMaterial;
import js.three.Mesh;

@:allow(shoe3d)
class AssetPack implements Disposable 
{
    private var _texMap:Map<String,TexDef>;
    private var _fileMap:Map<String,File>;
    private var _geomMap:Map<String,Geometry>;
    private var _bufGeomMap:Map<String,BufferGeometry>;
    private var _soundMap:Map<String,String>; // map just to check if sound belongs to this asset pack
    private var _atlasMap:Map<String,Atlas>;
    private var _fontMap:Map<String,Font>;
    private var _objectMap:Map<String,Object3D>;

    public function new()
    {
        _texMap = new Map();
        _fileMap = new Map();
        _soundMap = new Map();
        _geomMap = new Map();
        _bufGeomMap = new Map();
        _atlasMap = new Map();
        _objectMap = new Map();
    }

    public function getAtlas (name:String, required:Bool = true)
    {
        if (! _atlasMap.exists(name) && required) throw 'No atlas with name=$name';
        return _atlasMap.get(name);
    }

    public function defineAtlas (name:String, texName:String, jsonName:String):Atlas
    {
        if ( ! _texMap.exists( texName ) || ! _fileMap.exists(jsonName ) ) throw 'No image or json from atlas $name';
        var atlas = new Atlas( getTexDef(texName), getFile(jsonName).content );
        _atlasMap.set( name, atlas );
        return atlas;
    }

    public function createFont (name:String):Font
    {
        if ( _fontMap == null ) _fontMap = new Map();
        if ( ! _fileMap.exists(name) ) throw 'No file $name';

        var font = new Font( name, this  );
        _fontMap.set( name, font );
        return font;
    }

    public function getFont (name:String):Font
    {
        if ( _fontMap == null || ! _fontMap.exists( name ) ) throw 'No font $name in this pack';
        return _fontMap.get(name);
    }

    public function getObject3D(name:String, required:Bool = true )
    {
        if ( ! _objectMap.exists( name ) )
            if ( required )
                throw 'No object3d with name=$name'
                else
                    return null;
        return _objectMap[name];
    }

    public function getTexDef( name:String, required:Bool = true, lookInAtlases:Bool = true )
    {
        var ret:TexDef = null;
        if ( lookInAtlases )
        {
            for ( i in _atlasMap )
            {
                if ( i.exists( name ) )
                {
                    return i.get( name );
                }
            }
        }
        ret = _texMap.get( name );
        if ( ret == null && required ) throw 'No texture with name=$name';
        return ret;
    }

    public function getSound( name:String, required:Bool = true )
    {
        if ( ! _soundMap.exists( name ) )
        {
            if ( required )
            {
                throw 'No sound with name=$name';
            }
            else
            {
                return null;
            }
        }
        return SoundManager.createInstance( name );
    }

    public function getFile( name:String, required:Bool = true )
    {
        var ret = _fileMap.get( name );
        if ( ret == null && required ) throw 'No file with name=$name';
        return ret;
    }

    public function getGeometry( name:String, required:Bool = true )
    {
        var ret = _geomMap.get( name );
        if ( ret == null && required ) throw 'No file with name=$name';
        return ret;
    }
    
    public function getBufferGeometry( name:String, required:Bool = true ):BufferGeometry
    {
        var ret = _bufGeomMap.get( name );
        if ( ret == null && required ) throw 'No file with name=$name';
        return ret;
    }

    public function dispose()
    {
        // private var _texMap:Map<String,TexDef>;
        // private var _fileMap:Map<String,File>;
        // private var _geomMap:Map<String,Geometry>;
        // private var _bufGeomMap:Map<String,BufferGeometry>;
        // private var _soundMap:Map<String,String>; // map just to check if sound belongs to this asset pack
        // private var _atlasMap:Map<String,Atlas>;
        // private var _fontMap:Map<String,Font>;
        // private var _objectMap:Map<String,Object3D>;

        function clearMap<String,V>(map:Map<String,V>, ?fn:V->Void):Void
        {
            for( i in map.keys() ) 
            {                
                if ( fn != null ) fn(map[i]);
                map.set(i, null);
            }
        }
        
        function disposeObject3D(v:Object3D)
        {
            if ( untyped v.geometry != null ) 
            {
                untyped v.geometry.dispose();
            }
            
            if ( untyped v.material != null ) 
            {
                untyped v.material.dispose();
            }
            
            for ( i in v.children )
            {
                disposeObject3D( i );
            }
        }

            
        
        clearMap(_texMap, function(t:TexDef) t.texture.dispose() ); _texMap = null;
        clearMap(_fileMap); _fileMap = null;
        clearMap(_geomMap, function(g:Geometry) g.dispose() ); _geomMap = null;
        clearMap(_bufGeomMap, function (g:BufferGeometry) g.dispose() ); _bufGeomMap = null;
        clearMap(_soundMap); _soundMap = null;
        clearMap(_atlasMap); _atlasMap = null;
        clearMap(_fontMap); _fontMap = null;
        clearMap(_objectMap, disposeObject3D); _objectMap = null;

    }

}

typedef TexDef =
{
    texture:Texture,
    uv:UV,
    width:Int,
    height:Int
}
