package  
{
	import data.Assets;
	import starling.display.Image;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;
	
	/**
	 * ...
	 * @author ...
	 */
	public class MoveConveyorButton extends Image 
	{
		private var _conveyor: Conveyor;
		//private var isMoving: Boolean;
		
		public function MoveConveyorButton(conveyor: Conveyor) 
		{
			//super(Texture.fromEmbeddedAsset(Assets.btn_move_conveyor));
			//super(Texture.fromColor(14, 13, 0x33FF0000));
			super(Assets.getTexture("btn_conveyor_move"));
			smoothing = TextureSmoothing.NONE;
			_conveyor = conveyor;
			
			//x = conveyor.x - width;
			//y = conveyor.y + conveyor.height - height;
			x = 152;// 120
			y = 206;
			
			addEventListener(TouchEvent.TOUCH, onTouch);
		}
		
		private function onTouch(e: TouchEvent): void 
		{
			touch = e.getTouch(this, TouchPhase.BEGAN);
			if (touch)
				_conveyor.move();
			
			var touch: Touch = e.getTouch(this, TouchPhase.ENDED);
			if (touch)
				_conveyor.stop();
		}
	}
}
