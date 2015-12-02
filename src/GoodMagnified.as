package  
{
	import data.BarcodeInfo;
	import data.GoodInfo;
	import flash.geom.Point;
	/**
	 * ...
	 * @author rkardashov@gmail.com
	 */
	public class GoodMagnified extends Good implements IItemReceiver 
	{
		private var dropArea: ItemsDropArea;
		
		public function GoodMagnified() 
		{
			super();
			type = TYPE_GOOD_MAGNIFIED;
			
			addChild(dropArea = new ItemsDropArea(this, null));
			scaleX = scaleY = 3;
			visible = true;
		}
		
		override public function get info():GoodInfo 
		{
			return super.info;
		}
		
		override public function set info(value:GoodInfo):void 
		{
			super.info = value;
			dropArea.setAreaSizeAs(_sides);
			dropArea.pivotX = int(dropArea.width / 2);
			dropArea.pivotY = int(dropArea.height / 2);
			//rotation = 0;
		}
		
		override protected function onTouch():void 
		{
			super.onTouch();
			dropArea.setAreaSizeAs(_sides);
			dropArea.pivotX = int(dropArea.width / 2);
			dropArea.pivotY = int(dropArea.height / 2);
		}
		
		/* INTERFACE IItemReceiver */
		public function receive(item: Item): void 
		{
			if (item.type == Item.TYPE_BARCODE_STICKER)
			{
				item.visible = false;
				//if (info.barcode.isScannable)
					//return;
				if (!info.barcode)
					info.barcode = new BarcodeInfo();
				info.barcode.isImprinted = false;
				info.barcode.isScannable = true;
				info.barcode.atSide = _sides.currentFrame;
				var p: Point = item.parent.localToGlobal(new Point(item.x, item.y));
				p = globalToLocal(p);
				info.barcode.x = int(p.x);
				info.barcode.y = int(p.y);
				
				GameEvents.dispatch(GameEvents.BARCODE_APPLY, info);
			}
		}
	}
}
