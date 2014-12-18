package screens 
{
	import data.Assets;
	import data.Saves;
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.events.Event;
	import flash.filesystem.File;
	import starling.utils.AssetManager;
	/**
	 * ...
	 * @author rkardashov@gmail.com
	 */
	public class Screens extends Sprite 
	{
		static private var _screens: Object = {};
		static private var _instance: Screens;
		static private var _currentScreen: DisplayObject;
		
		static public var unit: int;
		static public var uHeight: int = 10;
		static public var uWidth: int = 16;
		static public var scale: int = 1;
		static public var centerX: int;
		static public var centerY: int;
		
		public function Screens() 
		{
			super();
			_instance = this;
			
			Saves.init();
			Assets.init();
			
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		/*
		 
		stage.addEventListener(Event.RESIZE, stageResized);
		
		private function stageResized(e:Event):void
		{
			starling.stage.stageWidth = this.stage.stageWidth;
			starling.stage.stageHeight = this.stage.stageHeight;
			const viewPort:Rectangle = starling.viewPort;
			viewPort.width = this.stage.stageWidth;
			viewPort.height = this.stage.stageHeight;
			starling.viewPort = viewPort;
		}*/
		
		protected function addedToStageHandler(event: Event): void
		{
			unit = 24;// 12;// stage.stageHeight / uHeight;
			//scrUnit = 12;// stage.stageWidth / scrUWidth;
			scale = stage.stageHeight / 240;// 120;
			centerX = 200;// 60;
			centerY = 120;// 60;
			
			//stage.scaleX = stage.scaleY = 4;
			
			//Assets.manager = new AssetManager();
			
			_screens[MainMenu] = new MainMenu();
			_screens[LoadGameScreen] = new LoadGameScreen();
			_screens[GameScreen] = new GameScreen();
			_screens[DayEndScreen] = new DayEndScreen();
			
			gotoScreen(MainMenu);
			//gotoScreen(DayEndScreen);
		}
		
		static public function gotoScreen(screenClass: Class): void 
		{
			if (_currentScreen)
				_instance.removeChild(_currentScreen);
			if (_screens[screenClass])
				_instance.addChild(_screens[screenClass]);
			_currentScreen = _screens[screenClass];
			if (_currentScreen.hasOwnProperty("enter"))
				_currentScreen["enter"]();
		}
		
		static public function getScreen(screenClass: Class): DisplayObject
		{
			return _screens[screenClass];
		}
		
		/*static public function alignPixel(x: Number): int 
		{
			return x - x % scale;
		}*/
	}
}
