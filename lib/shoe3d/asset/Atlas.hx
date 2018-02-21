package shoe3d.asset;
import haxe.Json;
import shoe3d.asset.AssetPack.TexDef;
import shoe3d.util.math.Rectangle;
import shoe3d.util.UVTools.UV;

enum AtlasType
{
    ShoeBox;
    TexturePacker;
    Auto;
}

class Atlas
{

    public var image(default, null):TexDef;

    private var _texMap:Map<String, TexDef>;

    public function new( image:TexDef, ?json:String )
    {
        _texMap = new Map();
        this.image = image;
        if ( json != null )
        {
            parseJSON( json );
        }
    }

    public function addSubTexture( name:String, rect:Rectangle ):Atlas
    {
        _texMap.set( name, { uv: UVfromRectangle(rect), texture: image.texture, width: cast rect.width, height: cast rect.height } );
        return this;
    }

    function UVfromRectangle( rect:Rectangle ):UV
    {
        if ( image == null ) throw "Image is null";
        return {
            umin: rect.x / image.width,
            vmin: (image.height - rect.y - rect.height) / image.height,
            umax: (rect.x + rect.width) / image.width,
            vmax: (image.height - rect.y) / image.height
        }
    }

    public function parseJSON( json:String, ?type:AtlasType  ):Atlas
    {
        if ( type == TexturePacker )
            parseTexturePacker( json )
            else if (type == ShoeBox )
                parseShoeBox( json );
            else if ( type == Auto  || type == null )
            {
                var a:Dynamic;
                try	a = Json.parse( json )
                    catch (e:Dynamic) throw 'Can\' parse atlas json';

                if ( Reflect.hasField( a, "frames") && Reflect.hasField( a, "meta" ) )
                {
                    if ( Std.is( Reflect.field(a, "frames"), Array  ) )
                        parseTexturePacker( json )
                        else if ( Std.is( Reflect.field(a, "frames"), Dynamic ) )
                            parseShoeBox(json );
                }
            }

        return this;
    }

    function parseTexturePacker( json:String )
    {
        var a:Dynamic = null;
        try	a = Json.parse( json )
                    catch (e:Dynamic) throw 'Can\' parse atlas json';

        if ( ! Reflect.hasField( a, "frames") && ! Reflect.hasField( a, "meta" ) ) throw 'Wrong JSON Format';

        var frames:Array<Dynamic> = Reflect.field(a, "frames");
        for ( o in frames )
            if ( Reflect.hasField( o, "filename" ) && Reflect.hasField( o, "frame" ))
            {
                var name:String = cast Reflect.field( o, "filename" );
                var frame:Dynamic = Reflect.field( o, "frame" );

                name = name.substr( 0, name.lastIndexOf( '.' ) );
                _texMap.set( name,
                {
                    uv: UVfromRectangle(
                        new Rectangle(
                            cast Reflect.field( frame, "x" ),
                            cast Reflect.field( frame, "y" ),
                            cast Reflect.field( frame, "w" ),
                            cast Reflect.field( frame, "h" )
                        )
                    ),
                    texture: image.texture,
                    width: cast Reflect.field( frame, "w" ),
                    height: cast Reflect.field( frame, "h" )
                }
                           );
            }
    }

    function parseShoeBox( json:String )
    {
        var a:Dynamic = null;
        try	a = Json.parse( json )
                    catch (e:Dynamic) throw 'Can\' parse json';

        if ( ! Reflect.hasField( a, "frames") && ! Reflect.hasField( a, "meta" ) ) throw 'Wrong JSON Format';

        var frames:Dynamic = Reflect.field(a, "frames");
        var fields = Reflect.fields( frames );

        for ( name in fields )
        {
            var o = Reflect.field( frames, name );
            if (  Reflect.hasField( o, "frame" ))
            {
                var frame:Dynamic = Reflect.field( o, "frame" );
                var clearName = name.substr( 0, name.lastIndexOf( '.' )  );

                _texMap.set( clearName,
                {
                    uv: UVfromRectangle(
                        new Rectangle(
                            cast Reflect.field( frame, "x" ),
                            cast Reflect.field( frame, "y" ),
                            cast Reflect.field( frame, "w" ),
                            cast Reflect.field( frame, "h" )
                        )
                    ),
                    texture: image.texture,
                    width: cast Reflect.field( frame, "w" ),
                    height: cast Reflect.field( frame, "h" )
                }
                           );

            }
        }
    }

    public function exists( name:String ):Bool
    {
        return _texMap.exists( name );
    }

    public function get( name:String ):TexDef
    {
        return _texMap.get( name );
    }
}