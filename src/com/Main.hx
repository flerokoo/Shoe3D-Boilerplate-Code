package com;

import shoe3d.*;
import shoe3d.asset.*;
import shoe3d.screen.BasicPreloader;
class Main 
{
	
	public static var pack:AssetPack;	
	public static var font:Font;
	public static var font2:Font;
	
	@:expose
	static function main() 
	{
		// init and setting original game resolution (in which game is supposed to be)
		System.init( 640, 800 );			
		#if debug  
		System.showFPSMeter();  
		#end

		// Setting window mode: Fill or Default
		// System.window.mode = Default;	
		
		// Setting canvas size
		// System.window.setSize( 600, 600 );		
		
		// Target orientation (engine will try to lock orientation 
		// otherwise "rotate-yo-phone" will be shown (wasn't implemented yet, sorry)
		//System.window.setTargetOrientation( Portrait );
		
		// Calls prepareGame after load is complete and show start button
		// Calls startGame on button press
		//NicePreloader.loadFolderFromAssets( "pack", prepareGame, startGame );			

		BasicPreloader.loadFolderFromAssets( "pack", function(pack){
			prepareGame(pack);
			startGame();
		});
		
	}	
	
	static function prepareGame( pack:AssetPack )
	{
		System.screen.addScreen( 'mainMenu', com.screens.MainMenu );
		trace("PREPS");
	}
	
	static function startGame( )
	{
		System.screen.show( 'mainMenu' );		
		trace("STARTING");	
	}
}