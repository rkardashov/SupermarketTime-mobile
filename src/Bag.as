package
{
	import screens.GameScreen;
	import screens.Screens;
	
	/**
	 * ...
	 * @author rkardashov@gmail.com
	 */
	public class Bag implements IItemReceiver
	{
		public var category: int;
		public var goods: Vector.<Good> = new Vector.<Good>();
		public var size: int = 4;
		
		public function Bag(goodsCategory: int)
		{
			category = goodsCategory;
			if (category == -1)
				size = int.MAX_VALUE;
		}
		
		public function receive(item: Item): void
		{
			if (item.type !== Item.TYPE_GOOD)
				return;
			if (goods.length >= size)
				return;
			var good:Good = item as Good;
			if (good.scanned/* && good.info.category == category*/)
			{
				if (good.info.category != category)
				{
					GameEvents.dispatch(GameEvents.BAG_WRONG_GOOD, this);
					GameEvents.dispatch(GameEvents.GOOD_WRONG_BAG, good);
					return;
				}
				goods.push(good);
				good.removeFromParent();
				good.atConveyor = false;
				good.inBag = true;
				good.visible = false;
				GameEvents.dispatch(GameEvents.GOOD_RECEIVED, good);
				GameEvents.dispatch(GameEvents.BAG_GOOD_ADDED, this);
				if (goods.length >= size)
					GameEvents.dispatch(GameEvents.BAG_FULL, this);
			}
		}
		
		public function recycle(): void
		{
			while (goods.length)
				goods.pop().recycle();
		}
		
		public function get fillState(): Number
		{
			if (goods.length < size)
				return goods.length / size;
			return 1;
		}
	}
}
