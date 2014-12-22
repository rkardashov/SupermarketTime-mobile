package 
{
	import data.Assets;
	import screens.Screens;
	import starling.animation.Transitions;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.extensions.PDParticleSystem;
	import starling.text.TextField;
	import starling.textures.TextureSmoothing;
	
	/**
	 * ...
	 * @author rkardashov@gmail.com
	 */
	public class ScorePopup extends Sprite 
	{
		static private const POOL_CHUNK: int = 8;
		static private var _pool: Vector.<ScorePopup> = new Vector.<ScorePopup>;
		static private var uiLayer: Sprite;
		
		static private function grow(): void 
		{
			for (var i:int = 0; i < POOL_CHUNK; i++) 
				_pool.push(new ScorePopup());
		}
		
		static private function get(): ScorePopup
		{
			if (_pool.length > 0)
				return _pool.pop();
			grow();
			return get();
		}
		
		static public function init(popupUILayer: Sprite): void 
		{
			uiLayer = popupUILayer;
			get().prepare();
		}
		
		private var _text: TextField;
		private var _shadow: TextField;
		private var _effect:MovieClip;
		private const DURATION: Number = 2.0;
		
		public function ScorePopup()
		{
			addChild(_effect = new MovieClip(Assets.getTextures("pixels")));
			_effect.smoothing = TextureSmoothing.NONE;
			//_effect.visible = false;
			_effect.scaleX = _effect.scaleY = 3;
			
			addChild(_shadow = new TextField
				(300, 50, "", "Systematic_9", 18, 0x88000000));
			_shadow.x = 1;
			_shadow.y = 1;
			addChild(_text = new TextField
				(300, 50, "", "Systematic_9", 18, 0xFFFFFFFF));
			
			x = 50;
			y = Screens.centerY - 30;
			//visible = false;
			touchable = false;
			visible = false;
			
			uiLayer.addChild(this);
		}
		
		private function onAddScore(e: Event, score: ScoreChange): void 
		{
			GameEvents.unsubscribe(GameEvents.ADD_SCORE, onAddScore);
			get().prepare();
			
			_text.text = score.message + " +" + score.change;
			_shadow.text = score.message + " +" + score.change;
			x = score.x;
			y = score.y;
			fadeOut();
		}
		
		private function prepare(): void 
		{
			GameEvents.subscribe(GameEvents.ADD_SCORE, onAddScore);
		}
		
		private function fadeOut(): void 
		{
			visible = true;
			alpha = 1.0;
			Starling.juggler.tween(this, DURATION,
				{
					alpha: 0.0,
					transition: Transitions.EASE_IN_OUT,
					onComplete: onFadeOutComplete
				});
			Starling.juggler.tween(this, DURATION,
				{
					y: y-20,
					transition: Transitions.LINEAR,
					roundToInt: true
				});
				
			//_effect.visible = true;
			_effect.currentFrame = 0;
			Starling.juggler.tween(_effect, DURATION,
				{
					currentFrame: _effect.numFrames - 1,
					transition: Transitions.LINEAR,
					roundToInt: true
				});
		}
		
		private function onFadeOutComplete(): void
		{
			visible = false;
			_pool.push(this);
			//_effect.visible = false;
		}
		
		/*private function onEnterFrame(e: EnterFrameEvent): void 
		{
			alpha -= 0.01;
			if (alpha <= 0)
			{
				visible = false;
				removeEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
				_pool.push(this);
			}
		}*/
	}
}
