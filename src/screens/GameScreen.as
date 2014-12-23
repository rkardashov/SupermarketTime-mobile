package screens
{
	import data.Assets;
	import data.CustomerInfo;
	import data.DayData;
	import data.GoodInfo;
	import data.Saves;
	import data.Speech;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import screens.DayEndScreen;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author kurguru
	 */
	public class GameScreen extends Sprite
	{
		private var layerBottom:Sprite; // dropAreas, conveyor button, etc.
		private var layerItems:Sprite; // middle layer - most used
		private var layerUI:Sprite; // top layer - UI
		
		public var conveyor:Conveyor;
		//private var btnMoveConveyor: MoveConveyorButton;
		public var scanner:Scanner;
		public var bags:Vector.<BagView> = new Vector.<BagView>();
		private var customerQueue:CustomerQueue;
		public var sum:Sum;
		private var customerCard:CustomerCard;
		private var customerReceipt:CustomerReceipt;
		public var goodsInspectionView:GoodsInspectionView;
		private var bagsRequestView:BagsRequestView;
		//private var scorePopup:ScorePopup;
		private var btnPause:PauseButton;
		private var scoreView:ScoreView;
		//private var speechView:SpeechView;
		private var customerSpeech:CustomerSpeech;
		private var btnCustomerWelcome:CustomerWelcomeButton;
		private var btnCustomerGoodbye:CustomerGoodbyeButton;
		private var pauseWindow:PauseWindow;
		private var instructionView:InstructionView;
		private var dayIntroView:DayIntroView;
		public var dayTimer:DayTimer;
		
		[Embed(source="../../assets/sounds/219533__pulswelle__supermarket.mp3")]
		private static const _SOUND_AMBIENT:Class;
		private var ambient:Sound;
		
		private var day:DayData;
		
		public function GameScreen():void
		{
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			scaleX = scaleY = 2;
			ambient = new _SOUND_AMBIENT();
			
			var u:int = Screens.unit;
			
			addChild(Assets.getImage("bg_game"));
			
			/***  layers  ***/
			addChild(layerBottom = new Sprite());
			addChild(layerItems = new Sprite());
			addChild(layerUI = new Sprite());
			
			// TODO: uncomment for release
			//addChild(Assets.getImage("vignette_dark")).touchable = false;
			
			instructionView = new InstructionView();
			
			layerUI.addChild(dayTimer = new DayTimer());
			layerUI.addChild(bagsRequestView = new BagsRequestView());
			layerUI.addChild(goodsInspectionView = new GoodsInspectionView());
			//layerUI.addChild(scorePopup = new ScorePopup());
			layerUI.addChild(btnPause = new PauseButton());
			layerUI.addChild(scoreView = new ScoreView(dayTimer));
			//layerUI.addChild(speechView = new SpeechView());
			layerUI.addChild(customerSpeech = new CustomerSpeech());
			layerUI.addChild(btnCustomerWelcome = new CustomerWelcomeButton());
			layerUI.addChild(btnCustomerGoodbye = new CustomerGoodbyeButton());
			layerUI.addChild(pauseWindow = new PauseWindow());
			layerUI.addChild(instructionView/* = new InstructionView()*/);
			layerUI.addChild(dayIntroView = new DayIntroView(/*startDay*/));
			
			layerItems.addChild(conveyor = new Conveyor());
			layerItems.addChild(customerCard = new CustomerCard( /*onPayment*/));
			layerItems.addChild(customerReceipt = new CustomerReceipt());
			
			layerBottom.addChild(sum = new Sum());
			layerBottom.addChild(scanner = new Scanner( /*sum*/));
			var bag:BagView;
			for each (var category:int in Goods.categories)
			{
				bags.push(bag = new BagView(category));
				//bag.y = int(category * u * 1.5 + 100);
				layerBottom.addChild(bag);
			}
			customerQueue = new CustomerQueue(dayTimer); // , onCustomerArrived);
			layerBottom.addChild(customerQueue);
			var areaInspectGood:ItemsDropArea = new ItemsDropArea(goodsInspectionView, /*null, */"droparea_scales");
			areaInspectGood.x = 119;
			areaInspectGood.y = 206;
			layerBottom.addChild(areaInspectGood);
			
			Goods.init();
			ScorePopup.init(layerUI);
			
			GameEvents.subscribe(GameEvents.INTRO_END, onIntroEnd);
			GameEvents.subscribe(GameEvents.CUSTOMER_COMPLETE, checkStatus);
			GameEvents.subscribe(GameEvents.TIME_OUT, checkStatus);
		}
		
		public function enter(): void
		{
			day = new DayData(Saves.currentDayIndex);
			for (var i:int = 0; i < Goods.categories.length; i++)
			{
				bags[i].visible = day.bags[i];
				bags[i].reset();
			}
			
			// TODO: move to BagsRequest.@DAY_START
			bagsRequestView.visible = false;
			// TODO: move to CustomerCard.@DAY_START
			customerCard.visible = false;
			// TODO: move to CustomerReceipt.@DAY_START
			customerReceipt.visible = false;
			
			// TODO: move to InstructionView.@DAY_START
			instructionView.init(day);
			
			//dayIntroView.show(day);
			GameEvents.dispatch(GameEvents.INTRO_START, day);
		}
		
		private function onIntroEnd(e: Event): void
		{
			//dayTimer.start();
			//ambient.play();
			GameEvents.dispatch(GameEvents.DAY_START, day);
		}
		
		// Triggered on time_out, customer_complete
		private function checkStatus(e: Event): void 
		{
			//if (e.type == GameEvents.CUSTOMER_COMPLETE)
				//Saves.currentDay.customers++;
			
			if (dayTimer.timeIsOut && !customerQueue.customer)
				endDay();
		}
		
		private function endDay(): void
		{
			if (!stage)
				return;
			// TODO: @ day end: ambient .pause() or .fadeOut() 
			
			GameEvents.dispatch(GameEvents.DAY_END);
			Screens.gotoScreen(DayEndScreen);
		}
	}
}