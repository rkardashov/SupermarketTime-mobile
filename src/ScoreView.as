package  
{
	import data.CustomerInfo;
	import data.DayData;
	import data.Saves;
	import flash.geom.Point;
	import screens.Screens;
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	/**
	 * ...
	 * @author rkardashov@gmail.com
	 */
	public class ScoreView extends Sprite 
	{
		private var textLabel: TextField;
		private var textShadow:TextField;
		private var score: int = 0;
		
		private var bagCategory: int;
		private var bagProgress: Boolean = false;
		private var dayTimer:DayTimer;
		private var timeFast:Number;
		private var day: DayData;
		private var p0: Point = new Point();
		private var p: Point = new Point();
		
		public function ScoreView(dayTimer: DayTimer)
		{
			super();
			this.dayTimer = dayTimer;
			x = 190;
			y = 30;
			addChild(textShadow = new TextField(120, 30, "", "Arcade_10", 20,
				0x88888888));
			textShadow.x = textShadow.y = 1;
			addChild(textLabel = new TextField(120, 30, "", "Arcade_10", 20,
				0xBB33FF00));
			textLabel.autoScale = textShadow.autoScale = false;
			textLabel.vAlign = textShadow.vAlign = VAlign.BOTTOM;
			textLabel.hAlign = textShadow.hAlign = HAlign.LEFT;
			textLabel.text = textShadow.text = "SCORE: 0";
			
			touchable = false;
			visible = false;
			
			GameEvents.subscribe(GameEvents.DAY_START, onDayStart);
			GameEvents.subscribe(GameEvents.DAY_END, onDayEnd);
			GameEvents.subscribe(GameEvents.INTRO_END, onIntroEnd);
			
			GameEvents.subscribe(GameEvents.GOOD_SCANNED, onGoodScanned);
			
			GameEvents.subscribe(GameEvents.BAG_GOOD_ADDED, onBagGoodAdded);
			GameEvents.subscribe(GameEvents.BAG_FULL, onBagFull);
			
			GameEvents.subscribe(GameEvents.CUSTOMER_ARRIVED, onCustomerArrived);
			GameEvents.subscribe(GameEvents.CUSTOMER_COMPLETE, onCustomerComplete);
		}
		
		private function onDayStart(e: Event, d: DayData): void 
		{
			day = d;
			score = 0;
			textLabel.text = textShadow.text = "SCORE: " + String(score);
		}
		
		private function onIntroEnd():void 
		{
			visible = true;
		}
		
		private function onDayEnd():void 
		{
			visible = false;
		}
		
		// TODO: move bonuses to Customer?
		
		/* Flip bonus */
		
		private function onGoodScanned(e: Event, g: Good): void 
		{
			if (g.flipCount < g.info.sideCount)
			{
				//g.localToGlobal(p0, p);
				//addScore("flip bonus!", 1, p.x, p.y);
				addScore("flip bonus!", 1, 50, 50);
			}
		}
		
		/* Bag bonus */
		
		private function onBagGoodAdded(e: Event, b: Bag): void 
		{
			b.goods[b.goods.length - 1].localToGlobal(p0, p);
			addScore("score", 1, p.x, p.y);
			if (bagCategory !== b.category)
				bagProgress = false;
			bagCategory = b.category;
			if (b.goods.length == 1)
				bagProgress = true;
		}
		
		private function onBagFull(e: Event, b: Bag): void 
		{
			if (bagProgress)
				addScore("bag bonus!", 5, 50, 50);
		}
		
		/* Fast service bonus */
		
		private function onCustomerArrived(e: Event, c: CustomerInfo): void 
		{
			timeFast = dayTimer.time + c.goods.length * 3.0 + 5.0;
		}
		
		private function onCustomerComplete(e: Event, c: CustomerInfo): void 
		{
			addScore("customer served", 5, 50, 20);
			if (dayTimer.time < timeFast)
				addScore("fast service!", 5, 50, 30);
		}
		
		private function addScore(message: String, scoreChange: int,
			posX: int, posY: int): void 
		{
			score += scoreChange;
			textLabel.text = textShadow.text = "SCORE " + String(score);
			if (scoreChange > 0)
				GameEvents.dispatch(GameEvents.ADD_SCORE, 
					new ScoreChange(message, scoreChange, posX, posY));
		}
	}
}
