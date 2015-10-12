package data 
{
	
	/**
	 * ...
	 * @author rkardashov@gmail.com
	 */
	public class SpeechPhrase 
	{
		public var eventShow: String;
		public var eventHide: String;
		public var text: String;
		public var disposable: Boolean = false;
		//public var tutorialName: String;
		//public var index: int;
		//public var event: String;
		//public var captureEvent: Boolean = true;
		//public var picture: String;
		
		// input: phrase XML:
		/*
		<speech
			eventShow="conveyor_goods_request"
			eventHide="good_scanned"
			phrase="Hey." />
		*/
		public function SpeechPhrase(xml: XML)
		{
			eventShow = xml.@eventShow;
			eventHide = xml.@eventHide;
			disposable = (xml.attribute("disposable").length() > 0) &&
				((xml.@disposable == "1") || (xml.@disposable == "true"));
			text = xml.@phrase;
			while (text.indexOf("\t") >= 0)
				text = text.replace("\t", "");
		}
	}
}
