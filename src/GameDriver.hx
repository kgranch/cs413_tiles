import starling.animation.Tween;
import starling.animation.Transitions;
import starling.display.MovieClip;
import starling.textures.Texture;
import starling.display.Sprite;
import starling.utils.AssetManager;
import starling.display.Image;
import starling.display.Quad;
import starling.core.Starling;
import starling.events.KeyboardEvent;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.display.Button;
import starling.events.Event;
import starling.textures.Texture;
import starling.events.EnterFrameEvent;
import starling.display.Stage;
import flash.media.Sound;
import flash.media.SoundChannel;
import flash.media.SoundTransform;
import starling.text.TextField;
import starling.events.KeyboardEvent;
import flash.ui.Keyboard;

import MovieClipPlus;

class GameDriver extends Sprite {
	// Global assets manager
	public static var assets:AssetManager;

	// Keep track of the stage
	static var globalStage:Stage = null;
	
	// In game text objects
	public var gameTitleText:TextField;
	
	
	// Interactive Buttons
	var startButton:Button;
	var mainMenuButton:Button;
	var creditsButton:Button;
	var tutorialButton:Button;
	
	// Menu Screens
	var mainScreen:Image;
	var creditsScreen:Image;
	var tutorialScreen:Image;
	var gameScreen:Image;
	
	// For the tilemap
	var tmx:Tilemap;
	
	// Game Characters
	var hero:MovieClipPlus;
	var badBot:MovieClipPlus;
	var goodBot:MovieClipPlus;
	
	/** Constructor */
	public function new() {
		super();
	}
	
	/** Function used to load in any assets to be used during the game */
	private function populateAssetManager() {
		assets = new AssetManager();
		
		// game buttons
		assets.enqueue("assets/mainMenuButton.png");
		assets.enqueue("assets/startButton.png");
		assets.enqueue("assets/creditsButton.png");
		assets.enqueue("assets/tutorialButton.png");
		
		// game screens
		assets.enqueue("assets/mainScreen.png");
		assets.enqueue("assets/tutorialScreen.png");
		assets.enqueue("assets/creditsScreen.png");
		assets.enqueue("assets/gameScreen.png");
		
		// game font
		assets.enqueue("assets/gameFont01.fnt");
		assets.enqueue("assets/gameFont01.png");
		assets.enqueue("assets/mainMenuFont01.fnt");
		assets.enqueue("assets/mainMenuFont01.png");
		assets.enqueue("assets/creditsFont01.fnt");
		assets.enqueue("assets/creditsFont01.png");
		assets.enqueue("assets/tutorialFont01.fnt");
		assets.enqueue("assets/tutorialFont01.png");

		//tilemap
		assets.enqueue("assets/skyone.png");
		assets.enqueue("assets/skytwo.png");
		assets.enqueue("assets/skythree.png");
		assets.enqueue("assets/dirtBlock.png");
		
		// game sprite atlas
		assets.enqueue("assets/sprite_atlas.xml");
		assets.enqueue("assets/sprite_atlas.png");
	}

	/** Function called from the initial driver, sets up the root class */
	public function start(startup:GameLoader, startupStage:Stage) {
		// Prep all asset paths
		populateAssetManager();
		
		// Set the global stage to the starling stage
		globalStage = startupStage;
		
		// Start loading in the assets
		assets.loadQueue(function onProgress(ratio:Int) {
			if (ratio == 1) {	
				startScreen();

				// Fade out the loading screen since everything is loaded
				Starling.juggler.tween(startup.loadingBitmap, 1, {
					transition: Transitions.EASE_OUT,
					delay: 3,
					alpha: 0,
					onComplete: function() {
					startup.removeChild(startup.loadingBitmap);
				}});
			}
		});
	}
	
	/** Do stuff with the menu screen */
	private function startScreen() {
		// Clear the stage
		this.removeChildren();
		
		mainScreen = new Image(GameDriver.assets.getTexture("mainScreen"));
		addChild(mainScreen);
		
		// Set and display game title
		gameTitleText = installText(0,20, "The Hippie's Great Adventure", "mainMenuFont01", 55, "center");
		addChild(gameTitleText);
		
		// Set and add start game button
		startButton = installStartGameButton(415, 550);
		addChild(startButton);
		
		tutorialButton = installTutorialButton(590, 550);
		addChild(tutorialButton);
		
		creditsButton = installCreditsButton(765, 550);
		addChild(creditsButton);
	}
	

		//Loading the tilemap (This is from the Starling docs)
	    /*
		tmx = new Tilemap();
		tmx.addEventListener(Event.COMPLETE, drawLayers);
		tmx.load("levelone.tmx");

		public function drawLayers(event:Event):void
        {
                for (var i:int = 0; i < tmx.layers().length; i++)
                {
                        addChild(tmx.layers()[i].getHolder());
                }
        }*/

