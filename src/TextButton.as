package  
{
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	/**
	 * ...
	 * @author rkardashov@gmail.com
	 */
	public class TextButton extends PixelButton 
	{
		private var textLabel: TextField;
		
		public function TextButton(text: String = "") 
		{
			super("btnWideUp", "btnWideDown");
			contentLayer.addChild(textLabel = new TextField(40, 18, "", "Systematic_9", 9));
			textLabel.x = 5;
			textLabel.autoScale = false;
			textLabel.autoSize = TextFieldAutoSize.HORIZONTAL;
			this.text = text;
		}
		
		public function set text(value: String): void
		{
			textLabel.text = value;
		}
		
		public function get text(): String
		{
			return textLabel.text;
		}
	}
}
