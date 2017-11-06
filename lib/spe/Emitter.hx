package spe;
import spe.EmitterParameters.EmitterDistribution;
import js.three.Vector3;

/**
 * ...
 * @author as
 */
@:native("window.SPE.Emitter")
extern class Emitter
{

	public function new( options:EmitterParameters );
	
	public function disable():Emitter;
	public function enable():Emitter;
	public function remove():Emitter;
	public function reset( ?force:Bool ):Emitter;
	public function tick(dt:Float):Void;
	
	public var position: {
		?value:Vector3,
		?spread:Vector3,
		?spreadClamp:Vector3,
		?radius:Float,
		?radiusScale:Vector3,
		?distribution:EmitterDistribution,
		?randomise:Bool
	};
	
	public var velocity: {
		?value: Vector3,
		?spread:Vector3,
		?distribution:EmitterDistribution,
		?randomise:Bool
	};
}