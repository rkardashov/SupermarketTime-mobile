package  
{
	import flash.display.Sprite;
	import screens.TestingScreen;
	import starling.core.Starling;
	
	/**
	 * ...
	 * @author rkardashov@gmail.com
	 */
	public class Testing extends Sprite
	{
		private var _starling: Starling;
		
		public function Testing()
		{
			_starling = new Starling(TestingScreen, stage);
			_starling.showStats = true;
			_starling.antiAliasing = 0;
			_starling.start();
		}
	}
}
