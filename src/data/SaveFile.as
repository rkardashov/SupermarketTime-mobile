package data
{
	import flash.events.Event;
	import flash.events.OutputProgressEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.filesystem.File;
	import flash.events.ErrorEvent;
	import flash.events.IOErrorEvent;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.setTimeout;
	/**
	 * ...
	 * @author ...
	 */
	public class SaveFile 
	{
		private var _filename: String;
		private var _fileStream: FileStream;
		private var _onSaveLoaded: Function;
		private var _days: Vector.<DaySave>;
		
				// flash.events.Event.COMPLETE
			//	- asynchronous operation is complete
			// flash.events.Event.CANCEL
			//	- pending asynchronous operation is canceled
			// flash.events.IOErrorEvent.IO_ERROR
			//	- asynchronous file operation error
			// flash.events.SecurityErrorEvent.SECURITY_ERROR
			//	- operation violates a security constraint
			//
			// flash.events.FileListEvent
			//	- getDirectoryListingAsync()
			
		public function SaveFile(filename: String) 
		{
			_filename = filename;
			_fileStream = new FileStream();
			_fileStream.addEventListener(Event.OPEN, onStreamOpen);
			_fileStream.addEventListener(ProgressEvent.PROGRESS, onStreamProgess);
			_fileStream.addEventListener(OutputProgressEvent.OUTPUT_PROGRESS, onStreamOutputProgess);
			_fileStream.addEventListener(Event.CLOSE, onStreamClose);
			_fileStream.addEventListener(IOErrorEvent.IO_ERROR, onStreamError);
			_fileStream.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onStreamSecurityError);
		}
		
		public function save(days: Vector.<DaySave>): void 
		{
			// TEMP: saving disabled
			var file: File = 
				File.applicationStorageDirectory.resolvePath(_filename + ".txt"); 
			
			_fileStream.openAsync(file, FileMode.WRITE);
			//_fileStream.writeUTF(dayNumber.toString() + " " + money.toFixed(2));
			for (var i:int = 0; i < days.length; i++) 
				_fileStream.writeUTF(days[i].score.toString() + "," + days[i].stars.toString()/* + ";"*/);
		}
		
		public function load(onSaveLoaded: Function): void 
		{
			//dayNumber = 0;
			//customers = 0;
			//money = 0;
			
			_onSaveLoaded = onSaveLoaded;
			_days = new Vector.<DaySave>;
			
			var file: File = 
				File.applicationStorageDirectory.resolvePath(_filename + ".txt");
			if (file.exists)
				_fileStream.openAsync(file, FileMode.READ)
			else
			{
				_days.push(new DaySave());
				setTimeout(onSaveLoaded, 50, _days);
			}
		}
		
		private function onStreamOpen(e: Event): void 
		{
			trace("file stream opened");
		}
		
		private function onStreamProgess(e:ProgressEvent):void 
		{
			if (e.bytesLoaded < e.bytesTotal)
				return;
			// read consecutive days data
			/*var fdata: String = _fileStream.readUTF();
			dayNumber = fdata.split(" ")[0];
			money = fdata.split(" ")[1];*/
			var day: DaySave;
			//var days: Vector.<DaySave> = new Vector.<DaySave>;
			//var daysArray: Array = fdata.split(";");
			//for (var i:int = 0; i < daysArray.length; i++) 
			//{
			var fdata: String;// = _fileStream.readUTF();
			while (_fileStream.position < e.bytesTotal)
			{
				fdata = _fileStream.readUTF();
				if (_days.length >= DayData.count)
					continue;
				day = new DaySave();
				day.index = _days.length;
				day.score = fdata.split(",")[0];
				day.stars = fdata.split(",")[1];
				_days.push(day);
				//fdata = _fileStream.readUTF();
			}
			if (_onSaveLoaded != null)
				_onSaveLoaded(_days);
			_onSaveLoaded = null;
		}
		
		private function onStreamOutputProgess(e:OutputProgressEvent):void 
		{
			if (e.bytesPending == 0)
				_fileStream.close();
		}
		
		private function onStreamClose(e: Event): void 
		{
			//trace("file closed");
		}
		
		private function onStreamError(e: IOErrorEvent): void 
		{
			trace("file stream IO error: " + e.text);
		}
		
		private function onStreamSecurityError(e: SecurityErrorEvent):void 
		{
			trace("file stream security error: " + e.text);
		}
	}
}
