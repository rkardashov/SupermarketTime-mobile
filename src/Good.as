package  
{
	import data.Assets;
	import data.BarcodeInfo;
	import data.GoodInfo;
	import data.Speech;
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
	import starling.events.TouchMarker;
	import starling.events.TouchProcessor;
	import starling.events.Touch;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;
	
	/**
	 * ...
	 * @author rkardashov@gmail.com
	 */
	public class Good extends Item /*implements IItemReceiver *///Sprite 
	{
		public var recycled: Boolean = true;
		
		//private var savedX: int;
		//private var savedY: int;
		
		private var _info: GoodInfo;
		
		private var _content: Sprite;
		
		protected var _sides: MovieClip;
		public var barCodeSticker: BarCode;
		private var _barcodeRect: Rectangle;
		private var _bubble: SpeechBubble;// Image;
		
		public var inBag: Boolean = false;
		public var scanned: Boolean = false;
		public var flipCount: int;
		
		public function Good()
		{
			super();
			_content = addChild(new Sprite()) as Sprite;
			_content.addChild(barCodeSticker = new BarCode());
			
			_bubble = new SpeechBubble(this, "goodsScanMeBubble", 70, 20);
			_bubble.addPhrase("scan me!", "", GameEvents.GOOD_SCANNED, null, checkHideBubble);
			_bubble.alignPivot("center", "bottom");
			
			visible = false;
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
		
		override public function get screenRect():Rectangle 
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
			if (_sides)
			{
				_sides.dispose();
				var numOldFrames: int = _sides.numFrames;
				for (var i:int = 0; i < frames.length; i++) 
					_sides.addFrame(frames[i]);
				//while (_sides.numFrames)
				while (numOldFrames)
				{
					numOldFrames --;
					_sides.removeFrameAt(0);
				}
			}
			else
			{
				_sides = new MovieClip(frames);
				_sides.smoothing = TextureSmoothing.NONE;
				_content.addChildAt(_sides, 0);
			}
			
			_sides.currentFrame = info.side;
			_sides.readjustSize();
			_content.pivotX = int(_sides.width / 2);
			_content.pivotY = int(_sides.height / 2);
			
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
		
		private function checkHideBubble(e: Event, g: Good): Boolean
		{
			// event: GOOD_SCANNED
			// return TRUE to hide the bubble for THIS good.
			return (g == this);
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
			_sides.currentFrame = (_sides.currentFrame + 1) % _sides.numFrames;
			_sides.readjustSize();
			_content.pivotX = int(_sides.width / 2);
			_content.pivotY = int(_sides.height / 2);
			barCodeSticker.visible = info.barcode && !info.barcode.isImprinted && barcodeSideUp;
		}
		
		override protected function onDrag(): void 
		{
			if (type == TYPE_GOOD/* && barcodeSideDown*/)
				GameEvents.dispatch(GameEvents.GOOD_DRAG, this);
		}
	}
}
