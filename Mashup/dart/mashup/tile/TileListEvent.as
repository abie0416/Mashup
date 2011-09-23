
package dart.mashup.tile
{

import flash.events.Event;

public class TileListEvent extends Event
{
    public static const ADD_TILE:String = "addTile";
    public static const REMOVE_TILE:String = "removeTile";
    
    public var tile:Tile;
    //making the default bubbles behavior of the event to true since we want
    //it to bubble out of the ProductListItem and beyond
    public function TileListEvent(type:String, bubbles:Boolean=true, cancelable:Boolean=false)
    {
        super(type, bubbles, cancelable);
    }
    
}

}