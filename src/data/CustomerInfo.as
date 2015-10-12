package data
{
	/**
	 * ...
	 * @author rkardashov@gmail.com
	 */
	public class CustomerInfo 
	{
		private var id: String;
		public var texture:String;
		public var disableTimer: Boolean = false;
		public var conveyorCapacity: int;
		public var messages: Object = { };
		public var bagsRequest: Vector.<Boolean> = new Vector.<Boolean>;
		//public var type: int;
		//public var texture: String;
		public var time: Number;
		public var interval: Number;
		public var goods: Vector.<GoodInfo> = new Vector.<GoodInfo>;
		public var events: Object = { };
		public var moodInitial: int = 0;
		public var speech: Speech;
		//public var speechBubble: String = "";
		private const ALL_EVENTS: Array = [GameEvents.CUSTOMER_WELCOME, GameEvents.CUSTOMER_GOODBYE];
		
		public function CustomerInfo(dayXML: XML) 
		{
			// get possible customerID
			id = StrUtil.randomPart(dayXML.@customers, ",");
			
			// get customer data from customers.xml
			// TODO: check if customer for ID exists
			var customerXML: XML = Assets.customersXML.customer.(@id == id)[0];
			
			if (customerXML.attribute("texture").length() == 1)
				texture = customerXML.@texture
			else
				texture = id;
			
			/*.goodsMax="2"> 
				<good id="0" counts="0112" />
				<good id="1" counts="0012" />*/
			
			var goodsCount: int = 0;
			if (customerXML.attribute("goodsMin").length() > 0)
				goodsCount = int(customerXML.@goodsMin);
			goodsCount += Math.round(Math.random() *
				(int(customerXML.@goodsMax) - int(customerXML.@goodsMin)));
			while (goods.length < goodsCount)
			{
				for each (var goodXML: XML in customerXML.good)
				{
					if (int(goodXML.@id) > int(dayXML.@goodsMaxID))
						continue;
					var goodCount: int = int(StrUtil.randomChar(goodXML.@counts));
					for (var i:int = 0; i < goodCount; i++) 
						goods.push(new GoodInfo(dayXML, goodXML.@id));
				}
			}
			while (goods.length > goodsCount)
				goods.pop();
			trace(id + " goods count: " + goods.length);
			
			// TODO: iterate <customer>.<reaction>, store [event: moodChange] pairs
			//for each (var event: String in ALL_EVENTS) 
				//events[event] = 0;
			for each (var reactionXML: XML in customerXML.reaction)
			//{
				//trace(reactionXML.toXMLString());
				events[reactionXML.@event] = int(reactionXML.@mood);
			//}
			
			moodInitial = customerXML.@mood;
			
			time = -1;
			/*if (xml.attribute("time").length() > 0)
				time = xml.@time;*/
			
			interval = Math.random() * 3 + 3;
			
			//texture = String(int(Math.random() * 4));
			
			disableTimer = false;/* (int(xml.@disableTimer) == 1);*/
			
			speech = new Speech(customerXML);
			/*if (customerXML.attribute("speechBubble").length() > 0)
				speechBubble = customerXML.@speechBubble;
			*/
			
			/*var bagsStr: String = xml.@bags;
			while (bagsRequest.length < Goods.categories.length)
				bagsRequest.push(false);
			for (var j:int = 0; j < bagsStr.length; j++)
				bagsRequest[int(bagsStr.charAt(j))] = true;*/

			conveyorCapacity = int.MAX_VALUE;
			if (customerXML.attribute("conveyorCapacity").length() > 0)
				conveyorCapacity = int(customerXML.@conveyorCapacity);
		}
		
		/*public function nextGood(): GoodInfo 
		{
			return goods.shift();
		}
		*/
		/*public function get goodsCount(): int
		{
			return _goods.length;
		}*/
	}
}