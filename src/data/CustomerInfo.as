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
		public var moodLevels: Vector.<int> = new Vector.<int>();
		public var moodInitial: int = 0;
		public var speech: Speech;
		public var cashPayment: Boolean;
		
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
			
			// TODO: iterate <customer>.<reaction>, store [event: moodChange] pairs
			for each (var reactionXML: XML in customerXML.reaction)
				events[reactionXML.@event] = int(reactionXML.@mood);
			
			//moodLevels.push(10, 25);
			var moodLevelsStr: String = customerXML.@moodLevels;
			for each (var lvlStr: String in moodLevelsStr.split(",")) 
				moodLevels.push(int(lvlStr));
			moodInitial = customerXML.@mood;
			
			time = -1;
			/*if (xml.attribute("time").length() > 0)
				time = xml.@time;*/
			
			interval = Math.random() * 3 + 3;
			
			//texture = String(int(Math.random() * 4));
			
			disableTimer = false;/* (int(xml.@disableTimer) == 1);*/
			
			speech = new Speech(customerXML);
			
			/*var bagsStr: String = xml.@bags;
			while (bagsRequest.length < Goods.categories.length)
				bagsRequest.push(false);
			for (var j:int = 0; j < bagsStr.length; j++)
				bagsRequest[int(bagsStr.charAt(j))] = true;*/

			conveyorCapacity = int.MAX_VALUE;
			if (customerXML.attribute("conveyorCapacity").length() > 0)
				conveyorCapacity = int(customerXML.@conveyorCapacity);
				
			// check for random() >= @cashProbability / 100.0
			cashPayment = false;
			if ((dayXML.disabled.(@feature == "cash").length() == 0) &&
				(customerXML.attribute("cashProbability").length() > 0))
				cashPayment =
					Number(customerXML.@cashProbability) > (Math.random() * 100.0);
		}
	}
}