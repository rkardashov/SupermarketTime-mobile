package 
{
	import starling.display.Sprite;
	
	/**
	 * ...
	 * @author rkardashov@gmail.com
	 */
	public class PixelSprite extends Sprite 
	{
		public function PixelSprite() 
		{
			super();
		}
		
		override public function alignPivot(hAlign:String = "center", vAlign:String = "center"):void 
		{
			super.alignPivot(hAlign, vAlign);
			pivotX = Math.round(pivotX);
			pivotY = Math.round(pivotY);
		}
	}
}
