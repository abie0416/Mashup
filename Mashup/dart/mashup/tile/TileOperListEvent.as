
package dart.mashup.tile
{

import flash.events.Event;

public class TileOperListEvent extends Event
{
    public static const ADD_OPER:String = "addOper";
    public static const REMOVE_OPER:String = "removeOper";
    public static const EDIT_OPER:String = "editOper";
    
    public var service:Service;
    
    //making the default bubbles behavior of the event to true since we want
    //it to bubble out of the ProductListItem and beyond
    public function TileOperListEvent(type:String, bubbles:Boolean=true, cancelable:Boolean=false)
    {
        super(type, bubbles, cancelable);
    }
    
}

}