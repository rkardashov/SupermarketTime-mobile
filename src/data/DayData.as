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
		
		public var dayNumber: int;
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
		public var disabledFeatures: Object = { };
		
		public var bubbleScannerVisible: Boolean = false;
		public var bubbleBagVisible: Boolean = false;
		public var bubbleSumDropCardVisible: Boolean = false;
		public var tutorialBagAutoShow: Boolean = false;
		public var bubbleCardDragMeVisible: Boolean = false;
		public var bubbleDividerMoveOffScreen: Boolean = false;
	//public var goodIDs: Vector.<int> = new Vector.<int>();
		
		public function DayData(dayNumber: int) 
		{
			this.dayNumber = dayNumber;
			save.index = dayNumber;
			
			var dayXML: XML = Assets.daysXML.day.(@index == dayNumber)[0];
			
			for each (var disabled: XML in dayXML.disabled)
				disabledFeatures[disabled.@feature] = true;
			
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
			
			var customersMax: int;
			if (dayXML.attribute("customersMax").length() == 1)
				customersMax = dayXML.@customersMax
			else
				customersMax = Math.ceil(scores[3] / 20);
			while (customers.length < customersMax)
				customers.push(new CustomerInfo(dayXML));
			
			// ' goods="0-4" '
			/*var maxGoodID: int = String(dayXML.@goods).split("-")[1];
			for (var i:int = 0; i < maxGoodID; i++) 
				goodIDs.push(i);*/
			
			if (dayXML.attribute("tutorial").length() > 0)
				tutorial = new Tutorial(dayXML.@tutorial);
			
			bubbleScannerVisible = (dayXML.attribute("scannerDropItemHereBubble").length() == 1);
			bubbleBagVisible = (dayXML.attribute("bagDropItemHereBubble").length() == 1);
			bubbleSumDropCardVisible = (dayXML.attribute("sumDropCardHereBubble").length() == 1);
			bubbleCardDragMeVisible = (dayXML.attribute("cardDragMeBubble").length() == 1);
			bubbleDividerMoveOffScreen = (dayXML.attribute("dividerMoveMeBubble").length() == 1);
			
			
			tutorialBagAutoShow = (dayXML.attribute("tutorialBagAutoShow").length() == 1);

			GameEvents.subscribe(GameEvents.ADD_SCORE, onScoreAdd);
			GameEvents.subscribe(GameEvents.DAY_END, onDayEnd);
		}
		
		public function hasAttribute(attributeName: String): Boolean
		{
			var dayXML: XML = Assets.daysXML.day.(@index == dayNumber)[0];
			return (dayXML.attribute(attributeName).length() > 0);
		}
		
		public function getBubbleInfo(xmlBubbleName: String): BubbleInfo
		{
			var dayXML: XML = Assets.daysXML.day.(@index == dayNumber)[0];
			var bubblesXML: XMLList = dayXML.child(xmlBubbleName);
			if (bubblesXML.length() == 0)
				return null;
			return new BubbleInfo(bubblesXML[0]);
			//return new Speech(bubbleXML);
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