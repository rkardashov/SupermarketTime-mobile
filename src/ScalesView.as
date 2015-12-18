package  
{
	import data.Assets;
	import data.DayData;
	import screens.DragController;
	import screens.Screens;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	/**
	 * ...
	 * @author ...
	 */
	public class ScalesView extends Sprite
	{
		private var good: GoodMagnified;
		private var barCode: BarcodeSticker;
		private var scales: Image;
		private var lcd: Sprite;
		private var lcdImages: Object = {};
		
		public function ScalesView() 
		{
			super();
			
			var dragController: DragController = new DragController(
				[Item.TYPE_GOOD_MAGNIFIED, Item.TYPE_BARCODE_STICKER]);
			
			addChild(scales = Assets.getImage("overlay_scales"));
			addChild(good = new GoodMagnified());
			addChild(barCode = new BarcodeSticker());
			addChild(dragController);
			
			// show all goods without barcode
			lcd = new Sprite();
			lcd.addChild(Assets.getImage("scales_screen"));
			var goodsList: XMLList = Assets.goodsXML.good;
			var gImage: Image;
			var i: int = 0;
			for each (var gXML: XML in goodsList) 
			{
				if (!(gXML.@noBarcode == "1"))
					continue;
				lcd.addChild(gImage = Assets.getImage("lcd_" + gXML.@texture));
				gImage.x = 80 + 80 * (i % 3);
				gImage.y = 20 + 70 * int(i / 3);
				lcdImages[int(gXML.@id)] = gImage;
				i ++;
			}
			
			visible = false;
			GameEvents.subscribe(GameEvents.SCALES_VIEW_SHOW, onScalesViewShow);
			GameEvents.subscribe(GameEvents.BARCODE_APPLY, onBarcodeStickerApplied);
		}
		
		private function onLCDGoodTouch(e: TouchEvent): void 
		{
			var goodImg: Image = lcdImages[good.info.id];
			if (e.getTouch(goodImg, TouchPhase.ENDED))
			{
				goodImg.removeEventListener(TouchEvent.TOUCH, onLCDGoodTouch);
				removeChild(lcd);
				barCode.print();
				GameEvents.dispatch(GameEvents.SCALES_BARCODE_PRINT);
			}
		}
		
		private function onBarcodeStickerApplied(): void 
		{
			visible = false;
		}
		
		private function onScalesViewShow(e: Event, g: Good): void
		{
			if (g.info.barcode)
				return;
			
			addChild(lcd);
			
			good.x = Screens.centerX;
			good.y = Screens.centerY;
			good.info = g.info;
			
			var goodImg: Image = lcdImages[good.info.id];
			if (goodImg)
				goodImg.addEventListener(TouchEvent.TOUCH, onLCDGoodTouch);
			
			visible = true;
		}
	}
}
