package data 
{
	/**
	 * ...
	 * @author rkardashov@gmail.com
	 */
	public class EmbeddedAssets 
	{
		/* Texture atlas */
		[Embed(source = "../../assets/atlas/atlas.png")]
		public static const atlas: Class;
		[Embed(source="../../assets/atlas/atlas.xml", mimeType="application/octet-stream")]
		public static const atlas_xml: Class;
	
		/* Fonts */
		[Embed(source="../../assets/fonts/systematic_9.fnt", mimeType="application/octet-stream")]
		public static const systematic: Class;
		[Embed(source="../../assets/fonts/arcade_10.fnt", mimeType="application/octet-stream")]
		public static const arcade: Class;
		
		/* Sounds */
		[Embed(source="../../assets/sounds/ambient.mp3")]
		public static const ambient: Class;
		[Embed(source="../../assets/sounds/scan.mp3")]
		public static const scan: Class;
		[Embed(source="../../assets/sounds/bag/bagLong.mp3")]
		public static const bag_long: Class;
		[Embed(source="../../assets/sounds/bag/bag_0.mp3")]
		public static const bag_0: Class;
		[Embed(source="../../assets/sounds/bag/bag_1.mp3")]
		public static const bag_1: Class;
		[Embed(source="../../assets/sounds/bag/bag_2.mp3")]
		public static const bag_2: Class;
		[Embed(source="../../assets/sounds/bag/bag_3.mp3")]
		public static const bag_3: Class;
		
		/* XML */
		[Embed(source="../../assets/xml/days.xml", mimeType="application/octet-stream")]
		public static const days: Class;
		[Embed(source="../../assets/xml/customers.xml", mimeType="application/octet-stream")]
		public static const customers: Class;
		[Embed(source="../../assets/xml/goods.xml", mimeType="application/octet-stream")]
		public static const goods: Class;
		
		/* Particles */
		[Embed(source = "../../assets/particles/particle1.png")]
		public static const particle1: Class;
		[Embed(source="../../assets/particles/particle1_xml.pex", mimeType="application/octet-stream")]
		public static const particle1_xml: Class;
		
		public function EmbeddedAssets() 
		{
		}
	}
}
