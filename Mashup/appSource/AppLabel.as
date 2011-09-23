package appSource
{
	import flash.events.MouseEvent;
	
	import mx.binding.utils.BindingUtils;
	import mx.containers.VBox;
	import mx.controls.Label;
	import mx.controls.TextInput;

	public class AppLabel extends Label
	{
		public var propertyArray:Array = new Array();
		
		public function AppLabel(displayName:String)
		{
			//TODO: implement function
			super();
			this.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			this.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			propertyArray[0] = "label";
			var textInput:TextInput = new TextInput(); 
			propertyArray[1] = textInput;
			BindingUtils.bindProperty(this, "text", textInput, "text");
			
			
			var displayer:Displayer = new Displayer(displayName);					
//			Alert.show("labelname: "+xx);
			AppViewManager.treeData.addItem(displayer);		
			BindingUtils.bindProperty(displayer, "name",this, "text");		
		}
		
		protected function mouseDownHandler(event:MouseEvent):void
		{
			this.startDrag();
			var propertyContainer:VBox = this.parentApplication.mashupViews.getChildByName("appViewer").propertyContainer;
			propertyContainer.removeAllChildren();
			for(var i:int = 0; i<propertyArray.length/2; i++)
			{
				var propertyName:Label = new Label();
				propertyName.text = propertyArray[2*i];
				propertyContainer.addChild(propertyName);
				propertyContainer.addChild(propertyArray[2*i+1]);
			}
		}
		
		protected function mouseUpHandler(event:MouseEvent):void 
		{
			AppViewManager.mouseUpOperation(this);
		}
		
	}
}