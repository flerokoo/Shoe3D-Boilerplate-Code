package shoe3d.asset;
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
/**
 * ...
 * @author as
 */
@:allow(shoe3d)
class AssetPack
{

	private var _texMap:Map<String,TexDef>;
	private var _fileMap:Map<String,File>;
	private var _geomMap:Map<String,Geometry>;
	private var _bufGeomMap:Map<String,BufferGeometry>;
	private var _soundMap:Map<String,String>; // map just to check if sound belongs to this asset pack
	private var _atlasMap:Map<String,Atlas>;
	private var _geomDefMap:Map<String,GeomDef>;
	private var _fontMap:Map<String,Font>;
	private var _objectMap:Map<String,Object3D>;
	
	public function new(  ) 
	{
		_texMap = new Map();
		_fileMap = new Map();
		_soundMap = new Map();
		_geomMap = new Map();
		_bufGeomMap = new Map();
		_atlasMap = new Map();
		_geomDefMap = new Map();
		_objectMap = new Map();
	}
	
	public function getAtlas( name:String )
	{
		if ( ! _atlasMap.exists( name ) ) throw 'No atlas with name=$name';
		return _atlasMap.get( name );
	}
	
	public function createAtlas( name:String, texName:String, jsonName:String ):Atlas
	{
		if ( ! _texMap.exists( texName ) || ! _fileMap.exists(jsonName ) ) throw 'No image or json from atlas $name';
		var atlas = new Atlas( getTexDef(texName), getFile(jsonName).content );
		_atlasMap.set( name, atlas );
		return atlas;
	}
	
	public function createFont( name:String ):Font
	{
		if ( _fontMap == null ) _fontMap = new Map();
		if ( ! _fileMap.exists(name) ) throw 'No file $name';
		
		var font = new Font( name, this  );
		_fontMap.set( name, font );
		return font;
	}
	
	public function getFont( name:String ):Font
	{
		if ( _fontMap == null || ! _fontMap.exists( name ) ) throw 'No font $name in this pack';
		return _fontMap.get(name);
	}
	
	/*public function createMesh( name:String, geomName:String, texDefName:String ) : Mesh
	{
		if ( ! _geomMap.exists( geomName ) ) throw 'No geometry with name=$geomName';
		if ( getTexDef( texDefName, false) == null) throw 'No texDef with name=$texDefName';
		
		var texd = getTexDef( texDefName );
		var geom = getGeometry( geomName );
		
		var newGeom = geom.clone();
		UVTools.setGeometryUV( newGeom, texd.uv );
		var geomDef:GeomDef = {
			geom: newGeom,
			texDef:texd,
			originalUV: geom.faceVertexUvs,
			material: new MeshPhongMaterial( {map: texd.texture, transparent: isTransparent} )
		};
		
		var geomDef = new GeomDef( geom, texd, geom.faceVertexUvs );
		
		_geomDefMap.set( name, geomDef );
		
		return geomDef;
	}*/
	
	public function getTexDef( name:String, required:Bool = true ) 
	{
		var ret:TexDef = null;
		for ( i in _atlasMap )
			if ( i.exists( name ) )
				return i.get( name );
		
		ret = _texMap.get( name );
		if ( ret == null && required ) throw 'No texture with name=$name';
		return ret;
	}
	
	public function getSound( name:String, required:Bool = true )
	{
		if ( ! _soundMap.exists( name ) )
			if ( required ) 
				throw 'No sound with name=$name'
			else
				return null;
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
	
	public function createGeometryFromFile( filename:String, geometryname:String )
	{
		
	}
}

typedef TexDef = 
{
	texture:Texture,
	uv:UV,
	width:Int,
	height:Int
}

class GeomDef 
{
	public var material:Material;
	public var texDef:TexDef;
	public var geom:Geometry;
	public var originalUV:Array<Array<Array<Vector2>>>;
	
	public function new( geom:Geometry, texDef:TexDef, ?material:Material, ?originalUV:Array<Array<Array<Vector2>>> )
	{
		this.geom = geom;
		this.texDef = texDef;
		this.originalUV = originalUV;
		this.material = material != null ? material : new MeshPhongMaterial( {map: texDef.texture} );
	}
	
	public function setTransparent( v:Bool = true )
	{
		material.transparent = v;
		material.needsUpdate = true;
		return this;
	}
	
	public function setShine( v:Float = 30 )
	{
		setMaterialParam( "shininess", v );
		return this;
	}
	
	public function setMaterialParam( param:String, val:Dynamic ):Dynamic
	{
		Assert.that(material != null, "Material is null");
		if ( Reflect.hasField( material, param ) )
		{
			Reflect.setProperty( material, param, val );
			material.needsUpdate = true;
		} else {
			Log.warn('No field $param in this material');
		}
		return this;
	}
}