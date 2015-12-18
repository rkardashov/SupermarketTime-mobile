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
	public class Item extends PixelSprite 
	{
		static public const TYPE_GOOD: int = 0;
		static public const TYPE_MONEY: int = 1;
		static public const TYPE_DISCOUNT_CARD: int = 2;
		static public const TYPE_RECEIPT: int = 3;
		static public const TYPE_GOOD_MAGNIFIED: int = 4;
		static public const TYPE_BARCODE_STICKER: int = 5;
		static public const TYPE_CONVEYOR_DIVIDER: int = 6;
		static public const TYPE_BANKNOTE: int = 7;
		
		public var type: int = TYPE_GOOD;
		
		public var atConveyor: Boolean = false;
		private var conveyorMoves: Boolean = false;
		private var pause: Boolean = false;
		
		public var isDragging: Boolean = false;
		public var isPicked: Boolean = false;
		
		public function Item(type: int = TYPE_GOOD)
		{
			super();
			this.type = type;
			
			GameEvents.dispatch(GameEvents.ITEM_NEW, this);
		}
		
		public function get screenRect(): Rectangle
		{
			return getBounds(Screens.getScreen(GameScreen));
		}
		
		public function checkConveyorMovement(): void 
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
		
		public function touch(): void 
		{
			onTouch();
		}
		protected function onTouch(): void 
		{
		}
		
		public function drag(): void 
		{
			onDrag();
		}
		protected function onDrag(): void
		{
		}
		
		public function drop(): void 
		{
			onDrop();
		}
		protected function onDrop(): void 
		{
		}
	}
}
