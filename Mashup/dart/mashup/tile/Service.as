// ActionScript file

package dart.mashup.tile
{
	import dart.mashup.utility.Tool;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IViewCursor;
[Bindable]
public class Service
{
	public var name:String;
	public var desc:String;
	public var invokeUrl:String;
	public var inParam:ArrayCollection;
	public var outParam:ArrayCollection;
	

	public function Service(name:String = null, desc:String = null, invokeUrl:String = null)
	{
		this.name = name;
		this.desc = desc;
		this.invokeUrl = invokeUrl;
		inParam = new ArrayCollection();
		outParam = new ArrayCollection();
	}
	
	public function setInputParam(ip:ArrayCollection):void
	{
		this.inParam = ip;
	}
	public function setOutputParam(op:ArrayCollection):void
	{
		this.outParam = op;
	}
	public function addInputParam(p:Param):void
	{
		this.inParam.addItem(p);	
	}
	public function addOutputParam(p:Param):void
	{
		this.outParam.addItem(p);
	}
	public function fill(obj:Object):void
	{
		this.name = obj.name;
		this.desc = obj.description;
		var tempObj:Object;
		var tempStr:String;
		var temp:ArrayCollection = new ArrayCollection();
		var cursor:IViewCursor;
		
		if(obj.input != null){
	    	tempObj = obj.input.param;
	    	tempStr = tempObj.toString();
	    	if(tempStr.search(",") != -1)
	    		temp = obj.input.param;
	    	else
	    		temp.addItem(tempObj);	    	
	        cursor = temp.createCursor();	 
	        while (!cursor.afterLast)
	        {
	        	var param:Param = new Param();
	            param.fill(cursor.current);
	            inParam.addItem(param);
	            cursor.moveNext();
	        }
  		}
  		if(obj.output != null){
	        tempObj = obj.output.param;
	        tempStr = tempObj.toString();
	    	if(tempStr.search(",") != -1)
	    		temp = obj.output.param;
	    	else
	    		temp.addItem(tempObj);
	        cursor = temp.createCursor();	
	        while (!cursor.afterLast)
	        { 
	        	var param2:Param = new Param();
	            param2.fill(cursor.current);
	            outParam.addItem(param2);
	            cursor.moveNext();
	        }
    	}
	}
	
	public function toString():String
	{
		return this.name;
	}
	
	public function toXmlString():String
	{
		var xmlStr:String = "";
		
		xmlStr = xmlStr + "<service name=\"" + Tool.escapeQuote(this.name) + "\">";
		xmlStr = xmlStr + "<description>" + Tool.escapeQuote(this.desc) + "</description>";
		xmlStr = xmlStr + "<invokeUrl>" + Tool.escapeQuote(this.invokeUrl) + "</invokeUrl>";
		xmlStr = xmlStr + "<input>";
		var i:int;
		for(i = 0; i < inParam.length; i++){
			var p:Param = inParam.getItemAt(i) as Param;
			xmlStr = xmlStr + p.toXmlString("input");
		}
		xmlStr = xmlStr + "</input>";
		xmlStr = xmlStr + "<output>";
		for(i = 0; i < outParam.length; i++){
			var p2:Param = outParam.getItemAt(i) as Param;
			xmlStr = xmlStr + p2.toXmlString("output");
		}
		xmlStr = xmlStr + "</output>";
		xmlStr = xmlStr + "</service>";
		
		return xmlStr;
		
	}
}

}