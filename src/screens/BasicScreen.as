package screens 
{
	import starling.animation.Transitions;
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.Event;
	
	/**
	 * ...
	 * @author rkardashov@gmail.com
	 */
	public class BasicScreen extends Sprite 
	{
		static protected const FADEOUT_DURATION: Number = 0.7;
		static protected const FADEIN_DURATION: Number = 1.2;
		
		private var nextScreenClass: Class;
		
		public function BasicScreen() 
		{
			super();
			scaleX = scaleY = 2;
			GameEvents.subscribe(GameEvents.SCREEN_CHANGE, onScreenChange);
			GameEvents.subscribe(GameEvents.SCREEN_ENTER, onScreenEnter);
		}
		
		private function onScreenEnter(e: Event, screenClass: Class): void 
		{
			if (this as screenClass)
			{
				alpha = 0;
				onEnter();
				Starling.juggler.tween(this, FADEIN_DURATION,
				{
					alpha: 1.0,
					transition: Transitions.EASE_IN_OUT,
					onComplete: onReady
				});
			}
		}
		
		private function onScreenChange(e: Event, screenClass: Class): void 
		{
			nextScreenClass = screenClass;
			alpha = 1;
			Starling.juggler.tween(this, FADEOUT_DURATION,
			{
				alpha: 0.0,
				transition: Transitions.EASE_IN_OUT,
				onComplete: onFadeOut
			});
		}
		
		private function onFadeOut(): void
		{
			onExit();
			removeFromParent();
			GameEvents.dispatch(GameEvents.SCREEN_ENTER, nextScreenClass);
		}
		
		// called when screen was just added to stage, right before fade-in effect start
		protected function onEnter(): void 
		{
		}
		
		// called when fade-in effect finished
		protected function onReady(): void 
		{
		}
		
		// called when fade-out effect finished, right before removing from the stage
		protected function onExit(): void 
		{
		}
	}
}
