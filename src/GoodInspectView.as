package  
{
	import data.Assets;
	import data.BarcodeInfo;
	import screens.Screens;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;
	
	/**
	 * ...
	 * @author ...
	 */
	public class GoodInspectView extends Sprite //implements IItemReceiver
	{
		private var codeInputField: TextField;
		//private var barCodeNumericText1: TextField;
		//private var barCodeNumericText2: TextField;
		private var good: Good;
		private var charIndex: int = 0;
		private var codeParts: Array = [];
		//private var _scanner: Scanner;
		
		public function GoodInspectView(/*scanner: Scanner*/) 
		{
			super();
			addChild(Assets.getImage("overlay_code_input"));
			addEventListener(TouchEvent.TOUCH, onTouch);
			
			// input text field
			addChild(codeInputField = new TextField(120, 32, "", "Arcade_10", 10, 0xFFFFFF));
			codeInputField.autoSize = TextFieldAutoSize.HORIZONTAL;
			codeInputField.x = 280;
			codeInputField.y = 48;
			
			// numeric buttons
			//var btn: Button;
			for (var i:int = 0; i <= 9; i++) 
				addChild(new NumpadButton(i));
				
			var tf: TextField;
			for (var j:int = 0; j < 2; j++) 
			{
				addChild(tf = new TextField(96, 24, "", "Arcade_10", 20));
				tf.x = 38 + j * 94;
				tf.y = 158;
				codeParts.push(tf);
			}
			
			/*addChild(barCodeNumericText2 = new TextField(
				Screens.unit * 3, Screens.unit * 1, "", "Arcade_10", 20));
			barCodeNumericText2.x =	int(Screens.unit * 5.25);
			barCodeNumericText2.y =	int(Screens.unit * 6.6);*/
			
			GameEvents.subscribe(GameEvents.INSPECT_VIEW_SHOW, onInspectViewShow);
			
			visible = false;
		}
		
		private function onNumpadDigit(e: Event, digit: int): void 
		{
			if (good.info.barcode.code.charAt(charIndex) == String(digit))
			{
				charIndex ++;
				codeInputField.text += String(digit);
			}
			if (charIndex == BarcodeInfo.LENGTH)
			{
				visible = false;
				good.scanned = true;
				GameEvents.unsubscribe(GameEvents.NUMPAD_ENTER_DIGIT, onNumpadDigit);
				GameEvents.dispatch(GameEvents.GOOD_SCANNED, good);
			}
		}
		
		private function onTouch(e: TouchEvent): void 
		{
			// TODO: hide on "ENTER"/"CANCEL" buttons tap
		}
		
		private function onInspectViewShow(e: Event, g: Good): void 
		{
			good = g;
			codeParts[0].text = g.info.barcode.code.slice(0, BarcodeInfo.LENGTH / 2);
			codeParts[1].text = g.info.barcode.code.slice(BarcodeInfo.LENGTH / 2);
			visible = true;
			codeInputField.text = "";
			charIndex = 0;
			GameEvents.subscribe(GameEvents.NUMPAD_ENTER_DIGIT, onNumpadDigit);
		}
	}
}
