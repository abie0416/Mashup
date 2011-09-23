
package dart.mashup.tile
{
	import mx.collections.ArrayCollection;
	import mx.collections.IViewCursor;

[Bindable]
public class Tile
{
	
    public var tileId:int;
    public var name:String;
    public var providerUrl:String;
    public var tags:String;
    public var text:String;
    public var category:String;
	public var services:ArrayCollection;
	public var image:String;

    public function Tile(tileId:int = 0, name:String = "", tags:String = "", text:String = "", category:String = "", image:String ="")
    {
		services = new ArrayCollection();
		this.tileId = tileId;
		this.name = name;
		this.tags = tags;
		this.text = text;
		this.category = category;
		this.image = "assets/classIcon/class.png";
    }
    public function fillServices(attributes:ArrayCollection):void
    {
    	this.services = services;
    }
	public function addService(s:Service):void
	{
		this.services.addItem(s);
	}
    public function fill(obj:Object):void
    {
    	this.tileId = obj.tileId;
    	this.name = obj.name;
    	this.providerUrl = obj.providerUrl;
    	this.tags = obj.description.tags;
    	this.text = obj.description.text;
    	this.category = obj.category;
    	var tempObj:Object = obj.services.service;
    	var tempStr:String = tempObj.toString();
    	var temp:ArrayCollection = new ArrayCollection();
    	if(tempStr.search(",") != -1)
    		temp = obj.services.service;
    	else
    		temp.addItem(tempObj);	
        var cursor:IViewCursor = temp.createCursor();
        while (!cursor.afterLast) 
        {
    	    var service:Service = new Service();
	        service.fill(cursor.current);
        	services.addItem(service);
        	cursor.moveNext();
        }
    }
    
    public function findService(sName:String):Service
    {
    	for(var i:int = 0; i < services.length; i++){
    		var s:Service = services.getItemAt(i) as Service;
    		if(s.name == sName)
    			return s;
    	}
    	
    	return null;
    }
 /*   public function get attributeNameStr():String
    {
    	var str:String = "";
    	for(var i:int = 0; i < attributes.length; i++){
    		str += attributes[i].name + "\n";
    	}
    	
    	return str;
    }
*/

}

}