package 
{
	import data.Assets;
	import data.CustomerInfo;
	import screens.Screens;
	import starling.display.MovieClip;
	import starling.events.Event;
	import starling.textures.TextureSmoothing;
	/**
	 * ...
	 * @author rkardashov@gmail.com
	 */
	public class Money extends Item
	{
		private static const defaultX: int = 115;
		private static const defaultY: int = 90;
		private var customer: CustomerInfo;
		private var frames:MovieClip;
		
		public var paid: Boolean;
		
		public function Money(texturePrefix: String) 
		{
			super(TYPE_MONEY);
			
			x = defaultX;
			y = defaultY;
			
			frames = new MovieClip(Assets.getTextures(texturePrefix));
			frames.smoothing = TextureSmoothing.NONE;
			addChild(frames);
			
			alignPivot();
			
			reset();
			
			GameEvents.subscribe(GameEvents.GOODS_COMPLETE, onGoodsComplete);
			GameEvents.subscribe(GameEvents.CUSTOMER_ARRIVED, onCustomerArrived);	
			GameEvents.subscribe(GameEvents.CUSTOMER_COMPLETE, reset);	
			GameEvents.subscribe(GameEvents.DAY_START, reset);
		}
		
		protected function reset(): void 
		{
			visible = false;
			paid = false;
		}
		
		override protected function onDrop(): void 
		{
			x = defaultX;
			y = defaultY;
		}
		
		private function onGoodsComplete(): void
		{
			if (customer.cashPayment && (this as Cash))
				visible = true;
			if (!customer.cashPayment && (this as Card))
				visible = true;
		}
		
		private function onCustomerArrived(e: Event, c: CustomerInfo): void 
		{
			customer = c;
			frames.currentFrame = Math.random() * frames.numFrames;
			frames.readjustSize();
		}
	}
}
