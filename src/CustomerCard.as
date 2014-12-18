package
{
	import data.Assets;
	import flash.geom.Point;
	import screens.Screens;
	import starling.display.Sprite;
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
		
		public function CustomerCard() 
		{
			super();
			type = Item.TYPE_CARD;
			
			addChild(Assets.getImage("card_" + String(int(Math.random() * 5))));
			
			x = defaultX;
			y = defaultY;
			
			GameEvents.subscribe(GameEvents.CUSTOMER_ARRIVED, onCustomerArrived);
			GameEvents.subscribe(GameEvents.GOODS_COMPLETE, onGoodsComplete);
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
