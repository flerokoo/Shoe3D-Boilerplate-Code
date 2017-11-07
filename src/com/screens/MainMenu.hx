package com.screens;

import shoe3d.asset.Assets;
import shoe3d.component.*;
import shoe3d.core.game.GameObject;
import shoe3d.screen.GameScreen;
import js.three.CubeGeometry;
import js.three.MeshLambertMaterial;
import js.three.Vector3;
import com.component.*;

class MainMenu extends GameScreen 
{
    public function new () {
        super();        
    }

    override public function onCreate() {
        var layer = newLayer("3d-layer");
        var cam = layer.addPerspectiveCamera();    

        layer.addChild(new GameObject()
            .setPos(10, 10, 0)
            .lookAt(new Vector3(0, 0, 0))
            .add(new LightDirectional( 0xffffff, 0.6))
        );

        layer.addChild(new GameObject()
            .add(new S3Mesh(new CubeGeometry( 3, 3, 3 ), new MeshLambertMaterial({color: 0x00ff00})))
            .add(new ComponentExample())
        );

        layer.addChild( new GameObject()
            .add(new CameraCopter(cam))
        );
        
        cam.position.set(10,10,10);
        cam.lookAt(new Vector3());

        haxe.Timer.delay( function(){
            var ob = Assets.getPack('pack').getObject3D("scenery");
            layer.scene.add( ob );
        }, 2000 );

        var layer2d = newLayer2D("2d-layer", true);
        
        layer2d.addChild( new GameObject()
            .add(new ImageSprite("jake"))     
            .add(new AutoPosition(true, true).setPos(0.5,0.5))       
        );
        
    }
}