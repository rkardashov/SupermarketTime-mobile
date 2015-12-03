package  
{
	import data.Assets;
	import data.BarcodeInfo;
	import data.GoodInfo;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import screens.GameScreen;
	import screens.Screens;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.events.Touch;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;
	
	/**
	 * ...
	 * @author rkardashov@gmail.com
	 */
	public class Good extends Item
	{
		protected var _content: PixelSprite;
		protected var _sides: MovieClip;
		public var barCodeSticker: BarCode;
		private var _bubble: SpeechBubble;
		private var _barcodeRect: Rectangle;
		
		private var _info: GoodInfo;
		public var recycled: Boolean = true;
		public var inBag: Boolean = false;
		public var scanned: Boolean = false;
		public var flipCount: int;
		
		public function Good()
		{
			super();
			_content = addChild(new PixelSprite()) as PixelSprite;
			_sides = new MovieClip(Assets.getTextures("goods_cola_can_1"));
			_sides.smoothing = TextureSmoothing.NONE;
			_content.addChild(_sides);
			_content.addChild(barCodeSticker = new BarCode());
			_content.alignPivot();
			
			_bubble = new SpeechBubble(this, "goodsScanMeBubble");
			_bubble.alignPivot("center", "bottom");
			
			visible = false;
			
			alignPivot();
		}
		
		public function recycle(): void 
		{
			removeFromParent();
			recycled = true;
			inBag = false;
			atConveyor = false;
			scanned = false;
		}
		
		public function get barCodeRect(): Rectangle
		{
			if (_info.barcode)
				return barCodeSticker.getBounds(stage, _barcodeRect)
			else
				return null;
		}
		
		override public function get screenRect(): Rectangle 
		{
			return _content.getBounds(Screens.getScreen(GameScreen));
		}
		
		public function get info(): GoodInfo
		{
			return _info;
		}
		
		public function set info(goodInfo: GoodInfo): void 
		{
			_info = goodInfo;
			
			var frames: Vector.<Texture> = Assets.getTextures(info.texturePrefix);
			//_sides.dispose();
			var numOldFrames: int = _sides.numFrames;
			for (var i:int = 0; i < frames.length; i++) 
				_sides.addFrame(frames[i]);
			while (numOldFrames)
			{
				numOldFrames --;
				_sides.removeFrameAt(0);
			}
			_sides.currentFrame = info.side;
			_sides.readjustSize();
			_bubble.y = -_content.pivotY;
			
			flipCount = 0;
			
			if (!_info.barcode)//.isImprinted)
				GameEvents.subscribe(GameEvents.BARCODE_APPLY, onBarcodeApplied);
			barCodeSticker.visible = _info.barcode &&
				!_info.barcode.isImprinted && barcodeSideUp;
			if (_info.barcode)
			{
				barCodeSticker.x = _info.barcode.x;
				barCodeSticker.y = _info.barcode.y;
			}
			
			_content.rotation = int(Math.random() * 4) * Math.PI * 0.5;
		}
		
		private function onBarcodeApplied(e: Event, g: GoodInfo): void 
		//private function onBarcodeApplied(e: Event, b: BarcodeInfo): void 
		{
			if (info !== g)
				return;
			GameEvents.unsubscribe(GameEvents.BARCODE_APPLY, onBarcodeApplied);
			//_info.barcode = b;
			barCodeSticker.visible = !info.barcode.isImprinted && barcodeSideUp;
			barCodeSticker.x = info.barcode.x;
			barCodeSticker.y = info.barcode.y;
		}
		
		/*protected function get side(): int
		{
			return _sides.currentFrame;
		}*/
		
		private function get barcodeSideUp(): Boolean
		{
			return (_info.barcode !== null &&
				_sides.currentFrame == _info.barcode.atSide);
		}
		
		public function get barcodeSideDown(): Boolean
		{
			return (_info.barcode !== null &&
				((_sides.currentFrame + int(_sides.numFrames / 2))
				% _sides.numFrames) == _info.barcode.atSide);
		}
		
		override protected function onTouch(): void 
		{
			if (!_info.flippable)
				return;
			flipCount ++;
			info.side = (_sides.currentFrame + 1) % _sides.numFrames;
			_sides.currentFrame = info.side;
			_sides.readjustSize();
			barCodeSticker.visible = info.barcode && !info.barcode.isImprinted && barcodeSideUp;
		}
		
		override protected function onDrag(): void 
		{
			if (type == TYPE_GOOD/* && barcodeSideDown*/)
				GameEvents.dispatch(GameEvents.GOOD_DRAG, this);
		}
	}
}
