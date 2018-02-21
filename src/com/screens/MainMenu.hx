package com.screens;

import shoe3d.util.GameConsole;
import js.three.AmbientLight;
import shoe3d.util.Log;
//import nape.phys.Body;
import js.Three;
import js.three.DirectionalLight;
import js.three.DirectionalLightHelper;
import js.three.DirectionalLightShadow;
import js.three.OrthographicCamera;
import shoe3d.System;
import shoe3d.asset.Assets;
import shoe3d.component.*;
import shoe3d.component.light.*;
import shoe3d.component.view3d.*;
import shoe3d.component.view2d.*;
import shoe3d.core.game.GameObject;
import shoe3d.screen.GameScreen;
import js.three.CubeGeometry;
import js.three.MeshLambertMaterial;
import js.three.Vector3;
import com.component.*;

class MainMenu extends GameScreen
{
    public function new ()
    {
        super();
    }

    override public function onCreate()
    {
        var layer = newLayer("3d-layer");
        var cam = layer.addPerspectiveCamera();

        layer.addChild(new GameObject()
                       .setPos(10, 10, 0)
                       .lookAt(new Vector3(0, 0, 0))
                       .add(new LightDirectional( 0xffffff, 0.6))
                      );

        layer.addChild(new GameObject()
                       //.add(ObjectView.fromGeometry(new CubeGeometry( 3, 3, 3 ), new MeshLambertMaterial({color: 0x00ff00})))
                       .add(new ComponentExample())
                      );

        //layer.scene.fog = new js.three.FogExp2(System.renderer.renderer.getClearColor().getHex(), 0.02);

        layer.addChild(new GameObject()
                       .add(new CameraCopter(cam))
                      );

        layer.addChild( new GameObject()
            .add( new GridDisplay(1000, 1))
            );

        cam.position.set(10,10,10);
        cam.lookAt(new Vector3());

        var scene = Assets.getObject3D("scenery");

        scene.traverse(function(o)
        {
            trace(o.type);
            if (o.type == "DirectionalLight")
            {
                var l:DirectionalLight = cast o;
                //dwl.shadow = new DirectionalLightShadow();
                l.shadow.mapSize.set( 512, 512 );
                l.castShadow = true;
                var cam:OrthographicCamera = cast l.shadow.camera;

                cam.left = -30;
                cam.right = 30;
                cam.bottom = -30;
                cam.top = 30;

                cam.updateProjectionMatrix();

                var h = new DirectionalLightHelper(l, 5);
                scene.add(h);
                System.renderer.renderer.shadowMap.enabled = true;
                System.renderer.renderer.shadowMap.type = Three.BasicShadowMap;
            }
            else if ( o.type == "Mesh" )
            {
                untyped o.material.castShadow = true;
                untyped o.material.receiveShadow = true;
            }
        });

        layer.addChild(new GameObject()
                       .add(new ObjectView(scene))
                      );

        var layer2d = newLayer2D("2d-layer", true);

        var t = null;
        layer2d.addChild(t = new GameObject()
            .add(ImageSprite.fromAssets("jake"))
        //.add(new AutoPosition(true, true).setPos(0.5,0.5))
                        );
        //motion.Actuate.tween(t.transform.position, 10, {y:500});


        /*haxe.Timer.delay( function() {
            trace("ADDED GLTF SCENE");
            var scene = Assets.getObject3D('gltf_test/level1_showcase');            
            layer.scene.add( scene );            
        }, 1000 );*/
        // TO REMOVE

        // var space = new shoe3d.component.napephysics.NapeSpace( new nape.geom.Vec2(0,-9.8) );

        /* var l3 = newLayer();

         l3.setCamera( cam );
         l3.addChild( new GameObject().add( space ));

         var body = new Body();
         body.shapes.add( new nape.shape.Polygon( nape.shape.Polygon.box(5, 1.5) ));
         body.align();
         space.space.bodies.add( body );

         var w1 = new Body();
         w1.shapes.add( new nape.shape.Circle(1));
         w1.align();
         w1.position.setxy(-1.6, -1.4);
         space.space.bodies.add( w1 );

         var w2 = new Body();
         w2.shapes.add( new nape.shape.Circle(1));
         w2.align();
         w2.position.setxy(1.6, -1.4);
         space.space.bodies.add( w2 );

         var p1 = new nape.constraint.PivotJoint( body, w1, body.worldVectorToLocal(w1.worldCOM), w2.localCOM);
         p1.ignore = true;
         p1.stiff = false;
         space.space.constraints.add(p1);

         var p2 = new nape.constraint.PivotJoint( body, w2, body.worldVectorToLocal(w2.worldCOM), w2.localCOM);
         p2.ignore = true;
         p2.stiff = false;
         space.space.constraints.add(p2);

         p1.frequency = p2.frequency = 2;
         trace(p1.frequency);

         shoe3d.util.GameConsole.registerCommand("cmd", function(){
             body.position.setxy(0,0);
             body.velocity.setxy( Math.random() - 0.5, 0).muleq( Math.random() * 20 );
         }, A);

         var body3 = new Body( nape.phys.BodyType.STATIC );
         body3.shapes.add( new nape.shape.Polygon( nape.shape.Polygon.box(60, 2)));
         body3.position.setxy(0, -20);
         space.space.bodies.add( body3 );

         l3.addChild( new GameObject()
             .add( new shoe3d.component.napephysics.NapeDebug( space ) )
             );
         */

         GameConsole.registerCommand("RELOAD", function() {
             //haxe.Timer.delay( function(){
             System.screen.show("mainMenu");
             //}, 500 );
         }, P);

    }
}