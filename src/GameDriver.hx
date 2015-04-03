import starling.animation.Tween;
import starling.animation.Juggler;
import starling.animation.Transitions;
import starling.display.MovieClip;
import starling.textures.Texture;
import starling.display.Sprite;
import starling.utils.AssetManager;
import starling.display.Image;
import starling.display.Quad;
import starling.core.Starling;
import starling.events.KeyboardEvent;
import flash.ui.Keyboard;
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
import starling.utils.RectangleUtil;
import flash.geom.Rectangle;

import MovieClipPlus;
import Character;

class GameDriver extends Sprite {
	// Global assets manager
	public static var assets:AssetManager;

	// Keep track of the stage
	static var globalStage:Stage = null;
	
	// In game text objects
	public var gameTitleText:TextField;
	public var scoreText:TextField;
	
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
	
	//For the tilemap
	var tmx:Tilemap;
	
	//vars for scrolling
	//var world;
	
	// Game Characters
	var hero:Character;
	var badBot:Character;
	var goodBot:Character;

    //var for the jump function
    var jump_tween:Tween;
    var guy_juggler:Juggler;
    var heroJumping:Image;
    var currentGround:Float = 0;
	
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
		assets.enqueue("assets/gameoverScreen.png");
		assets.enqueue("assets/gamewinScreen.png");
		
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
		assets.enqueue("assets/cloud.png");
		
		// hero healthbar
		assets.enqueue("assets/health_bar.png");
		
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
	    
