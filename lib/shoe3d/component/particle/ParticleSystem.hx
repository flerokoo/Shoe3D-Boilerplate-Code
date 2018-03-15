package shoe3d.component.particle;
import haxe.Json;
import shoe3d.asset.AssetPack;
import shoe3d.asset.Assets;
import shoe3d.core.game.Component;
import shoe3d.core.Time;
import shoe3d.util.Assert;
import shoe3d.util.Log;
import spe.Emitter;
import spe.EmitterParameters;
import spe.Group;
import spe.GroupParameters;
import js.three.Color;
import js.three.Euler;
import js.three.Vector2;
import js.three.Vector3;

/**
 * ...
 * @author as
 */
class ParticleSystem extends Component
{
    static var _scratch:Vector3 = new Vector3();

    public var group(default, null):Group;
    public var emitters(default, null):Map<String, Emitter>;
    public var startData(default, null):Map<String, {v:Vector3, p:Vector3}>;
    public var rememberStartPositionsAndVelocities:Bool = false;

    public function new( groupParams:GroupParameters, mobileScale:Bool = true, rememberStartPositionsAndVelocities:Bool = true )
    {
        super();

        // fix scale for mobile
        if ( mobileScale )
        {
            if ( groupParams.scale != null )
                groupParams.scale *= js.Browser.window.devicePixelRatio;
            else
                groupParams.scale = 300 * js.Browser.window.devicePixelRatio ;
        }

        group = new Group( groupParams );
        emitters = new Map();

        this.rememberStartPositionsAndVelocities = rememberStartPositionsAndVelocities;
        if ( rememberStartPositionsAndVelocities )
        {
            startData = new Map();
        }
        group.mesh.frustumCulled = false;

    }

    public function addEmitter( name:String, emitter:Emitter ):ParticleSystem
    {
        Assert.that( emitter != null );
        emitters[name] = emitter;
        group.addEmitter( emitter );
        if ( startData != null )
            startData.set( name, {
            p:  untyped emitter.position.value.clone(),
            v:  untyped emitter.velocity.value.clone()
        });
        return this;
    }

    public function getEmitter( name:String ):Emitter
    {
        Assert.that(emitters.exists(name));
        return emitters[name];
    }

    public static function fromJSON( json:String, mobileScale:Bool = true, rememberStartPositionsAndVelocities:Bool = true ):ParticleSystem
    {
        var out = null;
        try {
            out = Json.parse( json );
        }
        catch (e:Dynamic)
        {
            throw e;
        }

        out.group.texture.value = Assets.getTexDef( out.meta.assetName ).texture;

        var createRealVectorsAndColors = null;
        createRealVectorsAndColors = function( o:Dynamic )
        {
            for ( i in Reflect.fields( o ) )
            {
                var fields = Reflect.fields( Reflect.field(o, i) );

                var foundVectorOrColor = false;
                if ( fields.length == 3 )
                {
                    if ( fields.indexOf("x") > -1 && fields.indexOf("y") > -1 )
                    {
                        if ( fields.indexOf("z") > -1 )
                            Reflect.setField( o, i, new Vector3(
                                Reflect.field( Reflect.field( o, i ), "x" ),
                                Reflect.field( Reflect.field( o, i ), "y" ),
                                Reflect.field( Reflect.field( o, i ), "z" )
                            ));
                        else
                            Reflect.setField( o, i, new Vector2(
                                Reflect.field( Reflect.field( o, i ), "x" ),
                                Reflect.field( Reflect.field( o, i ), "y" )
                            ));

                        foundVectorOrColor = true;
                    }

                    if ( fields.indexOf("r") > -1 && fields.indexOf("g") > -1 && fields.indexOf("b") > -1 )
                    {
                        foundVectorOrColor = true;
                        Reflect.setField( o, i, new Color(
                                              Reflect.field( Reflect.field(o, i), "r" ),
                                              Reflect.field( Reflect.field(o, i), "g" ),
                                              Reflect.field( Reflect.field(o, i), "b" )
                                          ));
                    }

                    if ( fields.indexOf("hex") > -1 )
                    {
                        Reflect.setField( o, i, new Color(
                                              Std.parseInt( Reflect.field( Reflect.field(o,i), "hex") )
                                          ));
                        foundVectorOrColor = true;
                    }

                }

                if ( ! foundVectorOrColor && fields.length > 0 && i.length > 1 && i != "texture" )
                {
                    createRealVectorsAndColors( Reflect.field( o, i ) );
                }
            }
        }

        createRealVectorsAndColors( out.group );
        createRealVectorsAndColors( out.emitters );

        var ps = new ParticleSystem( out.group, mobileScale, rememberStartPositionsAndVelocities );

        for ( i in Reflect.fields(out.emitters) )
        {
            var em = new Emitter( Reflect.field( out.emitters, i ) );
            ps.addEmitter( i, em );
        }

        return ps;
    }

    public static function fromPack( pack:AssetPack, filename:String, mobileScale:Bool = true, rememberStartPositionsAndVelocities:Bool = true ):ParticleSystem
    {
        return ParticleSystem.fromJSON( pack.getFile( filename ).content, mobileScale, rememberStartPositionsAndVelocities );
    }

    public function setEmitterParam( em:String, path:Array<String>, val:Dynamic )
    {
        Assert.that( path != null && path.length > 0 );
        var emitter = emitters[em];
        Assert.that(emitter != null, 'Emitter $em not found');

        var last:Dynamic = emitter;
        for ( i in 0...path.length )
        {
            if ( i < path.length -1 )
            {
                var field = Reflect.field( last, path[i] );
                Assert.that( field != null, 'Field ${path[i]} from path $path not found' );
                last = field;
            }
            else
            {
                Reflect.setProperty( last, path[i], val);
            }
        }
        return this;
    }

    override public function onAdded()
    {
        owner.transform.add( group.mesh );
    }

    override public function onRemoved()
    {
        owner.transform.remove( group.mesh );
    }

    override public function onUpdate()
    {
        group.tick( Time.dt );
    }

    public function setOffset( offset:Vector3 )
    {
        if ( startData == null ) throw 'Cant offset emitters without start positions';

        for ( i in emitters.keys() )
        {
            var dat = startData[i];
            var em = emitters[i];
            em.position.value.x = dat.p.x + offset.x;
            em.position.value.y = dat.p.y + offset.y;
            em.position.value.z = dat.p.z + offset.z;
            em.position.value = em.position.value;
        }
        return this;
    }

    public function setRotationFromEuler( e:Euler )
    {
        if ( startData == null ) throw 'Cant offset emitters without start positions';

        for ( i in emitters.keys() )
        {
            var dat = startData[i];
            var em = emitters[i];
            ( untyped _scratch.copy(dat.v) ).applyEuler( e );
            em.velocity.value.x = _scratch.x;
            em.velocity.value.y = _scratch.y;
            em.velocity.value.z = _scratch.z;
            em.velocity.value = em.velocity.value;
        }
        return this;
    }

    public function enable()
    {
        for ( i in emitters )
            i.enable();
    }

    public function disable()
    {
        for ( i in emitters )
            i.disable();
    }

    override public function dispose()
    {
        super.dispose();
        group.dispose();
    }
}