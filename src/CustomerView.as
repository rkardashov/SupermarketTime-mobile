package  
{
	import data.Assets;
	import data.CustomerInfo;
	import screens.GameScreen;
	import screens.Screens;
	import starling.animation.Juggler;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	
	/**
	 * ...
	 * @author rkardashov@gmail.com
	 */
	public class CustomerView extends Sprite/* implements IGoodReceiver*/
	{
		// TEMP
		static public const SPD: Number = 3;// 0.8;
		
		//private var goods: Vector.<Good> = new Vector.<Good>;
		private var isMoving: Boolean;
		private var isPaused: Boolean;
		private var timer: DayTimer;
		private var startTime: Number;
		private var xPrecise: Number;
		private var xTarget: Number;
		private var onArrived: Function;
		private var bubbleSpeech: SpeechView;
		//private var bubbleText:TextField;
		//private var juggler: Juggler = new Juggler();
		//private var moveTween: Tween;
		public var info: CustomerInfo;
		
		public function CustomerView(customerInfo: CustomerInfo) 
		{
			super();
			info = customerInfo;
			//var image: Image = Assets.getImage("customer_" + info.type);
			var image: Image = Assets.getImage("customer_" + info.texture);
			addChild(image);
			image.x = 16;
			image.y = 0;
			
			//bubbleSpeech = addChild(new Sprite()) as Sprite;
			bubbleSpeech = addChild(new SpeechView()) as SpeechView;
			bubbleSpeech.x = image.width;
			/*var bubble: Image = bubbleSpeech.addChild(Assets.getImage("bubble_customer_speech")) as Image;
			bubble.x = image.width;
			bubbleText = new TextField(150, 60, "", "Systematic_9", 9);
			bubbleSpeech.addChild(bubbleText);
			bubbleText.x = bubble.x + 10;
			bubbleText.y = bubble.y;
			bubbleText.autoScale = false;
			//bubbleText.autoSize = TextFieldAutoSize.VERTICAL;
			bubbleText.hAlign = "left";
			bubbleText.vAlign = "center";
			
			GameEvents.subscribe(GameEvents.CUSTOMER_ARRIVED, onCustomerArrived);
			GameEvents.subscribe(GameEvents.CONVEYOR_GOODS_REQUEST, onConveyorGoodsRequest);*/
			
			GameEvents.subscribe(GameEvents.PAUSE, onPause);
			GameEvents.subscribe(GameEvents.RESUME, onResume);
			timer = GameScreen(Screens.getScreen(GameScreen)).dayTimer;
			//juggler = new Juggler();
			//juggler.
			//moveTween = juggler.tween(this, ;
			//moveTween = Tween.
		}
		
		/*private function onCustomerArrived(e: Event, c: CustomerInfo): void 
		{
			bubbleSpeech.visible = (c == info && info.speechBubble.length);
			bubbleText.text = info.speechBubble;
		}
		
		private function onConveyorGoodsRequest(e: Event): void 
		{
			//if (c == info)
				bubbleSpeech.visible = false;
		}*/
		
		private function onPause(/*e: Event*/): void 
		{
			removeEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
			isPaused = true;
		}
		
		private function onResume(/*e: Event*/): void 
		{
			isPaused = false;
			if (isMoving && !hasEventListener(EnterFrameEvent.ENTER_FRAME))
				addEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(e: EnterFrameEvent): void 
		{
			if (timer.time < startTime)
				return;
			xPrecise -= SPD * e.passedTime * 60.0; // 60 FPS
			x = int(xPrecise);
			if (xPrecise < xTarget)
			{
				isMoving = false;
				removeEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
				//if (onArrived !== null)
					//onArrived();
				//GameEvents.dispatch(GameEvents.CUSTOMER_ARRIVED, info);
				GameEvents.dispatch(GameEvents.CUSTOMER_STOPPED, info);
			}
		}
		
		public function moveTo(xTarget: int, delay: Number = 0/*,
			onArrived: Function = null*/): void 
		{
			isMoving = true;
			this.xTarget = xTarget;
			this.startTime = timer.time + delay;
			//this.onArrived = onArrived;
			xPrecise = x;
			if (!isPaused && !hasEventListener(EnterFrameEvent.ENTER_FRAME))
				addEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
			/*var tween: Tween = Tween(
				Starling.juggler.tween(this, Math.pow((x-xPos) / 20, 0.5), 
				{
					// EASE_IN_OUT
					transition: Transitions.EASE_IN_OUT,
					delay: delay,
					x: xPos,
					roundToInt: true,
					onComplete: onArrived
				}
				));*/
		}
	}
}
