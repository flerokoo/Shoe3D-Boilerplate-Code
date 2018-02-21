package shoe3d.component.view2d;
import shoe3d.asset.AssetPack.TexDef;
import shoe3d.asset.Assets;
import shoe3d.util.Assert;
import js.three.Geometry;
import js.three.Mesh;
import js.three.MeshBasicMaterial;
import js.three.PlaneGeometry;
import js.three.Vector3;
import shoe3d.asset.Atlas;

/**
 * ...
 * @author as
 */
class ImageSprite extends Element2D
{
    var _mesh:Mesh;
    var _geometry:Geometry;
    var _texDef:TexDef;
    var _material:MeshBasicMaterial;

    public function new( texDef:TexDef )
    {
        super();
        _texDef = texDef;
        _geometry = new PlaneGeometry(0, 0, 1, 1);
        _material = new MeshBasicMaterial( { transparent: true, side: js.Three.DoubleSide, depthTest: false, depthWrite: false } );
        _mesh = new Mesh( _geometry, _material );
        redefineSprite();
    }

    public static function fromAssets( texDefName:String, lookInAtlases:Bool = true )
    {
        var texDef = Assets.getTexDef( texDefName, null, lookInAtlases );
        return new ImageSprite(texDef);
    }

    public static function fromAtlas( atlas:Atlas, name:String )
    {

    }

    function redefineSprite()
    {
        if ( _texDef == null ) return;

        var w = _texDef.width;
        var h = _texDef.height;
        var uv = _texDef.uv;

        _geometry.uvsNeedUpdate = true;
        _geometry.verticesNeedUpdate = true;

        /*geom.vertices[0].set( -w / 2, h / 2, 0 );
        geom.vertices[1].set( w / 2, h / 2, 0 );
        geom.vertices[2].set( -w / 2, -h / 2, 0 );
        geom.vertices[3].set( w / 2, -h / 2, 0 );

        var uvs = geom.faceVertexUvs[0];
        uvs[0][0].set( uv.umin, uv.vmax );
        uvs[0][1].set( uv.umin, uv.vmin );
        uvs[0][2].set( uv.umax, uv.vmax );

        uvs[1][0].set( uv.umin, uv.vmin );
        uvs[1][1].set( uv.umax, uv.vmin );
        uvs[1][2].set( uv.umax, uv.vmax );*/

        // flipped

        _geometry.vertices[0].set( 0, 0, 0 );
        _geometry.vertices[1].set( w, 0, 0 );
        _geometry.vertices[2].set( 0, h, 0 );
        _geometry.vertices[3].set( w, h, 0 );

        // scheme
        // | 2   3 |
        // |   \   |
        // | 0   1 |
        // faces 0-2-1  2-3-1

        var uvs = _geometry.faceVertexUvs[0];
        uvs[0][0].set( uv.umin, uv.vmax );
        uvs[0][1].set( uv.umin, uv.vmin );
        uvs[0][2].set( uv.umax, uv.vmax );

        uvs[1][0].set( uv.umin, uv.vmin );
        uvs[1][1].set( uv.umax, uv.vmin );
        uvs[1][2].set( uv.umax, uv.vmax );

        _material.map = _texDef.texture;
    }

    public function setTexture( tex:TexDef )
    {
        Assert.that(tex != null, "TexDef is null" );
        _texDef = tex;
        redefineSprite();
    }

    override function updateAnchor()
    {
        _mesh.position.x = -anchorX;
        _mesh.position.y = -anchorY;
    }

    override public function centerAnchor()
    {
        _mesh.position.x = -_texDef.width/2;
        _mesh.position.y = -_texDef.height/2;
        return this;
    }

    override public function onAdded()
    {
        owner.transform.add( _mesh );
    }

    override public function onRemoved()
    {
        owner.transform.remove( _mesh );
    }

    public override function contains( x:Float, y:Float ):Bool
    {
        if ( _texDef == null ) return false;
        //y = System.window.height - y;
        var v = _mesh.worldToLocal( new Vector3( x, y, 0 ) );
        x = v.x;
        y = v.y;

        return x > 0 && x < _texDef.width && y > 0 && y < _texDef.height;
    }

    override function setLevel( level:Float ):Element2D
    {
        _mesh.renderOrder = level;
        return this;
    }

    override function setPremultipliedAlpha( alpha:Float ):Element2D
    {
        _material.opacity = alpha;
        return this;
    }
}