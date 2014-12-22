package screens 
{
	import data.Assets;
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.events.Event;
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
		}
	}
}
