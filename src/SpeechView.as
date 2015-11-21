package 
{
	import data.Assets;
	import data.CustomerInfo;
	import data.DayData;
	import data.Speech;
	import data.SpeechPhrase;
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
		private var bubbleText: TextField;
		private var speech: Speech;
		
		public function SpeechView() 
		{
			super();
			
			addChild(Assets.getImage("bubble_customer_speech"));
			addChild(bubbleText = new TextField(150, 60, "", "Systematic_9", 9));
			bubbleText.x = 10;
			bubbleText.autoScale = false;
			bubbleText.hAlign = "left";
			bubbleText.vAlign = "center";
			
			visible = false;
			
			GameEvents.subscribe(GameEvents.CUSTOMER_ARRIVED, onCustomerArrived);
		}
		
		private function onCustomerArrived(e: Event, c: CustomerInfo): void 
		{
			// subscribe to all speech events
			speech = c.speech;
			for each (var p: SpeechPhrase in speech.phrases)
				GameEvents.subscribe(p.eventShow, onShowEvent);
			var welcomePhrase: SpeechPhrase = speech.getPhrase("default");
			if (welcomePhrase)
				speak(welcomePhrase);
		}
		
		private function onShowEvent(e: Event): void 
		{
			var phrase: SpeechPhrase = speech.getPhrase(e.type);
			if (phrase)
				speak(phrase);
		}
		
		private function speak(phrase: SpeechPhrase): void 
		{
			if (phrase.disposable)
				GameEvents.unsubscribe(phrase.eventShow, onShowEvent);
			visible = true;
			bubbleText.text = phrase.text;
			if (phrase.eventHide !== "")
				GameEvents.subscribe(phrase.eventHide, onHideEvent);
		}
		
		private function onHideEvent(e: Event): void
		{
			visible = false;
			GameEvents.unsubscribe(e.type, onHideEvent);
		}
	}
}
