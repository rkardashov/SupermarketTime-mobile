package screens 
{
	import flash.geom.Point;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author rkardashov@gmail.com
	 */
	public class DragController extends Sprite 
	{
		private var items: Vector.<Item> = new Vector.<Item>;
		
		private var touchLocation: Point;
		private var touchOffset: Point;
		private var item:Item;

		public function DragController() 
		{
			super();
			//addChild(new Quad(Screens.uWidth * Screens.unit, Screens.uHeight * Screens.unit, 0x00000000)).addEventListener(TouchEvent.TOUCH, onTouch);
			addChild(new Image(Texture.fromColor(
				Screens.uWidth * Screens.unit, Screens.uHeight * Screens.unit,
				0x00000000))
				).addEventListener(TouchEvent.TOUCH, onTouch);
			GameEvents.subscribe("item_new", onNewItem);
		}
		
		private function onNewItem(e: Event, i: Item): void 
		{
			//if (ite)
			items.push(i);
		}
		
		private function onTouch(e: TouchEvent): void 
		{
			var touch: Touch = e.getTouch(this, TouchPhase.BEGAN);
			if (touch)
			{
				item = getClosestItem(touch.getLocation(this));
				touchOffset = touch.getLocation(item.parent);
				touchOffset.offset(-item.x, -item.y);
				item.isPicked = true;
				GameEvents.dispatch(GameEvents.ITEM_PICK, item);
				GameEvents.dispatch(GameEvents.CONVEYOR_START);
			}
			
			/*touch = e.getTouch(this, TouchPhase.ENDED);
			if (touch && !isDragging)
				onTouch();
			if (touch)
			{
				_isPicked = false;
				GameEvents.dispatch(GameEvents.ITEM_DROP, this);
				
				checkConveyorMovement();
				onDrop();
			}*/
			
			touch = e.getTouch(this, TouchPhase.MOVED);
			//_isDragging = (touch != null);
			if (item && touch)
			{
				//item = getClosestItem(touch.getLocation(this));
				touchLocation = touch.getLocation(item.parent);
				item.x = int(touchLocation.x - touchOffset.x);
				item.y = int(touchLocation.y - touchOffset.y);
				//item.onDrag();
			}
		}
		
		private function getClosestItem(touchLocalPos: Point): Item
		{
			var touchGlobalPos: Point = localToGlobal(touchLocalPos);
			var itemLocalOrigin: Point = new Point();
			var itemGlobalPos: Point = new Point();
			var dMin: Number = 1000.0;
			var d: Number;
			var closestItem: Item;
			for each (var i: Item in items) 
			{
				if (!i.parent)
					continue;
				i.localToGlobal(itemLocalOrigin, itemGlobalPos);
				d = Point.distance(itemGlobalPos, touchGlobalPos);
				if (d < dMin)
				{
					dMin = d;
					closestItem = i;
				}
			}
			return closestItem;
		}
	}
}
