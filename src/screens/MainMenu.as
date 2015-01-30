package screens 
{
	import data.Assets;
	import starling.events.Event;
	/**
	 * ...
	 * @author rkardashov@gmail.com
	 */
	public class MainMenu extends BasicScreen
	{
		protected var btnPlay: PixelButton;
		protected var btnOptions: PixelButton;
		
		public function MainMenu()
		{
			super();
			
			addChild(Assets.getImage("bg_main_menu"));
			
			addChild(btnPlay = new PixelButton("btn_play_up", "btn_play_down"));
			btnPlay.scaleX = btnPlay.scaleY = 2;
			btnPlay.x = Screens.unit * 8;
			btnPlay.y = Screens.unit * 4;
			btnPlay.addEventListener(Event.TRIGGERED, btnPlayTriggered);
		}
		
		/*override protected function onEnter():void 
		{
		}*/
		
		private function btnPlayTriggered(e:Event):void 
		{
			/*btnPlay.removeEventListener(Event.TRIGGERED, btnPlayTriggered);*/
			if (state == STATE_ACTIVE)
				Screens.gotoScreen(LoadGameScreen);
		}
	}
}