	/** Function to be called when we are ready to start the game */
	private function startGame() {
		// Clear the stage
		this.removeChildren();
		
		// Set and display game screen background
		gameScreen = new Image(GameDriver.assets.getTexture("gameScreen"));
		addChild(gameScreen);
		
		// Set and display startgame title
		var titleText:TextField = installText(0,20, "Game Goes Here", "gameFont01", 55, "center");
		addChild(titleText);
	
		// Set and add mainMenu button
		mainMenuButton = installMainMenuButton(590, 550);
		addChild(mainMenuButton);

		// Load tilemap
		tmx = new Tilemap(GameDriver.assets, "levelone");
		addChild(tmx);
		
		// Set and add hero character

		hero = createHero();
		hero.x = 20;
        hero.y = 330;
        addChild(hero);
		makeHeroStand();
		
		// Set and add hero character
		badBot = createBadBot();
		badBot.x = (globalStage.stageWidth - hero.width)/2 - 100;
        badBot.y = 268;
        addChild(badBot);
		
		// Set and add hero character
		goodBot = createGoodBot();
		goodBot.x = (globalStage.stageWidth - hero.width)/2 + 100;
        goodBot.y = 235;
        addChild(goodBot);
        
        Starling.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, 
        function(event:KeyboardEvent){
        	trace(event.keyCode);
            if (event.keyCode == Keyboard.LEFT) {
				// go to walking
				makeHeroWalk();
				
                hero.x -= 10;			
            }
                        		
            if (event.keyCode == Keyboard.RIGHT) {
				// go to walking
				makeHeroWalk();
				
            	hero.x += 10;
            }
            
            if (event.keyCode == Keyboard.UP) {
				// go to dizzy position
				makeHeroDizzy();
				
            	hero.y += 20;
            	hero.y -= 20;
            }
            
            if (event.keyCode == Keyboard.DOWN) {
				// go standing position
				makeHeroStand();
            }
            
            if (event.keyCode == Keyboard.SPACE) {
				// go to jump position
				makeHeroJump();
				
            	hero.y += 20;
            	}
            if(event.keyCode == Keyboard.UP){
            	hero.y -= 20;
            }
            
            });

