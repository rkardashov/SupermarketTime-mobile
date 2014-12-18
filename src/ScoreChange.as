package 
{
	
	/**
	 * ...
	 * @author rkardashov@gmail.com
	 */
	public class ScoreChange 
	{
		public var message: String;
		public var change: int;
		public var x: int;
		public var y: int;
		
		public function ScoreChange(message: String, change: int, x: int, y: int)
		{
			this.message = message;
			this.change = change;
			this.x = x;
			this.y = y;
		}
	}
}
