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
	GEOMETRY;

	//buffergeometry
	BUFFERGEOMETRY;
	
	//scene or object
	OBJECT;
	
	//atlas
	ATLAS;

	//raw data
	RAW;
}
 
 
class AssetEntry
{

	public var name(default, null):String;
	public var url(default, null):String;
	public var format(default, null):AssetFormat;
	public var bytes(default, null):Int;
	public var extra(default, null):Dynamic;
	
	public function new( name:String, url:String, format:AssetFormat, bytes:Int, extra:Dynamic ) 
	{
		this.name = name;
		this.url = url;
		this.format = format;
		this.bytes = bytes;		
		this.extra = extra;		
	}
	
}