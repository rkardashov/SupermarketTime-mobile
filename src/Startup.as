package  
{
	import flash.display.Sprite;
	import starling.core.Starling;
	import screens.Screens;
	
	/**
	 * ...
	 * @author rkardashov@gmail.com
	 */
	public class Startup extends Sprite
	{
		private var _starling: Starling;

		public function Startup()
		{
			Starling.handleLostContext = true;
			_starling = new Starling(Screens, stage);
			_starling.showStats = true;
			_starling.antiAliasing = 0;
			_starling.start();
		}
	}
}
