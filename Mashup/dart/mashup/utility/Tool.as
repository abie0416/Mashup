package dart.mashup.utility
{
	public class Tool
	{
		public function Tool()
		{
		}
		
		public static function assert(s:String):Boolean
		{
			return s.length == 0 ;
			
		}
		public static function escapeQuote(str:String):String
		{
			var s:String = " ";
			
			if(str == null)
				return null;
			str = str.replace(/'/g, s);
			str = str.replace(/\r/g, s);
			str = str.replace(/\n/g, s);
		//	return str;
			return str.replace(/"/g, s);
		}		

	}
}