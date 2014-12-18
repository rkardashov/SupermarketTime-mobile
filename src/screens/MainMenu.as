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
	public class MainMenu extends Sprite
	{
		protected var btnPlay: PixelButton;
		protected var btnOptions: PixelButton;
		
		public function MainMenu()
		{
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		protected function addedToStageHandler(event: Event): void
		{
			scaleX = scaleY = 2;// 4;
			//addChild(Assets.getImage(Assets.bg_mainmenu));
			addChild(Assets.getImage("bg_main_menu"));
			
			//addChild(btnPlay = new PixelButton(Assets.btn_play));
			addChild(btnPlay = new PixelButton("btn_play"));
			btnPlay.x = Screens.unit * 7;
			btnPlay.y = Screens.unit * 3;
			btnPlay.addEventListener(Event.TRIGGERED, btnPlayTriggered);
			
			//addChild(btnOptions = new PixelButton(Assets.btn_options));
			addChild(btnOptions = new PixelButton("btn_options"));
			btnOptions.x = Screens.unit * 6;
			btnOptions.y = Screens.unit * 5;
			btnOptions.addEventListener(Event.TRIGGERED, btnOptionsTriggered);
			
			alpha = 0;
			Starling.juggler.tween(this, 2.0,
				{
					alpha: 1.0,
					transition: Transitions.EASE_IN_OUT
					//roundToInt: true,
					//onComplete: onArrived
				});
		}
		
		private function onBtnPlayTouch(e: TouchEvent): void 
		{
			var touch: Touch = e.getTouch(btnPlay, TouchPhase.ENDED);
			if (touch)
				Screens.gotoScreen(LoadGameScreen);
		}
		
		private function btnPlayTriggered(e:Event):void 
		{
			/*const label: Label = new Label();
			label.text = "Hi, I'm Feathers!\nВсего хорошего.";
			Callout.show( label, btnPlay );*/
			//Screens.navigator.showScreen(LoadGameScreen.id);
			Screens.gotoScreen(LoadGameScreen);
			//trace("btn PLAY triggered");
		}
		
		private function btnOptionsTriggered(e:Event):void 
		{
			
		}
	}
}
