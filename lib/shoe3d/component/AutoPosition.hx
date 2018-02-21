package shoe3d.component;
import shoe3d.core.game.Component;
import shoe3d.util.signal.Sentinel;
import shoe3d.util.SMath;
import js.three.Vector3;

/**
 * ...
 * @author as
 */
class AutoPosition extends Component
{
    var conn:Sentinel;

    public var scaleEnabled:Bool = true;
    public var positionEnabled:Bool = true;

    public var posX(default, set):Float = 0.0;
    public var posY(default, set):Float = 0.0;
    public var xOffset:Float = 0;
    public var yOffset:Float = 0;
    public var scaleXRatio:Float = 1;
    public var scaleYRatio:Float = 1;
    public var scaleOffsetXRatio:Float = 1;
    public var scaleOffsetYRatio:Float = 1;

    private var _dirty:Bool = true;

    public function new( positionEnabled:Bool = true, scaleEnabled:Bool = true )
    {
        super();
        this.positionEnabled = positionEnabled;
        this.scaleEnabled = scaleEnabled;

    }

    override public function onStart()
    {
        super.onAdded();
        conn = System.window.resize.connect( setDirty );
        reoverlay();
    }

    function setDirty()
    {
        _dirty = true;
    }

    override public function onRemoved()
    {
        if ( conn != null ) conn.dispose();
        super.onRemoved();
    }

    override public function dispose()
    {
        conn.dispose();
        super.dispose();
    }

    public function reoverlay():AutoPosition
    {
        if ( owner == null ) return this;
        if ( owner.parent == null && owner.layer == null ) return this;

        var base = owner.parent != null ? owner.parent.transform : owner.layer.scene;

        if ( positionEnabled && base != null )
        {
            var targetPos = base.worldToLocal( new Vector3(
                System.window.width * posX + SMath.lerp( scaleOffsetXRatio, xOffset, xOffset * System.screen.scale),
                System.window.height * posY + SMath.lerp( scaleOffsetYRatio, yOffset, yOffset * System.screen.scale),
                0
            ) );

            owner.transform.position.x = targetPos.x;
            owner.transform.position.y = targetPos.y;

        }

        if ( scaleEnabled )
        {
            owner.transform.scale.set(
                SMath.lerp( scaleXRatio, 1, System.screen.scale ),
                SMath.lerp( scaleYRatio, 1, System.screen.scale ),
                1
            );
        }

        owner.transform.updateMatrixWorld( true );

        _dirty = false;

        return this;

    }

    public function setScaleRatio( x:Float, y:Float )
    {
        scaleEnabled = true;
        scaleXRatio = x;
        scaleYRatio = y;
        _dirty = true;
        return this;
    }

    public function setOffsetScaleRatio( x:Float, y:Float )
    {
        positionEnabled = true;
        scaleOffsetXRatio = x;
        scaleOffsetYRatio = y;
        _dirty = true;
        return this;
    }

    public function setOffsets(x:Float, y:Float )
    {
        positionEnabled = true;
        xOffset = x;
        yOffset = y;
        _dirty = true;
        return this;
    }

    public function left()
    {
        positionEnabled = true;
        posX = 0;
        _dirty = true;
        return this;
    }

    public function right()
    {
        positionEnabled = true;
        posX = 1;
        _dirty = true;
        return this;
    }

    public function top()
    {
        positionEnabled = true;
        posY = 1;
        _dirty = true;
        return this;
    }

    public function bottom()
    {
        positionEnabled = true;
        posY = 0;
        _dirty = true;
        return this;
    }

    public function centerX()
    {
        positionEnabled = true;
        posX = 0.5;
        _dirty = true;
        return this;
    }

    public function centerY()
    {
        positionEnabled = true;
        posY = 0.5;
        _dirty = true;
        return this;
    }

    public function setAsOnScreenContainer()
    {
        setPos( 0, 0 );
        setScaleRatio( 0, 0 );
        return this;
    }

    public function setPos( posX:Float, posY:Float, xOffset:Float = 0, yOffset:Float = 0 )
    {
        positionEnabled = true;
        this.posX = posX;
        this.posY = posY;
        this.xOffset = xOffset;
        this.yOffset = yOffset;
        _dirty = true;
        return this;
    }

    public static function container()
    {
        return new AutoPosition().setAsOnScreenContainer();
    }

    public function setScaleEnabled( bool:Bool )
    {
        scaleEnabled = bool;
        _dirty = true;
        return this;
    }

    public function setPosEnabled( bool:Bool )
    {
        positionEnabled = bool;
        _dirty = true;
        return this;
    }

    override public function onUpdate()
    {
        if ( _dirty ) reoverlay();
    }

    function set_posX(value:Float):Float
    {
        _dirty =  true;
        return posX = value;
    }

    function set_posY(value:Float):Float
    {
        _dirty = true;
        return posY = value;
    }

}

enum Position
{
    Left;
    Right;
    Top;
    Bottom;
    Center;
}