	    /*
	    guy_juggler = new Juggler();
	    animate_guy();
	    addEventListener(KeyboardEvent.SPACE, jump_listener);

	    //Code for dat jumping goodness
	    Transitions.register("jump", function(ratio:Float):Float
        {
                return jump_transition(ratio);
        });
        Transitions.register("jump_up", function(ratio:Float):Float
        {
                return jump_transition(ratio/2);
        });
        Transitions.register("jump_down", function(ratio:Float):Float
        {
                return 1-jump_transition(1/2+ratio/2);
        });
        */
        
	}
	
	/*
	private static function jump_transition(ratio:Float):Float
    {
            var v:Float = 4.0;
            var a:Float = -2*v;
            //hero.y += 100;
            //return v*ratio + 1/2*a*ratio*ratio;
            Starling.juggler.add(jump_transition);
    }
    private function jump_listener(e:KeyboardEvent)
    {
            removeEventListener(KeyboardEvent.KEY_DOWN, jump_listener);
            var jump_sound = assets.playSound("Jump.mp3", 150);
            //hero_juggler.purge();
            hero.makeJump();
            jump_tween = new Tween(hero, 1.2, "jump");
            jump_tween.onComplete = function()
            {
                    addEventListener(KeyboardEvent.KEY_DOWN, jump_listener);
                    animate_guy();
            };
            Starling.juggler.add(jump_tween);
    }
    private function animate_guy()
    {
            heroJumping = new Image(1, atlas.getTextures("jumping_guy"), this); 
            var delay = 2.0;
            guy_juggler.purge();
            for (i in 0
    }
    */
    
    
	/**Camera scrolling functions
	private function onEnterFrame(event:EnterFrameEvent):void
	{
		world.x = - hero.x + (stage.stageWidth/2);
		world.y = - hero.y + (stage.stageHeight/2);
  
		//Travel Limits
	
		var ox = stage.stageWidth/2;
		var oy = stage.stageHeight/2;
		
		var maxworld;
	
		maxworld.x = -min(max(hero.x * world.scaleX, ox), 1280 - ox) + stage.stageWidth/2;
	
		maxworld.y = -min(max(hero.y * world.scaleY, oy), 720 - oy) + stage.stageHeight/2;
	}
	**/

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
		startButton = installStartGameButton(920, 100);
		addChild(startButton);
		
		tutorialButton = installTutorialButton(920, 220);
		addChild(tutorialButton);
		
		creditsButton = installCreditsButton(920, 340);
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

		// Load tilemap
		tmx = new Tilemap(GameDriver.assets, "levelone");
		addChild(tmx);
	
		// Set and add mainMenu button
		mainMenuButton = installMainMenuButton(15, 15);
		addChild(mainMenuButton);
		
		// Set and add hero character
		var atlas = GameDriver.assets.getTextureAtlas("sprite_atlas");
		hero = new Character(1, atlas.getTextures("walking_guy"), this);
		hero.setHealthBar(GameDriver.assets.getTexture("health_bar"));
		hero.x = 20;
		hero.y = 300;
		hero.makeStand();
        addChild(hero);
		
		// Set and add badbot character
		badBot = new Character(2, atlas.getTextures("bad_bot"), this);
		badBot.x = 220;
		badBot.y = 420;
        addChild(badBot);
		
		// Set and add goodbot character
		goodBot = new Character(3, atlas.getTextures("good_bot"), this);
		goodBot.x = 400;
		goodBot.y = 268;
        addChild(goodBot);
        
        // bounds for the bad bot and good bot
        var BadBotBound = badBot.bounds;
        var GoodBotBound = goodBot.bounds;
        
	//onEnterFrame();
        
        //Listen for jump input, this does not work
        /*
        Starling.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, 
                        function(event:KeyboardEvent)
                        {
                                if (event.keyCode == Keyboard.SPACE)
                                {
                                        hero.makeJump();
                                        //hero.y -= 100;
                                        //var heroJump = new Image(Character.makeJump());
                                        var travelTime = 1;
                                        var jumpSound = assets.playSound("Jump.mp3", 150);
                                        var heroTween = new Tween(hero, travelTime);
                                        heroTween.delay = 0.0;
                                        heroTween.animate("y", 100);
                                        heroTween.onComplete = function()
                                        {
                                                Starling.juggler.tween(hero, 0.5, 
                                                {
                                                        transition: Transitions.EASE_OUT,
                                                        y: currentGround,
                                                        repeatCount: 1,
                                                        reverse: true
                                                });
                                                //removeChild(hero);
                                                hero.makeStand();
                                        }
                                        var heroTween2 = new Tween(hero, travelTime);
                                        heroTween2.delay = 0.0;
                                        heroTween2.animate("y", -10);
                                        heroTween2.onComplete = function()
                                        {
                                                removeChild(hero);
                                                hero.makeStand;
                                        }
                                        Starling.juggler.add(heroTween);
                                        //Starling.juggler.add(heroTween2);
                                }
                        });
		                */
		
		// map boundaries 
		//var Bound1 = new Rectangle(0,448, 1040, 272);
        var Bound1 = new Rectangle(0,478, 1040, 272);
        // var Bound2 = new Rectangle(192,446, 848, 32);
       	var Bound2 = new Rectangle(242,446, 758, 32);
        var Bound3 = new Rectangle(306,414,694,32);
        var Bound4 = new Rectangle(370,382,550,32);
        var Bound5 = new Rectangle(498,318,230,64);
        var Bound6 = new Rectangle(818,350,6,32);
        var Bound7 = new Rectangle(1090,494,134,256);
        var Bound8 = new Rectangle(1202,462,22,32);
        var Bound9 = new Rectangle(1314,558,102,192);
        var Bound10 = new Rectangle(1506,494,-10,256);
        var Bound11 = new Rectangle(1586,414,6,336);
        var Bound12 = new Rectangle(1682,334,22,416);
        var Bound13 = new Rectangle(1794,254,-10,496);
        var Bound14 = new Rectangle(1874,158,150,592);
        var Bound15 = new Rectangle(2114,398,342,352);
        var Bound16 = new Rectangle(2546,446,6,304);
        var Bound17 = new Rectangle(2643,478,166,272);
        var Bound18 = new Rectangle(2898,398,278,352);
        var Bound19 = new Rectangle(3010, 350, 166, 48);
		
 		Starling.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, 
        function(event:KeyboardEvent){
            if(event.keyCode == Keyboard.LEFT){
            	hero.makeWalk();
            	hero.x -= 10;
            	//TODO currentGround = hero.x;
				
				//if the hero hit the bad bot
            	if(checkCollision(hero, BadBotBound)){
       				hero.makeDizzy();
					//hero.processBotCollision(badBot);
       			}
       			
       			//if the hero hit the good bot
       			if(checkCollision(hero, goodBot.bounds)){
					hero.processBotCollision(goodBot);
       				removeChild(goodBot, true);
       			}
       			
            	// check if the hero hit the bound
            	if(checkCollision(hero, Bound1)||checkCollision(hero, Bound2)||checkCollision(hero, Bound2)||
            	checkCollision(hero, Bound3)||checkCollision(hero, Bound4)||checkCollision(hero, Bound5)||
            	checkCollision(hero, Bound6)||checkCollision(hero, Bound7)||checkCollision(hero, Bound8)||
            	checkCollision(hero, Bound9)||checkCollision(hero, Bound10)||checkCollision(hero, Bound11)||
            	checkCollision(hero, Bound12)||checkCollision(hero, Bound13)||checkCollision(hero, Bound14)||
            	checkCollision(hero, Bound15)||checkCollision(hero, Bound16)||checkCollision(hero, Bound17)||
            	checkCollision(hero, Bound18)||checkCollision(hero, Bound19)){
            		hero.x +=10;
                    //TODO currentGround = hero.x;

                }
                
                // keep the hero on the ground
                while(!checkCollision(hero, Bound1)||!checkCollision(hero, Bound2)||!checkCollision(hero, Bound2)||
            	!checkCollision(hero, Bound3)||!checkCollision(hero, Bound4)||!checkCollision(hero, Bound5)||
            	!checkCollision(hero, Bound6)||!checkCollision(hero, Bound7)||!checkCollision(hero, Bound8)||
            	!checkCollision(hero, Bound9)||!checkCollision(hero, Bound10)||!checkCollision(hero, Bound11)||
            	!checkCollision(hero, Bound12)||!checkCollision(hero, Bound13)||!checkCollision(hero, Bound14)||
            	!checkCollision(hero, Bound15)||!checkCollision(hero, Bound16)||!checkCollision(hero, Bound17)||
            	!checkCollision(hero, Bound18)||!checkCollision(hero, Bound19)){
        			hero.y += 1;
        			currentGround = hero.x;
            	if(checkCollision(hero, Bound1)||checkCollision(hero, Bound2)||checkCollision(hero, Bound2)||
            	checkCollision(hero, Bound3)||checkCollision(hero, Bound4)||checkCollision(hero, Bound5)||
            	checkCollision(hero, Bound6)||checkCollision(hero, Bound7)||checkCollision(hero, Bound8)||
            	checkCollision(hero, Bound9)||checkCollision(hero, Bound10)||checkCollision(hero, Bound11)||
            	checkCollision(hero, Bound12)||checkCollision(hero, Bound13)||checkCollision(hero, Bound14)||
            	checkCollision(hero, Bound15)||checkCollision(hero, Bound16)||checkCollision(hero, Bound17)||
            	checkCollision(hero, Bound18)||checkCollision(hero, Bound19)){
        				hero.y-= 1;
        			    //TODO currentGround = hero.y;
        				break;
        			}
        		}
            }
                        		
            if(event.keyCode == Keyboard.RIGHT){
            	hero.makeWalk();
            	hero.x += 10;
        		//TODO currentGround = hero.x;
				
				//if the hero hit the bad bot
            	if(checkCollision(hero, badBot.bounds)){
       				hero.makeDizzy();
					hero.processBotCollision(badBot);
       			}
       			
       			//if the hero hit the good bot
       			if(checkCollision(hero, goodBot.bounds)){
					hero.processBotCollision(goodBot);
       				removeChild(goodBot, true);
       			}
            	
            	//keep the hero on the ground
            	while(!checkCollision(hero, Bound1)||!checkCollision(hero, Bound2)||!checkCollision(hero, Bound2)||
            	!checkCollision(hero, Bound3)||!checkCollision(hero, Bound4)||!checkCollision(hero, Bound5)||
            	!checkCollision(hero, Bound6)||!checkCollision(hero, Bound7)||!checkCollision(hero, Bound8)||
            	!checkCollision(hero, Bound9)||!checkCollision(hero, Bound10)||!checkCollision(hero, Bound11)||
            	!checkCollision(hero, Bound12)||!checkCollision(hero, Bound13)||!checkCollision(hero, Bound14)||
            	!checkCollision(hero, Bound15)||!checkCollision(hero, Bound16)||!checkCollision(hero, Bound17)||
            	!checkCollision(hero, Bound18)||!checkCollision(hero, Bound19)){
        			hero.y += 1;
        		    //TODO currentGround = hero.y;
            	if(checkCollision(hero, Bound1)||checkCollision(hero, Bound2)||checkCollision(hero, Bound2)||
            	checkCollision(hero, Bound3)||checkCollision(hero, Bound4)||checkCollision(hero, Bound5)||
            	checkCollision(hero, Bound6)||checkCollision(hero, Bound7)||checkCollision(hero, Bound8)||
            	checkCollision(hero, Bound9)||checkCollision(hero, Bound10)||checkCollision(hero, Bound11)||
            	checkCollision(hero, Bound12)||checkCollision(hero, Bound13)||checkCollision(hero, Bound14)||
            	checkCollision(hero, Bound15)||checkCollision(hero, Bound16)||checkCollision(hero, Bound17)||
            	checkCollision(hero, Bound18)||checkCollision(hero, Bound19)){
        				hero.y-= 1;
        		        //TODO currentGround = hero.y;
        				break;
        			}
        		}
            	
            	//check if the hero hit the bounds 
            	if(checkCollision(hero, Bound1)||checkCollision(hero, Bound2)||checkCollision(hero, Bound2)||
            	checkCollision(hero, Bound3)||checkCollision(hero, Bound4)||checkCollision(hero, Bound5)||
            	checkCollision(hero, Bound6)||checkCollision(hero, Bound7)||checkCollision(hero, Bound8)||
            	checkCollision(hero, Bound9)||checkCollision(hero, Bound10)||checkCollision(hero, Bound11)||
            	checkCollision(hero, Bound12)||checkCollision(hero, Bound13)||checkCollision(hero, Bound14)||
            	checkCollision(hero, Bound15)||checkCollision(hero, Bound16)||checkCollision(hero, Bound17)||
            	checkCollision(hero, Bound18)||checkCollision(hero, Bound19)){
                	hero.x -= 10;
        		    //TODO currentGround = hero.x;
                }
        	}
        	
        	    if(event.keyCode == Keyboard.SPACE)
        	    {
        	            hero.makeJump();
                        makeJump(); 
                            
                        while(!checkCollision(hero, Bound1)||!checkCollision(hero, Bound2)||!checkCollision(hero, Bound2)||
                        !checkCollision(hero, Bound3)||!checkCollision(hero, Bound4)||!checkCollision(hero, Bound5)||
                        !checkCollision(hero, Bound6)||!checkCollision(hero, Bound7)||!checkCollision(hero, Bound8)||
                        !checkCollision(hero, Bound9)||!checkCollision(hero, Bound10)||!checkCollision(hero, Bound11)||
                        !checkCollision(hero, Bound12)||!checkCollision(hero, Bound13)||!checkCollision(hero, Bound14)||
                        !checkCollision(hero, Bound15)||!checkCollision(hero, Bound16)||!checkCollision(hero, Bound17)||
                        !checkCollision(hero, Bound18)||!checkCollision(hero, Bound19))
                        {
                            hero.y += 1;
                            //TODO currentGround = hero.y;
                            if(checkCollision(hero, Bound1)||checkCollision(hero, Bound2)||checkCollision(hero, Bound2)||
                            checkCollision(hero, Bound3)||checkCollision(hero, Bound4)||checkCollision(hero, Bound5)||
                            checkCollision(hero, Bound6)||checkCollision(hero, Bound7)||checkCollision(hero, Bound8)||
                            checkCollision(hero, Bound9)||checkCollision(hero, Bound10)||checkCollision(hero, Bound11)||
                            checkCollision(hero, Bound12)||checkCollision(hero, Bound13)||checkCollision(hero, Bound14)||
                            checkCollision(hero, Bound15)||checkCollision(hero, Bound16)||checkCollision(hero, Bound17)||
                            checkCollision(hero, Bound18)||checkCollision(hero, Bound19))
                            {
                                hero.y-= 1;
                                //TODO currentGround = hero.y;
                                break;
                            }
                                //check if the hero hit the bounds 
                                if(checkCollision(hero, Bound1)||checkCollision(hero, Bound2)||checkCollision(hero, Bound2)||
                                checkCollision(hero, Bound3)||checkCollision(hero, Bound4)||checkCollision(hero, Bound5)||
                                checkCollision(hero, Bound6)||checkCollision(hero, Bound7)||checkCollision(hero, Bound8)||
                                checkCollision(hero, Bound9)||checkCollision(hero, Bound10)||checkCollision(hero, Bound11)||
                                checkCollision(hero, Bound12)||checkCollision(hero, Bound13)||checkCollision(hero, Bound14)||
                                checkCollision(hero, Bound15)||checkCollision(hero, Bound16)||checkCollision(hero, Bound17)||
                                checkCollision(hero, Bound18)||checkCollision(hero, Bound19)){
                                    hero.x -= 10;
                                    //TODO currentGround = hero.x;
                                }
                        }
        		}

            
            if(event.keyCode == Keyboard.DOWN){
            	hero.y += 10;
        		//TODO currentGround = hero.y;
            	if(checkCollision(hero, Bound1)||checkCollision(hero, Bound2)||checkCollision(hero, Bound2)||
            	checkCollision(hero, Bound3)||checkCollision(hero, Bound4)||checkCollision(hero, Bound5)||
            	checkCollision(hero, Bound6)||checkCollision(hero, Bound7)||checkCollision(hero, Bound8)||
            	checkCollision(hero, Bound9)||checkCollision(hero, Bound10)||checkCollision(hero, Bound11)||
            	checkCollision(hero, Bound12)||checkCollision(hero, Bound13)||checkCollision(hero, Bound14)||
            	checkCollision(hero, Bound15)||checkCollision(hero, Bound16)||checkCollision(hero, Bound17)||
            	checkCollision(hero, Bound18)||checkCollision(hero, Bound19)){
                	hero.y -= 10;
        		    //TODO currentGround = hero.y;
                }
        	}
            }); 
		return;
	}

	public function makeJump()
    {

		//Starling.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, function(event:KeyboardEvent)
		//{
		        //if (event.keyCode == Keyboard.SPACE)
                //{
                        hero.makeJump();
                        Starling.juggler.tween(hero, 0.8,
                        {
                                transition: Transitions.EASE_OUT,
                                y: currentGround,
                                repeatCount: 2,
                                reverse: true
                        });
                        //hero.makeStand();
                //}
        //});
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
		tutorialText += "How To Play:\n";
		tutorialText += "  1. Use the arrow keys to move the hippie right and left.\n";
		tutorialText += "  2. Press the up arrow to make the hippie jump.\n";
		tutorialText += "  3. Collect the peace signs to increase the hippies score.\n";
		tutorialText += "  4. Avoid touching the mushrooms, they will cause the hippie to lose health.\n";
		tutorialText += "  5. If the hippie looses all of his health, he will die.\n";
		tutorialText += "  6. Reach 20 points to win!\n";
		
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
		designerText += "Veronika Alves\n";
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
	
	/** Called when the game is over */
	public function triggerGameOver(winGame:Bool) {
		this.removeChildren();
		startScreen();
		
		// local vars
		var container = new Sprite();
		var displayText:TextField = null;
		var bg:Image;
		
		if (!winGame){
			displayText = installText(470, 125, "You lose!", "creditsFont01", 65);
			bg = new Image(assets.getTexture("gameoverScreen"));
		} else {
			displayText = installText(470, 125, "You Win!", "gameFont01", 65);
			bg = new Image(assets.getTexture("gamewinScreen"));
		}
		
		container.addChild(bg);
		container.addChild(displayText);
		addChild(container);
		
		Starling.juggler.tween(container, 2, {
			transition: Transitions.EASE_OUT,
			delay: 4,
			alpha: 0,
			onComplete: function(){
				startScreen();
			}
		});
		
		return;
	}
	
	/** Restart the game */
	private function restartGame(){
		this.removeChildren();
		startGame();
	}
	
	/** Install game text **/
	public function installText(x:Int, y:Int, myText:String, myFont:String, myFontsize:Int, myHAlign:String = "left", myAutoSize:String = "vertical") {
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
	
	// Check Collision
    private function checkCollision(texture1:Image, texture2:Rectangle):Bool {
        return (texture1.bounds.intersects(texture2));
    }

    

}
