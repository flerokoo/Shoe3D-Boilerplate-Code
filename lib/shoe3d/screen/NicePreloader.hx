package shoe3d.screen;
import haxe.Json;
import haxe.Timer;
import shoe3d.asset.AssetPack;
import shoe3d.component.AutoPosition;
import shoe3d.component.FillSprite;
import shoe3d.component.ScaleButton;
import shoe3d.component.SimpleGradientSprite;
import shoe3d.core.game.GameObject;
import shoe3d.core.Layer2D;
import shoe3d.util.Log;
import shoe3d.util.promise.Promise;
import shoe3d.util.Value;
import js.Three;
import js.three.CircleGeometry;
import js.three.Euler;
import js.three.Geometry;
import js.three.JSONLoader;
import js.three.Matrix4;
import js.three.Mesh;
import js.three.MeshBasicMaterial;
import js.three.Side;
import js.three.WireframeHelper;

/**
 * ...
 * @author as
 */
@:access(shoe3d)
class NicePreloader extends GameScreen
{
    public static var PLAY_BUTTON_COLOR = 0xFFCC00;
    public static var BAR_COLOR = 0xFFCC00;
    public static var BAR_BACKGROUND = 0xAA6F00;
    public static var BACKGROUND_COLOR = 0x201515;

    public static var POS_Y_RELATIVE = 0.7;
    public static var BAR_HEIGHT = 5;
    public static var BAR_WIDTH = 180;

    var layer:Layer2D;
    var offsets:Array< {offset:Float, index:Int}>;
    static var progress:Value<Float>;
    static var loading = false;

