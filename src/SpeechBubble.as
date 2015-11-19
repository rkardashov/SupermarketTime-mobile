package 
{
	import data.Assets;
	import data.CustomerInfo;
	import data.DayData;
	import data.Speech;
	import data.SpeechPhrase;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	import flash.geom.Rectangle;
	import screens.Screens;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
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
	public class SpeechBubble extends Sprite 
	{
		private var owner: DisplayObjectContainer;
		private var text: TextField;
		private var dayAttribute: String;
		private var hAlign: String = "left";
		private var vAlign: String = "center";
		
		private var currentPhrase: SpeechPhrase = null;
		private var phrasesShow: Object = { };
		private var phrasesHide: Object = { };
		private var checkersShow: Object = { };
		private var checkersHide: Object = { };
		
		private var bubble: Scale9Image;
		private var pointer: Image;
		
		public function SpeechBubble(
			owner: DisplayObjectContainer, dayAttribute: String,
			textWidth: int, textHeight: int) 
		{
			super();
			this.dayAttribute = dayAttribute;
			this.owner = owner;
			
			text = new TextField(textWidth, textHeight, "", "Systematic_9", 9);
			text.autoScale = false;
			text.autoSize = "none";
			text.hAlign = "center";
			text.vAlign = "center";
			
			var scale9Textures: Scale9Textures = new Scale9Textures
				(Assets.getTexture("bubbleScale9"), new Rectangle(3, 3, 1, 1));
			bubble = new Scale9Image(scale9Textures);
			bubble.smoothing = "none";
			
			pointer = Assets.getImage("bubbleScale9");// bubblePointer");
			
			addChild(bubble);
			bubble.addChild(text);
			addChild(pointer);
			
			updateBubble();
			
			GameEvents.subscribe(GameEvents.DAY_START, onDayStart);
			GameEvents.subscribe(GameEvents.DAY_END, onDayEnd);
		}
		
		private function updateBubble(): void 
		{
			bubble.width = text.textBounds.width + 16;
			bubble.height = text.textBounds.height + 12;
			
			text.alignPivot();
			text.x = bubble.width >> 1;
			text.y = -3 + bubble.height >> 1;
			
			alignPivot(hAlign, vAlign);
		}
		
		override public function alignPivot(hAlign: String = "center", vAlign: String = "center"): void 
		{
			this.hAlign = hAlign;
			this.vAlign = vAlign;
			removeChild(pointer);
			super.alignPivot(hAlign, vAlign);
			pivotX = Math.round(pivotX);
			pivotY = Math.round(pivotY);
			var alignInvert: Object = {
				"center": "center",
				"left": "right",
				"right": "left",
				"top":"bottom",
				"bottom":"top"
			};
			addChild(pointer);
			pointer.alignPivot(alignInvert[hAlign], alignInvert[vAlign]);
			pointer.x = pivotX;
			pointer.y = pivotY;
		}
		
		public function addPhrase(speechText: String,
			eventShow: String, eventHide: String,
			checkEventShow: Function = null,
			checkEventHide: Function = null):void 
		{
			var p: SpeechPhrase = new SpeechPhrase();
			p.text = speechText;
			p.eventShow = eventShow;
			p.eventHide = eventHide;
			phrasesShow[eventShow] = p;
			phrasesHide[eventHide] = p;
			checkersShow[eventShow] = checkEventShow;
			checkersHide[eventHide] = checkEventHide;
		}
		
		private function onDayStart(e: Event, d: DayData): void 
		{
			if (!d.hasAttribute(dayAttribute))
				return;
			
			for each (var p: SpeechPhrase in phrasesShow) 
			{
				if (p.eventShow == "")
				{
					text.text = p.text;
					updateBubble();
					owner.addChild(this);
				} else
					GameEvents.subscribe(p.eventShow, onShowEvent);
			}
		}
		
		private function onShowEvent(e: Event, p: * = null): void 
		{
			if (currentPhrase)
				GameEvents.unsubscribe(currentPhrase.eventHide, onHideEvent);
			
			currentPhrase = phrasesShow[e.type];
			if (!currentPhrase)
				return;
				
			if ((checkersShow[e.type] == null) || checkersShow[e.type](e, p))
			{
				text.text = currentPhrase.text;
				updateBubble();
				owner.addChild(this);
				GameEvents.subscribe(currentPhrase.eventHide, onHideEvent);
			}
		}
		
		private function onHideEvent(e: Event, p: * = null): void
		{
			if ((checkersHide[e.type] == null) || checkersHide[e.type](e, p))
			{
				currentPhrase = phrasesHide[e.type];
				if (currentPhrase)
				{
					GameEvents.unsubscribe(currentPhrase.eventHide, onHideEvent);
					GameEvents.subscribe(currentPhrase.eventShow, onShowEvent);
				}
				owner.removeChild(this);
				currentPhrase = null;
			}
		}
		
		private function onDayEnd(e: Event): void 
		{
			owner.removeChild(this);
			currentPhrase = null;
			for each (var p: SpeechPhrase in phrasesShow) 
			{
				GameEvents.unsubscribe(p.eventShow, onShowEvent);
				GameEvents.unsubscribe(p.eventHide, onHideEvent);
			}
		}
	}
}
