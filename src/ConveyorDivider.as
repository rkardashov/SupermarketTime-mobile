package  
{
	import data.Assets;
	import data.DayData;
	import flash.geom.Point;
	import starling.display.Image;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;
	
	/**
	 * ...
	 * @author ...
	 */
	public class ConveyorDivider extends Item
	{
		public function ConveyorDivider() 
		{
			super(TYPE_CONVEYOR_DIVIDER);
			
			var imgDivider: Image = Assets.getImage("conveyor_divider");
			addChild(imgDivider);
			
			// tutorial "bubble"
			var bubble: SpeechBubble = new SpeechBubble(
				this, // parent object
				"dividerMoveMeBubble", // day xml attribute name
				70, 50, // text area size
				"move me to the right", // speech text
				GameEvents.CUSTOMER_ARRIVED, // show on this event
				GameEvents.CONVEYOR_GOODS_REQUEST // hide on this event
				);
			bubble.alignPivot("left", "center");
			bubble.x = imgDivider.width;
			bubble.y = imgDivider.height >> 1;
		}
		
		override protected function onDrag(): void 
		{
			y = 0;
			if (x < 0)
				x = 0;
			/*if (x > 150)
				//onDividerMoveOut();
				GameEvents.dispatch(GameEvents.CONVEYOR_GOODS_REQUEST);*/
		}
		
		override protected function onDrop(): void 
		{
			//trace("divider x = " + int(x));
			if (x > 150)
				//onDividerMoveOut();
				GameEvents.dispatch(GameEvents.CONVEYOR_GOODS_REQUEST);
		}
	}
}
