package  
{
	import data.Assets;
	import data.SpeechPhrase;
	/**
	 * ...
	 * @author rkardashov@gmail.com
	 */
	public class Tutorial 
	{
		public var id: String;
		public var instructions: Vector.<data.SpeechPhrase> = new Vector.<data.SpeechPhrase>();
		
		public function Tutorial(id: String) 
		{
			this.id = id;
			if (Assets.tutorialsXML.tutorial.(@id == id).length() == 0)
				return;
			var tutXML: XML = Assets.tutorialsXML.tutorial.(@id == id)[0];
			var instrXML: XMLList;
			for (var i: int = 0; i < tutXML.instruction.length(); i++)
			{
				instrXML = tutXML.instruction.(@index == i);
				if (instrXML.length() == 1)
					instructions.push(new data.SpeechPhrase(instrXML[0]));
			}
		}
	}
}