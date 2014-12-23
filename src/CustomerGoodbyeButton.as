package
{
	import starling.events.Event;
	/**
	 * ...
	 * @author rkardashov@gmail.com
	 */
	public class CustomerGoodbyeButton extends PixelButton
	{
		public function CustomerGoodbyeButton() 
		{
			super("bubble_goodbye");
			x = 100;
			y = 150;
			visible = false;
			addEventListener(Event.TRIGGERED, onTrigger);
			GameEvents.subscribe(GameEvents.CARD_PAYMENT, onCardPayment);
			GameEvents.subscribe(GameEvents.CUSTOMER_COMPLETE, onCustomerComplete);
		}
		
		private function onCustomerComplete(e: Event): void 
		{
			visible = false;
		}
		
		private function onCardPayment(e: Event): void 
		{
			visible = true;
		}
		
		private function onTrigger(e: Event): void 
		{
			GameEvents.dispatch(GameEvents.CUSTOMER_GOODBYE);
			visible = false;
		}
	}
}
