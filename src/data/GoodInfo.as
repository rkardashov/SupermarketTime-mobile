package data 
{
	/**
	 * ...
	 * @author rkardashov@gmail.com
	 */
	public class GoodInfo 
	{
		//static public const prefixes: Array = [
			//"milk_", "mustard", "beer_", "ketchup_", "cola_", "wine_"];
		
		//private static var _xml: XML;
		
		public var messages: Object = { };
		//public var type: int;
		public var id: String;
		public var side: int;
		public var sideCount: int = 4;
		public var flippable: Boolean = true;
		public var bubbleVisible: Boolean = false;
		private var _category: int;
		public var texturePrefix: String;
		
		public var barcode: BarcodeInfo;
		
		public function GoodInfo(dayXML: XML, goodID: String) 
		{
			id = goodID;
			//trace("creating good @ID " + id);
			var goodXML: XML = Assets.goodsXML.good.(@id == id)[0];
			
			texturePrefix = "goods_" + goodXML.@texture + "_";
			_category = goodXML.@category;
			/*if (xml.attribute("category").length() > 0)
				category = xml.@category;*/
			var catIDs: Array = String(dayXML.@bags).split(",");
			var maxCatID: int = catIDs.pop();
			if (_category > maxCatID)
				_category = Math.random() * maxCatID;
			
			if (!(goodXML.@noBarcode == "1"))
				barcode = new BarcodeInfo(goodXML);
			
			side = Math.random() * sideCount;
			if (dayXML.attribute("side").length() == 1)
				side = dayXML.@side;
			//flippable = !(dayXML.@noflip == "1");
			//var disabledFeatures: String = dayXML.@disabledFeatures;
			flippable = !(dayXML.disabled.(@feature == "flipping").length() == 1);
			if (!flippable)
				side = 2;
				
			bubbleVisible = (dayXML.attribute("goodsScanMeBubble").length() == 1);
			
			var msgQueue: Vector.<Speech>;
			var i: int;
			for each (var event: String in [
				GameEvents.GOOD_ENTER, GameEvents.GOOD_RECEIVED,
				GameEvents.GOOD_SCANNED, GameEvents.GOOD_CHECKOUT,
				GameEvents.BAG_GOOD_ADDED]) 
			{
				msgQueue = new Vector.<Speech>;
				var xmlMsgs: XMLList = dayXML.message.(@event == event);
				for (i = 0; i < xmlMsgs.length(); i++) 
					if (xmlMsgs.(@index == i).length())
						msgQueue.push(new Speech(xmlMsgs.(@index == i)[0]));
				messages[event] = msgQueue;
			}
		}
		
		public function get category(): int 
		{
			return _category;
		}
		
		public function set category(value: int): void 
		{
			_category = value;
			if ((_category == -1) && (messages[GameEvents.GOOD_SCANNED].length == 0))
			{
				var msgQueue: Vector.<Speech> = new Vector.<Speech>;
				var xmlMsg: XML = 
					<message index="0" instruction="1"> Это давайте мне в руки.
					</message>;
				msgQueue.push(new Speech(xmlMsg));
				messages[GameEvents.GOOD_SCANNED] = msgQueue;
			}
		}
		
		/*public function get texturePrefix(): String 
		{
			return "goods_" + prefixes[type];
		}*/
	}
}
