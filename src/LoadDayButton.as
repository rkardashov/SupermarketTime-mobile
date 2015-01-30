package  {
	import data.DayData;
	import data.DaySave;
	import data.Saves;
	import screens.GameScreen;
	import screens.Screens;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	/**
	 * ...
	 * @author rkardashov@gmail.com
	 */
	public class LoadDayButton extends TextButton
	{
		//private var textDayIndex: TextField;
		public var day: DaySave;
		
		public function LoadDayButton(day: DaySave) 
		{
			this.day = day;
			super("day " + day.index + " ");
			for (var i:int = 0; i < day.stars; i++) 
				text += " *";
			//addEventListener(Event.TRIGGERED, onTrigger)
		}
		
/*		private function onTrigger(e:Event):void 
		{
			if (Saves.selectDay(day.index))
			{
				Screens.gotoScreen(GameScreen);
			}
		}*/
	}
}