package shoe3d.util;
import shoe3d.asset.AssetPack.TexDef;
import shoe3d.util.math.Rectangle;
import shoe3d.util.UVTools.UV;
import js.three.Geometry;

/**
 * ...
 * @author as
 */
typedef UV =
{
    umin:Float,
    umax:Float,
    vmin:Float,
    vmax:Float,
}

class UVTools
{

    public static function UVfromRectangle( rect:Rectangle, totalWidth:Float, totalHeight:Float ):UV
    {
        Assert.that( rect != null );

        // ThreeJS coordinates start at bottom-left corner, so, converting it
        return {
            umin: rect.x / totalWidth,
            vmin: (totalHeight - rect.y - rect.height) / totalHeight,
            umax: (rect.x + rect.width) / totalWidth,
            vmax: (totalHeight - rect.y) / totalHeight
        }

        /*return {
        	umin: rect.x / totalWidth,
        	vmin: rect.y / totalHeight,
        	umax: (rect.x + rect.width) / totalWidth,
        	vmax: (rect.y + rect.height) / totalHeight
        }*/
    }

    public static function UVFromRectangles( rect:Rectangle, from:Rectangle):UV
    {
        Assert.that( rect != null );
        Assert.that( from != null );
        throw "NO!";
    }

    public static function setGeometryUVFromTexDef( geom:Geometry, texDef:TexDef )
    {
        setGeometryUV( geom, texDef.uv );
    }

    public static function setGeometryUV( geom:Geometry, uv:UV )
    {
        geom.uvsNeedUpdate = true;
        for ( a in geom.faceVertexUvs )
            for ( b in a )
                for ( c in b )
                {
                    c.x = uv.umin + (uv.umax - uv.umin) * c.x;
                    c.y = uv.vmin + (uv.vmax - uv.vmin) * c.y;
                }
    }

}