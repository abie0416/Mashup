
package dart.mashup.mashup
{

import flash.events.Event;

public class ModeListEvent extends Event
{
    public static const CHANGE_MODE:String = "modeChange";
    public var mode:String;
    
    
    //making the default bubbles behavior of the event to true since we want
    //it to bubble out of the ProductListItem and beyond
    public function ModeListEvent(type:String, bubbles:Boolean=true, cancelable:Boolean=false)
    {
        super(type, bubbles, cancelable);
    }
    
}

}