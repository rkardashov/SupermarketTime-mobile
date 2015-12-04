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
			addChild(imgBarcode = Assets.getImage("barcode_1")); // 15x10
			imgBarcode.scaleX = imgBarcode.scaleY = 3;
			imgBarcode.rotation = Math.PI * 0.5;
			alignPivot();
			clipRect = getBounds(this);
			visible = false;
		}
		
		public function print(): void 
		{
			// TODO: canDrag = false;
			if (visible)
				return;
			x = 340;
			y = 155;
			visible = true;
			//imgBarcode.x = -imgBarcode.width;
			imgBarcode.x = -clipRect.width;
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
