
package dart.mashup.tile
{

import flash.events.Event;

import tileView.OperInput;
import tileView.OperOutput;

public class ParamListEvent extends Event
{
    public static const REMOVE_INPUT_PARAM:String = "removeInputParam";
    public static const REMOVE_OUTPUT_PARAM:String = "removeOutputParam";
    
    public var p:OperInput; 
    public var op:OperOutput;
    //making the default bubbles behavior of the event to true since we want
    //it to bubble out of the ProductListItem and beyond
    public function ParamListEvent(type:String, bubbles:Boolean=true, cancelable:Boolean=false)
    {
        super(type, bubbles, cancelable);
    }
    
}

}