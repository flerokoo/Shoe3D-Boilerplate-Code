package com;

import shoe3d.util.Log;
import shoe3d.*;
import shoe3d.asset.*;
import shoe3d.screen.BasicPreloader;
import shoe3d.component.*;

class Main
{

    @:expose
    static function main()
    {

        // Init and set original game resolution (in which game is supposed to be)
        System.init(GameMeta.width, GameMeta.height);

        #if debug
        System.showFPSMeter();
        #end

        // Setting window mode: Fill or Default
        // System.window.mode = Default;

        // Target orientation (engine will try to lock orientation
        // otherwise "rotate-yo-phone" will be shown (wasn't implemented yet, sorry)
        // System.window.setTargetOrientation( Portrait );

        // Calls prepareGame after load is complete and show start button
        // Calls startGame on button press
        // NicePreloader.loadFolderFromAssets( "pack", prepareGame, startGame );

        BasicPreloader.loadFolderFromAssets( "pack", function(pack)
        {
            prepareGame(pack);
            startGame();
        });

    }

    static function prepareGame( pack:AssetPack )
    {
        System.screen.addScreen( 'mainMenu', com.screens.MainMenu );
    }

    static function startGame( )
    {
        System.screen.show( 'mainMenu' );
    }
}