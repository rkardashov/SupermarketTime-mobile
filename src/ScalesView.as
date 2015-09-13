package  
{
	import data.Assets;
	import data.DayData;
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
	public class ScalesView extends Sprite //implements IItemReceiver
	{
		private var good: GoodMagnified;
		private var barCode: BarcodeSticker;
		private var scales: Image;
		/*private var printer: PixelButton;*/
		private var screen:Sprite;
		
		public function ScalesView() 
		{
			super();
			
			addChild(scales = Assets.getImage("overlay_scales"));
			/*addChild(printer = 
				new PixelButton("btnPrintBarcodeUp", "btnPrintBarcodeDown"));
			printer.x = 261;
			printer.y = 138;*/
			addChild(good = new GoodMagnified());
			addChild(barCode = new BarcodeSticker());
			/*printer.addEventListener(Event.TRIGGERED, barCode.print);*/
			
			// TODO: show all goods without barcode
			screen = new Sprite();
			screen.addChild(Assets.getImage("scales_screen"));
			var goodsList: XMLList = Assets.goodsXML.good.(@noBarcode == "1");
			var gImage: Image;
			//var gBtn: ScalesScreenGoodButton;
			var i: int = 0;
			for each (var gXML: XML in goodsList) 
			//for (var i:int = 0; i < goodsList.length(); i++) 
			{
				screen.addChild(gImage = Assets.getImage("goods_" + gXML.@texture + "_1"));
				//screen.addChild(gBtn = new ScalesScreenGoodButton(gXML.@texture));
				gImage.x = 100 + 100 * (i % 4);
				gImage.y = 100 + 90 * int(i / 4);
				i ++;
			}
			//screen.addEventListener(TouchEvent.TOUCH, onScreenTouch);
			gImage.addEventListener(TouchEvent.TOUCH, onScreenTouch);
			
			visible = false;
			GameEvents.subscribe(GameEvents.SCALES_VIEW_SHOW, onScalesViewShow);
			GameEvents.subscribe(GameEvents.BARCODE_APPLY, onBarcodeStickerApplied);
		}
		
		private function onScreenTouch(e:TouchEvent):void 
		{
			if (e.getTouch(this, TouchPhase.ENDED))
			{
				removeChild(screen);
				barCode.print();
				GameEvents.dispatch(GameEvents.SCALES_BARCODE_PRINT);
			}
		}
		
		private function onBarcodeStickerApplied(): void 
		{
			visible = false;
		}
		
		//public function receive(item: Item): void 
		private function onScalesViewShow(e: Event, g: Good): void
		{
			/*if (!day || day.disabledFeatures["scales"]
				|| item.type !== Item.TYPE_GOOD
				|| (Item as Good).info.barcode)*/
			if (g.info.barcode)
				return;
			
			addChild(screen);
			
			good.x = 150;
			good.y = Screens.centerY;
			good.info = g.info;
			
			visible = true;
		}
	}
}