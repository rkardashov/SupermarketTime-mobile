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
		
		public function CustomerCard() 
		{
			super();
			type = Item.TYPE_CARD;
			
			addChild(Assets.getImage("card_" + String(int(Math.random() * 5))));
			
			x = defaultX;
			y = defaultY;
			
			GameEvents.subscribe(GameEvents.CUSTOMER_ARRIVED, onCustomerArrived);
			GameEvents.subscribe(GameEvents.GOODS_COMPLETE, onGoodsComplete);
			
			bubble = new SpeechBubble(this, "cardDragMeBubble", 70, 20);
			bubble.addPhrase("drag me",
				GameEvents.GOODS_COMPLETE, GameEvents.CARD_PAYMENT);
			bubble.alignPivot("right", "center");
			bubble.y = int(height / 2);
		}
		
		override protected function onDrag(): void 
		{
			removeChild(bubble);
		}
		
		override protected function onDrop(): void 
		{
			x = defaultX;
			y = defaultY;
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
			if (!paid)
				visible = true;
		}
	}
}
