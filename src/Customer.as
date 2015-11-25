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
		static public const MOOD_LEVEL_LOW: int = 0;
		static public const MOOD_LEVEL_MID: int = 1;
		static public const MOOD_LEVEL_HIGH: int = 2;
		
		private var mood: int = 0;
		private var info: CustomerInfo;
		private var moodLevel: int = 0;
		
		public function Customer()
		{
			GameEvents.subscribe(GameEvents.CUSTOMER_ARRIVED, onCustomerArrive);
			GameEvents.subscribe(GameEvents.CUSTOMER_COMPLETE, onCustomerComplete);
			GameEvents.subscribe(GameEvents.CONVEYOR_GOODS_REQUEST, onGoodsRequest);
			
			GameEvents.subscribe(GameEvents.CUSTOMER_WELCOME, eventReaction);
			GameEvents.subscribe(GameEvents.CUSTOMER_GOODBYE, eventReaction);
		}
		
		private function onCustomerArrive(e: Event, c: CustomerInfo): void 
		{
			mood = c.moodInitial;
			info = c;
			changeMoodLevel(0);
			GameEvents.subscribe(GameEvents.TIMER_SECOND, onTimerSecond);
		}
		
		private function onGoodsRequest(e: Event): void 
		{
			if (!info)
				return;
			while (info.goods.length)
				GameEvents.dispatch(GameEvents.GOOD_ADD_TO_CONVEYOR, info.goods.pop());
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
		
		private function eventReaction(e: Event): void 
		{
			changeMoodLevel(info.events[e.type]);
		}
		
		private function changeMoodLevel(change: int): void 
		{
			mood += change;
			if (mood < 0)
				mood = 0;
			
			if (moodLevel < info.moodLevels.length
				&& mood >= info.moodLevels[moodLevel])
			{
				while (moodLevel < info.moodLevels.length
						&& mood >= info.moodLevels[moodLevel])
					moodLevel ++;
				GameEvents.dispatch(GameEvents.CUSTOMER_MOOD_LEVEL, moodLevel);
			}
			if (moodLevel > 0 && mood < info.moodLevels[moodLevel-1])
			{
				moodLevel --;
				GameEvents.dispatch(GameEvents.CUSTOMER_MOOD_LEVEL, moodLevel);
			}
			
			/*if (mood >= 20)
				GameEvents.dispatch(GameEvents.CUSTOMER_MOOD_LEVEL, MOOD_LEVEL_HIGH)
			else if (mood >= 10)
				GameEvents.dispatch(GameEvents.CUSTOMER_MOOD_LEVEL, MOOD_LEVEL_MID)
			else if (mood >= 0)
				GameEvents.dispatch(GameEvents.CUSTOMER_MOOD_LEVEL, MOOD_LEVEL_LOW);*/
		}
	}
}
