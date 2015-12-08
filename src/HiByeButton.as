package
{
	import data.Assets;
	import data.DayData;
	import feathers.controls.Button;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	/**
	 * ...
	 * @author rkardashov@gmail.com
	 */
	public class HiByeButton extends Sprite//PixelButton
	{
		private var frames: MovieClip;
		private var pressed: Boolean = false;
		private var bubble: SpeechBubble;
		
		public function HiByeButton() 
		{
			super();//"bubble_welcome");
			x = 90;
			y = 170;
			//var btnHi: Button = new Button();
			//btnHi.upSkin = Assets.getImage("bubble_welcome");
			//addChild(btnHi);
			frames = new MovieClip(Assets.getTextures("bubble_welcome"));
			frames.addFrame(Assets.getTexture("bubble_goodbye"));
			frames.smoothing = "none";
			addChild(frames);
			
			bubble = new SpeechBubble(this, "hiByeBubble");
			bubble.alignPivot("right");
			bubble.x = -10;
			bubble.y = frames.height >> 1;
			bubble.addEventInspector(GameEvents.CUSTOMER_MOOD_LEVEL, inspectCustomerMoodEvent);
			
			visible = false;
			GameEvents.subscribe(TouchEvent.TOUCH, onTouch);
			GameEvents.subscribe(GameEvents.DAY_START, onDayStart);
			GameEvents.subscribe(GameEvents.DAY_END, onDayEnd);
		}
		
		private function inspectCustomerMoodEvent(e: Event, moodLevel: int): Boolean
		{
			return (moodLevel == 1);
		}
		
		private function onDayStart(e: Event, d: DayData): void 
		{
			visible = false;
			if (d.disabledFeatures["hi-bye"])
				return;
			GameEvents.subscribe(GameEvents.CUSTOMER_ARRIVED, onCustomerArrived);
			GameEvents.subscribe(GameEvents.GOOD_ENTER, onHideEvent);
			GameEvents.subscribe(GameEvents.PAYMENT_COMPLETE, onCardPayment);
			GameEvents.subscribe(GameEvents.CUSTOMER_COMPLETE, onHideEvent);
		}
		
		private function onDayEnd(e: Event, d: DayData): void 
		{
			GameEvents.unsubscribe(GameEvents.CUSTOMER_ARRIVED, onCustomerArrived);
			GameEvents.unsubscribe(GameEvents.GOOD_ENTER, onHideEvent);
			GameEvents.unsubscribe(GameEvents.PAYMENT_COMPLETE, onCardPayment);
			GameEvents.unsubscribe(GameEvents.CUSTOMER_COMPLETE, onHideEvent);
		}
		
		private function onCustomerArrived(e: Event): void 
		{
			visible = true;
			frames.currentFrame = 0;
			frames.readjustSize();
		}
		
		private function onCardPayment(e: Event): void 
		{
			visible = true;
			frames.currentFrame = 1;
			frames.readjustSize();
		}
		
		private function onHideEvent(e: Event): void 
		{
			visible = false;
		}
		
		private function onTouch(e: TouchEvent): void 
		{
			if (!pressed && e.getTouch(this, TouchPhase.BEGAN))
			{
				pressed = true;
				return;
			}
			if (pressed && e.getTouch(this, TouchPhase.ENDED))
			{
				pressed = false;
				visible = false;
				if (frames.currentFrame == 0)
					GameEvents.dispatch(GameEvents.CUSTOMER_WELCOME)
				else
					GameEvents.dispatch(GameEvents.CUSTOMER_GOODBYE);
			}
		}
	}
}
