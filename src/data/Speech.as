package data 
{
	/**
	 * ...
	 * @author rkardashov@gmail.com
	 */
	public class Speech 
	{
		public var phrases: Vector.<SpeechPhrase> = new Vector.<SpeechPhrase>();
		//public var phrases: Array = new Array();
		//public var phrases: Object = { };
		
		// input: customer XML
		public function Speech(xml: XML)
		{
			var speechList: XMLList = xml.speech;
			var phrase: SpeechPhrase;
			for each (var phraseXML: XML in speechList) 
				phrases.push(new SpeechPhrase(phraseXML));
				/*{
					phrase = new SpeechPhrase(phraseXML);
					phrases[phrase.eventShow] = phrase;
				}*/
		}
		
		public function getPhrase(event: String): SpeechPhrase
		{
			if (phrases.length == 0)
				return null;
			var filtered: Vector.<SpeechPhrase> = phrases.filter(
				function(item: SpeechPhrase, index: int, vector: Vector.<SpeechPhrase>): Boolean {
					return (item.eventShow == event);
				});
			if (filtered.length)
				return filtered[0];
			return null;
		}
	}
}
