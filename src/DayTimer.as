package  
{
	import data.CustomerInfo;
	import data.DayData;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	/**
	 * ...
	 * @author rkardashov@gmail.com
	 */
	public class DayTimer extends Sprite
	{
		private const DEFAULT_DURATION: int = 60;
		private var _timer: Timer;
		private var _text: TextField;
		private var _text_shadow: TextField;
		private var _event_times: Vector.<Number> = new Vector.<Number>();
		private var _event_handlers: Vector.<Function> = new Vector.<Function>();
		private var dayDuration: int;
		
		public function DayTimer() 
		{
			super();
			
			alpha = 0.3;
			
			x = 190;
			y = 2;
			addChild(_text_shadow = new TextField(125, 30, "", "Arcade_10", 20,
				0x88888888));
			_text_shadow.x = _text_shadow.y = 1;
			addChild(_text = new TextField(125, 30, "", "Arcade_10", 20, 0xFFFF8839));
			_text.autoScale = _text_shadow.autoScale = false;
			_text.vAlign = _text_shadow.vAlign = VAlign.BOTTOM;
			_text.hAlign = _text_shadow.hAlign = HAlign.LEFT;
			_text.text = _text_shadow.text = "";
			
			
			_timer = new Timer(1000, 0);// DEFAULT_TIME_SEC);
			_timer.addEventListener(TimerEvent.TIMER, onTimer);
			visible = false;
			
			GameEvents.subscribe(GameEvents.INTRO_START, onIntroStart);
			GameEvents.subscribe(GameEvents.DAY_START, onDayStart);
			GameEvents.subscribe(GameEvents.DAY_END, pause);
			GameEvents.subscribe(GameEvents.PAUSE, onGamePause);
			GameEvents.subscribe(GameEvents.RESUME, onGameResume);
			GameEvents.subscribe(GameEvents.CUSTOMER_ARRIVED, onCustomerArrived);
			GameEvents.subscribe(GameEvents.CUSTOMER_COMPLETE, onCustomerComplete);
		}
		
		private function onIntroStart():void 
		{
			visible = false;
		}
		
		private function onDayStart(e: Event, d: DayData): void
		{
			reset(d.duration);
			start();
			visible = true;
		}
		
		// TODO: move this away from DayTimer. Customer? CustomerQueue?
		private function onCustomerArrived(e: Event, c: CustomerInfo): void 
		{
			// WTF ???
			/*if (c.disableTimer)
				pause()
			else
				resume();*/
		}
		
		private function onCustomerComplete(e: Event, c: CustomerInfo): void 
		{
			resume();
			if (timeIsOut)
				GameEvents.dispatch(GameEvents.TIME_OUT);
			else
			// TODO: move _CUSTOMER_ messages out. TIMER messages ONLY!
				GameEvents.dispatch(GameEvents.NEXT_CUSTOMER);
		}
		
		private function onGamePause(): void 
		{
			if (_timer.running)
				pause();
		}
		private function onGameResume(): void 
		{
			if (!_timer.running)
				resume();
		}
		
		public function start(): void 
		{
			_timer.reset();
			_timer.start();
		}
		
		public function pause(): void 
		{
			_timer.stop();
		}
		
		public function resume(): void 
		{
			_timer.start();
		}
		
		public function get isRunning(): Boolean
		{
			return _timer.running;
		}
		
		public function reset(duration: int): void 
		{
			_timer.reset();
			//_timer.repeatCount = duration;
			dayDuration = duration;
			setTimeText(duration);
			clearEvents();
		}
		
		private function setTimeText(value: int): void 
		{
			_text.text = "TIME: " + value.toString();
			_text_shadow.text = "TIME: " + value.toString();
		}
		
		public function get time(): Number 
		{
			return _timer.currentCount;
		}
		
		public function get timeIsOut(): Boolean
		{
			return _timer.currentCount >= dayDuration;// _timer.repeatCount;
		}
		
		private function onTimer(e: TimerEvent): void 
		{
			if (timeIsOut)
				setTimeText(0)
			else
				setTimeText(dayDuration - _timer.currentCount);
				
			if (_event_times.length && _timer.currentCount >= _event_times[0])
			{
				_event_times.shift();
				_event_handlers.shift()();
			}
			
			GameEvents.dispatch(GameEvents.TIMER_SECOND, dayDuration - _timer.currentCount);
			if (timeIsOut)
				GameEvents.dispatch(GameEvents.TIME_OUT);
		}
		
		/**
		 * Запланировать выполнение метода в указанное время игрового дня
		 * @param	time	время дня
		 * @param	handler	метод-обработчик события
		 */
		public function addEvent(time: Number, handler: Function): void 
		{
			_event_times.push(time);
			_event_handlers.push(handler);
		}
		
		/**
		 * Запланировать выполнение метода спустя указанное время после последнего события
		 * @param	offset	интервал ожидания после последнего события
		 * @param	handler	метод-обработчик события
		 */
		public function addLastEvent(offset: Number, handler: Function): void 
		{
			if (_event_times.length)
				addEvent(_event_times[_event_times.length - 1] + offset, handler)
			else
				addEvent(offset, handler);
		}
		
		public function clearEvents():void 
		{
			_event_handlers.splice(0, _event_handlers.length);
			_event_times.splice(0, _event_times.length);
		}
	}
}
