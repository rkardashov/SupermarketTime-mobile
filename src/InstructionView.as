package
{
	import data.Assets;
	import data.DayData;
	import starling.display.DisplayObject;
	import starling.display.Image;
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
	public class InstructionView extends Sprite 
	{
		static public const MAX_APLHA: Number = 0.8;
		/*private var index: int = 0;
		private function get instruction(): Instruction
		{
			if (tutorial && (index < tutorial.instructions.length))
				return tutorial.instructions[index];
			return null;
		}*/
		private var instruction: data.SpeechPhrase = null;
		private var tutorial: Tutorial;
		private var capturedEvent:Event;
		
		public function InstructionView() 
		{
			super();
			addEventListener(TouchEvent.TOUCH, onTouch);
			GameEvents.subscribe(GameEvents.DAY_START, onGameEvent);
			GameEvents.subscribe(GameEvents.CUSTOMER_ARRIVED, onGameEvent);
			GameEvents.subscribe(GameEvents.GOOD_ENTER, onGameEvent);
			GameEvents.subscribe(GameEvents.GOOD_SCANNED, onGameEvent);
			GameEvents.subscribe(GameEvents.GOODS_COMPLETE, onGameEvent);
			GameEvents.subscribe(GameEvents.CARD_PAYMENT, onGameEvent);
			GameEvents.subscribe(GameEvents.GOOD_DRAG, onGameEvent);
			GameEvents.subscribe(GameEvents.GOOD_WRONG_BAG, onGameEvent);
			GameEvents.subscribe(GameEvents.SCANNER_GOOD_NO_BARCODE, onGameEvent);
			GameEvents.subscribe(GameEvents.SCALES_VIEW_SHOW, onGameEvent);
			GameEvents.subscribe(GameEvents.SCALES_BARCODE_PRINT, onGameEvent);
			
			visible = false;
			alpha = MAX_APLHA;
		}
		
		public function init(day: DayData): void 
		{
			visible = false;
			tutorial = day.tutorial;
			/*index = 0;*/
			instruction = null;
			if (day.tutorial)
				instruction = tutorial.instructions.shift();
		}
		
		private function onGameEvent(e: Event): void 
		{
			if (instruction && (instruction.event == e.type))
			{
				capturedEvent = null;
				if (instruction.captureEvent)
				{
					// cancel and store the event
					e.stopImmediatePropagation();
					capturedEvent = new Event(e.type, false, e.data);
				}
				GameEvents.dispatch(GameEvents.PAUSE);
				removeChildren();
				var textures: Vector.<Texture> = Assets.getTextures(
					"tutorial_" + tutorial.id + "_" + instruction.index + "_");
				var image: Image;
				for (var i:int = 0; i < textures.length; i++) 
				{
					image = new Image(textures[i]);
					image.smoothing = TextureSmoothing.NONE;
					addChildAt(image, 0);
				}
				visible = true;
				instruction = tutorial.instructions.shift();
			}
		}
		
		private function onTouch(e: TouchEvent): void 
		{
			var touch: Touch = e.getTouch(this, TouchPhase.MOVED);
			if (touch)
			{
				topPage.x = Math.min(0, int(topPage.x + touch.getMovement(this).x));
				// topPage.x is negative or 0
				topPage.alpha = MAX_APLHA * (topPage.width + topPage.x) / topPage.width;
			}
			
			touch = e.getTouch(this, TouchPhase.ENDED);
			if (touch)
			{
				if (topPage && (topPage.x < - topPage.width * 1 / 5))
				{
					removeChildAt(numChildren - 1).dispose();
					if (!topPage)
					{
						// TODO: tween left
						visible = false;
						/*index ++;
						if (!instruction)
							tutorial = null;*/
						GameEvents.dispatch(GameEvents.RESUME);
						if (capturedEvent !== null)
							GameEvents.dispatchEvent(capturedEvent);
					}
				}
			}
		}
		
		private function get topPage(): DisplayObject
		{
			if (numChildren)
				return getChildAt(numChildren - 1);
			return null;
		}
		
		/*private function onInitialShow(e: Event): void 
		{
			GameEvents.unsubscribe(GameEvents.CUSTOMER_STOPPED, onInitialShow);
			GameEvents.dispatch(GameEvents.PAUSE);
			visible = true;
		}*/
	}
}
