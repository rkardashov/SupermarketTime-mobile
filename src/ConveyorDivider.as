package  
{
	import data.Assets;
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
	public class ConveyorDivider extends Item// Image
	{
		//private var onDividerMoveOut:Function;
		
		public function ConveyorDivider(/*onDividerMoveOut: Function*/) 
		{
			super(TYPE_CONVEYOR_DIVIDER);
			
			//this.onDividerMoveOut = onDividerMoveOut;
			
			addChild(Assets.getImage("conveyor_divider"));
		}
		
		override protected function onDrag(): void 
		{
			y = 0;
			if (x < 0)
				x = 0;
			if (x > 200)
				//onDividerMoveOut();
				GameEvents.dispatch(GameEvents.CONVEYOR_GOODS_REQUEST);
		}
		
		override protected function onDrop(): void 
		{
			//trace("divider x = " + int(x));
		}
	}
}
