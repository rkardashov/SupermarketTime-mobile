package 
{
	import Banknote;
	/**
	 * ...
	 * @author rkardashov@gmail.com
	 */
	public class ChangeTray extends ItemsDropArea implements IItemReceiver
	{
		public function ChangeTray() 
		{
			super(this, "change_tray");
		}
		
		/* INTERFACE IItemReceiver */
		
		public function receive(item: Item): void 
		{
			var banknote: Banknote = item as Banknote;
			if (!banknote)
				return;
			if (banknote.isChange)
				GameEvents.dispatch(GameEvents.BANKNOTE_IN_TRAY, banknote);
		}
	}
}
