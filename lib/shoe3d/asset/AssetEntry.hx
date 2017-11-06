package shoe3d.asset;

/**
 * ...
 * @author as
 */

enum AssetFormat 
{
	//textures
	PNG; JPG; GIF; JXR; WEBP;
	
	//sounds	
	MP3; M4A; OPUS; OGG; WAV; AAC;
	
	//geometry
	GEOM;
	
	//scene
	SCENE;
	
	//raw data
	RAW;
}
 
 
class AssetEntry
{

	public var name(default, null):String;
	public var url(default, null):String;
	public var format(default, null):AssetFormat;
	public var bytes(default, null):Int;
	
	public function new( name:String, url:String, format:AssetFormat, bytes:Int ) 
	{
		this.name = name;
		this.url = url;
		this.format = format;
		this.bytes = bytes;
		
	}
	
}