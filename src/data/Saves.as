package data
{
	/**
	 * ...
	 * @author rkardashov@gmail.com
	 */
	public class Saves 
	{
		static private var daysfile: SaveFile;
		static private var _onDaysLoaded: Function;
		static private var days: Vector.<DaySave>;
		static public var currentDayIndex: int = 0;
		
		public function Saves() 
		{
		}
		
		static public function init(): void 
		{
			/*daysfile = new SaveFile("dayssave");*/
			// TEMP: day saves static list
			days = new Vector.<DaySave>;
			var day: DaySave;
			for (var i:int = 0; i < 6; i++) 
			{
				day = new DaySave();
				day.index = i;
				day.stars = Math.random() * 4;
				days.push(day);
			}
			//saveDays();
		}
		
		static public function loadDays(onDaysLoaded: Function): void 
		{
			/*_onDaysLoaded = onDaysLoaded;*/
			/*daysfile.load(onFileLoad);*/
			// TEMP: loadDays()
			onDaysLoaded(days);
		}
		
		static public function saveDays(): void 
		{
			// TEMP: saving disabled
			/*daysfile.save(days);*/
		}
		
		static public function selectDay(index: int): Boolean
		{
			if (index < days.length)
			{
				currentDayIndex = index;
				return true;
			}
			return false;
		}
		
		static public function nextDay(completedDay: DaySave): Boolean
		{
			/*
			// найти день с тем же индексом;
			// переписать его данные, если новый результат лучше.
			if (completedDay.index >= days.length)
				days.push(completedDay)
			else
			{
				if (days[completedDay.index].score < completedDay.score)
					days[completedDay.index] = completedDay;
			}
			if (currentDayIndex + 1 >= DayData.count)
				return false;
			currentDayIndex ++;
			if (currentDayIndex < days.length) // day save exists
				return true;
			var day: DaySave = new DaySave();
			day.index = days.length;
			days.push(day);
			*/
			return true;
		}
		
		static private function onFileLoad(days: Vector.<DaySave>): void 
		{
			Saves.days = days;
			_onDaysLoaded(days);
		}
	}
}
