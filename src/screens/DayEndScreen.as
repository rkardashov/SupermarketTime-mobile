package screens 
{
	import data.Assets;
	import data.DayData;
	import data.Saves;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.HAlign;
	
	/**
	 * ...
	 * @author rkardashov@gmail.com
	 */
	public class DayEndScreen extends BasicScreen
	{
		private var _scoreText: TextField;
		private var _dayNumberText: TextField;
		private var _successText: TextField;
		private var _starsText: TextField;
		private var _starsShadowText: TextField;
		
		private var _btnNext: TextButton;
		private var _btnToMenu: TextButton;
		private var _btnToDaySelection: TextButton;
		
		private var day: DayData;
		
		public function DayEndScreen() 
		{
			super();
			
			//scaleX = scaleY = 2;
			
			addChild(Assets.getImage("bg_day_end"));
			
			var u: int = Screens.unit;
			
			addChild(_dayNumberText = new TextField(165, 30, "day 0 end",
				"arcade_10", 20));
			_dayNumberText.hAlign = HAlign.CENTER;
			_dayNumberText.x = 120;// 190;
			_dayNumberText.y = 10;
			
			addChild(_scoreText = new TextField(155, 50, "0", "systematic_9", 9));
			_scoreText.hAlign = HAlign.RIGHT;
			_scoreText.x = 120;// int(u * 9);
			_scoreText.y = 50;// int(u * 1.5);
			
			addChild(_starsShadowText = new TextField(165, 70, "", "Systematic_9", 27,
				0xFF777777));
			_starsShadowText.hAlign = HAlign.CENTER;
			_starsShadowText.x = 121;// int(u * 8);
			_starsShadowText.y = 81;// int(u * 6);
			addChild(_starsText = new TextField(165, 70, "", "Systematic_9", 27));
			_starsText.hAlign = HAlign.CENTER;
			_starsText.x = 120;// int(u * 8);
			_starsText.y = 80;// int(u * 6);
			
			addChild(_successText = new TextField(165, 50, "", "Arcade_10", 10));
			_successText.hAlign = HAlign.CENTER;
			_successText.x = 120;// int(u * 5);
			_successText.y = 140;// int(u * 4);
			
			addChild(_btnToMenu = new TextButton("menu"));
			_btnToMenu.x = int(u * 1);
			_btnToMenu.y = int(u * 8);
			_btnToMenu.addEventListener(Event.TRIGGERED, onBtnMenuTrigger);
			
			addChild(_btnNext = new TextButton("next day"));
			_btnNext.x = int(u * 6);
			_btnNext.y = int(u * 8);
			_btnNext.addEventListener(Event.TRIGGERED, onBtnNextTrigger);
			
			addChild(_btnToDaySelection = new TextButton("day selection"));
			_btnToDaySelection.x = int(u * 11);
			_btnToDaySelection.y = int(u * 8);
			_btnToDaySelection.addEventListener(Event.TRIGGERED, onBtnDaySelectTrigger);
			
			//addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			GameEvents.subscribe(GameEvents.DAY_START, onDayStart);
			//GameEvents.subscribe(GameEvents.DAY_END, onDayEnd);
		}
		
		private function onBtnDaySelectTrigger(e:Event):void 
		{
			Screens.gotoScreen(LoadGameScreen);
		}
		
		private function onBtnMenuTrigger(e:Event):void 
		{
			Screens.gotoScreen(MainMenu);
		}
		
		private function onDayStart(e: Event, d: DayData):void 
		{
			day = d;
		}
		
		//public function enter(): void
		override protected function onEnter():void 
		{
			//_dayNumberText.text = "day " + day.dayNumber.toString() + " end";
			_dayNumberText.text = day.dayNumber.toString();
			_scoreText.text = day.save.score.toString();
				//"score . . . . . . . . . 120 ";
				//"score . . . . . . . . . " + day.save.score.toString() + " ";
			
			var stars: String = "";
			if (day.save.stars > 0)
				stars = "*";
			for (var i:int = 1; i < day.save.stars; i++) 
				stars += " *"
					
			_starsText.text = stars;
			_starsShadowText.text = stars;
			
			if (day.save.stars > 0)
			{
				_successText.text = "Day completed!";
				_btnNext.enabled = Saves.nextDay(day.save);
				Saves.saveDays();
			}
			else
				_successText.text = "Day failed. Try again!";
		}
		
		private function onBtnNextTrigger(e: Event): void 
		{
			Screens.gotoScreen(GameScreen);
		}
	}
}
