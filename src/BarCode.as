package  
{
	import data.Assets;
	import starling.display.Image;
	import starling.textures.TextureSmoothing;
	
	/**
	 * ...
	 * @author rkardashov@gmail.com
	 */
	public class BarCode extends PixelSprite
	{
		public function BarCode() 
		{
			super();
			var img: Image = Assets.getImage("barcode_1");
			img.smoothing = TextureSmoothing.NONE;
			img.readjustSize();
			img.rotation = Math.PI * 0.5;
			addChild(img);
			alignPivot();
		}
	}
}
