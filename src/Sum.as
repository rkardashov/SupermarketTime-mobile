package  
{
	import data.Assets;
	import data.DayData;
	import screens.Screens;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author rkardashov@gmail.com
	 */
	public class Sum extends TextField/*ItemsDropArea*/ implements IItemReceiver 
	{
		/*private var bubble: Image;
		private var hasBubble:Boolean = false;
		*/
		public var total: Number = 0;
		
		public function Sum() 
		{
			//super(this, "", 40, 30);
			super(40, 30, "0.00", "arcade_10", 10, 0xAA00AA22);
			x = 140;
			y = 70;
			//addChild(_text = new TextField(40, 30, "0.00", "arcade_10", 10, 0xAA00AA22));
			
			addChild(new ItemsDropArea(this, "", 40, 30)).alpha = 0;
			
			GameEvents.subscribe(GameEvents.GOOD_SCANNED, onGoodScanned);
			GameEvents.subscribe(GameEvents.CUSTOMER_COMPLETE, reset);
			
			// tutorial "bubble"
			var bubble: SpeechBubble = new SpeechBubble(this, 
				"sumDropCardHereBubble", 70, 20);
			/*bubble.addPhrase("drop here",
				GameEvents.GOODS_COMPLETE, GameEvents.CARD_PAYMENT);*/
			bubble.alignPivot("center", "top");
			bubble.x = 17;
			bubble.y = 30;
		}
		
		private function onGoodScanned(e: Event, good: Good): void
		{
			add(Math.random());// good.info.cost);
			Assets.playSound(Assets.SOUND_SCAN);
			GameEvents.dispatch(GameEvents.GOOD_CHECKOUT, good);			
		}
		
		public function add(cost: Number): void 
		{
			total += cost;
			text = total.toFixed(2);
		}
		
		public function reset(): void 
		{
			total = 0;
			add(0);
		}
		
		/* INTERFACE IItemReceiver */
		
		public function receive(item: Item): void 
		{
			if (item.type == Item.TYPE_CARD)
				(item as CustomerCard).pay();
		}
	}
}
