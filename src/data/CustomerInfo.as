package data
{
	/**
	 * ...
	 * @author rkardashov@gmail.com
	 */
	public class CustomerInfo 
	{
		public var id: String;
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
		private const ALL_EVENTS: Array = [GameEvents.CUSTOMER_WELCOME, GameEvents.CUSTOMER_GOODBYE];
		
		public function CustomerInfo(dayXML: XML) 
		{
			// get possible customerID
			id = StrUtil.randomPart(dayXML.@customers, ",");
			trace("selected customer ID: " + id);
			//customerIDs[int(Math.random() * (customerIDs.length - 1))];
			
			// get customer data from customers.xml
			// TODO: check if customer for ID exists
			var customerXML: XML = Assets.customersXML.customer.(@id == id)[0];
			
			/*.goodsMax="2"> 
				<good id="0" counts="0112" />
				<good id="1" counts="0012" />*/
			
			var goodsCount: int = Math.max(1, Math.random() * int(customerXML.@goodsMax));
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
			
			/*var bagsStr: String = xml.@bags;
			while (bagsRequest.length < Goods.categories.length)
				bagsRequest.push(false);
			for (var j:int = 0; j < bagsStr.length; j++)
				bagsRequest[int(bagsStr.charAt(j))] = true;*/

			/*conveyorCapacity = int(xml.@conveyorCapacity);
			if (conveyorCapacity <= 0)*/
				conveyorCapacity = int.MAX_VALUE;
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