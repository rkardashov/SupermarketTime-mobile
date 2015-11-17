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
		private var eventShow: String;
		private var eventHide: String;
		private var checkEventShow: Function = null;
		private var checkEventHide: Function = null;
		
		private var pointer: Image;
		//private var speech: Speech;
		
		public function SpeechBubble(
			owner: DisplayObjectContainer, dayAttribute: String,
			textWidth: int, textHeight: int, speechText: String,
			eventShow: String, eventHide: String,
			checkEventShow: Function = null,
			checkEventHide: Function = null) 
		{
			super();
			this.dayAttribute = dayAttribute;
			this.owner = owner;
			this.eventHide = eventHide;
			this.eventShow = eventShow;
			this.checkEventShow = checkEventShow;
			this.checkEventHide = checkEventHide;
			
			text = new TextField(textWidth, textHeight, speechText, "Systematic_9", 9);
			//text.x = 5;// -2;
			//text.y = -3;// -2;
			text.autoScale = false;
			text.hAlign = "center";
			text.vAlign = "center";
			
			var scale9Textures: Scale9Textures = new Scale9Textures
				(Assets.getTexture("bubbleScale9"), new Rectangle(3, 3, 1, 1));
			var bubble: Scale9Image = new Scale9Image(scale9Textures);
			bubble.smoothing = "none";
			bubble.width = text.textBounds.width + 16;
			bubble.height = text.textBounds.height + 12;// 16;
			
			text.alignPivot();
			text.x = bubble.width >> 1;
			text.y = -3 + bubble.height >> 1;
			
			pointer = Assets.getImage("bubbleScale9");// bubblePointer");
			
			addChild(bubble);
			bubble.addChild(text);
			addChild(pointer);
			
			GameEvents.subscribe(GameEvents.DAY_START, onDayStart);
			GameEvents.subscribe(GameEvents.DAY_END, onDayEnd);
		}
		
		override public function alignPivot(hAlign: String = "center", vAlign: String = "center"): void 
		{
			// 0, h/2
			//trace("pivot: " + pivotX + "," + pivotY);
			super.alignPivot(hAlign, vAlign);
			pivotX = Math.round(pivotX);
			pivotY = Math.round(pivotY);
			//text.pivotX = pivotX;
			//text.pivotY = pivotY;
			//trace("pivot: " + pivotX + "," + pivotY);
			var alignInvert: Object = {
				"center": "center",
				"left": "right",
				"right": "left",
				"top":"bottom",
				"bottom":"top"
			};
			pointer.alignPivot(alignInvert[hAlign], alignInvert[vAlign]);
			pointer.x = pivotX;
			pointer.y = pivotY;
		}
		
		private function onDayStart(e: Event, d: DayData): void 
		{
			if (!d.hasAttribute(dayAttribute))
				return;
			
			if (eventShow == "")
				owner.addChild(this)
			else
				GameEvents.subscribe(eventShow, onShowEvent);
			if (eventHide !== "")
				GameEvents.subscribe(eventHide, onHideEvent);
		}
		
		private function onShowEvent(e: Event, p: * = null): void 
		{
			if ((checkEventShow == null) || checkEventShow(e, p))
				owner.addChild(this);
		}
		
		private function onHideEvent(e: Event, p: * = null): void
		{
			if ((checkEventHide == null) || checkEventHide(e, p))
				owner.removeChild(this);
		}
		
		private function onDayEnd(e: Event): void 
		{
			owner.removeChild(this);
			GameEvents.unsubscribe(eventShow, onShowEvent);
			GameEvents.unsubscribe(eventHide, onHideEvent);
		}
	}
}
