package screens 
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import starling.core.Starling;
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
		private var item: Item;
		private var allowedItemTypes: Array;

		public function DragController(allowedItemTypes: Array) 
		{
			super();
			this.allowedItemTypes = allowedItemTypes;
			//addChild(new Quad(Screens.uWidth * Screens.unit, Screens.uHeight * Screens.unit, 0x00000000)).addEventListener(TouchEvent.TOUCH, onTouch);
			addChild(new Image(Texture.fromColor(
				Screens.uWidth * Screens.unit, Screens.uHeight * Screens.unit,
				0x00000000))
				).addEventListener(TouchEvent.TOUCH, onTouch);
			GameEvents.subscribe("item_new", onNewItem);
		}
		
		private function onNewItem(e: Event, i: Item): void 
		{
			if (allowedItemTypes.indexOf(i.type) >= 0)
				items.push(i);
		}
		
		private function onTouch(e: TouchEvent): void 
		{
			var touch: Touch = e.getTouch(this, TouchPhase.BEGAN);
			if (touch)
			{
				//item = getClosestItem(touch.getLocation(this));
				item = getClosestItem(touch.getLocation(Starling.current.stage));
				if (!item)
					return;
				touchOffset = touch.getLocation(item.parent);
				touchOffset.offset(-item.x, -item.y);
				item.isPicked = true;
				GameEvents.dispatch(GameEvents.ITEM_PICK, item);
				GameEvents.dispatch(GameEvents.CONVEYOR_START);
			}
			
			touch = e.getTouch(this, TouchPhase.ENDED);
			if (item && touch && !item.isDragging)
				item.touch();
			if (item && touch)
			{
				item.isPicked = false;
				GameEvents.dispatch(GameEvents.ITEM_DROP, item);
				
				item.checkConveyorMovement();
				item.drop();
			}
			
			touch = e.getTouch(this, TouchPhase.MOVED);
			if (item)
				item.isDragging = (touch != null);
			if (item && touch)
			{
				touchLocation = touch.getLocation(item.parent);
				item.x = int(touchLocation.x - touchOffset.x);
				item.y = int(touchLocation.y - touchOffset.y);
				item.drag();
			}
		}
		
		private function getClosestItem(touchGlobalPos: Point): Item
		{
			var itemGlobalRect: Rectangle = new Rectangle();
			var itemGlobalPos: Point = new Point();
			var d: Number;
			var rMin: Number = 0.67;
			var r: Number;
			var closestItem: Item = null;
			for each (var i: Item in items) 
			{
				if (!i.parent || !i.visible)
					continue;
				itemGlobalRect = i.getBounds(Starling.current.stage);
				itemGlobalPos.x = itemGlobalRect.x + itemGlobalRect.width / 2;
				itemGlobalPos.y = itemGlobalRect.y + itemGlobalRect.height / 2;
				d = Point.distance(itemGlobalPos, touchGlobalPos);
				// коэффициент дальности от объекта (с учетом его размеров)
				r = d / itemGlobalRect.size.length;
				if (r < rMin)
				{
					rMin = r;
					closestItem = i;
				}
			}
			return closestItem;
		}
	}
}
