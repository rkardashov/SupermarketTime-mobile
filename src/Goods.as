package  
{
	import data.GoodInfo;
	import starling.display.Image;
	/**
	 * ...
	 * @author rkardashov@gmail.com
	 */
	public class Goods 
	{
		static private var _pool: Vector.<Good> = new Vector.<Good>();
		static private const GOODS_CHUNK: int = 64;
		
		public static const CATEGORY_UNSORTED: int = 0;
		public static const CATEGORY_CHEMICALS: int = 1;
		public static const CATEGORY_COLD: int = 2;
		public static const CATEGORY_BREAD: int = 3;
		static public var categories: Array = [/*CATEGORY_CUSTOMER, */
			CATEGORY_UNSORTED, CATEGORY_CHEMICALS, CATEGORY_COLD, CATEGORY_BREAD];
		
		public function Goods() 
		{
		}
		
		static public function init(): void 
		{
			grow();
		}
		
		static private function grow(): void 
		{
			for (var i:int = 0; i < GOODS_CHUNK; i++) 
				_pool.push(new Good());
		}
		
		static public function get(info: GoodInfo): Good
		{
			for (var i:int = 0; i < _pool.length; i++) 
				if (_pool[i].recycled)
				{
					_pool[i].recycled = false;
					_pool[i].info = info;
					return _pool[i];
				}
			grow();
			return get(info);
		}
		
		/*static public function atConveyor(): Vector.<Good> 
		{
			var goods: Vector.<Good> = new Vector.<Good>();
			for (var i:int = 0; i < _pool.length; i++) 
				if (!_pool[i].recycled && _pool[i].atConveyor)
					goods.push(_pool[i]);
			return goods;
		}*/
		
		/*static public function addToConveyor(): void
		{
			var good: Good = recycled.pop() as Good;
			atConveyor.push(good);
				_conveyor.add(good);
			good.scanned = false;
			good.visible = true;
			good.reset();
		}*/
		
		/*static public function recycleGoodsInBags(): void 
		{
			while (inBags.length)
				recycled.push(inBags.pop());
		}*/
		
		/*static public function moveToBag(good: Good): void 
		{
			good.visible = false;
			if (atConveyor.indexOf(good) >= 0)
			{
				atConveyor.splice(atConveyor.indexOf(good), 1);
				good.removeFromParent();
			}
			if (inBags.indexOf(good) == -1)
				inBags.push(good);
		}*/
		
		/*static public function bag(category: String): Vector.<Good>
		{
			var goods: Vector.<Good> = new Vector.<Good>();
			for (var i:int = 0; i < inBags.length; i++) 
				if (inBags[i].category == category)
					goods.push(inBags[i]);
			return goods;
		}*/
	}
}
