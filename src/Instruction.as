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
		//public var picture: String;
		
		public function Instruction(xml: XML)
		{
			index = xml.@index;
			event = xml.@event;
			//picture = xml.@picture;
		}
	}
}
