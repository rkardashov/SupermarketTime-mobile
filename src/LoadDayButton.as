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
		private var day: DaySave;
		
		public function LoadDayButton(day: DaySave) 
		{
			this.day = day;
			super("day " + day.index + " ");/* "btnWideUp", "btnWideDown");
			addChild(textDayIndex = new TextField(40, 18, "", "Systematic_9", 9));
			textDayIndex.x = 5;
			textDayIndex.text = "day " + day.index + " ";
			textDayIndex.autoScale = false;
			textDayIndex.autoSize = TextFieldAutoSize.HORIZONTAL;*/
			for (var i:int = 0; i < day.stars; i++) 
				/*textDayIndex.*/text += " *";
			//if (DayData.count > day.index)
			addEventListener(Event.TRIGGERED, onTrigger)
			//enabled = (DayData.count > day.index);
		}
		
		private function onTrigger(e:Event):void 
		{
			if (Saves.selectDay(day.index))
			{
				Screens.gotoScreen(GameScreen);
			}
			//(Screens.getScreen(GameScreen) as GameScreen).startDay();
		}
	}
}