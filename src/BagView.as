package  
{
	import data.Assets;
	import flash.geom.Point;
	import screens.GameScreen;
	import screens.Screens;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;
	
	/**
	 * ...
	 * @author rkardashov@gmail.com
	 */
	public class BagView extends Sprite /*GoodsDropArea *//*implements IGoodReceiver*/
	{
		static public const BAG_X: int = 16;
		static public const STATE_NO_BAG: int = -1;
		static public const STATE_EMPTY: int = 0;
		static public const STATE_FULL: int = 1;
		
		private var state: int;
		
		private var dropArea: ItemsDropArea;
		private var bagFrames: MovieClip;
		
		private var category: int;
		private var bag: Bag;
		
		private var redLayer: Image;
		
		public function BagView(category: int) 
		{
			this.category = category;
			bag = new Bag(category);
			
			y = int(category * Screens.unit * 1.5 + 100);
			
			var icon: Image = Assets.getImage("category_" + category);
			if (icon)
			{
				addChild(icon);
				icon.x = 1;
				icon.y = 6;
			}
			
			var frames: Vector.<Texture> = Assets.getTextures("bag_" + category);
			frames.unshift(Assets.getTexture("bag"));
			addChild(bagFrames = new MovieClip(frames));
			bagFrames.currentFrame = 0;
			bagFrames.x = BAG_X;
			bagFrames.smoothing = TextureSmoothing.NONE;
			
			addChild(redLayer = Assets.getImage("bag_red_layer"));
			redLayer.alpha = 0;
			redLayer.touchable = false;
			redLayer.x = bagFrames.x;
			
			addChild(dropArea = new ItemsDropArea(null, null, /*null, */width, height));
			state = STATE_NO_BAG;
			
			addEventListener(TouchEvent.TOUCH, onTouch);
			GameEvents.subscribe(GameEvents.CUSTOMER_COMPLETE, reset);
			GameEvents.subscribe(GameEvents.BAG_GOOD_ADDED, onGoodAdded);
			GameEvents.subscribe(GameEvents.BAG_WRONG_GOOD, onWrongGood);
		}
		
		private function onGoodAdded(e: Event, b: Bag):void 
		{
			if (b.category == category)
				update();
		}
		
		private function onWrongGood(e: Event, b: Bag): void 
		{
			if (b.category == category)
			//var t: Tween = 
			Starling.juggler.tween(redLayer, 0.15, 
				{
					//color: 0x88FF0000,
					alpha: 0.5,
					transition: Transitions.EASE_IN_OUT_BACK,
					repeatCount: 8,
					reverse: true,
					onComplete: function():void {
						redLayer.alpha = 0;
					}
				} );// as Tween;
			//t.repeatCount = 3;
			//t.
		}
		
		private function onTouch(e: TouchEvent): void 
		{
			var touch: Touch;
			
			touch = e.getTouch(this, TouchPhase.MOVED);
			if (touch && (state > STATE_NO_BAG))
			{
				bagFrames.x = Math.min(BAG_X, 
					int(bagFrames.x + touch.getMovement(this).x));
			}
			
			touch = e.getTouch(this, TouchPhase.ENDED);
			if (touch)
			{
				if (state == STATE_NO_BAG)
				{
					state = STATE_EMPTY;
					/*bags.unshift(new Bag(this, category));
					dropArea.target = bags[0];*/
					addBag();
				}
				else
				{
					if (bagFrames.x < -bagFrames.width / 2)
					{
						state = STATE_NO_BAG;
						dropArea.target = null;
					}
				}
				bagFrames.x = BAG_X;
				update();
			}
		}
		
		private function addBag(): void
		{
			//bags.unshift(new Bag(/*this, */category));
			bag.recycle();
			dropArea.target = bag;// s[0];
			GameEvents.dispatch(GameEvents.BAG_NEW, bag);// s[0]);
		}
		
		public function update(): void 
		{
			bagFrames.visible = (state > STATE_NO_BAG);
			//if (bags.length)
				bagFrames.currentFrame =
					bag/*s[0]*/.fillState * (bagFrames.numFrames - 1);
		}
		
		public function reset(): void 
		{
			bag.recycle();
			//while (bags.length)
				//bags.pop().recycle();
			dropArea.target = null;
			//state = STATE_EMPTY;
			state = STATE_NO_BAG;
			update();
		}
	}
}
