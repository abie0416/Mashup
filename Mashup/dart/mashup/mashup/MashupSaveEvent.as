package dart.mashup.mashup
{
	import flash.events.Event;

	public class MashupSaveEvent extends Event
	{
		public static const SAVE:String = "save";
		public function MashupSaveEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}