package 
{
	import data.Assets;
	import data.CustomerInfo;
	import data.Speech;
	import screens.Screens;
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
	public class SpeechView extends Sprite 
	{
		private var textField: TextField;
		//private var commandCallback: Function;
		private var bg: Image;
		private var bubble: Sprite;
		private var speechList: Vector.<Speech>;
		private var speech: Speech;
		private var onEndCallback: Function;
		private var dayEnd:Boolean;
		
		public function SpeechView(/*commandCallback: Function*/) 
		{
			super();
			//this.commandCallback = commandCallback;
			addChild(bg = new Image(Texture.fromColor(
				Screens.uWidth * Screens.unit,
				Screens.uHeight * Screens.unit,
				//0x33000000)));
				0x00000000)));
			addChild(bubble = new Sprite());
			bubble.addChild(Assets.getImage("bubble_customer"));
			bubble.x = int((Screens.uWidth * Screens.unit - bubble.width) * 0.75);
			bubble.y = 0;// int(Screens.unit * 0.5);
			bubble.addChild(textField = new TextField(200, 50, ""));// Systematic"));
			textField.fontSize = 9;
			textField.x = /*bubble.x + */16;
			textField.y = /*bubble.y + */6;
			textField.hAlign = "left";
			textField.autoSize = TextFieldAutoSize.VERTICAL;
			visible = false;
			bubble.addEventListener(TouchEvent.TOUCH, onTouch);
			
			GameEvents.subscribe(GameEvents.CUSTOMER_ARRIVED, onCustomerEvent);
			GameEvents.subscribe(GameEvents.CUSTOMER_COMPLETE, onCustomerEvent);
			GameEvents.subscribe(GameEvents.GOOD_ENTER, onGoodEvent);
			GameEvents.subscribe(GameEvents.GOOD_SCANNED, onGoodEvent);
			GameEvents.subscribe(GameEvents.GOOD_CHECKOUT, onGoodEvent);
			//GameEvents.subscribe(GameEvents.BAG_GOOD_ADDED, onGoodEvent);
		}
		
		private function onGoodEvent(e: Event, g: Good): void 
		{
			show(g.info.messages[e.type]);
		}
		
		private function onCustomerEvent(e: Event, c: CustomerInfo):void 
		{
			show(c.messages[e.type]);
		}
		
		private function onTouch(e: TouchEvent): void 
		{
			if (e.getTouch(bubble, TouchPhase.ENDED))
			{
				if (!speech.instruction)
					nextMessage();
			}
		}
		
		private function show(messages: Vector.<Speech>/*, endCallback: Function*/): void 
		{
			speechList = messages.slice();
			//onEndCallback = endCallback;
			nextMessage();
		}
		
		private function nextMessage(): void 
		{
			speech = speechList.shift();
			visible = (speech !== null);
			if (speech)
			{
				//GameEvents.dispatch(GameEvents.MESSAGE_SHOW);
				bg.visible = !speech.instruction;
				textField.text = speech.text;
				if (speech.instruction)
					endCallback();
			}
			else
				endCallback();
		}
		
		private function endCallback(): void 
		{
			//if (onEndCallback !== null)
				//onEndCallback();
			//GameEvents.dispatch(GameEvents.MESSAGE_CLOSE);
		}
	}
}
