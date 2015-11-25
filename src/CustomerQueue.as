package  
{
	import data.Assets;
	import data.CustomerInfo;
	import data.DayData;
	import flash.utils.setTimeout;
	import screens.GameScreen;
	import screens.Screens;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.TextureSmoothing;
	
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
		private var _customer: Customer;
		private var pocket: Bag;
		//private var moodIndicator: CustomerMoodIndicator;// MovieClip;
		private var bubbleSpeech: SpeechView;
		
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
			pocket = new Bag( -1);
			_customer = new Customer();
			addChild(layerDepart = new Sprite());
			addChild(layerCustomers = new Sprite());
			/*addChild(moodIndicator = new MovieClip(Assets.getTextures("mood")));
			moodIndicator.smoothing = TextureSmoothing.NONE;
			moodIndicator.visible = false;*/
			addChild(new CustomerMoodIndicator());
			
			bubbleSpeech = addChild(new SpeechView()) as SpeechView;
			bubbleSpeech.x = 90;
			
			addChild(dropArea = new ItemsDropArea(this, null, /*null, */70, 70));
			
			GameEvents.subscribe(GameEvents.DAY_START, onDayStart);
			GameEvents.subscribe(GameEvents.DAY_END, reset);
			GameEvents.subscribe(GameEvents.NEXT_CUSTOMER, next);
			GameEvents.subscribe(GameEvents.CUSTOMER_STOPPED, onCustomerStopped);
			GameEvents.subscribe(GameEvents.CUSTOMER_MOOD_LEVEL,
				onCustomerMoodChange);
		}
		
		private function onDayStart(e: Event, d: DayData): void 
		{
			reset();
			_customers = d.customers;
			
			_timer.addEvent(0, customerEnter);
			for (var i:int = 1; i < _customers.length; i++)
				_timer.addLastEvent(_customers[i].interval, customerEnter);
		}
		
		private function reset(): void 
		{
			receivedCard = false;
			receivedReceipt = false;
			
			layerCustomers.removeChildren();
			layerDepart.removeChildren();
			bubbleSpeech.visible = false;
			
			//moodIndicator.visible = false;
			
			_timer.clearEvents();
			
			_customers = null;
			_queue.splice(0, _queue.length);
			_current = null;			
		}
		
		private function onCustomerMoodChange(e: Event, moodLevel: int): void 
		{
			//trace("customer mood level " + moodLevel);
			//moodIndicator.currentFrame = moodLevel;
		}
		
		private function next(): void 
		{
			receivedCard = false;
			receivedReceipt = false;
			//for (var i:int = 0; i < layerCustomers.numChildren; i++) 
			var num: int = layerCustomers.numChildren - 1;
			for (var i:int = 0; i <= num; i++) 
				CustomerView(layerCustomers.getChildAt(num - i)).moveTo(i * 70, i);
		}
		
		private function customerLeaves():void 
		{
			//layerDepart.addChildAt(layerCustomers.removeChildAt(0), 0);
			layerDepart.addChildAt(layerCustomers.removeChildAt(layerCustomers.numChildren - 1), 0);
			CustomerView(layerDepart.getChildAt(0)).moveTo( -280);
			_queue.shift();
			_current = null;
			//moodIndicator.visible = false;
		}
		
		private function onCustomerStopped(e: Event, c: CustomerInfo): void
		{
			if (_queue.length && (c == _queue[0]))
			{
				_current = c;
				//_customer.init(_current);
				//moodIndicator.visible = true;
				GameEvents.dispatch(GameEvents.CUSTOMER_ARRIVED, c);
			}
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
			
			//layerCustomers.addChild(new CustomerView(_queue[_queue.length - 1]));
			layerCustomers.addChildAt(new CustomerView(_queue[_queue.length - 1]), 0);
			var i: int = layerCustomers.numChildren - 1;
			//layerCustomers.getChildAt(i).x = Screens.uWidth * Screens.unit;
			layerCustomers.getChildAt(0).x = Screens.uWidth * Screens.unit;
			if (_queue.length > 1)
				//CustomerView(layerCustomers.getChildAt(i)).moveTo(i * 70, i)
				CustomerView(layerCustomers.getChildAt(0)).moveTo(i * 70, i)
			else
				//CustomerView(layerCustomers.getChildAt(0)).moveTo(0, 0);
				CustomerView(layerCustomers.getChildAt(i)).moveTo(0, 0);
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
