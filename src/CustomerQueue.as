package  
{
	import data.CustomerInfo;
	import flash.utils.setTimeout;
	import screens.GameScreen;
	import screens.Screens;
	import starling.display.Sprite;
	import starling.events.Event;
	
	/**
	 * ...
	 * @author rkardashov@gmail.com
	 */
	public class CustomerQueue extends Sprite implements IItemReceiver
	{
		private var _customers: Vector.<CustomerInfo>;
		private var _queue: Vector.<CustomerInfo>;
		private var _timer: DayTimer;
		private var layerCustomers: Sprite;
		private var layerDepart: Sprite;
		private var _current: CustomerInfo;
		private var pocket: Bag;
		
		public var dropArea: ItemsDropArea;
		public var receivedCard: Boolean;
		public var receivedReceipt: Boolean;
		
		public function CustomerQueue(dayTimer: DayTimer) 
		{
			super();
			x = 60;
			y = 0;
			_timer = dayTimer;
			_queue = new Vector.<CustomerInfo>();
			pocket = new Bag(-1);
			addChild(layerDepart = new Sprite());
			addChild(layerCustomers = new Sprite());
			addChild(dropArea = new ItemsDropArea(this, null, /*null, */70, 70));
			
			GameEvents.subscribe(GameEvents.NEXT_CUSTOMER, next);
			GameEvents.subscribe(GameEvents.CUSTOMER_STOPPED, onCustomerStopped);
		}
		
		private function next(): void 
		{
			receivedCard = false;
			receivedReceipt = false;
			for (var i:int = 0; i < layerCustomers.numChildren; i++) 
				CustomerView(layerCustomers.getChildAt(i)).moveTo(i * 70, i);
		}
		
		private function customerLeaves():void 
		{
			layerDepart.addChildAt(layerCustomers.removeChildAt(0), 0);
			CustomerView(layerDepart.getChildAt(0)).moveTo( -280);
			_queue.shift();
			_current = null;
		}
		
		private function onCustomerStopped(e: Event, c: CustomerInfo): void
		{
			if (_queue.length && (c == _queue[0]))
			{
				_current = c;
				GameEvents.dispatch(GameEvents.CUSTOMER_ARRIVED, c);
			}
		}
		
		public function set customers(value: Vector.<CustomerInfo>): void 
		{
			receivedCard = false;
			receivedReceipt = false;
			
			layerCustomers.removeChildren();
			layerDepart.removeChildren();
			
			_customers = value;
			_queue.splice(0, _queue.length);
			_current = null;
			
			_timer.clearEvents();
			/*for (var i:int = 0; i < _customers.length; i++)
			{
				if (_customers[i].time >= 0)
					_timer.addEvent(_customers[i].time, customerEnter)
				else
					_timer.addLastEvent(_customers[i].interval, customerEnter);
			}*/
			_timer.addEvent(0, customerEnter);
			for (var i:int = 1; i < _customers.length; i++)
				_timer.addLastEvent(_customers[i].interval, customerEnter);
		}
		
		public function get customer(): CustomerInfo
		{
			return _current;
		}
		
		private function customerEnter(): void 
		{
			if (_customers.length)
				_queue.push(_customers.shift());
			else
				return;
			
			layerCustomers.addChild(new CustomerView(_queue[_queue.length - 1]));
			var i: int = layerCustomers.numChildren - 1;
			layerCustomers.getChildAt(i).x = Screens.uWidth * Screens.unit;
			if (_queue.length > 1)
				CustomerView(layerCustomers.getChildAt(i)).moveTo(i * 70, i)
			else
				CustomerView(layerCustomers.getChildAt(0)).moveTo(0, 0);
		}
		
		public function receive(item: Item): void 
		{
			if (item.type == Item.TYPE_GOOD)
			{
				pocket.receive(item);
				return;
			}
			
			if (item.type == Item.TYPE_CARD)
			{
				if ((item as CustomerCard).paid)
				{
					item.visible = false;
					receivedCard = true;
				}
			}
			if (item.type == Item.TYPE_RECEIPT)
			{
				item.visible = false;
				receivedReceipt = true;
				//return;
			}
			
			if (receivedCard && receivedReceipt)
			{
				var c: CustomerInfo = _current;
				customerLeaves();
				GameEvents.dispatch(GameEvents.CUSTOMER_COMPLETE, c);// _current);
			}
		}
	}
}
