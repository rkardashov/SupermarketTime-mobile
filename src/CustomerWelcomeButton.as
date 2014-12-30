package
{
	import starling.events.Event;
	/**
	 * ...
	 * @author rkardashov@gmail.com
	 */
	public class CustomerWelcomeButton extends PixelButton
	{
		public function CustomerWelcomeButton() 
		{
			super("bubble_welcome");
			x = 90;
			y = 170;
			visible = false;
			addEventListener(Event.TRIGGERED, onTrigger);
			GameEvents.subscribe(GameEvents.CUSTOMER_ARRIVED, onCustomerArrived);
			GameEvents.subscribe(GameEvents.GOOD_ENTER, onGoodEnter);
		}
		
		private function onGoodEnter(e: Event): void 
		{
			visible = false;
		}
		
		private function onCustomerArrived(e: Event): void 
		{
			visible = true;
			// TODO: add CONVEYOR_GOODS_REQUEST event, send upon divider move out
			//GameEvents.subscribe(GameEvents.CONVEYOR_GOODS_REQUEST);
		}
		
		private function onTrigger(e: Event): void 
		{
			GameEvents.dispatch(GameEvents.CUSTOMER_WELCOME);
			visible = false;
		}
	}
}
