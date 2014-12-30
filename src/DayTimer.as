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
	/**
	 * ...
	 * @author rkardashov@gmail.com
	 */
	public class DayTimer extends Sprite
	{
		private const DEFAULT_DURATION: int = 60;
		private var _timer: Timer;
		private var _text: TextField;
		private var _event_times: Vector.<Number> = new Vector.<Number>();
		private var _event_handlers: Vector.<Function> = new Vector.<Function>();
		private var dayDuration: int;
		
		public function DayTimer() 
		{
			super();
			x = 20;
			y = 10;
			//addChild(_text = new TextField(50, 20, "", "arcade_10", 10));// verdana"));// 10));
			addChild(_text = new TextField(50, 20, "", "systematic_9", 9));// verdana"));// 10));
			_text.autoScale = false;
			_text.autoSize = TextFieldAutoSize.HORIZONTAL;// LEFT;
			_text.hAlign =  "right";
			_text.text = "";
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
			if (c.disableTimer)
				pause()
			else
				resume();
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
			_text.text = duration.toString();
			clearEvents();
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
			//_text.text = (_timer.repeatCount - _timer.currentCount).toString();
			if (timeIsOut)
				_text.text = "0"
			else
				_text.text = (dayDuration - _timer.currentCount).toString();
				
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
