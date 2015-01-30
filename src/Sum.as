package  
{
	import data.Assets;
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
	public class Sum extends ItemsDropArea implements IItemReceiver // Sprite//TextField 
	{
		private var _text: TextField;
		
		public var total: Number = 0;
		
		public function Sum() 
		{
			super(this, "", 40, 30);
			x = 140; //int(Screens.unit * 5.8);
			y = 70; //Screens.unit * 3;
			//addChild(new Image(Texture.fromColor(40, 30, 0x44FF0000)));
			addChild(_text = new TextField(40, 30, "0.00", "arcade_10", 10, 0xAA00AA22));
			
			GameEvents.subscribe(GameEvents.GOOD_SCANNED, onGoodScanned);
			GameEvents.subscribe(GameEvents.CUSTOMER_COMPLETE, reset);
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
			_text.text = total.toFixed(2);
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
