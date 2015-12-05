package  
{
	import data.Saves;
	import flash.display.Sprite;
	import screens.GameScreen;
	import screens.Screens;
	import tests.TestingScreen;
	import starling.core.Starling;
	
	/**
	 * ...
	 * @author rkardashov@gmail.com
	 */
	public class StartupTesting extends Sprite
	{
		private var _starling: Starling;
		
		public function StartupTesting()
		{
			Starling.handleLostContext = true;
			Screens.onScreensLoaded = onScreensLoaded;
			_starling = new Starling(Screens, stage);
			_starling.showStats = true;
			_starling.antiAliasing = 0;
			_starling.start();
		}
		
		private function onScreensLoaded(): void 
		{
			if (Saves.selectDay(-1))
				Screens.gotoScreen(GameScreen);
		}
	}
}
