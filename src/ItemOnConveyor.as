package 
{
	
	/**
	 * ...
	 * @author rkardashov@gmail.com
	 */
	public class ItemOnConveyor extends Item
	{
		public function ItemOnConveyor()
		{
			GameEvents.subscribe(GameEvents.CONVEYOR_START, onConveyorStart);
			GameEvents.subscribe(GameEvents.CONVEYOR_STOP, onConveyorStop);
			GameEvents.subscribe(GameEvents.PAUSE, onPause);
			GameEvents.subscribe(GameEvents.RESUME, onResume);
		}
	}
}
