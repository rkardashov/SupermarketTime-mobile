package  
{
	import data.Assets;
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
	public class ZoomedBarCodeView extends Sprite implements IItemReceiver
	{
		private var codeInputField: TextField;
		private var barCodeNumericText1: TextField;
		private var barCodeNumericText2: TextField;
		private var _good: Good;
		private var _scanner: Scanner;
		
		public function ZoomedBarCodeView(scanner: Scanner) 
		{
			super();
			_scanner = scanner;
			//var img: Image = new Image(
				//Texture.fromEmbeddedAsset(Assets.barcode_input_view));
			var img: Image = Assets.getImage("overlay_code_input");
			img.smoothing = TextureSmoothing.NONE;
			addChild(img);
			addEventListener(TouchEvent.TOUCH, onTouch);
			// numeric buttons
			var btn: Button;
			for (var i:int = 0; i <= 9; i++) 
			{
				addChild(btn = new Button(
					//Texture.fromEmbeddedAsset(Assets.numeric_button), 
					Assets.getTexture("btn_numeric"), 
					String(i+1)));
					//(i+1).toString()));
				btn.x = int(Screens.unit * (10 + (i % 3) * 1.6));
				btn.y = int(Screens.unit * (2.5 + Math.floor(i / 3) * 1.6));
				btn.fontSize = 36;
				btn.addEventListener(Event.TRIGGERED, onNumBtnTriggered);
			}
			btn.text = "0";
			btn.x = int(Screens.unit * 11.6);
			
			// input text field
			addChild(codeInputField = new TextField(
				Screens.unit * 4, Screens.unit, "", "Courier new", 42));
			codeInputField.autoSize = TextFieldAutoSize.HORIZONTAL;
			codeInputField.x = int(Screens.unit * 9.75);
			codeInputField.y = int(Screens.unit * 1.2);
			
			addChild(barCodeNumericText1 = new TextField(
				Screens.unit * 3, Screens.unit * 1, "", "Courier new", 36));
			barCodeNumericText1.x =	int(Screens.unit * 2.15);
			barCodeNumericText1.y =	int(Screens.unit * 6.6);
			addChild(barCodeNumericText2 = new TextField(
				Screens.unit * 3, Screens.unit * 1, "", "Courier new", 36));
			barCodeNumericText2.x =	int(Screens.unit * 5.25);
			barCodeNumericText2.y =	int(Screens.unit * 6.6);
			
			// TODO: ENTER and CANCEL buttons
			visible = false;
		}
		
		private function onNumBtnTriggered(e: Event): void 
		{
			/*if (codeInputField.text.length < BarCode.LENGTH)
			{
				if ((e.target as Button).text == _good.barCodeSticker.code.charAt(
						codeInputField.text.length))
					codeInputField.text += (e.target as Button).text;
			}
			if (codeInputField.text == _good.barCodeSticker.code)
			{
				//_good.barCode.isGood = true;
				_scanner.scan(_good, true);
				visible = false;
			}*/
		}
		
		private function onTouch(e: TouchEvent): void 
		{
			// TODO: hide on "ENTER"/"CANCEL" buttons tap
		}
		
		//public function show(good: Good): void 
		public function receive(item: Item): void 
		{
			if (item.type !== Item.TYPE_GOOD)
				return;
			var good: Good = item as Good;
			
			//if (!good.barCode.isPresent || good.barCode.isGood)
				//return;
			_good = good;
			visible = true;
			codeInputField.text = "";
			// show numeric code under barcode
			// Courier new is OK
			/*barCodeNumericText1.text = good.barCodeSticker.code1;
			barCodeNumericText2.text = good.barCodeSticker.code2;*/
		}
	}
}
