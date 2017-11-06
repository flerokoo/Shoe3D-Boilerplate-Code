package spe;
import js.three.Color;
import js.three.Vector3;

/**
 * ...
 * @author as
 */
typedef EmitterParameters = {
	?type:EmitterDistribution,
	?particleCount:Int,
	?duration:Float,
	?isStatic:Bool,
	?activeMultiplier:Float,
	?direction:Float,
	?maxAge: { ?value:Float, ?spread:Float },
	?position: {
		?value:Vector3,
		?spread:Vector3,
		?spreadClamp:Vector3,
		?radius:Float,
		?radiusScale:Vector3,
		?distribution:EmitterDistribution,
		?randomise:Bool
	},
	?velocity: {
		?value: Vector3,
		?spread:Vector3,
		?distribution:EmitterDistribution,
		?randomise:Bool
	},
	?acceleration: {
		?value: Vector3,
		?spread:Vector3,
		?distribution:EmitterDistribution,
		?randomise:Bool
	},
	?drag: {
		?value: Vector3,
		?spread:Vector3,
		?randomise:Bool
	},
	?wiggle: {
		?value: Vector3,
		?spread:Vector3
	},
	?rotation: {
		?axis: Vector3,
		?axisSpread:Vector3,
		?angle:Float ,
		?angleSpread:Float,
		// TODO Find out how to replace static to another name
		// ?static:Bool,
		?center:Vector3,
		?randomise:Bool
	},
	?color: {
		?value: Dynamic,
		?spread:Vector3,
		?randomise:Bool
	},
	?opacity: {
		?value: Dynamic,
		?spread:Float,
		?randomise:Bool
	},
	?size: {
		?value: Dynamic,
		?spread:Float,
		?randomise:Bool
	}
}

@:native("SPE.distributions")
extern enum EmitterDistribution {
	BOX;
	SPHERE;
	DISC;	
}