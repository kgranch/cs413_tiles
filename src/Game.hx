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
import flash.ui.GameInput;
import flash.ui.GameInputControl;
import flash.ui.GameInputDevice;
import flash.events.GameInputEvent;
import starling.text.TextField;
import flash.utils.Dictionary;

class Game extends Sprite {
  // Global assets manager
  public static var assets:AssetManager;
  
  //Initialize it immediately - VERY important to now move this.
  var gi = new GameInput();
  
  //score
  var Score:Text;
  
  //buttons
  var MainMenu:Button;
  
  // sprites
  var Hippie:Sprite;
  var Grass:Sprite;
  var GameOver:Sprite;
  var Mushroom:Sprite;
  
  gi.addEventListener("device_added", handleDeviceAdded);
}

function handleDeviceAdded(event:DeviceAdded) {
}

function onKeyDown(event:KeyboardEvent) {
    if (event.keyCode == Keyboard.SPACE) {
    
    }
    if (event.keyCode == Keyboard.LEFT){
      
    }
    if (event.keyCode == Keyboard.RIGHT){
      
    }
}

function scrollMap(){
  screenMatrix = new Matrix(SCREEN_COLS, SCREEN_ROWS);
 
  for (var rowCtr:int = 0;rowCtr < SCREEN_ROWS; rowCtr++)
  {
    for (var colCtr:int = 0; colCtr < SCREEN_COLS; colCtr++)
    {
	      //var tileSprite:Sprite = new Sprite();
	      var image:Image = new Image(tilesetVector[levelMatrix.GetItem(colCtr, rowCtr)]);
	      //tileSprite.addChild(image);
        //tileSprite.flatten();					
 
	    //screenMatrix.PutItem(colCtr, rowCtr, tileSprite);
  	  screenMatrix.PutItem(colCtr, rowCtr, image);
	    screenMatrix.GetItem(colCtr, rowCtr).x = colCtr * TILE_WIDTH;
	    screenMatrix.GetItem(colCtr, rowCtr).y = rowCtr * TILE_HEIGHT;
	    addChild(screenMatrix.GetItem(colCtr, rowCtr));
 
      }
    }
  }
  
}

//Insert the map reading here
function readMap(){
  int get_x;
  int get_y;
}
