package 
{
	import data.Assets;
	/**
	 * ...
	 * @author rkardashov@gmail.com
	 */
	public class Cash extends Money 
	{
		public function Cash() 
		{
			super();
			
			addChild(Assets.getImage("card_" + String(int(Math.random() * 5))));
		}
	}
}
