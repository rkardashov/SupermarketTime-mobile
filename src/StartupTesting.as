package  
{
	import flash.display.Sprite;
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
			_starling = new Starling(TestingScreen, stage);
			_starling.showStats = true;
			_starling.antiAliasing = 0;
			_starling.start();
		}
	}
}
