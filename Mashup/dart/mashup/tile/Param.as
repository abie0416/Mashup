// ActionScript file

package dart.mashup.tile
{
	import mx.messaging.channels.StreamingAMFChannel;
	import dart.mashup.utility.Tool;
	
[Bindable]
public class Param
{
	public var className:String;
	public var classAttr:String;
	public var paraName:String;
	public var paraValue:String = "defaultValue";
	public var description:String;
	public var required:Boolean = true;
	public var hasSetValue:Boolean = false;
	
	public function Param(className:String = null, classAttr:String = null, paraName:String = null, description:String = null)
	{
		this.className = className;
		this.classAttr = classAttr;
		this.paraName = paraName;
		this.description = description;
	}
	public function fill(obj:Object):void
	{
		var temp:String = obj.className;
		var length:int = temp.length;
		var index:int = -1;
		
		for(var i:int = 0; i < length; i++){ 
			if(temp.charAt(i) == '.'){
				index = i;
				break;
			}
		}
		this.className = temp.substr(0, index);
		this.classAttr = temp.substr(index + 1, length);
		this.paraName = obj.name;
		this.paraValue = obj.defaultValue;
		this.description = obj.description;
		this.required = obj.required;
		
		//this.paraName = obj.toString();
	}
	
	public function setValue(value:String):void
	{
		this.paraValue = value;	
	}
	
	public function getValue():String
	{
		return this.paraValue;
	}
	
	
	public function toString():String
	{
		return this.paraName;
	}
	
	public function toXmlString(symbol:String):String
	{
		var xmlStr:String = "";
		xmlStr = xmlStr + "<param className=\"" + this.className + "."+ this.classAttr + "\" name=\"" + Tool.escapeQuote(this.paraName) + "\" ";
		if(symbol == "input"){
			var flag:String = "true";
			if(!this.required)
				flag = "false"
			xmlStr = xmlStr + "required=\"" + flag + "\">";
			xmlStr = xmlStr + "<description>" + Tool.escapeQuote(this.description) + "</description>";
			xmlStr = xmlStr + "<defaultValue>" + Tool.escapeQuote(this.paraValue) + "</defaultValue>";
			xmlStr = xmlStr + "</param>"
		}
		else{
			xmlStr = xmlStr + "/>";
		}
		
		return xmlStr;
	}
}

}