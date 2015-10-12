package  
{
	import data.Assets;
	import data.DayData;
	import flash.media.Sound;
	import screens.GameScreen;
	import screens.Screens;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author rkardashov@gmail.com
	 */
	public class Scanner extends Sprite// Image 
	{
		private var bubble:Image;
		private var hasBubble: Boolean = false;
		//private var _sum: Sum;
		
		public function Scanner(/*sum: Sum*/) 
		{
			/*super(Texture.fromColor(
				60, 60, 0x0000FF00)
			);*/
			
			addChild(new Image(Texture.fromColor(
				60, 60, 0x0000FF00)));
				
			addChild(bubble = Assets.getImage("bubble_scanner_drag_item_here"));
			bubble.alignPivot("center", "top");
			bubble.x = 30;
			bubble.y = 55;
			bubble.visible = false;
			
			x = 105;// 107
			y = 126;// 88
			
			//_sum = sum;
			GameEvents.subscribe(GameEvents.GOOD_DRAG, onGoodDrag);
			
			// tutorial "bubble" events
			GameEvents.subscribe(GameEvents.DAY_START, onDayStart);
			GameEvents.subscribe(GameEvents.GOOD_ENTER, onGoodEnter);
			GameEvents.subscribe(GameEvents.GOOD_SCANNED, onGoodScanned);
		}
		
		private function onDayStart(e: Event, d: DayData): void 
		{
			hasBubble = d.bubbleScannerVisible;
		}
		
		private function onGoodEnter(e: Event, g: Good): void 
		{
			bubble.visible = hasBubble;
		}
		
		private function onGoodScanned(e: Event, g: Good): void 
		{
			bubble.visible = false;
		}
		
		private function onGoodDrag(e: Event, good: Good): void
		{
			if (!good.scanned && !good.info.barcode
				&& getBounds(stage).intersects(good.getBounds(stage)))
				GameEvents.dispatch(GameEvents.SCANNER_GOOD_NO_BARCODE);
			if (good.scanned ||
				!good.info.barcode || //!good.info.barcode.isImprinted || 
				!good.info.barcode.isScannable)
				return;
			if (good.barcodeSideDown &&
				getBounds(stage).containsRect(good.barCodeRect))
			{
				good.scanned = true;
				GameEvents.dispatch(GameEvents.GOOD_SCANNED, good);
			}
		}
	}
}
