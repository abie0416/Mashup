package org.un.cava.birdeye.ravis.graphLayout.visual.events
{
	import flash.events.Event;
	
	import org.un.cava.birdeye.ravis.graphLayout.data.IEdge;

	public class VisualEdgeEvent extends Event
	{
		public static const EDGE_CLICK:String = "edgeClick";
        public static const EDGE_DOUBLE_CLICK:String = "edgeDoubleClick";
		public static const EDGE_DRAG_START:String = "edgeDragStart";
		public static const EDGE_DRAG_END:String = "edgeDragEnd";
		
		
		
		public var edge:IEdge;
        public var ctrlKey:Boolean;
		
		public function VisualEdgeEvent(type:String, edge:IEdge, ctrlKey:Boolean, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.edge = edge;
            this.ctrlKey = ctrlKey;
		}
		
		public override function clone():Event
		{
			return new VisualEdgeEvent(type,edge,ctrlKey, bubbles,cancelable);
		}
		
	}
}