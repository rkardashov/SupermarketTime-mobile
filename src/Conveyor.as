package  
{
	import data.Assets;
	import data.CustomerInfo;
	import data.GoodInfo;
	import screens.Screens;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Conveyor extends Sprite 
	{
		public var goodsCount: int = 0;
		private var capacity: int;
		private var divider: ConveyorDivider;
		private var leftItem: Item;
		private var layerOff:Sprite;
		private var layerConveyor:Sprite;
		private var paused: Boolean = true;
		
		public function Conveyor() 
		{
			x = 186;
			y = 86;
			addChild(layerOff = new Sprite());
			addChild(layerConveyor = new Sprite());
			
			layerConveyor.addChild(divider = new ConveyorDivider());
			
			GameEvents.subscribe(GameEvents.DAY_START, onDayStart);
			GameEvents.subscribe(GameEvents.PAUSE, onPause);
			GameEvents.subscribe(GameEvents.RESUME, onResume);
			GameEvents.subscribe(GameEvents.CUSTOMER_ARRIVED, onCustomerArrived);
			GameEvents.subscribe(GameEvents.GOOD_RECEIVED, onGoodReceived);
			GameEvents.subscribe(GameEvents.BAG_GOOD_ADDED, onGoodAddedToBag);
			GameEvents.subscribe(GameEvents.ITEM_DROP, onItemDrop);
			GameEvents.subscribe(GameEvents.ITEM_PICK, onItemPick);
			GameEvents.subscribe(GameEvents.GOOD_ADD_TO_CONVEYOR, onGoodAddedToConveyor);
		}
		
		private function onDayStart(): void 
		{
			divider.x = 0;// 100;
			paused = false;
			move();
		}
		
		private function onPause():void 
		{
			paused = true;
		}
		
		private function onResume():void 
		{
			paused = false;
		}
		
		private function onCustomerArrived(e: Event, c: CustomerInfo): void 
		{
			capacity = c.conveyorCapacity;
		}
		
		private function onGoodAddedToConveyor(e: Event, g: GoodInfo): void 
		{
			layerConveyor.removeChild(divider);
			add(Goods.get(g));
			add(divider);
			leftItem = atConveyor(0);
			move();
		}
		
		private function onGoodAddedToBag(e: Event, b: Bag): void 
		{
			if (goodsCount == 0)
				GameEvents.dispatch(GameEvents.GOODS_COMPLETE);
		}
		
		private function onGoodReceived(e: Event, good: Good): void 
		{
			goodsCount --;
			if (good == leftItem)
				findLeftMostItem();
		}
		
		private function add(item: Item): void 
		{
			item.removeFromParent();
			layerConveyor.addChild(item);
			item.visible = true;
			
			var rightBorder: int = Screens.unit * (4 + 2 * layerConveyor.numChildren);
			
			if (item.type == Item.TYPE_CONVEYOR_DIVIDER)
			{
				item.y = 0;
				if (item.x < rightBorder)
					item.x = rightBorder;
			}
			else
			{
				item.x = rightBorder;
				item.y = int(Screens.unit * (1 + Math.random() * 4));
			}
			
			if (item.type == Item.TYPE_GOOD)
			{
				var good: Good = item as Good;
				goodsCount ++;
				good.atConveyor = true;
				good.inBag = false;
				good.scanned = false;
				good.scaleX = good.scaleY = 1;
				GameEvents.dispatch(GameEvents.GOOD_ENTER, good);
			}
		}
		
		private function move(): void 
		{
			addEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
		}
		
		private function stop(): void 
		{
			removeEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
		}
		
		/*private function addGoods(): void 
		{
			if (!customer)
				return;
			
			layerConveyor.removeChild(divider);
			var info: GoodInfo;
			while (info = customer.nextGood())
				add(Goods.get(info));
			add(divider);
			leftItem = atConveyor(0);
			move();
		}*/
		
		private function atConveyor(i: int): Item
		{
			if (i < layerConveyor.numChildren)
				return layerConveyor.getChildAt(i) as Item;
			return null;
		}
		
		private function onEnterFrame(e: EnterFrameEvent): void 
		{
			if (paused || !leftItem)
				return;
			if (isItemHitsSensor(leftItem))
			{
				stop();
				leftItem.x += 2;
			}
			else
				for (var i:int = 0; i < layerConveyor.numChildren; i++) 
					/*if (isItemAtConveyor(atConveyor(i)))*/
						atConveyor(i).x -= 2;
		}
		
		private function onItemPick(e: Event, item: Item): void 
		{
			if (item.parent !== layerConveyor)
				return;
			layerOff.addChild(layerConveyor.removeChild(item));
			findLeftMostItem();
			move();
		}
		
		private function onItemDrop(e: Event, item: Item): void 
		{
			if (item.parent !== layerOff)
				return;
			//layerConveyor.addChild(layerOff.removeChild(item));
			if (isItemAtConveyor(item))
			{
				layerConveyor.addChild(layerOff.removeChild(item));
				if (!leftItem ||
					(leftItem.getBounds(this).left > item.getBounds(this).left))
					leftItem = item;
				if (isItemHitsSensor(leftItem))
					stop();
			}
		}
		
		private function isItemAtConveyor(item: Item): Boolean
		{
			//return (item.getBounds(this).left > Screens.unit * 0.5);
			var itemLeft: int = item.getBounds(this).left;
			var success: Boolean = (itemLeft >= 0);// Screens.unit * 0.5);
			//trace("isItemAtConveyor? " + success ? );
			return success;
		}
		
		private function isItemHitsSensor(item: Item): Boolean
		{
			return (isItemAtConveyor(item)
				&& (item.getBounds(this).left < Screens.unit * 0.5));
		}
		
		private function findLeftMostItem(): void 
		{
			leftItem = atConveyor(0);
			if (!leftItem) // in case the divider has been just pick up
				return;
			for (var i:int = 1; i < layerConveyor.numChildren; i++) 
				if (atConveyor(i).getBounds(this).left < leftItem.getBounds(this).left)
					leftItem = atConveyor(i);
		}
	}
}
