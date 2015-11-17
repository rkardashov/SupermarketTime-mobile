package
{
	import data.Assets;
	import data.DayData;
	import flash.geom.Point;
	import screens.Screens;
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
	public class CustomerCard extends Item
	{
		private static const defaultX: int = int(Screens.unit * 3.8);
		private static const defaultY: int = int(Screens.unit * 3);
		
		public var paid: Boolean;
		
		private var bubble: SpeechBubble;
		//private var hasBubble: Boolean = false;
		
		public function CustomerCard() 
		{
			super();
			type = Item.TYPE_CARD;
			
			addChild(Assets.getImage("card_" + String(int(Math.random() * 5))));
			
			x = defaultX;
			y = defaultY;
			
			GameEvents.subscribe(GameEvents.CUSTOMER_ARRIVED, onCustomerArrived);
			GameEvents.subscribe(GameEvents.GOODS_COMPLETE, onGoodsComplete);
			
			/*addChild(bubble = Assets.getImage("bubble_card_drag_me"));
			bubble.alignPivot("right", "center");
			*/
			bubble = new SpeechBubble(
				this, // parent object
				"cardDragMeBubble", // day data attribute name
				70, 20, // text area size
				"drag me", // speech text
				GameEvents.GOODS_COMPLETE, // show on this event
				GameEvents.CARD_PAYMENT // hide on this event
				);
			bubble.alignPivot("right", "center");
			bubble.y = int(height / 2);
			//bubble.visible = false;
			
			// tutorial "bubble" events
			//GameEvents.subscribe(GameEvents.DAY_START, onDayStart);
			//GameEvents.subscribe(GameEvents.GOODS_COMPLETE, onGoodsComplete);
			//GameEvents.subscribe(GameEvents.CARD_PAYMENT, onCardPayment);
		}
		
		
		/*private function onDayStart(e: Event, d: DayData): void 
		{
			hasBubble = d.bubbleCardDragMeVisible;
		}*/
		
		/*private function onGoodsComplete(e: Event): void 
		{
			bubble.visible = hasBubble;
		}*/
		
		/*private function onCardPayment(e: Event): void 
		{
			bubble.visible = false;
		}*/
		
		override protected function onDrag(): void 
		{
			removeChild(bubble);
		}
		
		override protected function onDrop(): void 
		{
			x = defaultX;
			y = defaultY;
			/*if (bubble)
				addChild(bubble);*/
		}
		
		public function pay(): void 
		{
			if (paid)
				return;
			paid = true;
			GameEvents.dispatch(GameEvents.CARD_PAYMENT);
		}
		
		private function onCustomerArrived(): void 
		{
			paid = false;
		}
		
		private function onGoodsComplete(): void
		{
			//bubble.visible = hasBubble;
			if (!paid)
				visible = true;
		}
	}
}
