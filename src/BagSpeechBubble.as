package 
{
	import starling.events.Event;
	/**
	 * ...
	 * @author rkardashov@gmail.com
	 */
	public class BagSpeechBubble extends SpeechBubble 
	{
		private var bag: Bag;
		
		public function BagSpeechBubble(bagView: BagView) 
		{
			super(bagView, "bagBubble");
			alignPivot("center", "top");
			bag = bagView.bag;
			addEventInspector(GameEvents.BAG_WRONG_GOOD, inspectBagWrongGood);
		}
		
		private function inspectBagWrongGood(e: Event, b: Bag): Boolean
		{
			// check showing the "bag for chemicals" message
			// when a good is put to the wrong bag
			return (bag.category == 1);
		}
	}
}