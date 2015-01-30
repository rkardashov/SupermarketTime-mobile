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
		static protected const STATE_INACTIVE: int = 0;
		static protected const STATE_ENTERING: int = 1;
		static protected const STATE_ACTIVE: int = 2;
		static protected const STATE_EXITING: int = 3;
		
		protected var state: int = STATE_INACTIVE;
		
		private var nextScreenClass: Class;
		
		public function BasicScreen() 
		{
			super();
			scaleX = scaleY = 3;
			GameEvents.subscribe(GameEvents.SCREEN_CHANGE, onScreenChange);
			GameEvents.subscribe(GameEvents.SCREEN_ENTER, onScreenEnter);
		}
		
		private function onScreenEnter(e: Event, screenClass: Class): void 
		{
			if (this as screenClass)
			{
				state = STATE_ENTERING;
				alpha = 0;
				onEnter();
				Starling.juggler.tween(this, FADEIN_DURATION,
				{
					alpha: 1.0,
					transition: Transitions.EASE_IN_OUT,
					onComplete: function(): void {
						state = STATE_ACTIVE;
						onReady(); }
				});
			}
		}
		
		private function onScreenChange(e: Event, screenClass: Class): void 
		{
			nextScreenClass = screenClass;
			alpha = 1;
			state = STATE_EXITING;
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
			state = STATE_INACTIVE;
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
