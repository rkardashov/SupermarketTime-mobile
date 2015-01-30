package  
{
	/**
	 * ...
	 * @author rkardashov@gmail.com
	 */
	public class NumpadButton extends PixelButton 
	{
		private var digit: int;
		
		public function NumpadButton(d: int) 
		{
			super(d + "_active", d + "_down");
			alignPivot();
			digit = d;
			d --;
			if (d == -1)
			{
				x = 292;
				y = 190;
			}
			else
			{
				x = 292 + 32 * (d % 3);
				y = 158 - 32 * int(d / 3);
			}
		}
		
		override protected function onPress():void 
		{
			GameEvents.dispatch(GameEvents.NUMPAD_ENTER_DIGIT, digit);
		}
	}
}
