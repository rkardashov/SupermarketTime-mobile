package screens 
{
	import Banknote;
	import BanknoteTray;
	import data.Assets;
	import starling.display.Image;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	/**
	 * ...
	 * @author rkardashov@gmail.com
	 */
	public class CashRegister extends PixelSprite 
	{
		private var cash: Cash;
		private var layerBanknotes: PixelSprite;
		
		public function CashRegister() 
		{
			super();
			
			var img: Image = Assets.getImage("cashregister");
			addChild(img);
			visible = false;
			
			var tray: BanknoteTray;
			for (var i:int = 0; i < 5; i++) 
			{
				addChild(tray = new BanknoteTray(i));	
				tray.x = 115 + 50 * i;
				tray.y = 120;
			}
			
			addChild(layerBanknotes = new PixelSprite());
			
			GameEvents.subscribe(GameEvents.PAYMENT_START, onPaymentStart);
			GameEvents.subscribe(TouchEvent.TOUCH, onTouch);
			GameEvents.subscribe(GameEvents.BANKNOTE_IN_TRAY, onBanknoteInTray);
		}
		
		private function onTouch(e: TouchEvent): void 
		{
			if (cash && cash.paid)
			{
				var t: Touch = e.getTouch(this, TouchPhase.ENDED);
				if (t && t.getLocation(this).y > 190)
				{
					visible = false;
					GameEvents.dispatch(GameEvents.PAYMENT_COMPLETE);
				}
			}
		}
		
		private function onPaymentStart(e: Event, item: Item): void 
		{
			cash = item as Cash;
			if (cash)
			{
				visible = true;
				for (var i:int = 0; i < Math.random() * 3 + 1; i++) 
					layerBanknotes.addChild(new Banknote());
			}
		}
		
		private function onBanknoteInTray(e: Event, banknote: Banknote): void 
		{
			layerBanknotes.removeChild(banknote);
			if (layerBanknotes.numChildren == 0)
			{
				cash.paid = true;
				//visible = false;
				//GameEvents.dispatch(GameEvents.PAYMENT_COMPLETE);
			}
		}
	}
}
