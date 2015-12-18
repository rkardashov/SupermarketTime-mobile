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
			
			alignPivot();
			y = 70;
			
			// tutorial "bubble"
			var bubble: SpeechBubble = new SpeechBubble(
				this, "dividerMoveMeBubble");
			bubble.alignPivot("left", "center");
			bubble.x = imgDivider.width;
			bubble.y = imgDivider.height >> 1;
		}
		
		override protected function onDrag(): void 
		{
			y = 70;
			if (x < 0)
				x = 0;
		}
		
		override protected function onDrop(): void 
		{
			if (x > 150)
				GameEvents.dispatch(GameEvents.CONVEYOR_GOODS_REQUEST);
		}
	}
}
