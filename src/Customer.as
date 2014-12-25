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
		private var info: CustomerInfo;
		
		public function Customer() 
		{
			GameEvents.subscribe(GameEvents.CUSTOMER_ARRIVED, onCustomerArrive);
			GameEvents.subscribe(GameEvents.CUSTOMER_WELCOME, onCustomerWelcome);
			GameEvents.subscribe(GameEvents.CUSTOMER_GOODBYE, onCustomerGoodbye);
			GameEvents.subscribe(GameEvents.CUSTOMER_COMPLETE, onCustomerComplete);
			GameEvents.subscribe(GameEvents.CONVEYOR_GOODS_REQUEST, onGoodsRequest);
		}
		
		private function onCustomerArrive(e: Event, c: CustomerInfo): void 
		{
			mood = 0;
			info = c;
			changeMoodLevel(info.events[e.type]);
			GameEvents.subscribe(GameEvents.TIMER_SECOND, onTimerSecond);
		}
		
		private function onCustomerWelcome(e: Event): void 
		{
			changeMoodLevel(info.events[e.type]);
		}
		
		private function onCustomerGoodbye(e: Event): void 
		{
			changeMoodLevel(info.events[e.type]);
		}
		
		private function onGoodsRequest(e: Event): void 
		{
			if (!info)
				return;
			while (info.goods.length)
				GameEvents.dispatch(GameEvents.GOOD_ADD_TO_CONVEYOR, info.nextGood());
		}
		
		private function onTimerSecond(e: Event): void 
		{
			if (mood > 0)
				changeMoodLevel( -1);
		}
		
		private function onCustomerComplete(): void 
		{
			info = null;
			GameEvents.unsubscribe(GameEvents.TIMER_SECOND, onTimerSecond);
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
