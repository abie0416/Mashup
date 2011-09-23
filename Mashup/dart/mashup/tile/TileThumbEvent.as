
package dart.mashup.tile
{
    
import flash.events.Event;

public class TileThumbEvent extends Event
{
    public static const DETAILS:String = "details";
    public static const BROWSE:String = "browse";
    public static const EDIT:String = "edit";
    
    public var tile:Tile;
    
    public function TileThumbEvent(type:String, tile:Tile)
    {
        super(type);
        this.tile = tile;
    }
    
    override public function clone():Event
    {
        return new TileThumbEvent(type, tile);
    }
}

}