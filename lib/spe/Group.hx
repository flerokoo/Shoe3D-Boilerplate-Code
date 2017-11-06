package spe;
import js.three.Mesh;
import js.three.Vector3;

/**
 * ...
 * @author as
 */
@:native("window.SPE.Group")
extern class Group
{

	public function new( options:GroupParameters );
	
	public function addEmitter( e:Emitter ):Void;
	public function addPool( numEmitters:Int, emitterOptions:Array<EmitterParameters>, createNew:Bool):Group;
	public function dispose():Group;
	public function getFromPool():Emitter;
	public function getPool():Array<Emitter>;
	public function releaseIntoPool(emitter:Emitter):Group;
	public function removeEmitter(emitter:Emitter):Void;
	public function tick(?dt:Float):Void;
	public function triggerPoolEmitter( numEmitters:Int, ?position:Vector3 ):Group;
	
	public var mesh:Mesh;
	public var scale:Float;
	
}