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
	
	/**
	 * ...
	 * @author rkardashov@gmail.com
	 */
	public class DayEndScreen extends Sprite 
	{
		private var _scoreText: TextField;
		private var _dayNumberText: TextField;
		private var _successText: TextField;
		private var _starsText: TextField;
		
		private var _btnNext: TextButton;
		private var _btnToMenu: TextButton;
		private var _btnToDaySelection: TextButton;
		
		private var day: DayData;
		
		public function DayEndScreen() 
		{
			super();
			scaleX = scaleY = 2;
			
			addChild(Assets.getImage("bg_day_end"));
			
			var u: int = Screens.unit;
			
			addChild(_dayNumberText = new TextField(u*2, u*2, "0", "arcade_10", 24));
			_dayNumberText.x = int(u * 7);
			_dayNumberText.y = 0;// int(u * 1);
			addChild(_scoreText = new TextField(100, 50, "0", "systematic_9", 9));
			_scoreText.x = int(u * 9);
			_scoreText.y = int(u * 1.5);
			
			addChild(_successText = new TextField(u*4, 50, "", "Courier New", 14));
			_successText.x = int(u * 5);
			_successText.y = int(u * 4);
			
			addChild(_starsText = new TextField(u*4, 50, "", "Systematic_9", 18));
			_starsText.x = int(u * 8);
			_starsText.y = int(u * 6);
			
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
		
		public function enter(): void
		//private function onDayEnd(e: Event, d: DayData): void 
		{
			//_dayNumberText.text = Saves.currentDay.index.toString();
			//_scoreText.text = Saves.currentDay.score.toString();
			_dayNumberText.text = day.dayNumber.toString();
			_scoreText.text = day.save.score.toString();
			
			var stars: String = "";
			//for (var i:int = 0; i < Saves.currentDay.stars; i++) 
			for (var i:int = 0; i < day.save.stars; i++) 
				stars += " *";
			_starsText.text = stars;
			
			//if (Saves.currentDay.stars > 0)
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
