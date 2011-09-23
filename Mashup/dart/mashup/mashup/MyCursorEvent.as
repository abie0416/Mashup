package dart.mashup.mashup
{
	import flash.events.Event;

	public class MyCursorEvent extends Event
	{
		public static const BUSY:String = "busy";
		public static const NORMAL:String = "normal";
		
		public function MyCursorEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}