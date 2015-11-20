package data 
{
	/**
	 * ...
	 * @author rkardashov@gmail.com
	 */
	public class BubbleInfo 
	{
		public var speech: Speech;
		public var textWidth: int;
		public var textHeight: int;
		
		public function BubbleInfo(xml: XML) 
		{
			speech = new Speech(xml);
			textWidth = xml.@textWidth;
			textHeight = xml.@textHeight;
		}
	}
}