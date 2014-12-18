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
		private var index: int = 0;
		private function get instruction(): Instruction
		{
			if (tutorial && (index < tutorial.instructions.length))
				return tutorial.instructions[index];
			return null;
		}
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
			visible = false;
			alpha = 0.2;
		}
		
		public function init(day: DayData): void 
		{
			visible = false;
			/*removeChildren();
			var textures: Vector.<Texture> = Assets.getTextures(day.tutorial);
			var image: Image;
			for (var i:int = 0; i < textures.length; i++) 
			{
				image = new Image(textures[i]);
				image.smoothing = TextureSmoothing.NONE;
				addChildAt(image, 0);
			}
			if (topPage)
				GameEvents.subscribe(GameEvents.CUSTOMER_STOPPED, onInitialShow);*/
			//instructions = day.tutorial;
			tutorial = day.tutorial;
			index = 0;
			//instruction = instructions.shift();
			/*var textures: Vector.<Texture> = Assets.getTextures(day.tutorial);
			var image: Image;
			for (var i:int = 0; i < textures.length; i++) 
			{
				image = new Image(textures[i]);
				image.smoothing = TextureSmoothing.NONE;
				addChildAt(image, 0);
			}*/
		}
		
		private function onGameEvent(e: Event): void 
		{
			if (instruction && (instruction.event == e.type))
			{
				// cancel and store the event
				e.stopImmediatePropagation();
				capturedEvent = new Event(e.type, false, e.data);
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
			}
		}
		
		private function onTouch(e: TouchEvent): void 
		{
			var touch: Touch = e.getTouch(this, TouchPhase.MOVED);
			if (touch)
				topPage.x = Math.min(0, int(topPage.x + touch.getMovement(this).x));
			
			touch = e.getTouch(this, TouchPhase.ENDED);
			if (touch)
			{
				if (topPage && (topPage.x < - topPage.width / 2))
				{
					removeChildAt(numChildren - 1).dispose();
					if (!topPage)
					{
						visible = false;
						//instruction = tutorial.instructions.shift();
						index ++;
						if (!instruction)
							tutorial = null;
						GameEvents.dispatch(GameEvents.RESUME);
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
