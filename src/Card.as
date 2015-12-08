package
{
	import data.Assets;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	/**
	 * ...
	 * @author rkardashov@gmail.com
	 */
	public class Card extends Money
	{
		private var bubble: SpeechBubble;
		
		public function Card() 
		{
			super();
			
			addChild(Assets.getImage("card_" + String(int(Math.random() * 5))));
			
			GameEvents.subscribe(GameEvents.PAYMENT_START, onPaymentStart);
			
			bubble = new SpeechBubble(this, "cardDragMeBubble");
			bubble.alignPivot("right", "center");
			bubble.y = int(height / 2);
		}
		
		override protected function onDrag(): void 
		{
			removeChild(bubble);
		}
		
		private function onPaymentStart(e: Event, i: Item): void 
		{
			if (i == this)
			{
				paid = true;
				GameEvents.dispatch(GameEvents.PAYMENT_COMPLETE);
			}
		}
	}
}
