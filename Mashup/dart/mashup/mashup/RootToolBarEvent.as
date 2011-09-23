package dart.mashup.mashup
{
	import flash.events.Event;

	public class RootToolBarEvent extends Event
	{
		public static const UP:String = "up";
		public static const DOWN:String = "down";
		public static const LEFT:String = "left";
		public static const RIGHT:String = "right";
		public static const ZOOMIN:String = "zoomIn";
		public static const ZOOMOUT:String = "zoomOut";
		public static const FULLSCREEN:String = "fullScreen";
				
		public function RootToolBarEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}