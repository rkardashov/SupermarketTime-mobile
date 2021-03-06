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
		public function Scanner() 
		{
			addChild(new Image(Texture.fromColor(
				60, 60, 0x0000FF00)));
				
			var bubble: SpeechBubble = new SpeechBubble(this,
				"scannerDropItemHereBubble");
			bubble.alignPivot("center", "top");
			bubble.x = 30;
			bubble.y = 50;
			
			x = 105;// 107
			y = 126;// 88
			
			//_sum = sum;
			GameEvents.subscribe(GameEvents.GOOD_DRAG, onGoodDrag);
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
