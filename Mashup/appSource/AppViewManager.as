package appSource
{
	import mx.collections.ArrayCollection;
	import mx.containers.Canvas;
	import mx.containers.HBox;
	import mx.controls.Alert;
	import mx.controls.Label;
	import mx.core.UIComponent;
	
	/**
	 * function1: judge whether the control has been dragged into the preview panel.
	 * function2: store all service output parameters.
	 * function3: store all controls added to the preview panel.
	 * function4: getResult()-write result into a string.
	 * TODO: deleting controls is not working well.
	 * ...
	 * */
	public class AppViewManager
	{
		// store the output parameters of all selected services.
		public static var serviceOutputs:ArrayCollection = new ArrayCollection(); 
		public static var treeData:ArrayCollection = new ArrayCollection();
		public static var controlsAdded:ArrayCollection = new ArrayCollection(); //all controls added to the preview panel.
				
		public function AppViewManager()
		{
		}
		
		/**
		 * write result into a string. Actually the result is the configuration file in javascript format.
		 * */
		public static function getResult():String
		{
			var resultString:String = "";
			resultString += 'var resultConfigItems = [';
			for(var i:int=0; i<controlsAdded.length; i++)
			{
				var control:UIComponent = controlsAdded.getItemAt(i) as UIComponent;
				var previewContainer:Canvas = control.parentApplication["appViewer"].previewContainer.previewCanvas;
				var parentWidth:Number = previewContainer.width;
				var parentHeight:Number = previewContainer.height;
				var type:String = null;
				var name:String = control.name;
				var left:Number = control.x/parentWidth;
				var top:Number = control.y/parentHeight;
				var width:Number = control.width/parentWidth;
				var height:Number = control.height/parentHeight;
				var target:String = null;
				if((control as AppTextArea) != null) // control is a TextArea control.
				{
					var controlTextArea:AppTextArea = control as AppTextArea;
					type = 'TEXTAREA';
					target = controlTextArea.serviceOutputBinding;
				}
				else if((control as AppImage) != null) // control is a TextArea control.
				{
					var controlImage:AppImage = control as AppImage;
					type = 'IMAGE';
					target = controlImage.serviceOutputBinding;
				}
				resultString += '{';
				resultString += 'target: "invoke'+target.substring(0, target.indexOf("("))+'",';
				resultString += 'left: "'+left+'",';
				resultString += 'top: "'+top+'",';
				resultString += 'width: "'+width+'",';
				resultString += 'height: "'+height+'",';
				resultString += 'type: "'+type+'",';
				resultString += 'name: "'+name+'",';
				resultString += '},';
			}
			resultString += '];';
			
			return resultString;
		}
		
		public static function mouseDownOperation(control:UIComponent,propertyArray:Array):void
		{
			Alert.show("propertyArray.length:"+propertyArray.length);
			control.startDrag();
			var propertyContainer:HBox = control.parentApplication["appViewer"].propertyContainer;
			propertyContainer.removeAllChildren();
			
			for(var i:int = 0; i<propertyArray.length/2; i++)
			{
				Alert.show("propertyArray.xxx:");
				Alert.show("propertyArray.length2:"+propertyArray.length);
				var propertyName:Label = new Label();
				propertyName.text = propertyArray[2*i];
				Alert.show("propertyName.text:"+propertyName.text);
				propertyContainer.addChild(propertyName);
				propertyContainer.addChild(propertyArray[2*i+1]);
			}
		} 
		
		public static function mouseUpOperation(control:UIComponent):void
		{
			control.stopDrag();
			var previewContainer:Canvas = control.parentApplication["appViewer"].previewContainer.previewCanvas;
			if(previewContainer.hitTestObject(control))
			{
				if(!previewContainer.contains(control))
				{
					previewContainer.addChild(control);
					var parentCanvas:Canvas = control.parent as Canvas;
					control.x = parentCanvas.contentMouseX-10;
					control.y = parentCanvas.contentMouseY-10;					
					controlsAdded.addItem(control);
				}
			}
			else
			{
				// TODO: something wrong here.
				if(previewContainer.contains(control)) {
					previewContainer.removeChild(control);
					var index:int = controlsAdded.getItemIndex(control);
					controlsAdded.removeItemAt(index);
				}
				control.parentApplication.removeChild(control);
			}
		}

	}
}