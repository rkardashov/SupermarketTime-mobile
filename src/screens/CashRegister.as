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
		private var layerChange: PixelSprite;
		private var changeRanks:Array;
		
		public function CashRegister() 
		{
			super();
			
			var img: Image = Assets.getImage("cashregister");
			addChild(img);
			visible = false;
			
			var changeTray: ChangeTray;
			addChild(changeTray = new ChangeTray());
			changeTray.x = 0;
			changeTray.y = 60;
			
			var tray: BanknoteTray;
			for (var i:int = 0; i < 5; i++) 
			{
				addChild(tray = new BanknoteTray(i));	
				tray.x = 115 + 50 * i;
				tray.y = 120;
			}
			
			addChild(layerChange = new PixelSprite());
			addChild(layerBanknotes = new PixelSprite());
			
			GameEvents.subscribe(GameEvents.PAYMENT_START, onPaymentStart);
			GameEvents.subscribe(TouchEvent.TOUCH, onTouch);
			GameEvents.subscribe(GameEvents.BANKNOTE_IN_TRAY, onBanknoteInTray);
		}
		
		private function onTouch(e: TouchEvent): void 
		{
			/*if (cash && cash.paid)
			{
				var t: Touch = e.getTouch(this, TouchPhase.ENDED);
				if (t && t.getLocation(this).y > 190)
				{
					visible = false;
					GameEvents.dispatch(GameEvents.PAYMENT_COMPLETE);
				}
			}*/
		}
		
		private function onPaymentStart(e: Event, item: Item): void 
		{
			cash = item as Cash;
			if (cash)
			{
				visible = true;
				layerChange.removeChildren();
				// payment ranks: 2..4
				// change ranks: 1..3
				changeRanks = [0, 1, 2, 3, 4];
				var ranks: Array = [];
				var maxRank: int = 0;
				var rank: int;
				while (ranks.length < (2 + Math.random() * 2))
				{
					rank = changeRanks.splice(
						Math.random() * changeRanks.length, 1)[0];
					if (rank > maxRank)
						maxRank = rank;
					ranks.push(rank);
				}
				while (changeRanks[changeRanks.length - 1] > maxRank)
					changeRanks.pop();
				if (changeRanks.length == 0)
					changeRanks.push(ranks.shift());
				
				for each (rank in ranks) 
					for (var i:int = 0; i < Math.random() * 3; i++) 
						layerBanknotes.addChild(new Banknote(rank));
			}
		}
		
		private function onBanknoteInTray(e: Event, banknote: Banknote): void 
		{
			layerBanknotes.removeChild(banknote);
			if (banknote.isChange)
				layerChange.addChild(banknote);
			if (layerBanknotes.numChildren > 0)
				return;
			// if the last banknote was the part of change,
			if (banknote.isChange)
				// the payment can be completed.
				//cash.paid = true
				{
					cash.paid = true;
					visible = false;
					GameEvents.dispatch(GameEvents.PAYMENT_COMPLETE);
				}
			else
				// otherwise, add a number of change banknotes.
				for each (var rank: int in changeRanks) 
					for (var i:int = 0; i < Math.random() * 3; i++) 
						layerBanknotes.addChild(new Banknote(rank, true));
		}
	}
}
