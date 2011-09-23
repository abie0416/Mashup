package dart.mashup.mashup
{
	import flash.events.Event;

	public class TpToolBarTypeEvent extends Event
	{
		public static const SHOW:String = "showMashupableAPI";
		public static const HIDE:String = "hideMashupableAPI";
		public static const INFO:String = "recommendation";
		public static const INSPIRE:String = "inspire";
		public static const CENTER:String = "center";
						
		public function TpToolBarTypeEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}