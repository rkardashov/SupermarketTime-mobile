package
{
	import data.Assets;
	import data.CustomerInfo;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	/**
	 * ...
	 * @author rkardashov@gmail.com
	 */
	public class BagsRequestView extends Sprite 
	{
		private var icons: Vector.<Image> = new Vector.<Image>;
		
		public function BagsRequestView() 
		{
			super();
			var bubble: Image;
			addChild(bubble = Assets.getImage("bubble_customer_bags"));
			bubble.x = 150;
			var icon: Image;
			for (var i:int = 0; i < Goods.categories.length; i++) 
			{
				icon = Assets.getImage("category_" + i);
				icons.push(icon);
				if (icon)
				{
					icon.visible = false;
					/*bubble.*/addChild(icon);
				}
			}
			GameEvents.subscribe(GameEvents.CUSTOMER_ARRIVED, onCustomerArrived);
			GameEvents.subscribe(GameEvents.GOODS_COMPLETE, onGoodsComplete);
		}
		
		private function onCustomerArrived(e: Event, c: CustomerInfo): void 
		{
			/*visible = true;*/
			setCategories(c.bagsRequest);
		}
		
		private function onGoodsComplete(): void
		{
			visible = false;
		}
		
		private function setCategories(bagsRequest: Vector.<Boolean>): void
		{
			var visibleIcons: Vector.<Image> = new Vector.<Image>;
			for (var i:int = 0; i < bagsRequest.length; i++) 
				if (icons[i])
				{
					icons[i].visible = bagsRequest[i];
					if (bagsRequest[i])
						visibleIcons.push(icons[i]);
				}
			
			for (var j:int = 0; j < visibleIcons.length; j++) 
			{
				visibleIcons[j].x = 165 + (j % 2) * 25;
				visibleIcons[j].y = 14 + int(j / 2) * 20;
			}
		}
	}
}
