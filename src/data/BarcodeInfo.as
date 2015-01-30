package data 
{
	/**
	 * ...
	 * @author rkardashov@gmail.com
	 */
	public class BarcodeInfo 
	{
		static public const LENGTH: int = 10;
		
		public var code: String = "";
		//public var code1: String = "";
		//public var code2: String = "";
		/* Indicates if the scanner is able to read the barcode */
		public var isScannable: Boolean = true;
		/* Indicates if the barcode exists on the package */
		// TODO: remove .isImprinted property
		public var isImprinted: Boolean = false;
		public var atSide: int = 0;
		public var x: int = 0;
		public var y: int = 0;
		
		public function BarcodeInfo(xml: XML = null) 
		{
			code = "";
			while (code.length < LENGTH)
				code += "0123456789".charAt(int(Math.random() * 10));
			
			if (!xml)
				return;
			isImprinted = !(xml.@noBarcode == "1");
			atSide = xml.@barcodeSide;
			x = xml.@barcodeX;
			y = xml.@barcodeY;
		}
	}
}
