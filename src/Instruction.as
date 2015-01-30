package 
{
	
	/**
	 * ...
	 * @author rkardashov@gmail.com
	 */
	public class Instruction 
	{
		//public var tutorialName: String;
		public var index: int;
		public var event: String;
		public var captureEvent: Boolean = true;
		//public var picture: String;
		
		public function Instruction(xml: XML)
		{
			index = xml.@index;
			event = xml.@event;
			if (xml.attribute("capture").length() == 1)
				captureEvent = (xml.@capture == "1");
			
			//picture = xml.@picture;
		}
	}
}
