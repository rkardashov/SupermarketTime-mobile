package 
{
	import data.Assets;
	import data.DayData;
	import starling.display.MovieClip;
	import starling.events.Event;
	import starling.textures.TextureSmoothing;
	
	/**
	 * ...
	 * @author rkardashov@gmail.com
	 */
	public class MoodIndicator extends MovieClip 
	{
		public function MoodIndicator() 
		{
			super(Assets.getTextures("mood"));
			smoothing = TextureSmoothing.NONE;
			visible = false;
			GameEvents.subscribe(GameEvents.DAY_START, onDayStart);
		}
		
		private function onDayStart(e: Event, d: DayData):void 
		{
			visible = false;
			if (d.disabledFeatures["hi-bye"])
			{
				GameEvents.unsubscribe(GameEvents.CUSTOMER_ARRIVED, onCustomerArrived);
				GameEvents.unsubscribe(GameEvents.CUSTOMER_MOOD_LEVEL, onMoodChange);
				GameEvents.unsubscribe(GameEvents.CUSTOMER_COMPLETE, onCustomerComplete);
			}
			else
			{
				GameEvents.subscribe(GameEvents.CUSTOMER_ARRIVED, onCustomerArrived);
				GameEvents.subscribe(GameEvents.CUSTOMER_MOOD_LEVEL, onMoodChange);
				GameEvents.subscribe(GameEvents.CUSTOMER_COMPLETE, onCustomerComplete);
			}
		}
		
		private function onCustomerArrived():void 
		{
			visible = true;
		}
		
		private function onMoodChange(e: Event, moodLevel: int): void 
		{
			currentFrame = Math.min(moodLevel, numFrames - 1);
		}
		
		private function onCustomerComplete(): void 
		{
			visible = false;
		}
		
	}
}
