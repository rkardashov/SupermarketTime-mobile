package tests
{
	import data.Assets;
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	/**
	 * ...
	 * @author rkardashov@gmail.com
	 */
	public class TestingScreen extends Sprite 
	{
		static public var unit: int;
		static public var uHeight: int = 10;
		static public var uWidth: int = 16;
		static public var scale: int = 1;
		static public var centerX: int;
		static public var centerY: int;
		
		private var popup:ScorePopup;
		
		public function TestingScreen() 
		{
			super();
			
			Assets.init();
			
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		protected function addedToStageHandler(event: Event): void
		{
			unit = 24;
			scale = stage.stageHeight / 240;
			centerX = 200;
			centerY = 120;
			scaleX = scaleY = 2;
			
			
			addChild(Assets.getImage("bg_game"));
			
			ScorePopup.init(this);
			//addChild(popup = new ScorePopup());
			
			addEventListener(TouchEvent.TOUCH, onTouch);
		}
		
		private function onTouch(e: TouchEvent): void 
		{
			if (e.getTouch(this, TouchPhase.ENDED))
				GameEvents.dispatch(GameEvents.ADD_SCORE, new ScoreChange("bonus points!", 15, 50, centerY));
		}
	}
}
