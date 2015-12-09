package 
{
	import Banknote;
	/**
	 * ...
	 * @author rkardashov@gmail.com
	 */
	public class BanknoteTray extends ItemsDropArea implements IItemReceiver
	{
		private var banknoteRank: int;
		
		public function BanknoteTray(banknoteRank: int) 
		{
			super(this, "", 40, 90);
			this.banknoteRank = banknoteRank;
		}
		
		/* INTERFACE IItemReceiver */
		
		public function receive(item: Item): void 
		{
			var banknote: Banknote = item as Banknote;
			if (banknote && banknote.rank == banknoteRank)
				GameEvents.dispatch(GameEvents.BANKNOTE_IN_TRAY, banknote);
		}
	}
}
