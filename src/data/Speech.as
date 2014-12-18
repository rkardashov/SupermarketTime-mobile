package data 
{
	/**
	 * ...
	 * @author rkardashov@gmail.com
	 */
	public class Speech 
	{
		public var text: String;
		//public var closeOnTouch: Boolean = true;
		//private var fullscreen: Boolean = false;
		public var instruction: Boolean = false;
		//public var command: String;
		//public var timed: Boolean = false;
		
		public function Speech(xml: XML) 
		{
			text = xml;
			while (text.indexOf("\t") >= 0)
				text = text.replace("\t", "");
			//fullscreen: blocks screen, closes on screen touch
			//permanent: shown forever (until next message)
			//timed: shown for N seconds
			instruction = (xml.@instruction == "1");
			//command = xml.@command;
			//this[xml.@type] = true;
		}
	}
}
