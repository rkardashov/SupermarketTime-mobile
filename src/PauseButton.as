package
{
	import screens.GameScreen;
	import screens.Screens;
	import starling.core.Starling;
	import starling.events.Event;
	/**
	 * ...
	 * @author rkardashov@gmail.com
	 */
	public class PauseButton extends PixelButton 
	{
		//private var gameScreen: GameScreen;
		
		public function PauseButton() 
		{
			super("btnPauseUp", "btnPauseDown");
			x = Screens.unit * (Screens.uWidth - 2);
			y = Screens.unit * 1;
			
			addEventListener(Event.TRIGGERED, onTrigger);
			
			//gameScreen = Screens.getScreen(GameScreen) as GameScreen;
		}
		
		private function onTrigger(e: Event): void 
		{
			//gameScreen.pauseGame();
			//gameScreen.dispatchEventWith(GameScreen.EVENT_PAUSE);// , true);
			//Screens.getScreen(GameScreen).dispatchEventWith(GameScreen.EVENT_PAUSE);
			GameEvents.dispatch(GameEvents.PAUSE, true);
		}
	}
}
