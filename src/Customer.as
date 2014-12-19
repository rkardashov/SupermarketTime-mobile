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
			GameEvents.subscribe(GameEvents.CUSTOMER_ARRIVED, onCustomerArrive);
		}
		
		private function onCustomerArrive(e: Event, c: CustomerInfo): void 
		{
			GameEvents.subscribe(GameEvents.TIMER_SECOND, onTimerSecond);
			mood = 20;
			GameEvents.dispatch(GameEvents.CUSTOMER_MOOD_LEVEL_CHANGE,
				MOOD_LEVEL_MAX);
		}
		
		public function reset():void 
		{
			GameEvents.subscribe(GameEvents.TIMER_SECOND, onTimerSecond);
		}
		
		/*public function init(info: CustomerInfo): void 
		{
			GameEvents.subscribe(GameEvents.TIMER_SECOND, onTimerSecond);
			mood = 10;
			GameEvents.dispatch(GameEvents.CUSTOMER_MOOD_LEVEL_CHANGE,
				MOOD_LEVEL_MAX);
		}*/
		
		private function onTimerSecond(e: Event): void 
		{
			if (mood > 0)
				mood --;
			if (mood == 10)
				GameEvents.dispatch(GameEvents.CUSTOMER_MOOD_LEVEL_CHANGE,
					MOOD_LEVEL_MID);
			if (mood == 0)
				GameEvents.dispatch(GameEvents.CUSTOMER_MOOD_LEVEL_CHANGE,
					MOOD_LEVEL_MIN);
		}
	}
}
