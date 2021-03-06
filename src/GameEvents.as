package 
{
	import starling.core.Starling;
	import starling.events.Event;
	
	/**
	 * ...
	 * @author rkardashov@gmail.com
	 */
	public class GameEvents 
	{
		static public const DAY_START: String = "day_start";
		static public const DAY_END: String = "day_end";
		
		static public const SCREEN_CHANGE: String = "screen_change";
		static public const SCREEN_ENTER: String = "screen_enter";
		
		static public const PAUSE: String = "game_pause";
		static public const RESUME: String = "game_resume";
		static public const TIME_OUT: String = "time_out";
		static public const TIMER_SECOND: String = "timer_second";
		
		//static public const INSPECTVIEW_CLOSE:String = "inspectview_close";
		static public const BARCODE_APPLY: String = "barcode_apply";
		
		static public const ITEM_PICK: String = "item_pick";
		//static public const ITEM_START_DRAG: String = "itemStartDrag";
		static public const ITEM_DROP: String = "item_drop";
		static public const GOOD_ENTER: String = "good_enter";
		static public const GOOD_DRAG: String = "good_drag";
		static public const GOOD_SCANNED: String = "good_scanned";
		static public const SCANNER_GOOD_NO_BARCODE: String = "scanner_good_no_barcode";
		static public const GOOD_CHECKOUT: String = "good_checkout";
		static public const GOOD_RECEIVED: String = "good_received";
		static public const GOOD_WRONG_BAG: String = "good_wrong_bag";
		static public const GOOD_ADD_TO_CONVEYOR: String = "good_add_to_conveyor";
		
		static public const BAG_NEW: String = "bag_new";
		static public const BAG_GOOD_ADDED: String = "bag_good_added";
		static public const BAG_FULL: String = "bag_full";
		static public const BAG_WRONG_GOOD: String = "bag_wrong_good";
		static public const BAG_REMOVE: String = "bag_remove";
		
		static public const GOODS_COMPLETE: String = "goods_complete";
		static public const PAYMENT_START:String = "payment_start";
		static public const PAYMENT_COMPLETE: String = "payment_complete";
		static public const ADD_SCORE: String = "add_score";
		
		static public const BANKNOTE_IN_TRAY:String = "banknoteInTray";
		
		static public const CUSTOMER_STOPPED: String = "customer_stopped";
		static public const CUSTOMER_ARRIVED: String = "customer_arrived";
		static public const CUSTOMER_COMPLETE: String = "customer_complete";
		static public const NEXT_CUSTOMER: String = "next_customer";
		static public const CUSTOMER_MOOD_LEVEL: String = "customer_mood_level";
		static public const CUSTOMER_WELCOME: String = "customer_welcome";
		static public const CUSTOMER_GOODBYE: String = "customer_goodbye";
		
		static public const CONVEYOR_START: String = "conveyor_start";
		static public const CONVEYOR_STOP: String = "conveyor_stop";
		static public const CONVEYOR_GOODS_REQUEST: String = "conveyor_goods_request";
		
		static public const INTRO_START: String = "intro_start";
		static public const INTRO_END: String = "intro_end";
		static public const SCALES_VIEW_SHOW: String = "scales_view_show";
		static public const SCALES_BARCODE_PRINT: String = "scales_barcode_print";
		static public const INSPECT_VIEW_SHOW: String = "inspect_view_show";
		static public const NUMPAD_ENTER_DIGIT: String = "numpad_enter_digit";
		
		static public function subscribe(eventType: String, handler: Function): void 
		{
			Starling.current.stage.addEventListener(eventType, handler);
		}
		
		static public function unsubscribe(eventType: String, handler: Function): void 
		{
			Starling.current.stage.removeEventListener(eventType, handler);
		}
		
		static public function dispatch(eventType: String, data: Object = null): void
		{
			Starling.current.stage.dispatchEventWith(eventType, false, data);
		}
		static public function dispatchEvent(event: Event): void
		{
			Starling.current.stage.dispatchEvent(event);
		}
	}
}
