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
		private var frames: MovieClip;
		
		public var isChange: Boolean;
		public var rank: int;
		
		public function Banknote(rank: int, isChange: Boolean = false) 
		{
			super(TYPE_BANKNOTE);
			
			this.isChange = isChange;
			this.rank = rank;
			//rank = Math.random() * 5;
			
			frames = new MovieClip(Assets.getTextures("banknote_"));
			frames.smoothing = TextureSmoothing.NONE;
			frames.currentFrame = rank;
			addChild(frames);
			
			alignPivot();
			rotation = Math.random() * Math.PI * 2;
			x = 60;
			y = 110;
			if (isChange)
			{
				x = 135 + 50 * rank;
				y = 160;
				rotation = Math.random() * Math.PI * 0.25 - Math.PI * 0.125;
			}
		}
	}
}
