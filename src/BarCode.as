package  
{
	import data.Assets;
	import starling.display.Image;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;
	
	/**
	 * ...
	 * @author rkardashov@gmail.com
	 */
	public class BarCode extends Image
	{
		public function BarCode() 
		{
			super(Assets.getTexture("barcode_1"));
			smoothing = TextureSmoothing.NONE;
			readjustSize();
			pivotX = int(width / 2);
			pivotY = int(height / 2);
		}
	}
}