    static public var playButton:Mesh;
    static public var progressBar:Mesh;
    static public var progressBarBackground:Mesh;
    static var onSuccessReal:AssetPack->Void;
    static var onStartReal:Void->Void;
    static var onSuccessInternal:AssetPack->Void;
    @:keep
    public function new()
    {
        super();
        layer = newLayer2D("main", true );

        // BACKGROUND
        System.renderer.clearColor = BACKGROUND_COLOR;

        // PLAY BUTTON
        var txt = '{"normals": [0, 1, 0, 0, 0.999969, 0], "name": "PlaneGeometry.1", "vertices": [-0.850601, 0, 1.06234, 0.850601, 0, 1.06234, -0.850601, -0, -1.06234, 0.850601, -0, -1.06234, -1, -0, -0, 0, 0, 1.24893, 1, -0, -0, 0, -0, -1.24893, -0.968882, 0, 0.605033, 0.484441, 0, 1.21006, 0.968882, -0, -0.605033, -0.484441, -0, -1.21006, -0.968882, -0, -0.605033, -0.484441, 0, 1.21006, 0.968882, 0, 0.605033, 0.484441, -0, -1.21006, 0, -0, -0.575132, 0.494661, 0, 0.417152, -0.494661, 0, 0.417152, -0.929984, 0, 0.871113, 0.697488, 0, 1.16149, 0.929984, -0, -0.871113, -0.697488, -0, -1.16149, -0.99222, -0, -0.309803, -0.248055, 0, 1.23921, 0.99222, 0, 0.309803, 0.248055, -0, -1.23921, -0.99222, 0, 0.309803, 0.248055, 0, 1.23921, 0.99222, -0, -0.309803, -0.248055, -0, -1.23921, -0.929984, -0, -0.871113, -0.697488, 0, 1.16149, 0.929984, 0, 0.871113, 0.697488, -0, -1.16149], "faces": [32, 18, 23, 4, 0, 0, 0, 32, 17, 14, 25, 0, 1, 0, 32, 27, 8, 18, 0, 1, 0, 32, 18, 16, 23, 0, 0, 0, 32, 12, 23, 16, 0, 0, 0, 32, 4, 27, 18, 0, 0, 0, 32, 10, 21, 34, 0, 0, 0, 32, 3, 34, 21, 0, 0, 0, 32, 15, 26, 16, 0, 1, 0, 32, 7, 30, 16, 0, 1, 0, 32, 11, 22, 12, 0, 0, 0, 32, 2, 31, 22, 0, 0, 0, 32, 17, 18, 5, 0, 0, 0, 32, 31, 12, 22, 0, 0, 0, 32, 18, 8, 19, 0, 1, 0, 32, 11, 12, 16, 0, 0, 0, 32, 18, 19, 32, 0, 0, 0, 32, 30, 11, 16, 1, 0, 0, 32, 19, 0, 32, 0, 0, 0, 32, 7, 16, 26, 0, 0, 1, 32, 34, 15, 10, 0, 0, 0, 32, 29, 10, 16, 0, 0, 0, 32, 25, 6, 17, 0, 0, 0, 32, 33, 14, 17, 0, 1, 0, 32, 20, 1, 33, 0, 0, 0, 32, 28, 9, 17, 1, 0, 0, 32, 24, 5, 18, 0, 0, 0, 32, 32, 13, 18, 0, 0, 0, 32, 15, 16, 10, 0, 0, 0, 32, 18, 13, 24, 0, 0, 0, 32, 5, 28, 17, 0, 1, 0, 32, 20, 33, 17, 0, 0, 0, 32, 6, 29, 17, 0, 0, 0, 32, 17, 9, 20, 0, 0, 0, 32, 29, 16, 17, 0, 0, 0], "metadata": {"version": 3, "generator": "io_three", "normals": 2, "faces": 35, "vertices": 35, "type": "Geometry"}}';
        var geom:Geometry = new JSONLoader().parse( Json.parse( txt ) ).geometry;
        geom.applyMatrix( new Matrix4().makeScale( 40, 40, 40 ) );
        var mesh = new Mesh( geom, new MeshBasicMaterial( { side: Three.DoubleSide, color: PLAY_BUTTON_COLOR } ) );
        mesh.rotateX( Math.PI / 2 );
        mesh.rotateY( -Math.PI / 2 );
        //mesh.rotateZ( Math.PI / 2 );
        playButton = mesh;
        //layer.scene.add( mesh );

        // PROGRESS BAR BACKGROUND
        geom = new CircleGeometry( BAR_HEIGHT, 10 );
        progressBarBackground = new Mesh( geom,  new MeshBasicMaterial( { side: Three.DoubleSide, color: BAR_BACKGROUND } ) );
        progressBarBackground.position.set( System.window.width / 2 - BAR_WIDTH / 2, System.window.height * POS_Y_RELATIVE, 0 );
        layer.scene.add( progressBarBackground );
        geom.verticesNeedUpdate = true;
        for ( i in 0...geom.vertices.length )
            if ( geom.vertices[i].x > 0 )
                geom.vertices[i].x += BAR_WIDTH;

        // PROGRESS BAR
        geom = new CircleGeometry( BAR_HEIGHT, 10 );
        progressBar = new Mesh( geom,  new MeshBasicMaterial( { side: Three.DoubleSide, color: BAR_COLOR } ) );
        progressBar.position.set( System.window.width / 2 - BAR_WIDTH / 2, System.window.height * POS_Y_RELATIVE, 0 );
        layer.scene.add( progressBar );
        offsets = [];
        for ( i in 0...geom.vertices.length )
            if ( geom.vertices[i].x > 0 )
                offsets.push( { offset: geom.vertices[i].x, index: i } );

        onSuccessInternal = function(a:AssetPack)
        {
            loading = false;
            onSuccessReal(a);
            var go = new GameObject()
            .add( new FillSprite(120, 100, 0xff0000 ).setAlpha(0.01).centerAnchor() )
            .add( new ScaleButton( function(e)
            {
                onStartReal();
                #if !debug
                //System.window.requestFullscreen();
                #end
            } ).disableDefaultSounds() )
            .add( new AutoPosition(  ).setPos(0.5, POS_Y_RELATIVE) );
            go.transform.add( playButton );

            layer.addChild( go );

            progressBarBackground.visible = false;
            progressBar.visible = false;
        }

        progress = new Value(0.0);
        progress.change.connect( function ( n, p)
        {
            n = Math.max(n, p);
            for ( o in offsets )
                cast(progressBar.geometry, Geometry).vertices[o.index].x = n * BAR_WIDTH + o.offset;

            cast(progressBar.geometry, Geometry).verticesNeedUpdate = true;
            progressBar.position.set(
                System.window.width / 2 - BAR_WIDTH / 2,
                System.window.height * POS_Y_RELATIVE,
                0
            );
            progressBarBackground.position.set(
                System.window.width / 2 - BAR_WIDTH / 2,
                System.window.height * POS_Y_RELATIVE,
                0
            );
        } );
    }

    public static function loadFolderFromAssets( folder:String, onSuccess:AssetPack->Void, onStart:Void->Void, ?registerThisPackWithName:String ):Promise<AssetPack>
    {
        if ( loading ) throw 'Can not load more that one asset pack at time';

        System.screen.addScreen( 'nice_preloader', NicePreloader );
        System.screen.show( 'nice_preloader' );
        progress._ = 0;
        loading = true;

        onSuccessReal = onSuccess;
        onStartReal = onStart;

        return System.loadFolderFromAssets(
            folder,
            onSuccessInternal,
            function( p:Float ) progress._ = p,
            registerThisPackWithName);

    }

}