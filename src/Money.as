package 
{
	import screens.Screens;
	import starling.events.Event;
	/**
	 * ...
	 * @author rkardashov@gmail.com
	 */
	public class Money extends Item
	{
		private static const defaultX: int = int(Screens.unit * 3.8);
		private static const defaultY: int = int(Screens.unit * 3);
		
		public var paid: Boolean;
		
		public function Money() 
		{
			super(TYPE_MONEY);
			
			visible = false;
			
			x = defaultX;
			y = defaultY;
			
			GameEvents.subscribe(GameEvents.GOODS_COMPLETE, onGoodsComplete);
			GameEvents.subscribe(GameEvents.CUSTOMER_ARRIVED, onCustomerArrived);	
			GameEvents.subscribe(GameEvents.DAY_START, onDayStart);
		}
		
		private function onDayStart(): void 
		{
			visible = false;
		}
		
		override protected function onDrop(): void 
		{
			x = defaultX;
			y = defaultY;
		}
		
		private function onGoodsComplete(): void
		{
			visible = true;
		}
		
		private function onCustomerArrived(e: Event): void 
		{
			paid = false;
		}
	}
}
