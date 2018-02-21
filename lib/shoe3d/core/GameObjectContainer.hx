package shoe3d.core;
import shoe3d.core.game.GameObject;

/**
 * ...
 * @author as
 */
interface GameObjectContainer
{

    public var children(default,null):Array<GameObject>;

}