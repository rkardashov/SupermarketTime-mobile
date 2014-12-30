package screens 
{
	import data.Assets;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.display.Button;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;
	import starling.textures.RenderTexture;// TextureOptions;
	import starling.utils.AssetManager;
	
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
			/*addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		protected function addedToStageHandler(event: Event): void
		{*/
			super();
			
			//scaleX = scaleY = 2;// 4;
			addChild(Assets.getImage("bg_main_menu"));
			
			addChild(btnPlay = new PixelButton("btn_play_up", "btn_play_down"));
			btnPlay.scaleX = btnPlay.scaleY = 2;
			btnPlay.x = Screens.unit * 8;
			btnPlay.y = Screens.unit * 4;
			btnPlay.addEventListener(Event.TRIGGERED, btnPlayTriggered);
		}
		
		private function onBtnPlayTouch(e: TouchEvent): void 
		{
			var touch: Touch = e.getTouch(btnPlay, TouchPhase.ENDED);
			if (touch)
				Screens.gotoScreen(LoadGameScreen);
		}
		
		private function btnPlayTriggered(e:Event):void 
		{
			Screens.gotoScreen(LoadGameScreen);
		}
	}
}
