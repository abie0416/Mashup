package dart.mashup.mashup
{
	import flash.events.Event;

	public class MPathRecommendEvent extends Event
	{
		public static const CHANGEOPTION:String = "changeOption";
		
		public var wantType:String;
		public function MPathRecommendEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}