package  
{
	/**
	 * ...
	 * @author rkardashov@gmail.com
	 */
	public final class StrUtil 
	{
		public function StrUtil() {}
		
		static public function randomPart(str: String, delim: String): String
		{
			var parts: Array = str.split(delim);
			if (parts.length > 0)
				return parts[int(Math.random() * parts.length)];
			return "";
		}
		
		static public function randomChar(str: String): String
		{
			if (str && str.length)
				return str.charAt(int(Math.random() * str.length));
			return "";
		}
	}
}
