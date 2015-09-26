package  
{
	import data.Assets;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import screens.GameScreen;
	import screens.Screens;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;
	
	/**
	 * ...
	 * @author ...
	 */
	public class ItemsDropArea extends Sprite/*Image */
	{
		public var target: IItemReceiver;
		//static public const DEFAULT_COLOR: uint = 0x44FF0000;
		static public const DEFAULT_COLOR: uint = 0x00000000;
		//private var screen: GameScreen;
		private var image: Image;
		//private var area: DisplayObject;
		
		public function ItemsDropArea(
			target: IItemReceiver, /*area: DisplayObject,*/
			textureName: String,
			w: int = 20, h: int = 20, c: uint = DEFAULT_COLOR) 
		{
			super();
			
			//this.area = area;
			//if (!area)
			//{
				//var image: Image = Assets.getImage(textureName);
				image = Assets.getImage(textureName);
				if (!image)
					image = new Image(Texture.fromColor(w, h, c));
				addChild(image);
			//}
			
			this.target = target;
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			//GameEvents.subscribe(GameEvents.ITEM_DROP, onItemDrop);
		}
		
		private function onAddedToStage(e:Event):void 
		{
			GameEvents.subscribe(GameEvents.ITEM_DROP, onItemDrop);
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		
		private function onRemovedFromStage(e: Event):void 
		{
			GameEvents.unsubscribe(GameEvents.ITEM_DROP, onItemDrop);
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		public function setAreaSizeAs(o: DisplayObject): void 
		{
			image.width = o.width;
			image.height = o.height;
		}
		
		private function overlaps(item: Item): Boolean
		{
			if (!visible || !stage || !item.stage)
				return false;
			var screen: GameScreen = Screens.getScreen(GameScreen) as GameScreen;
			//var itemBounds: Rectangle = item.getBounds(screen);
			var itemRect: Rectangle = item.screenRect;
			var p: Point = itemRect.topLeft.clone();
			p.offset(itemRect.width / 2, itemRect.height / 2);
			return getBounds(screen).containsPoint(p);
			/*var areaBounds: Rectangle = getBounds(screen);
			var success: Boolean = areaBounds.containsPoint(p);
			if (success)
				trace("item drop @ " + this);
			return success;*/
		}
		
		private function onItemDrop(e: Event, item: Item): void 
		{
			if (target && overlaps(item))
				target.receive(item);
		}
	}
}