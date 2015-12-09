package screens 
{
	import data.Assets;
	import starling.display.Image;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	/**
	 * ...
	 * @author rkardashov@gmail.com
	 */
	public class CashRegister extends PixelSprite 
	{
		private var cash: Cash;
		
		public function CashRegister() 
		{
			super();
			
			var img: Image = Assets.getImage("cashregister");
			addChild(img);
			visible = false;
			
			GameEvents.subscribe(GameEvents.PAYMENT_START, onPaymentStart);
			GameEvents.subscribe(TouchEvent.TOUCH, onTouch);
		}
		
		private function onTouch(e: TouchEvent): void 
		{
			if (e.getTouch(this, TouchPhase.ENDED))
			{
				cash.paid = true;
				visible = false;
				GameEvents.dispatch(GameEvents.PAYMENT_COMPLETE);
			}
		}
		
		private function onPaymentStart(e: Event, item: Item): void 
		{
			cash = item as Cash;
			if (cash)
				visible = true;
		}
	}
}
