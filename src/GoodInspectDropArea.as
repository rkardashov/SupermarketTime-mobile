package 
{
	import data.DayData;
	import starling.events.Event;
	/**
	 * ...
	 * @author rkardashov@gmail.com
	 */
	public class GoodInspectDropArea extends ItemsDropArea implements IItemReceiver
	{
		private var day:DayData;
		
		public function GoodInspectDropArea() 
		{
			super(this, "droparea_scales");
			GameEvents.subscribe(GameEvents.DAY_START, onDayStart);
		}
		
		private function onDayStart(e: Event, d: DayData):void 
		{
			day = d;
		}
		
		/* INTERFACE IItemReceiver */
		
		public function receive(item: Item): void 
		{
			if (!day || item.type !== Item.TYPE_GOOD)
				return;
			
			var good: Good = item as Good;
				
			// if the good has no barcode and the scales feature is available
			if (!good.info.barcode && !day.disabledFeatures["scales"])
			{
				GameEvents.dispatch(GameEvents.SCALES_VIEW_SHOW, good);
				return;
			}
				
			// if the good has barcode and the inspect feature is available
			if (good.info.barcode //&& !good.info.barcode.isScannable
				&& !day.disabledFeatures["inspect"])
			{
				GameEvents.dispatch(GameEvents.INSPECT_VIEW_SHOW, good);
				return;
			}
		}
	}
}
