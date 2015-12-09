package 
{
	import data.Assets;
	import starling.display.MovieClip;
	import starling.textures.TextureSmoothing;
	/**
	 * ...
	 * @author rkardashov@gmail.com
	 */
	public class Banknote extends Item 
	{
		private const defaultX: int = 50;
		private const defaultY: int = 80;
		
		private var frames: MovieClip;
		
		public var rank: int;
		
		public function Banknote() 
		{
			super(TYPE_BANKNOTE);
			
			rank = Math.random() * 5;
			
			frames = new MovieClip(Assets.getTextures("banknote_"));
			frames.smoothing = TextureSmoothing.NONE;
			frames.currentFrame = rank;
			addChild(frames);
			
			alignPivot();
			
			rotation = Math.random() * Math.PI * 2;
			x = defaultX;
			y = defaultY;
		}
	}
}
