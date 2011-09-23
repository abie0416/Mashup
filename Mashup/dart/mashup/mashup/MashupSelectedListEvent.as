package dart.mashup.mashup
{
	import dart.mashup.tile.Service;
	
	import flash.events.Event;

	public class MashupSelectedListEvent extends Event
	{
    	public static const ADD_MASHUPPATHITEM:String = "addMashupPathItem";
    	public static const REMOVE_MASHUPPATHITEM:String = "removeMashupPathItem";
    	
    	public var tp1:TilePacket;
    	public var tp2:TilePacket;
    	public var s1:Service;
    	public var s2:Service;
    			
		public function MashupSelectedListEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}