package  
{
	import data.Assets;
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
	public class GoodsInspectionView extends Sprite implements IItemReceiver
	{
		private var good: GoodMagnified;
		//private var good: Good;
		private var barCode: BarcodeSticker;
		private var scales: Image;
		private var printer: PixelButton;
		
		public function GoodsInspectionView() 
		{
			super();
			
			addChild(scales = Assets.getImage("overlay_scales"));
			addChild(printer = 
				new PixelButton("btnPrintBarcodeUp", "btnPrintBarcodeDown"));
			printer.x = 261;
			printer.y = 138;
			addChild(good = new GoodMagnified());
			addChild(barCode = new BarcodeSticker());
			printer.addEventListener(Event.TRIGGERED, barCode.print);
			
			visible = false;
			//GameEvents.subscribe(GameEvents.CLOSE_INSPECTVIEW, onCloseView);
			GameEvents.subscribe(GameEvents.BARCODE_APPLY, onBarcodeStickerApplied);
		}
		
		private function onBarcodeStickerApplied(): void 
		{
			visible = false;
		}
		
		public function receive(item: Item): void 
		{
			if (item.type !== Item.TYPE_GOOD)
				return;
			//if (!(item as Good).info.noBarcode)
				//return;
				
			//var g: Good = item as Good;
			//GameEvents.dispatch(GameEvents.GOOD_RECEIVED, good);
			//good.type = Item.TYPE_GOOD_MAGNIFIED;
			//good.removeFromParent();
			//addChildAt(good, 1);
			good.x = 150;
			good.y = Screens.centerY;
			//good.scaleX = good.scaleY = 3;
			good.info = (item as Good).info;
			
			visible = true;
			//good.good = item as Good;
			//barCode.good = good;// item as Good;
		}
	}
}
