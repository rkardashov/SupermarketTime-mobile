package data
{
	import starling.events.Event;
	/**
	 * ...
	 * @author rkardashov@gmail.com
	 */
	public class DayData 
	{
		public var customers: Vector.<CustomerInfo> = new Vector.<CustomerInfo>();
		
		public var dayNumber: uint;
		//public var scoreMin: uint;
		//public var scoreMid: uint;
		//public var scoreMax: uint;
		public var scores: Vector.<int> = new Vector.<int>;
		public var flipping: Boolean = false;
		public var numericInput: Boolean = false;
		public var barcodePrinter: Boolean = false;
		public var bags: Vector.<Boolean> = new Vector.<Boolean>();
		public var duration: int;
		public var tutorial: Tutorial = null;
		//public var score: int = 0;
		public var save: DaySave = new DaySave();
		public var disabledFeatures: Object = {};
		//public var goodIDs: Vector.<int> = new Vector.<int>();
		
		public function DayData(dayNumber: uint) 
		{
			this.dayNumber = dayNumber;
			save.index = dayNumber;
			
			var dayXML: XML = Assets.daysXML.day.(@index == dayNumber)[0];
			
			/*var scoreStr: String = dayXML.@score;
			scoreMin = scoreStr.split(",")[0];
			scoreMid = scoreStr.split(",")[1];
			scoreMax = scoreStr.split(",")[2];*/
			scores.push(0);
			var scoresStr: Array = String(dayXML.@score).split(",");
			for (var i:int = 0; i < scoresStr.length; i++) 
				scores.push(scoresStr[i]);
			while (scores.length < 4)
				scores.push(scoresStr[scoresStr.length - 1]);
			
			duration = dayXML.@duration;
			
			var bagsStr: String = dayXML.@bags;
			while (bags.length < Goods.categories.length)
				bags.push(false);
			for (var j:int = 0; j < bagsStr.length; j++)
				bags[int(bagsStr.charAt(j))] = true;
			
			/*var custXML: XML;
			for (var i:int = 0; i < dayXML.customer.length() - 1; i++) 
			{
				if (dayXML.customer.(@index == i).length())
				{
					custXML = dayXML.customer.(@index == i)[0];
					customers.push(new CustomerInfo(custXML));
				}
			}
			if (dayXML.customer.(@index == "").length())
				custXML = dayXML.customer.(@index == "")[0]
			else
				custXML = <customer/>;
			while (customers.length < scoreMax * 2)
				customers.push(new CustomerInfo(custXML));
			*/
			while (customers.length < scores[3] / 20)
				customers.push(new CustomerInfo(dayXML));
			
			// ' goods="0-4" '
			/*var maxGoodID: int = String(dayXML.@goods).split("-")[1];
			for (var i:int = 0; i < maxGoodID; i++) 
				goodIDs.push(i);*/
			
			for each (var disabled: XML in dayXML.disabled)//.Feature) 
				//this[feature.@name] = false;
				disabledFeatures[disabled.@feature] = true;
			
			if (dayXML.attribute("tutorial").length() > 0)
				tutorial = new Tutorial(dayXML.@tutorial);
			
			GameEvents.subscribe(GameEvents.ADD_SCORE, onScoreAdd);
			GameEvents.subscribe(GameEvents.DAY_END, onDayEnd);
		}
		
		private function onDayEnd(e: Event, d: DayData): void 
		{
			GameEvents.unsubscribe(GameEvents.ADD_SCORE, onScoreAdd);
			GameEvents.unsubscribe(GameEvents.DAY_END, onDayEnd);
		}
		
		private function onScoreAdd(e: Event, s: ScoreChange): void 
		{
			save.score += s.change;
			for (var i: int = 0; i < 4; i++) 
				if (save.score >= scores[i])
					save.stars = i;
		}
		
		static public function get count(): int
		{
			return Assets.daysXML.day.length();
		}
	}
}