		return;
	}
	
	/** Install hero character movieclip at (x,y) coordinates */
	function createHero() {
		var cHero:MovieClipPlus;
		
		// Create hero character
		var atlas = GameDriver.assets.getTextureAtlas("sprite_atlas");
		cHero = new MovieClipPlus(atlas.getTextures("walking_guy"), 8);
		cHero.scaleX = .25;
		cHero.scaleY = .25;
		Starling.juggler.add(cHero);
        cHero.stop();
		
		// Return hero movieclip
		return cHero;
	}
	
	function makeHeroWalk() {
		// make hero walk
		hero.setNext(4, 0);
		hero.gotoAndPlay(4);
	}
	
	function makeHeroStand() {
		// make hero stand
		hero.setNext(6, 6);
		hero.gotoAndPlay(6);
	}
	
	function makeHeroJump() {
		// make hero jump
		hero.setNext(5, 5);
		hero.gotoAndPlay(5);
	}
	
	function makeHeroDizzy() {
		// make hero dizzy
		hero.setNext(8, 7);
		hero.gotoAndPlay(7);
	}
	
	/** Install bad bot character movieclip at (x,y) coordinates */
	function createBadBot() {
		var cbot:MovieClipPlus;
		
		// Create hero character
		var atlas = GameDriver.assets.getTextureAtlas("sprite_atlas");
		cbot = new MovieClipPlus(atlas.getTextures("bad_bot"), 1);
		cbot.scaleX = .35;
		cbot.scaleY = .35;
		Starling.juggler.add(cbot);
        cbot.stop();
		
		// Return hero movieclip
		return cbot;
	}
	
	/** Install good bot character movieclip at (x,y) coordinates */
	function createGoodBot() {
		var cbot:MovieClipPlus;
		
		// Create hero character
		var atlas = GameDriver.assets.getTextureAtlas("sprite_atlas");
		cbot = new MovieClipPlus(atlas.getTextures("good_bot"), 1);
		cbot.scaleX = .35;
		cbot.scaleY = .35;
		Starling.juggler.add(cbot);
        cbot.stop();
		
		// Return hero movieclip
		return cbot;
	}

	/** Check Collision */
	private function checkCollision(texture1:Image, texture2:Image):Bool {
        return (texture1.bounds.intersects(texture2.bounds));
	}
	
	/** Display the rules menu */
	private function viewTutorial() {
		// local vars
		var titleText:TextField;
		var tutorialText:String = "";
		var gameTutorialText:TextField;
		
		// Clear the stage
		this.removeChildren();
		
		tutorialScreen = new Image(GameDriver.assets.getTexture("tutorialScreen"));
		addChild(tutorialScreen);
		
		// Set and display game tutorial title
		titleText = installText(0,20, "Game Tutorial", "tutorialFont01", 55, "center");
		addChild(titleText);
		
		// Set and display game designers
		tutorialText += "This is how you play the game.\n";
		tutorialText += "  1. Use the arrow keys to move the character and Space to jump.\n";
		tutorialText += "  2. Collect the powerups along the way.\n";
		tutorialText += "  3. Avoid death whenever possible.\n";
		
		gameTutorialText = installText(100,200, tutorialText, "tutorialFont01", 25, "left", "bothDirections");
		addChild(gameTutorialText);
	
		// Set and add mainMenu button
		mainMenuButton = installMainMenuButton(590, 550);
		addChild(mainMenuButton);
		return;
	}
	
	/** Function to be called when looking at the credits menu*/
	private function viewCredits() {
		// local vars
		var titleText:TextField;
		var designerText:String = "";
		var gameDesignerText:TextField;
		
		// Clear the stage
		this.removeChildren();
		
		creditsScreen = new Image(GameDriver.assets.getTexture("creditsScreen"));
		addChild(creditsScreen);
		
		// Set and display game credits title
		titleText = installText(0,20, "Game Developers", "creditsFont01", 55, "center");
		addChild(titleText);
		
		// Set and display game designers
		designerText += "Veronica Alves\n";
		designerText += "Waylon Dixon\n";
		designerText += "Kyle Granchelli\n";
		designerText += "Matthew Ostovarpour\n";
		designerText += "Brian Saganey\n";
		
		gameDesignerText = installText(0,200, designerText, "creditsFont01", 35, "center");
		addChild(gameDesignerText);
	
		// Set and add mainMenu button
		mainMenuButton = installMainMenuButton(590, 550);
		addChild(mainMenuButton);	
		return;
	}
	
	/** Restart the game */
	private function restartGame(){
		this.removeChildren();
		startGame();
	}
	
	private function installText(x:Int, y:Int, myText:String, myFont:String, myFontsize:Int, myHAlign:String = "left", myAutoSize:String = "vertical") {
		// local vars
		var gameText:TextField;
		
		// note: possible values for parameters:
		// myHAlign: left, right, center
		// myAutoSize: vertical, horizontal, bothDirections, none
		
		gameText = new TextField(globalStage.stageWidth, globalStage.stageHeight, myText);
		gameText.fontName = myFont;
		gameText.fontSize = myFontsize;
		gameText.color = 0xffffff;
		gameText.hAlign = myHAlign;
		gameText.autoSize = myAutoSize;
		gameText.x = x;
		gameText.y = y;
		
		return gameText;
	}
	
	/** Install start game button at (x,y) coordinates */
	function installStartGameButton(x:Int, y:Int) {
		var sgButton:Button;
						
		sgButton = new Button(GameDriver.assets.getTexture("startButton"));
		sgButton.x = x;
		sgButton.y = y;
		
		// On button press, display game screen
		sgButton.addEventListener(Event.TRIGGERED, startGame);
		
		// Return start game button
		return sgButton;
	}
	
	/** Install game tutorial button at (x,y) coordinates */
	function installTutorialButton(x:Int, y:Int) {
		var tButton:Button;
						
		tButton = new Button(GameDriver.assets.getTexture("tutorialButton"));
		tButton.x = x;
		tButton.y = y;
		
		// On button press, display tutorial
		tButton.addEventListener(Event.TRIGGERED, viewTutorial);
		
		// Return tutorial button
		return tButton;
	}
	
	
	/** Install game tutorial button at (x,y) coordinates */
	function installCreditsButton(x:Int, y:Int) {
		var cButton:Button;
						
		cButton = new Button(GameDriver.assets.getTexture("creditsButton"));
		cButton.x = x;
		cButton.y = y;
		
		// On button press, display tutorial
		cButton.addEventListener(Event.TRIGGERED, viewCredits);
		
		// Return tutorial button
		return cButton;
	}
	
	/** Install main menu button at (x,y) coordinates */
	function installMainMenuButton(x:Int, y:Int) {		
		var mmButton:Button;
		
		// Make main menu button and set location
		mmButton = new Button(GameDriver.assets.getTexture("mainMenuButton"));
		mmButton.x = x;
		mmButton.y = y;
	
		// On button press, display the main menu
		mmButton.addEventListener(Event.TRIGGERED, startScreen);
		
		// Return main menu button
		return mmButton;
	}
}
