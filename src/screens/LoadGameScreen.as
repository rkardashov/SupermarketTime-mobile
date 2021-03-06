package screens
{
	import data.Assets;
	import data.DaySave;
	import data.Saves;
	import LoadDayButton;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author rkardashov@gmail.com
	 */
	public class LoadGameScreen extends BasicScreen
	{
		protected var btnContinue: PixelButton;
		
		public function LoadGameScreen()
		{
			super();
			addChild(Assets.getImage("bg_load_game"));
		}
		
		override protected function onEnter(): void
		{
			Saves.loadDays(onDaysLoaded);
		}
		
		private function onDaysLoaded(days: Vector.<DaySave>): void 
		{
			var btn: LoadDayButton;
			for each (var day: DaySave in days) 
			{
				addChild(btn = new LoadDayButton(day));
				btn.x = 50;
				btn.y = 20 + day.index * 20;
				btn.addEventListener(Event.TRIGGERED, onBtnTrigger);
			}
		}
		
		private function onBtnTrigger(e:Event):void 
		{
			if (state !== STATE_ACTIVE)
				return;
			if (Saves.selectDay((e.currentTarget as LoadDayButton).day.index))
				Screens.gotoScreen(GameScreen);
		}
	}
}
