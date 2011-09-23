package dart.mashup.mashup
{
	import flash.events.Event;

	public class TileInputEvent extends Event
	{
		public static const ENTERCOMPLETE:String = "enterComplete";
		public static const CLEARVIEW:String = "clearView";
		public var tileName:String;
		
		public function TileInputEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}