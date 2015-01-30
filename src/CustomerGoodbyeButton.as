package
{
	import data.DayData;
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
			x = 90;
			y = 170;
			visible = false;
			addEventListener(Event.TRIGGERED, onTrigger);
			GameEvents.subscribe(GameEvents.CARD_PAYMENT, onCardPayment);
			GameEvents.subscribe(GameEvents.CUSTOMER_COMPLETE, onCustomerComplete);
			GameEvents.subscribe(GameEvents.DAY_START, onDayStart);
		}
		
		private function onDayStart(e: Event, d: DayData):void 
		{
			visible = false;
			if (d.disabledFeatures["hi-bye"])
			{
				GameEvents.unsubscribe(GameEvents.CARD_PAYMENT, onCardPayment);
				GameEvents.unsubscribe(GameEvents.CUSTOMER_COMPLETE, onCustomerComplete);
			}
			else
			{
				GameEvents.subscribe(GameEvents.CARD_PAYMENT, onCardPayment);
				GameEvents.subscribe(GameEvents.CUSTOMER_COMPLETE, onCustomerComplete);
			}
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
