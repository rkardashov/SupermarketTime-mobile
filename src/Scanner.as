package  
{
	import data.Assets;
	import flash.media.Sound;
	import screens.GameScreen;
	import screens.Screens;
	import starling.display.Image;
	import starling.events.Event;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author rkardashov@gmail.com
	 */
	public class Scanner extends Image 
	{
		//private var _sum: Sum;
		
		public function Scanner(/*sum: Sum*/) 
		{
			super(Texture.fromColor(
				//Screens.unit * 2.5, Screens.unit * 2, 0x33FF0000)
				60, 60, 0x3300FF00)
			);
			x = 105;// 107
			y = 126;// 88
			
			//_sum = sum;
			GameEvents.subscribe(GameEvents.SCANNER_TRY_SCAN, onTryScan);
		}
		
		private function onTryScan(e: Event, good: Good): void
		{
			if (good.scanned ||
				!good.info.barcode || //!good.info.barcode.isImprinted || 
				!good.info.barcode.isScannable)
				return;
			//if (getBounds(Screens.getScreen(GameScreen)).containsRect(good.barCodeRect))
			if (getBounds(stage).containsRect(good.barCodeRect))
			{
				good.scanned = true;
				// TODO: move BEEP! sound to Sum (cash register)
				//Assets.beep.play();
				Assets.playSound(Assets.SOUND_SCAN);
				GameEvents.dispatch(GameEvents.GOOD_SCANNED, good);
			}
		}
	}
}
