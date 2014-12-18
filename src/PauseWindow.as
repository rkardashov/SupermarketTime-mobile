package
{
	import data.Assets;
	import screens.GameScreen;
	import screens.Screens;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author rkardashov@gmail.com
	 */
	public class PauseWindow extends Sprite 
	{
		private var textPause: TextField;
		private var textTapScreen: TextField;
		//private var onCloseCallback: Function;
		private var fadeOut: Boolean = false;
		private var layerText: Sprite;
		//private var messageQueue: Vector.<String> = new Vector.<String>();
		
		public function PauseWindow() 
		{
			super();
			//onCloseCallback = onClose;
			addChild(new Image(Texture.fromColor(
				Screens.uWidth * Screens.unit, Screens.uHeight * Screens.unit, 
				0x0)));
			var bubble: Image = Assets.getImage("bubble_briefing");
			addChild(bubble);
			bubble.x = int((Screens.uWidth * Screens.unit - bubble.width) / 2);
			bubble.y = int((Screens.uHeight * Screens.unit - bubble.height) / 2);
			
			layerText = addChild(new Sprite()) as Sprite;
			
			layerText.addChild(textPause = new TextField(260, 80, "", "Arcade_10", 20));
			textPause.x = bubble.x + 10;
			textPause.y = bubble.y + 10;
			textPause.text = " PAUSE ";
			
			layerText.addChild(
				textTapScreen = new TextField(260, 80, "", "Arcade_10", 10));
			textTapScreen.x = bubble.x + 10;
			textTapScreen.y = bubble.y + 50;
			textTapScreen.text = "tap to continue";
			
			addEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
			addEventListener(TouchEvent.TOUCH, onTouch);
			//Screens.getScreen(GameScreen).addEventListener(GameScreen.EVENT_PAUSE, onPause);
			//GameEvents.subscribe(GameEvents.PAUSE, show);// onPause);
			GameEvents.subscribe(GameEvents.PAUSE, onPause);
			
			visible = false;
		}
		
		private function onPause(e: Event, showPauseWindow: Boolean = false): void 
		{
			if (showPauseWindow)
				show();
		}
		
		private function show(): void 
		{
			//messageQueue.splice(0, messageQueue.length, messages);
			//messageQueue = messages.slice();
			//textPause.text = " PAUSE ";
			layerText.alpha = 1;
			visible = true;
			//addEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
			//nextMessage();
		}
		
		private function onEnterFrame(e:Event):void 
		{
			if (fadeOut)
				layerText.alpha -= 0.03
			else
				layerText.alpha += 0.03;
			
			if (layerText.alpha >= 1.0)
				fadeOut = true;
			if (layerText.alpha <= 0.4)
			//{
				fadeOut = false;
				//removeEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
				//visible = false;
				//onCloseCallback();
			//}
		}
		
		private function onTouch(e: TouchEvent): void 
		{
			if (e.getTouch(this, TouchPhase.ENDED))
			{
				visible = false;
				GameEvents.dispatch(GameEvents.RESUME);
				//Screens.getScreen(GameScreen).
					//dispatchEventWith(GameScreen.EVENT_RESUME , true);
				//dispatchEventWith(GameScreen.EVENT_RESUME, true);
			}
		}
	}
}
