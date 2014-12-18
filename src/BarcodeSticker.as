package  
{
	import data.Assets;
	import flash.geom.Rectangle;
	import starling.display.Image;
	import starling.events.EnterFrameEvent;
	/**
	 * ...
	 * @author rkardashov@gmail.com
	 */
	public class BarcodeSticker extends Item 
	{
		private var imgBarcode: Image;
		
		public function BarcodeSticker() 
		{
			super(TYPE_BARCODE_STICKER);
			addChild(imgBarcode = Assets.getImage("barcode_1"));
			imgBarcode.scaleX = imgBarcode.scaleY = 3;
			//imgBarcode.readjustSize();
			clipRect = new Rectangle(0, 0, imgBarcode.width, imgBarcode.height);
			pivotX = int(width / 2);
			pivotY = int(height / 2);
			visible = false;
		}
		
		public function print(): void 
		{
			// TODO: canDrag = false;
			if (visible)
				return;
			x = 300;
			y = 180;
			visible = true;
			imgBarcode.x = -imgBarcode.width;
			addEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(e: EnterFrameEvent): void 
		{
			imgBarcode.x += 3;
			if (imgBarcode.x > 0)
				removeEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
		}
	}
}
