package  
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import screens.GameScreen;
	import screens.Screens;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.events.Touch;
	
	/**
	 * ...
	 * @author rkardashov@gmail.com
	 */
	public class Item extends Sprite 
	{
		static public const TYPE_GOOD: int = 0;
		static public const TYPE_CARD: int = 1;
		static public const TYPE_RECEIPT: int = 2;
		static public const TYPE_GOOD_MAGNIFIED: int = 3;
		static public const TYPE_BARCODE_STICKER: int = 4;
		static public const TYPE_CONVEYOR_DIVIDER: int = 5;
		
		public var type: int = TYPE_GOOD;
		
		public var atConveyor: Boolean = false;
		private var conveyorMoves:Boolean = false;
		private var pause: Boolean = false;
		
		private var _isDragging: Boolean = false;
		private var _isPicked: Boolean = false;
		private var touchLocation: Point;
		private var touchOffset: Point;
		
		public function Item(type: int = TYPE_GOOD)
		{
			super();
			this.type = type;
			//screen = Screens.getScreen(GameScreen) as GameScreen;
			
			addEventListener(TouchEvent.TOUCH, _onTouch);
			
			/*GameEvents.subscribe(GameEvents.DAY_START, onConveyorStart);
			GameEvents.subscribe(GameEvents.CONVEYOR_START, onConveyorStart);
			GameEvents.subscribe(GameEvents.CONVEYOR_STOP, onConveyorStop);
			GameEvents.subscribe(GameEvents.PAUSE, onPause);
			GameEvents.subscribe(GameEvents.RESUME, onResume);*/
		}
		
		/*public function get screenBounds(): Rectangle
		{
			return getBounds(Screens.getScreen(GameScreen));
		}*/
		
		private function onConveyorStart(e: Event): void 
		{
			trace("item @ " + e.type);
			conveyorMoves = true;
			checkConveyorMovement();
		}
		
		private function onConveyorStop(e: Event): void 
		{
			trace("item @ " + e.type + ": remove ENTER_FRAME listener");
			conveyorMoves = false;
			removeEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
		}
		
		private function onPause(e: Event):void 
		{
			trace("item @ " + e.type + ": remove ENTER_FRAME listener");
			pause = true;
			removeEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
		}
		
		private function onResume(e: Event):void 
		{
			trace("item @ " + e.type + ": remove ENTER_FRAME listener");
			pause = false;
			checkConveyorMovement();
		}
		
		private function checkConveyorMovement(): void 
		{
			if (!pause && conveyorMoves && !isDragging && !isPicked
				&& parent && (parent.isPrototypeOf(Conveyor))
				&& (getBounds(parent).left > 0)
				&& !(hasEventListener(EnterFrameEvent.ENTER_FRAME)))
			{
				trace("item @ checkConveyorMovement(): add ENTER_FRAME listener");
				addEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
			}
		}
		
		private function onEnterFrame(e:EnterFrameEvent):void 
		{
			if (/*pause || !conveyorMoves || isDragging || isPicked
				||*/ !parent || !(parent.isPrototypeOf(Conveyor))
				|| (getBounds(parent).left <= 0))
				//removeEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame)
				{
					trace("item @ ENTER_FRAME: STOP_CONVEYOR");
					GameEvents.dispatch(GameEvents.CONVEYOR_STOP)
				}
			else
				x --;
		}
		
		private function _onTouch(e: TouchEvent): void 
		{
			var touch: Touch = e.getTouch(this, TouchPhase.BEGAN);
			if (touch)
			{
				touchOffset = touch.getLocation(parent);
				touchOffset.offset( -x, -y);
				_isPicked = true;
				GameEvents.dispatch(GameEvents.ITEM_PICK, this);
				// ?
				GameEvents.dispatch(GameEvents.CONVEYOR_START);
			}
			
			touch = e.getTouch(this, TouchPhase.ENDED);
			if (touch && !isDragging)
				onTouch();
			if (touch)
			{
				_isPicked = false;
				GameEvents.dispatch(GameEvents.ITEM_DROP, this);
				
				checkConveyorMovement();
				//trace(GameEvents.ITEM_DROP);
				onDrop();
			}
			
			touch = e.getTouch(this, TouchPhase.MOVED);
			_isDragging = (touch != null);
			if (touch)
			{
				touchLocation = touch.getLocation(parent);
				x = int(touchLocation.x - touchOffset.x);
				y = int(touchLocation.y - touchOffset.y);
				onDrag();
			}
		}
		
		protected function onTouch(): void 
		{
			
		}
		
		protected function onDrag(): void
		{
			
		}
		
		protected function onDrop(): void 
		{
			//trace("drop @ x " + x);
		}
		
		public function get isDragging(): Boolean 
		{
			return _isDragging;
		}
		
		public function get isPicked():Boolean 
		{
			return _isPicked;
		}
	}
}
