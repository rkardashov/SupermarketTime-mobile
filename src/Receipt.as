package
{
	import data.Assets;
	import flash.geom.Rectangle;
	import screens.Screens;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	
	/**
	 * ...
	 * @author rkardashov@gmail.com
	 */
	public class Receipt extends Item //Sprite 
	{
		private static const defaultX: int = int(Screens.unit * 5.9);
		private static const defaultY: int = int(Screens.unit * 4);
		private var imgReceipt: Image;
		
		
		public function Receipt()
		{
			super();
			type = Item.TYPE_RECEIPT;
			
			x = defaultX;
			y = defaultY;
			
			imgReceipt = addChild(Assets.getImage("receipt_1")) as Image;
			clipRect = new Rectangle(0, 0, imgReceipt.width, imgReceipt.height);
			
			GameEvents.subscribe(GameEvents.PAYMENT_COMPLETE, print);
		}
		
		public function print(): void 
		{
			// TODO: canDrag = false;
			visible = true;
			imgReceipt.y = - imgReceipt.height;
			addEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(e: EnterFrameEvent): void 
		{
			imgReceipt.y += 1;
			if (imgReceipt.y >= 0)
				removeEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
		}
		
		override protected function onDrop(): void 
		{
			x = defaultX;
			y = defaultY;
		}
	}
}
