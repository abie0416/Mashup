package dart.mashup.mashup
{
	import flash.events.Event;
	
	import mashupView.MPathRecomendItem;

	public class MPCEvent extends Event
	{
		public static const SHOWMPC:String = "showMPC";
		public static const HIDEMPC:String = "hideMPC";
		public static const CLONEMPC:String = "cloneMPC";
		public var mpri:MPathRecomendItem;
		
		public function MPCEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}