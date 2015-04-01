import starling.core.Starling;
import starling.display.Sprite;
import starling.textures.Texture;

import MovieClipPlus;
import HealthBar;

class Character extends MovieClipPlus {
	/** Local vars */
	
	// Game character stats
	public var health:Int;
	
	/** Constructor */
	public function new (textures:flash.Vector<Texture>, fps:Int=8) {
		super(textures, fps);
		health = 4;
	}

	/** Create and return game hero */
	public function initializeHero() {
		this.scaleX = .25;
		this.scaleY = .25;
		
		// set hero's starting position
		this.x = 20;
		this.y = 250;
		Starling.juggler.add(this);
        this.stop();
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