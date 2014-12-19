package
{
	import data.Assets;
	import data.DayData;
	import screens.Screens;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	
	/**
	 * ...
	 * @author rkardashov@gmail.com
	 */
	public class DayIntroView extends Sprite 
	{
		private var textField: TextField;
		//private var onCloseCallback: Function;
		private var fadeOut: Boolean = false;
		//private var messageQueue: Vector.<String> = new Vector.<String>();
		
		public function DayIntroView(/*onClose: Function*/) 
		{
			super();
			//onCloseCallback = onClose;
			var bubble: Image = Assets.getImage("bubble_briefing");
			addChild(bubble);
			bubble.x = int((Screens.uWidth * Screens.unit - bubble.width) / 2);
			bubble.y = int((Screens.uHeight * Screens.unit - bubble.height) / 2);
			addChild(textField = new TextField(260, 80, "", "Arcade_10", 20));
			textField.x = bubble.x + 10;
			textField.y = bubble.y + 10;
			// TEMP!
			addEventListener(TouchEvent.TOUCH, onTouch);
			visible = false;
			GameEvents.subscribe(GameEvents.INTRO_START, onIntroStart);
		}
		
		//public function show(day: DayData): void 
		private function onIntroStart(e: Event, day: DayData): void
		{
			textField.text = "DAY " + day.dayNumber;
			alpha = 0;
			visible = true;
			addEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
			//nextMessage();
		}
		
		private function onEnterFrame(e: Event): void 
		{
			if (fadeOut)
				alpha -= 0.05
			else
				alpha += 0.01;
			if (alpha >= 1.0)
				fadeOut = true;
			if (alpha <= 0)
			{
				fadeOut = false;
				removeEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
				visible = false;
				//onCloseCallback();
				GameEvents.dispatch(GameEvents.INTRO_END);
			}
		}
		
		private function onTouch(e: TouchEvent): void 
		{
			if (e.getTouch(this, TouchPhase.ENDED))
			{
				removeEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
				visible = false;
				//onCloseCallback();
				GameEvents.dispatch(GameEvents.INTRO_END);
			}
		}
	}
}
