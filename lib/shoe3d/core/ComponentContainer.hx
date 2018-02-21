package shoe3d.core;
import shoe3d.core.game.Component;
import js.three.Object3D;

/**
 * ...
 * @author as
 */
interface ComponentContainer
{

    public var components(default,null):Array<Component>;

}