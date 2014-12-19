package  
{
	import data.CustomerInfo;
	import starling.events.Event;
	/**
	 * ...
	 * @author rkardashov@gmail.com
	 */
	public class Customer 
	{
		static public const MOOD_LEVEL_MIN: int = 0;
		static public const MOOD_LEVEL_MID: int = 1;
		static public const MOOD_LEVEL_MAX: int = 2;
		
		private var mood: int = 0;
		
		public function Customer() 
		{
			GameEvents.subscribe(GameEvents.DAY_START, onDayStart);
			GameEvents.subscribe(GameEvents.CUSTOMER_ARRIVED, onCustomerArrive);
			GameEvents.subscribe(GameEvents.CUSTOMER_WELCOME, onCustomerWelcome);
			GameEvents.subscribe(GameEvents.CUSTOMER_COMPLETE, onCustomerComplete);
		}
		
		private function onDayStart(): void 
		{
			//mood = 0;
		}
		
		private function onCustomerArrive(e: Event, c: CustomerInfo): void 
		{
			mood = 0;
			changeMoodLevel(20);
			GameEvents.subscribe(GameEvents.TIMER_SECOND, onTimerSecond);
		}
		
		private function onCustomerComplete(): void 
		{
			GameEvents.unsubscribe(GameEvents.TIMER_SECOND, onTimerSecond);
		}
		
		private function onCustomerWelcome(e: Event): void 
		{
			changeMoodLevel(10);
		}
		
		private function onTimerSecond(e: Event): void 
		{
			if (mood > 0)
				changeMoodLevel( -1);
		}
		
		private function changeMoodLevel(change: int): void 
		{
			//trace("mood change: " + mood + ((change > 0) ? "+" : "") + change);
			mood += change;
			if (mood < 0)
				mood = 0;
			if (mood >= 20)
				GameEvents.dispatch(GameEvents.CUSTOMER_MOOD_LEVEL, MOOD_LEVEL_MAX);
			else if (mood >= 10)
				GameEvents.dispatch(GameEvents.CUSTOMER_MOOD_LEVEL, MOOD_LEVEL_MID);
			else if (mood >= 0)
				GameEvents.dispatch(GameEvents.CUSTOMER_MOOD_LEVEL, MOOD_LEVEL_MIN);
		}
	}
}
