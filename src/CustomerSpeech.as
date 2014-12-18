package 
{
	import data.Assets;
	import data.CustomerInfo;
	import data.Speech;
	import screens.Screens;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author rkardashov@gmail.com
	 */
	public class CustomerSpeech extends Sprite 
	{
		private var textField: TextField;
		private var bg: Image;
		private var bubble: Sprite;
		
		public function CustomerSpeech() 
		{
			super();
			addChild(bg = new Image(Texture.fromColor(
				Screens.uWidth * Screens.unit,
				Screens.uHeight * Screens.unit,
				0x00000000)));
			addChild(bubble = new Sprite());
			bubble.addChild(Assets.getImage("bubble_customer"));
			bubble.x = int((Screens.uWidth * Screens.unit - bubble.width) * 0.75);
			bubble.y = 0;// int(Screens.unit * 0.5);
			bubble.addChild(textField = new TextField(200, 50, "", "Systematic_9", 9));
			textField.x = 16;
			textField.y = 6;
			textField.hAlign = "left";
			textField.autoSize = TextFieldAutoSize.VERTICAL;
			visible = false;
			touchable = false;
			
			GameEvents.subscribe(GameEvents.GOOD_WRONG_BAG, onGoodWrongBag);
		}
		
		private function onGoodWrongBag(e: Event, g: Good): void 
		{
			// TODO: get phrase & category name strings from xml
			textField.text = "Please put this to another bag!";
			visible = true;
			alpha = 1;
			Starling.juggler.tween(this, 3.0,
				{
					alpha: 0,
					transition: Transitions.EASE_IN_OUT
					//roundToInt: true,
					//onComplete: onArrived
				});
		}
	}
}
