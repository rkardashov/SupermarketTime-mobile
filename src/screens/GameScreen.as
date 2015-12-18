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
	public class GameScreen extends BasicScreen
	{
		private var layerBottom: Sprite; // dropAreas, conveyor button, etc.
		private var layerItems: Sprite; // middle layer - most used
		private var dragController: DragController; // item dragging controller
		private var layerUI: Sprite;  // top layer - UI
		
		public var conveyor: Conveyor;
		//private var btnMoveConveyor: MoveConveyorButton;
		public var scanner: Scanner;
		public var bags: Vector.<BagView> = new Vector.<BagView>();
		private var customerQueue: CustomerQueue;
		public var sum: Sum;
		private var customerReceipt: Receipt;
		public var scalesView: ScalesView;
		public var inspectView: GoodInspectView;
		private var bagsRequestView: BagsRequestView;
		//private var scorePopup:ScorePopup;
		private var btnPause: PauseButton;
		private var scoreView: ScoreView;
		private var btnCustomerHiBye: HiByeButton;
		private var pauseWindow: PauseWindow;
		private var dayIntroView: DayIntroView;
		public var dayTimer: DayTimer;
		
		/*[Embed(source="../../assets/sounds/219533__pulswelle__supermarket.mp3")]
		private static const _SOUND_AMBIENT:Class;
		private var ambient:Sound;
		*/
		private var day: DayData;
		
		public function GameScreen(): void
		{
			super();
			
			//ambient = new _SOUND_AMBIENT();
			
			var u:int = Screens.unit;
			
			addChild(Assets.getImage("bg_game"));
			
			/***  layers  ***/
			addChild(layerBottom = new Sprite());
			addChild(layerItems = new Sprite());
			addChild(dragController = new DragController(
				[Item.TYPE_GOOD, Item.TYPE_CONVEYOR_DIVIDER,
				Item.TYPE_MONEY, Item.TYPE_RECEIPT]));
			addChild(layerUI = new Sprite());
			
			// TODO: uncomment for release
			//addChild(Assets.getImage("vignette_dark")).touchable = false;
			
			layerUI.addChild(dayTimer = new DayTimer());
			layerUI.addChild(scoreView = new ScoreView(dayTimer));
			layerUI.addChild(bagsRequestView = new BagsRequestView());
			layerUI.addChild(scalesView = new ScalesView());
			layerUI.addChild(inspectView = new GoodInspectView());
			//layerUI.addChild(scorePopup = new ScorePopup());
			layerUI.addChild(btnPause = new PauseButton());
			layerUI.addChild(btnCustomerHiBye = new HiByeButton());
			layerUI.addChild(pauseWindow = new PauseWindow());
			layerUI.addChild(dayIntroView = new DayIntroView());
			layerUI.addChild(new CashRegister());
			
			layerBottom.addChild(sum = new Sum());
			layerBottom.addChild(scanner = new Scanner( /*sum*/));
			var bag:BagView;
			for each (var category:int in Goods.categories)
			{
				bags.push(bag = new BagView(category));
				//bag.y = int(category * u * 1.5 + 100);
				layerBottom.addChild(bag);
			}
			customerQueue = new CustomerQueue(dayTimer);
			layerBottom.addChild(customerQueue);
			var areaInspectGood:GoodInspectDropArea = new GoodInspectDropArea();
			areaInspectGood.x = 119;
			areaInspectGood.y = 206;
			layerBottom.addChild(areaInspectGood);
			
			layerItems.addChild(conveyor = new Conveyor());
			layerItems.addChild(new Cash());
			layerItems.addChild(new Card());
			layerItems.addChild(customerReceipt = new Receipt());
			
			Goods.init();
			ScorePopup.init(layerUI);
			
			GameEvents.subscribe(GameEvents.INTRO_END, onIntroEnd);
			GameEvents.subscribe(GameEvents.CUSTOMER_COMPLETE, checkStatus);
			GameEvents.subscribe(GameEvents.TIME_OUT, checkStatus);
		}
		
		override protected function onEnter(): void 
		{
			day = new DayData(Saves.currentDayIndex);
			for (var i:int = 0; i < Goods.categories.length; i++)
			{
				bags[i].visible = day.bags[i];
				bags[i].reset();
			}
			
			// TODO: move to BagsRequest.@DAY_START
			bagsRequestView.visible = false;
			// TODO: move to CustomerReceipt.@DAY_START
			customerReceipt.visible = false;
			
			//dayIntroView.show(day);
			/*GameEvents.dispatch(GameEvents.INTRO_START, day);*/
		}
		
		override protected function onReady(): void 
		{
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
			if (dayTimer.timeIsOut && !customerQueue.customer
				&& state == STATE_ACTIVE)
			{
				GameEvents.dispatch(GameEvents.DAY_END);
				Screens.gotoScreen(DayEndScreen);
			}
		}
	}
}