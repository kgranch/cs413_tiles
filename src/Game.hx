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
import flash.utils.Dictionary;

class GameDriver extends Sprite {
  // Global assets manager
  public static var assets:AssetManager;
  
  // sprites
  var Hippie:Sprite;
  var Grass:Sprite;
  var GameOver:Sprite;
  var Mushroom:Sprite;
}

function onKeyDown(event:KeyboardEvent) {
}
