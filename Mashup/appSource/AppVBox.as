package appSource
{
	import mx.containers.VBox;
	import flash.events.MouseEvent;

	public class AppVBox extends VBox
	{
		public function AppVBox()
		{
			//TODO: implement function
			super();
			this.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			this.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			this.setStyle("borderStyle", "solid");
			this.setStyle("borderColor", "green");
			this.setStyle("borderThickness", "2");
			this.width = 100;
			this.height = 100;
		}
		
		protected function mouseDownHandler(event:MouseEvent):void
		{
			this.startDrag();
		}
		
		protected function mouseUpHandler(event:MouseEvent):void 
		{
			this.stopDrag();
			var previewContainer:Canvas = this.parentApplication.mashupViews.getChildByName("appViewer").previewContainer.previewCanvas;
			if(previewContainer.hitTestObject(this))
			{
				if(!previewContainer.contains(this))
				{
					previewContainer.addChild(this);
				}
				//this.parentApplication.addChild(this); //?
			}
			//trace("test");
		}
		
	}
}