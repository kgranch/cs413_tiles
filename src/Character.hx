﻿import starling.core.Starling;
import starling.display.Sprite;
import starling.textures.Texture;
import starling.display.Image;

import MovieClipPlus;
import HealthBar;

class Character extends MovieClipPlus {
	/** Local vars */
	public var heroBotType:Int = 1;
	public var badBotType:Int = 2;
	public var goodBotType:Int = 3;
	public var gameDriver:GameDriver;
	
	// Game character stats
	public var health:Int;
	public var healthBar:HealthBar;
	
	/** Constructor */
	public function new (botType:Int, textures:flash.Vector<Texture>, gameDriver:GameDriver, fps:Int=8) {
		super(textures, fps);
		this.health = 4;
		this.gameDriver = gameDriver;
		
		if(botType == heroBotType) {
			this.initializeHero();
		}
		else if(botType == badBotType) {
			this.initializeBadBot();
		}
		else if(botType == goodBotType) {
			this.initializeGoodBot();
		}
	}

	/** Create and return game hero */
	public function initializeHero() {
		this.scaleX = .20;
		this.scaleY = .20;
		
		Starling.juggler.add(this);
        this.stop();
	}

	/** Create and return game bad bot */
	public function initializeBadBot() {
		this.scaleX = .20;
		this.scaleY = .20;
		
		Starling.juggler.add(this);
        this.stop();
	}

	/** Create and return game good bot */
	public function initializeGoodBot() {
		this.scaleX = .20;
		this.scaleY = .20;
		
		Starling.juggler.add(this);
        this.stop();
	}
	
	public function setHealthBar(healthBarTexture:Texture) {
		healthBar = new HealthBar(400,25,healthBarTexture);
		healthBar.defaultColor = healthBar.color;
		healthBar.x = gameDriver.stage.stageWidth/2 - healthBar.maxWidth/2;
		healthBar.y = 25;
		
		var tHealthbar = new Image(healthBarTexture);
		tHealthbar.width = healthBar.maxWidth;
		tHealthbar.height = healthBar.height;
		tHealthbar.x = healthBar.x;
		tHealthbar.y = healthBar.y;
		tHealthbar.alpha = 0.2;
			
		gameDriver.addChild(tHealthbar);
		gameDriver.addChild(healthBar);
	}
	
	public function makeWalk() {
		// make hero walk
		this.setNext(4, 0);
		this.gotoAndPlay(4);
	}
	
	public function makeStand() {
		// make hero stand
		this.setNext(6, 6);
		this.gotoAndPlay(6);
	}
	
	public function makeJump() {
		// make hero jump
		this.setNext(5, 5);
		this.gotoAndPlay(5);
	}
	
	public function makeDizzy() {
		// make hero dizzy
		this.setNext(8, 7);
		this.gotoAndPlay(7);
	}
}