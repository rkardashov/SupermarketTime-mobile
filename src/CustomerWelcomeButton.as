package
{
	import data.DayData;
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
			GameEvents.subscribe(GameEvents.DAY_START, onDayStart);
		}
		
		private function onDayStart(e: Event, d: DayData):void 
		{
			visible = false;
			if (d.disabledFeatures["hi-bye"])
			{
				GameEvents.unsubscribe(GameEvents.CUSTOMER_ARRIVED, onCustomerArrived);
				GameEvents.unsubscribe(GameEvents.GOOD_ENTER, onGoodEnter);
			}
			else
			{
				GameEvents.subscribe(GameEvents.CUSTOMER_ARRIVED, onCustomerArrived);
				GameEvents.subscribe(GameEvents.GOOD_ENTER, onGoodEnter);
			}
		}
		
		private function onGoodEnter(e: Event): void 
		{
			visible = false;
		}
		
		private function onCustomerArrived(e: Event): void 
		{
			visible = true;
		}
		
		private function onTrigger(e: Event): void 
		{
			GameEvents.dispatch(GameEvents.CUSTOMER_WELCOME);
			visible = false;
		}
	}
}
