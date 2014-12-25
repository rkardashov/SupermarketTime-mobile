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
		public var texture: String;
		public var time: Number;
		public var interval: Number;
		public var goods: Vector.<GoodInfo> = new Vector.<GoodInfo>;
		public var events: Object = { };
		private const ALL_EVENTS: Array = [GameEvents.CUSTOMER_ARRIVED, GameEvents.CUSTOMER_WELCOME, GameEvents.CUSTOMER_GOODBYE];
		
		public function CustomerInfo(xml: XML) 
		{
			time = -1;
			/*if (xml.attribute("time").length() > 0)
				time = xml.@time;*/
			
			interval = Math.random() * 3 + 3;
			
			/*type = -1;
			if (xml.attribute("type").length() > 0)
				type = xml.@type;
			if (type == -1)*/
				//type = Math.random() * 4;
			texture = String(int(Math.random() * 4));
			
			disableTimer = false;/* (int(xml.@disableTimer) == 1);*/
			
			/*var bagsStr: String = xml.@bags;
			while (bagsRequest.length < Goods.categories.length)
				bagsRequest.push(false);
			for (var j:int = 0; j < bagsStr.length; j++)
				bagsRequest[int(bagsStr.charAt(j))] = true;*/
			
			/*for each (var goodXML: XML in xml.good)
				if (goodXML.attribute("count").length() == 0)
					_goods.push(new GoodInfo(goodXML))
				else
					for (var i:int = 0; i < int(goodXML.@count); i++) 
						_goods.push(new GoodInfo(goodXML));*/
			
			var goodsCount: int = 2 + Math.random() * 4;
				/*int(xml.@goodsMin) + Math.random() * 
				(int(xml.@goodsMax) - int(xml.@goodsMin));
			while (_goods.length < goodsCount)
				_goods.push(new GoodInfo(new XML(<good type="-1" side="-1"/>)));*/
			while (goods.length < goodsCount)
				goods.push(new GoodInfo(xml));
			
			// some goods have category == -1 (in hands)
			/*var handLimit: int = Math.min(int(xml.@hands), _goods.length);
			var good: GoodInfo;
			while (handLimit > 0)
			{
				good = _goods[int(Math.random() * _goods.length)];
				if (good.category > -1)
				{
					good.category = -1;
					handLimit --;
				}
			}*/
			
			for each (var event: String in ALL_EVENTS) 
				/*if (Math.random() > 0.5)*/
					events[event] = 15
				/*else
					events[event] = 0*/;
			
			/*var xmlMsgs: XMLList;
			for each (var event: String in [
				GameEvents.CUSTOMER_ARRIVED, GameEvents.CUSTOMER_COMPLETE,
				GameEvents.BAG_NEW, GameEvents.BAG_FULL, GameEvents.CARD_PAYMENT]) 
			{
				messages[event] = new Vector.<Speech>;
				xmlMsgs = xml.message.(@event == event);
				for (i = 0; i < xmlMsgs.length(); i++) 
					if (xmlMsgs.(@index == i).length())
						messages[event].push(new Speech(xmlMsgs.(@index == i)[0]));
			}
			conveyorCapacity = int(xml.@conveyorCapacity);
			if (conveyorCapacity <= 0)*/
				conveyorCapacity = int.MAX_VALUE;
		}
		
		public function nextGood(): GoodInfo 
		{
			return goods.shift();
		}
		
		/*public function get goodsCount(): int
		{
			return _goods.length;
		}*/
	}
}