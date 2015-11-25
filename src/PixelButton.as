package  
{
	import data.Assets;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;
	
	/**
	 * ...
	 * @author ...
	 */
	public class PixelButton extends Sprite 
	{
		//private static const STATE_OUT: uint = 0;
		//private static const STATE_OVER: uint = 1;
		//private static const STATE_DOWN: uint = 2;
		
		//private var state: uint = STATE_OUT;
		private var pressed: Boolean = false;
		
		private var disabledOverlay: Image;
		protected var contentLayer: Sprite;
		private var touch: Touch;
		private var imgUp: Image;
		private var imgDown: Image;
		
		public function PixelButton(upStateImg: String, downStateImg: String = null) 
		{
			//imgUp = new Image(Texture.fromEmbeddedAsset(upStateImg));
			imgUp = Assets.getImage(upStateImg);
			imgUp.smoothing = TextureSmoothing.NONE;
			addChild(imgUp);
			
			if (!downStateImg)
				downStateImg = upStateImg;
			//imgDown = new Image(Texture.fromEmbeddedAsset(downStateImg));
			imgDown = Assets.getImage(downStateImg);
			imgDown.smoothing = TextureSmoothing.NONE;
			addChild(imgDown);
			imgDown.visible = false;
			
			addChild(contentLayer = new Sprite());
			
			addChild(disabledOverlay = new Image(
				Texture.fromColor(imgUp.width, imgUp.height, 0x66FFFFFF)));
			disabledOverlay.visible = false;
			
			addEventListener(TouchEvent.TOUCH, onTouch);
		}
		
		public function set enabled(value: Boolean): void 
		{
			disabledOverlay.visible = !value;
			if (value)
				addEventListener(TouchEvent.TOUCH, onTouch);
			if (!value)
				removeEventListener(TouchEvent.TOUCH, onTouch);
		}
		
		private function onTouch(e: TouchEvent): void 
		{
			if (!pressed)
			{
				touch = e.getTouch(this, TouchPhase.BEGAN);
				if (touch)
				{
					pressed = true;
					imgUp.visible = false;
					imgDown.visible = true;
					return;
				}
			}
			if (pressed)
			{
				touch = e.getTouch(this, TouchPhase.ENDED);
				if (touch)
				{
					pressed = false;
					imgUp.visible = true;
					imgDown.visible = false;
					onPress();
					dispatchEvent(new Event(Event.TRIGGERED));
				}
			}
		}
		
		protected function onPress(): void 
		{
		}
	}
}