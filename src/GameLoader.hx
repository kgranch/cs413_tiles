import flash.display.Bitmap;
import flash.display.Sprite;
import flash.geom.Rectangle;
import starling.core.Starling;

@:bitmap("assets/loadingScreen.png")
class LoadingBitmapData extends flash.display.BitmapData { }

class GameLoader extends Sprite {

    public var loadingBitmap:Bitmap;
    public var startup:Sprite;

    function new() {
        super();
        startup = this;
        loadingBitmap = new Bitmap(new LoadingBitmapData(0, 0));
        loadingBitmap.x = 0;
        loadingBitmap.y = 0;
        loadingBitmap.width = flash.Lib.current.stage.stageWidth;
        loadingBitmap.height = flash.Lib.current.stage.stageHeight;
        loadingBitmap.smoothing = true;
        addChild(loadingBitmap);

        flash.Lib.current.stage.addEventListener(flash.events.Event.RESIZE,
            function(e:flash.events.Event) {
                Starling.current.viewPort = new Rectangle(0, 0,
                flash.Lib.current.stage.stageWidth,
                flash.Lib.current.stage.stageHeight);
                if (loadingBitmap != null) {
                    loadingBitmap.width = flash.Lib.current.stage.stageWidth;
                    loadingBitmap.height = flash.Lib.current.stage.stageHeight;
                }});

		var mStarling = new Starling(GameDriver, flash.Lib.current.stage);
		mStarling.antiAliasing = 0;
		function onGameDriverCreated(event:Dynamic, root:GameDriver) {
			mStarling.removeEventListener(starling.events.Event.ROOT_CREATED,
			    onGameDriverCreated);
            root.start(this, mStarling.stage);
            mStarling.start();
        }
        mStarling.addEventListener(starling.events.Event.ROOT_CREATED,
		    onGameDriverCreated);
    }

    static function main() {
        var stage = flash.Lib.current.stage;
        stage.addChild(new GameLoader());
    }

}