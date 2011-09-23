/* 
* The MIT License
*
* Copyright (c) 2007 The SixDegrees Project Team
* (Jason Bellone, Juan Rodriguez, Segolene de Basquiat, Daniel Lang).
* 
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
* 
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
* 
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/
package org.un.cava.birdeye.ravis.graphLayout.visual {
    
    import appSource.AppViewManager;
    
    import flash.display.DisplayObject;
    import flash.display.Graphics;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.net.*;
    import flash.utils.Dictionary;
    
    import mashupBuild.Condition;
    import mashupBuild.DataMashup;
    import mashupBuild.ParaSet;
    import mashupBuild.Ravis;
    import mashupBuild.assignMent;
    import mashupBuild.flowDesicion;
    import mashupBuild.globalVar;
    import mashupBuild.toolBar;
    import mashupBuild.variableForUserInput;
    
    import mx.binding.utils.BindingUtils;
    import mx.collections.ArrayCollection;
    import mx.containers.Canvas;
    import mx.containers.HBox;
    import mx.containers.VBox;
    import mx.controls.Alert;
    import mx.controls.Button;
    import mx.controls.ComboBox;
    import mx.controls.Label;
    import mx.controls.TextInput;
    import mx.core.IDataRenderer;
    import mx.core.IFactory;
    import mx.core.UIComponent;
    import mx.effects.Effect;
    import mx.events.EffectEvent;
    import mx.events.ListEvent;
    import mx.managers.CursorManager;
    import mx.managers.PopUpManager;
    import mx.rpc.events.ResultEvent;
    import mx.rpc.http.HTTPService;
    import mx.utils.ObjectUtil;
    
    import org.un.cava.birdeye.ravis.Compile.Loop;
    import org.un.cava.birdeye.ravis.Compile.inToPost;
    import org.un.cava.birdeye.ravis.distortions.IDistortion;
    import org.un.cava.birdeye.ravis.graphLayout.data.*;
    import org.un.cava.birdeye.ravis.graphLayout.layout.ILayoutAlgorithm;
    import org.un.cava.birdeye.ravis.graphLayout.visual.edgeRenderers.BaseEdgeRenderer;
    import org.un.cava.birdeye.ravis.graphLayout.visual.events.VisualEdgeEvent;
    import org.un.cava.birdeye.ravis.graphLayout.visual.events.VisualGraphEvent;
    import org.un.cava.birdeye.ravis.graphLayout.visual.events.VisualNodeEvent;
    import org.un.cava.birdeye.ravis.utils.LogUtil;
    import org.un.cava.birdeye.ravis.utils.events.VGraphEvent;
    
    
    
    /**
     *  Dispatched when there is any change to the nodes and/or links of this graph.
     *
     *  @eventType org.un.cava.birdeye.ravis.utils.events.VGraphEvent
     */
    [Event(name=VGraphEvent.VGRAPH_CHANGED, type="org.un.cava.birdeye.ravis.utils.events.VGraphEvent")]
    
    /**
     *  Dispatched when a drag event starts
     *
     *  @eventType org.un.cava.birdeye.ravis.graphLayout.visual.events.VisualNodeEvent
     */
    [Event(name="nodeDragStart", type="org.un.cava.birdeye.ravis.graphLayout.visual.events.VisualNodeEvent")]
    
    /**
     *  Dispatched when a drag event ends
     *
     *  @eventType org.un.cava.birdeye.ravis.graphLayout.visual.events.VisualNodeEvent
     */
    [Event(name="nodeDragEnd", type="org.un.cava.birdeye.ravis.graphLayout.visual.events.VisualNodeEvent")]
    
    /**
     *  Dispatched when a node is clicked it is totally independant of drags, this means you 
     *  do not have to use double clicks to handle expanding or resetting the root
     *
     *  @eventType org.un.cava.birdeye.ravis.graphLayout.visual.events.VisualNodeEvent
     */
    [Event(name="nodeClick", type="org.un.cava.birdeye.ravis.graphLayout.visual.events.VisualNodeEvent")]
    
    /**
     *  Dispatched when a node is double clicked it is totally independant of drags.
     *
     *  @eventType org.un.cava.birdeye.ravis.graphLayout.visual.events.VisualNodeEvent
     */
    [Event(name="nodeDoubleClick", type="org.un.cava.birdeye.ravis.graphLayout.visual.events.VisualNodeEvent")]
    
    /**
     *  Dispatched when the background is done dragging.
     *
     *  @eventType org.un.cava.birdeye.ravis.graphLayout.visual.events.VisualGraphEvent
     */
    [Event(name="backgroundDragEnd", type="org.un.cava.birdeye.ravis.graphLayout.visual.events.VisualGraphEvent")]
    
    /**
     *  Dispatched when the background is done dragging.
     *
     *  @eventType org.un.cava.birdeye.ravis.graphLayout.visual.events.VisualGraphEvent
     */
    [Event(name="graphScaled", type="org.un.cava.birdeye.ravis.graphLayout.visual.events.VisualGraphEvent")]
    
    /**
     *  Dispatched when the background has been clicked but no nodes selected, and no drag occured
     *
     *  @eventType org.un.cava.birdeye.ravis.graphLayout.visual.events.VisualGraphEvent
     */
    [Event(name="backgroundClick", type="org.un.cava.birdeye.ravis.graphLayout.visual.events.VisualGraphEvent")]
    
    [Event(name="edgeDoubleClick", type="org.un.cava.birdeye.ravis.graphLayout.visual.events.VisualEdgeEvent")]
    
    /**
     * This component can visualize and layout a graph data structure in 
     * a Flex application. It is derived from canvas and thus behaves much
     * like that in general.
     * 
     * Currently the graphs are required to be connected. And for most layouts
     * a root node is required (as they are tree based).
     * 
     * A graph object needs to be specified as well as a layouter object
     * that implements the ILayoutAlgorithm interface.
     * 
     * XXX provide example code here
     * */
	public class VisualGraph extends Canvas implements IVisualGraph {
        
        private static const _LOG:String = "graphLayout.visual.VisualGraph";		
        
        [Embed('/org/un/cava/birdeye/ravis/assets/cursors/openhand.png')]
        private static const HAND_CURSOR:Class;
        private  var url:String = "http://localhost:8080/mobileMashup/matchedServices?serviceName=";
        private static const RESULTMASHUPURL:String = "http://localhost:8080/mobileMashup/mashup";
        

        
        /**
         * Distortion to be applied on mouse over 
         **/
        public var distortion:IDistortion;
        
        public  var varWarehouse:Dictionary = new Dictionary() ;
        public  static var mode:Boolean = false;
        

        private var _nodeMouseDownLocation:Point;
        private var _mouseDownLocation:Point
        
        private var _allNode:ArrayCollection;
        /**
         * Used to determine if a node has been moved or if it was just a click
         */ 
        private var _nodeMovedInDrag:Boolean = false;
        /**
         * This flag for draw() specifies that the linklength
         * shall be reset to 100 when calling draw();
         * */
        public static const DF_RESET_LL:uint = 1;
        
        /**
         * We keep a reference to ourselves (this) in this attribute.
         * Not really necessary, but it makes the code more clear if
         * a method is called, that really belongs to the super class.
         * */
        protected var _canvas:Canvas;
        
        /**
         * This property holds the Graph object with the graph
         * data, that is supposed to be visualised. This is also
         * the only data structure that keeps track of nodes and
         * edges.
         * */
        protected var _graph:IGraph = null;
        
        /**
         * This property holds the layouter object. The layouter does the 
         * calculation of the layout and the placement of the nodes.
         * It may be exchanged on the fly.
         * */
        protected var _layouter:ILayoutAlgorithm;
        
        /**
         * This is a drawing surface to draw the edges on. It is only
         * used for the edges and is added as a child to the canvas.
         * */
        protected var _drawingSurface:UIComponent; 
        
        /**
         * for cleanup we also need a reference source for
         * vnodes and vedges
         * */
        protected var _vnodes:Dictionary;
        protected var _vedges:Dictionary;
        
        /**
         * Every visual node is associated with an UIComponent that 
         * will be the actual visual representation of the node in the
         * Flashplayer. This UIComponent (which is typically an ItemRenderer)
         * is called a "view". Node's views are now mainly created on
         * demand and destroyed if the node is currently not visible
         * to save resources. This map keeps track of which VNode belongs
         * to which view. This is required as in certain events, we get
         * only access to the UIComponent and we need to get hold of
         * the corresponding node.
         * */
        protected var _viewToVNodeMap:Dictionary;
        
        /**
         * A similar map needs to exist for edges
         * */
        protected var _viewToVEdgeMap:Dictionary;
        
        /**
         * The standard origin is the upper left corner, but if
         * the graph is scrolled, this origin may change, so we keep
         * track of that here.
         * */
        protected var _origin:Point;
        
        /**
         * The current zooming scale of the vgraph.
         * This is used to facilitate the use of scaleX/scaleY
         * and take it into account for drag and drop.
         * Supported by getter/setting methods.
         * (Contributed by Ivan Bulanov)
         * */
        protected var _scale:Number = 1;
        
        
        /* drag and drop support */
        
        /**
         * This is the current UIComponent that is dragged by the mouse.
         * */
        protected var _dragComponent:UIComponent;
        
        /**
         * These two maps keep the drag cursor offset positions
         * for each dragged component. This allows to (theoretically)
         * drag more than one component at once and to correctly reposition the
         * component during the drag and at the drop.
         * */
        protected var _drag_x_offsetMap:Dictionary;
        protected var _drag_y_offsetMap:Dictionary;
        
        /**
         * There is generally support to restrict dragging and dropping
         * to a certain area. These bounds are kept for each dragged
         * component in this map.
         * */
        protected var _drag_boundsMap:Dictionary;
        
        /**
         * The drag cursors starting position is required
         * if we do a "background drag", i.e. scroll the whole
         * VisualGraph around. All this does is basically moving all
         * components with the mouse, thus creating the effect of a 
         * background drag.
         * */
        protected var _dragCursorStartX:Number;
        protected var _dragCursorStartY:Number;
        
        /**
         * To distinguish an active mouse move drag that drags
         * a component from one that should drag the background, 
         * we need this property.
         * */
        protected var _backgroundDragInProgress:Boolean = false;
        
        /**
         * To enable/disable scrolling while background is being
         * dragged 
         * */
        protected var _scrollBackgroundInDrag:Boolean = true;
        
        /**
         * To enable/disable movement while node is being
         * dragged 
         * */
        protected var _moveNodeInDrag:Boolean = true;
        
        /**
         * To enable/disable movement while edge is being
         * dragged 
         * */
        protected var _moveEdgeInDrag:Boolean = true;
        
        /**
         * To enable/disable movement while background is being
         * dragged 
         * */
        protected var _moveGraphInDrag:Boolean = true;
        
        /* Rendering */
        
        /**
         * We allow the specification of an EdgeRenderer object
         * that draws the Edges using the graphics part of the
         * drawing surface.
         * */
        protected var _edgeRenderer:IEdgeRenderer = null;
        
        /**
         * We allow the specification of an ItemRenderer (i.e. an IFactory)
         * that allows us to specify the view's for each node in MXML
         * */
        protected var _itemRendererFactory:IFactory = null;
        
        /**
         * Also allow the specification of an IFactory for edge
         * labels.
         * */
        protected var _edgeLabelRendererFactory:IFactory = null;
        
        /**
         * Flag to force a redraw of all edge even if the layout
         * has not changed
         * */
        protected var _forceUpdateEdges:Boolean = false;
        
        /**
         * Flag to force a redraw of all nodes even if the layout
         * has not changed
         * */
        protected var _forceUpdateNodes:Boolean = false;
        /**
         * Specify whether edge labels should be displayed or not
         * */
        protected var _displayEdgeLabels:Boolean = true;
        
        
        private var _twoNode:ArrayCollection ;
        /**
         * We keep the default parameters
         * to draw edges (line width, color, alpha channel)
         * in this object. The params to be expected are all
         * params which can be accepted by the lineStyle()
         * method of the Graphics class.
         * We keep a separate default set for regular edges and
         * for distinguished edges.
         * */
        protected var _defaultEdgeStyle:Object = {
            thickness:1,
            alpha:1.0,
            color:0xcccccc,
            pixelHinting:false,
            scaleMode:"normal",
            caps:null,
            joints:null,
            miterLimit:3
        }
        
        /* The visibility of nodes can be controlled in a few ways.
        * The principal limit is to restrict nodes to only be visible if they
        * are within a certain distance (in degrees of separation) from the
        * current root node. In addition previous root nodes can be
        * made visible */
        
        /**
         * This property controls if any visibility limit is currently
         * active at all. Strongly recommended for large graphs.
         * The application will be brought to its knees if thousands of nodes
         * should be displayed. 
         * */
        protected var _visibilityLimitActive:Boolean = true;
        
        /**
         * Controls the maximum distance from the root that a node
         * can have to still be visible.
         * */
        protected var _maxVisibleDistance:uint = int.MAX_VALUE;
        
        /**
         * This object hash contains all node ids 
         * of nodes which are currently within the visible
         * distance limit. This hash is typically initialised from
         * from the Graph object. These nodes are NOT all
         * visible nodes (since the history nodes are also
         * visible).
         * */
        protected var _nodeIDsWithinDistanceLimit:Dictionary;
        
        /**
         * This object contains the previuos hash of nodes
         * within the distance. To keep this helps to avoid
         * running through all nodes to render the olds
         * invisible and the new ones visible.
         * */
        protected var _prevNodeIDsWithinDistanceLimit:Dictionary;
        
        /**
         * This is the number of nodes within the distance
         * limit.
         * */
        protected var _noNodesWithinDistance:uint;
        
        /**
         * This Dictionary holds all visible nodes,
         * i.e. those within the limit and the history
         * nodes (if the history is enabled), or even all
         * nodes, if the visibility limitation is disabled.
         * This directory is indexed by VNode and the values
         * are the same VNode.
         * */
        protected var _visibleVNodes:Dictionary;
        
        /**
         * The number of currently visible VNodes.
         * */
        protected var _noVisibleVNodes:int;
        
        /**
         * This Dictionary keeps track of all currently
         * visible edges. An edge is visible iff both
         * attached nodes are visible. This hash is indexed
         * with VEdges and the values are the same VEdge objects.
         * */
        protected var _visibleVEdges:Dictionary;
        
        /* root nodes, distinguished nodes and history */
        
        /**
         * This is the current focused / root node. It will be
         * used as the root for any tree computations and
         * currently all layouters depend on this.
         * Typically the root node is selected by double-click.
         * */
        protected  var _currentRootVNode:IVisualNode = null;
        
        /**
         * This hash keeps track of all the past root VNodes
         * thus being the history. If showHistory is enabled,
         * these nodes are also visible even if they are outside
         * the visible distance.
         * */
        protected var _currentVNodeHistory:Array = null;
        
        /**
         * This flag controls whether to show the history nodes or not.
         * */
        protected var _showCurrentNodeHistory:Boolean = false;
        
        /* for debugging purposes we need a component counter */
        protected var _componentCounter:int = 0;
        
        /* public attributes */
        
        /**
         * enable bitmap caching in renderer components
         * */
        public var cacheRendererObjects:Boolean = false;
        
        /**
         * Default visibility setting for new nodes. If
         * set all new nodes are created visible and with
         * a view component. Beware of that if you have
         * many nodes.
         * */
        public var newNodesDefaultVisible:Boolean = false;
        
        /**
         * This property controls whether the mouse cursor
         * should be locked in the dragged node's center or not.
         * */
        public var dragLockCenter:Boolean = false;
        
        /**
         * If set, this effect will be applied if a view
         * is created (e.g. while a node becomes visible
         * or if a new node is created).
         * */
        public var addItemEffect:Effect;
        
        /**
         * If set, this effect will be applied if a view
         * is removed (e.g. a node becomes invisible or
         * is removed).
         * */
        public var removeItemEffect:Effect;
        
        /**
         * The constructor just initialises most data structures, but not all
         * required. Currently it does neither set a Graph object, nor a 
         * Layouter object. Reasonable defaults may be added as an option.
         * */
        public function VisualGraph() {
            
            /* call super class constructor */
            super();
            
            /* initialize maps for drag and drop */
            _drag_x_offsetMap = new Dictionary;
            _drag_y_offsetMap = new Dictionary;
            _drag_boundsMap = new Dictionary;
            
            /* initialise view/ItemRenderer and visibility mapping */
            _vnodes = new Dictionary;
            _vedges = new Dictionary;
            _viewToVNodeMap = new Dictionary;
            _viewToVEdgeMap = new Dictionary;
            _visibleVNodes = new Dictionary;
            _visibleVEdges = new Dictionary;
            _noVisibleVNodes = 0;
            _visibilityLimitActive = true;
            
            /* init the history array */
            _currentVNodeHistory = new Array;
            _twoNode  =  new ArrayCollection();
            
            /* set the drawing surface for the edges */
            _drawingSurface = new UIComponent();
            _drawingSurface.percentWidth = 100;
            _drawingSurface.percentHeight = 100;
            /* set an edge renderer, for now we use the Default,
            * but at a later stage this could be set externally */
            _edgeRenderer = new BaseEdgeRenderer(_drawingSurface.graphics);
            
            /* initialize the canvas, we are our own canvas obviously */
            _canvas = this;
            
            _canvas.addChild(_drawingSurface);
            
            _canvas.horizontalScrollPolicy = "off";
            _canvas.verticalScrollPolicy = "off"; 
            
            _allNode = new ArrayCollection;
            
            /* add event handlers for background drag/drop i.e. scrolling */
            _canvas.addEventListener(MouseEvent.MOUSE_DOWN,backgroundDragBegin);
            _canvas.addEventListener(MouseEvent.MOUSE_MOVE,mouseMoveHandler);
            _canvas.addEventListener(MouseEvent.ROLL_OVER,rollOverHandler);
            _canvas.addEventListener(MouseEvent.ROLL_OUT,rollOutHandler); 
            _canvas.addEventListener(MouseEvent.CLICK,backgroundClick);
            
            _origin = new Point(0,0);
        }
        
        
       public  function removeRavisEdge():void{
        				if(this._currentEdge !=null){
						
				       var fromNode:IVisualNode = this._currentEdge.edge.node1.vnode;
				       var toNode:IVisualNode = this._currentEdge.edge.node2.vnode;
				       
						this.unlinkNodes(fromNode,toNode);
//						var fromNodeName:String = this.idToName(fromNode);
//						var toNodeName:String = this.idToName(toNode);
//						trace(fromNodeName+"        "+toNodeName)
//						trace (String(Graph.selectedDataChild[fromNodeName] ))
						
//						var index:int = (Graph.selectedDataChild[fromNodeName] as ArrayCollection).getItemIndex(toNodeName);
//						if(index!= -1)
//									(Graph.selectedDataChild[fromNodeName] as ArrayCollection).removeItemAt(index);
//							trace (String(Graph.selectedDataChild[fromNodeName] as ArrayCollection))
//							var isExist:Boolean = false;
//							 for (var nods:String in this.loopDictionary ){
//							 		if(nods == toNode.node.id.toString()){
//							 				isExist = true ;break;
//							 		}
//							 }
//							 
//							 if( isExist){
//							 	var temp:ArrayCollection = loopDictionary[nods] as ArrayCollection;
//							   	var index :int = temp.getItemIndex(fromNode.node);
//							   if(index != -1)
//							   			temp.removeItemAt(index);
//							 }			

							 				 
//							draw();
				}else{
					mx.controls.Alert.show("No edge is selected!!,Please trace again");
				}
       }
//       private var loopDictionary:Dictionary =new Dictionary();
       
      
       
        public function addEdge():void{
        	
        	if(this._twoNode.length == 2){
        	        	var fromNode:IVisualNode = this._twoNode.getItemAt(0) as IVisualNode;
        			var toNode:IVisualNode = this._twoNode.getItemAt(1) as IVisualNode;
        			var edge:IEdge = this._graph.getEdge(fromNode.node,toNode.node);
        	
        	if(edge == null){

        			var  vedge:IVisualEdge = linkNodes(fromNode,toNode);
        			 this._twoNode.removeAll();
        			 if(fromNode.id == toNode.id){
        			 	        			 	
//	 				    var str:String = toNode.node.id.toString();	 
//						 if(!loopDictionary.hasOwnProperty(str))
//								loopDictionary[str]  = new ArrayCollection();						
//						var temparr:ArrayCollection = loopDictionary[str] as ArrayCollection;
//						if(!temparr.contains(fromNode.node))
//									temparr.addItem(fromNode.node);						
	 					vedge.isLoopEdge = true;
        			 }else{		 	
        			 //check  whether loop  is overlapping
        			       	var tempnodes:Array = new  Array();
        			 		for each (var tempnode:Node in  this._graph.nodes){
        			 			tempnodes.push(tempnode);
        			 		}
        			 		
        			 		var nodelist:ArrayCollection = new ArrayCollection(tempnodes.reverse());		
        			 							
        			         var loop:Loop = new Loop(nodelist);
				        	loop.findcycle();
				        	var loops:Array = loop.output;
	
				        	for  (var j:int = 0;j<loops.length;j++ ){
				        			var item:Array = loops[j] as Array;
				        			 for (var i:int =0;i<loops.length;i++){
				        			 			var one:Array = loops[i] as Array;
				        			 			if(i==j ) continue;
				        			 			if(item[0] ==  one[0] && item[item.length -1] == one[one.length -1])
				        			 								continue;
				        			 			else{
				        			 				if(!this.isLoop(item,one)){
				        			 						this.unlinkNodes(fromNode,toNode);
				        			 						mx.controls.Alert.show("loop:"+String(item)+" with loop: "+String(one)+" is intersect");
				        			 						return ;
				        			 				}	
				        			 				}
        			 			}
        			 			
        			 			
        			 			if(item[0] == toNode.id.toString() &&item[item.length -1] == fromNode.id.toString()){       			 						
//			        			 		 str = toNode.node.id.toString();	 
//										 if(!loopDictionary.hasOwnProperty(str))
//												loopDictionary[str]  = new ArrayCollection();
//										
//										 temparr = loopDictionary[str] as ArrayCollection;
//										if(!temparr.contains(fromNode.node))
//													temparr.addItem(fromNode.node);						
        			 					vedge.isLoopEdge = true;
        			 			}							
        			 }	
        			 		
        			 }
        			 this._edgeRenderer.draw(vedge);
        			mx.controls.Alert.show("  Add an edge  successfully!!");
        	}else{
        		mx.controls.Alert.show("this edge has already exist!!");
        	}

        	}else{
        		mx.controls.Alert.show("Select the node less or more than 2,please try again!!!");
        		this._twoNode.removeAll();
        	}
        
        }
        
        	
        
        
        		private function isLoop(item:Array,one:Array):Boolean{
							  var two:Array = new Array();
				        			 				for (var m:int = 0;m<item.length;m++)
				        			 					for(var n:int =0;n<one.length;n++){
				        			 						 if(item[m]==one[n]){
				        			 						 	two.push(item[m]);
				        			 						 }
				        			 					}
				        			 	var len:int = two.length;
				        			 		if(len != 0 && len<one.length && len < item.length){
				        			 			return false;
				        			 		}
				        			 		else 
				        			 			return true;
		}
        
        	private   function getNamefromId(vnode:IVisualNode):String{
		  	          var dic1:Dictionary = Graph(this._graph).getDic1();
                       	var id:String = vnode.id.toString();
            for (var key:String in dic1){

            	if(id == dic1[key]){
//            		mx.controls.Alert.show(" id:  "+ id + " name : "+key);
            		break;
            	}
            }
            return key;          
		  }
		  
		  
		private function backgroundClick(e:MouseEvent):void{
			 this._twoNode.removeAll();
		}
        
        private function mouseMoveHandler(e:MouseEvent):void
        {
            if(distortion && layouter.animInProgress == false)
            {
                var dp:Point = new Point(e.stageX,e.stageY);
                dp = dp.subtract(localToGlobal(new Point(x,y)));
                distortion.distort(dp);
            }
        }
        
        private function rollOverHandler(e:MouseEvent):void
        {
            CursorManager.setCursor(HAND_CURSOR,3);
            
        }
        
        private function rollOutHandler(e:MouseEvent):void
        {
            if(distortion)
            {
                draw();
            }
            CursorManager.removeAllCursors();
        }
        
        public function releaseNodes():void
        {
            for each(var node:IVisualNode in visibleVNodes)
            {
                node.moveable = true;
            }
        }
        
        /**
         * This property allows access and setting of the underlying
         * graph object. If set, it will automatically initialise the VGraph
         * from the Graph object, i.e. create VNodes and VEdges for each
         * Graph node and Graph edge.
         * If there was already a Graph present, the VGraph is purged, but no other
         * cleanup is done, which means that there could still be
         * some references floating around thus leaking memory.
         * For now, avoid setting it more than once in the same
         * VGraph.
         * @param g The Graph object to be assigned.
         * */
        public function set graph(g:IGraph):void {
            
            if(_graph != null) {
                LogUtil.warn(_LOG, "_graph in VisualGraph was not null when new graph was assigned."+
                    " Some cleanup done, but this may leak memory");
                /* this cleanes the VGraph so we are pristine */
                clearHistory();
                purgeVGraph();
                
                _graph.purgeGraph();
                _nodeIDsWithinDistanceLimit = null;
                _prevNodeIDsWithinDistanceLimit = null;
                _noNodesWithinDistance = 0;
                
                /* this may have been removed already before */
                if(_layouter) {
                    _layouter.resetAll();
                }
                
            }
            
            /* assign defaults */
            _graph = g;
            
            /* IMPORTANT: a layouter also has a graph reference
            * separate, this must be updated in order for
            * this to work properly
            */
            if(_layouter) {
                _layouter.graph = g;
            }
            
            /* better safe than sorry even if it is an empty one */
            initFromGraph();
            
            /* invalidate old root node */
            _currentRootVNode = null;
            
            /* now use the first node as the new default root node */
            if(_graph.nodes.length > 0) {
                _currentRootVNode = (_graph.nodes[0] as INode).vnode;
            }
            
            LogUtil.warn(_LOG, "Setting a new graph object invalidates the root node,"+
                " a new default root node was set, but it may not be what you want");
        }
        
        /**
         * @private
         * */
        public function get graph():IGraph {
            return _graph;
        }
        
        
        public  function setRootVNode(selectedID:String):void{

        		var startRoot:IVisualNode=this.graph.nodeByStringId(selectedID).vnode;//this.graph.nodeByStringId(selectedID).vnode;

				/* the following kicks it off .... */
				this.currentRootVNode= startRoot;
				
				draw();
        }
        /**
         * @inheritDoc
         * */
        public function get edgeDrawGraphics():Graphics {
            if(_drawingSurface) {
                return _drawingSurface.graphics;
            } else {
                return null;
            }
        }
        
        /**
         * @inheritDoc
         * */
        public function get drawingSurface():UIComponent {
            return _drawingSurface;
        }
        
        /**
         * @inheritDoc
         * */
        public function set itemRenderer(ifac:IFactory):void {
            if(ifac != _itemRendererFactory) {
                _itemRendererFactory = ifac;
                
                /* if that has changed, we would need to recreate all
                * currently visible nodes */
                setAllInVisible();
                updateVisibility();
            }
        }
        
        /**
         * @private
         * */
        public function get itemRenderer():IFactory {
            return _itemRendererFactory;
        }
        
        
        /**
         * @inheritDoc
         * */
        public function set edgeRenderer(er:IEdgeRenderer):void {
            _edgeRenderer = er;
        }
        /**
         * @private
         * */
        public function get edgeRenderer():IEdgeRenderer {
            return _edgeRenderer;
        }
        
        /**
         * @inheritDoc
         * */
        public function set edgeLabelRenderer(elr:IFactory):void {
            /* if the factory was changed, then we have to remove all
            * instances of vedgeViews to have them updated */
            if(elr != _edgeLabelRendererFactory) {
                /* set all edges invisible, this should delete all instances
                * of view components */
                setAllEdgesInVisible();
                
                /* set the new renderer */
                _edgeLabelRendererFactory = elr;	
                
                /* update i.e. recreate the instances */
                updateEdgeVisibility();
            }
        }
        
        /**
         * @private
         * */
        public function get edgeLabelRenderer():IFactory {
            return _edgeLabelRendererFactory;
        }
        
        
        /**
         * @inheritDoc
         * */
        public function set displayEdgeLabels(del:Boolean):void {
            var e:IEdge;
            
            if(_displayEdgeLabels == del) {
                // no change
            } else {
                _displayEdgeLabels = del;
                setAllEdgesInVisible();
                updateEdgeVisibility();
            }
        }
        
        /**
         * @private
         * */
        public function get displayEdgeLabels():Boolean {
            return _displayEdgeLabels;
        }
        
        /**
         * @inheritDoc
         * */
        public function get layouter():ILayoutAlgorithm {
            return _layouter;
        }
        
        /**
         * @private
         * */
        public function set layouter(l:ILayoutAlgorithm):void {
            if(_layouter != null) {
                _layouter.resetAll(); // to stop any pending animations
            }
            _layouter = l;
            /* need to signal control components possibly */
            this.dispatchEvent(new VGraphEvent(VGraphEvent.LAYOUTER_CHANGED));
        }
        
        /**
         * @inheritDoc
         * */
        public function get origin():Point {
            return _origin;
        }
        
        /**
         * @inheritDoc
         * */
        public function get center():Point {
            return new Point(this.width / 2.0, this.height / 2.0);
        }
        
        /**
         * @inheritDoc
         * */
        public function get visibleVNodes():Dictionary {
            return _visibleVNodes;
        }
        
        /**
         * @inheritDoc
         * */
        public function get noVisibleVNodes():uint {
            return _noVisibleVNodes;
        }
        
        /**
         * @inheritDoc
         * */
        public function get visibleVEdges():Dictionary {
            return _visibleVEdges;
        }
        
        /**
         * @inheritDoc
         * */
        [Bindable]
        public function get visibilityLimitActive():Boolean {
            return _visibilityLimitActive;
        }
        /**
         * @private
         * */
        public function set visibilityLimitActive(ac:Boolean):void {
            /* check for a change */
            if(_visibilityLimitActive != ac) {	
                /* execute the change */
                _visibilityLimitActive = ac;
                /* activate? */
                if(ac) {
                    if(_currentRootVNode == null) {
                        LogUtil.warn(_LOG, "No root selected, not creating limited graph, not doing anything.");
                        return;
                    }
                    //LogUtil.debug(_LOG, "getting limited node ids with limit:"+_maxVisibleDistance);
                    
                    /* 1. Get the spanning tree, rooted in our current root node from
                    *    the graph object.
                    * 2. Get the hash from this tree, that contains only the nodes
                    *    within the set distance.
                    * 3. Use this to set our properties for the nodes within the distance
                    *    limit.
                    */
                    setDistanceLimitedNodeIds(_graph.getTree(_currentRootVNode.node).
                        getLimitedNodes(_maxVisibleDistance));
                    
                    /* now update all other visibility data structure
                    * this also forces a redraw() (and layout) of the 
                    * visualisation */
                    updateVisibility();
                }
                    /* when we deactivate this limit, we render all nodes
                    * visible! */
                else {
                    setAllVisible();
                }
            }
        }
        
        
        /**
         * @inheritDoc
         * */
        [Bindable]
        public function get maxVisibleDistance():int {
            return _maxVisibleDistance;
        }
        
        /**
         * @private
         * */
        public function set maxVisibleDistance(md:int):void {
            /* check if there was a change */
            if(_maxVisibleDistance != md) {
                /* if yes, apply the change */
                _maxVisibleDistance = md;
                //LogUtil.debug(_LOG, "visible distance changed to: "+md);
                
                /* if our current limits are active we create a new
                * set of nodes within the distance and update the
                * visibility */
                if(_visibilityLimitActive) {
                    if(_currentRootVNode == null) {
                        LogUtil.warn(_LOG, "No root selected, not creating limited graph");
                        return;
                    } else {
                        setDistanceLimitedNodeIds(_graph.getTree(_currentRootVNode.node).
                            getLimitedNodes(_maxVisibleDistance));
                        updateVisibility();
                    }
                }
            }
        }
        
        
        /**
         * This was added for testing. It may be removed
         * again.
         * */
        public function get currentRootSID():String {
            return _currentRootVNode.node.stringid;
        }
        
        /**
         * @inheritDoc
         * */
        /* [Bindable]  */
        public function get currentRootVNode():IVisualNode {
            return _currentRootVNode;
        }
        /**
         * @private
         * */
        public function set currentRootVNode(vn:IVisualNode):void {
            /* check for a change */
            if(_currentRootVNode != vn) {
                
                /* apply the change */
                _currentRootVNode = vn;
                
                /* now update the history with the new node */
                _currentVNodeHistory.unshift(_currentRootVNode);
            }	
            //LogUtil.debug(_LOG, "node:"+_currentRootVNode.id+" added to history");
            
            //we always need to the following because:
            //the _currentRootVNode can be set when you 
            //create a node. Then if you set a custom renderer for nodes
            //every node is made to be invisible, and because this stuff
            //following hasn't been called it stays that way and is not deployed 
            
            /* if we are currently limiting node visibility,
            * update the set of visible nodes since we 
            * have changed the root, the spanning tree has changed
            * and thus the set of visible nodes */
            if(_visibilityLimitActive) {
                setDistanceLimitedNodeIds(_graph.getTree(_currentRootVNode.node).
                    getLimitedNodes(_maxVisibleDistance));
                updateVisibility();
            } else {					
                //if the visibility limit is not active, get all the nodes
                setDistanceLimitedNodeIds(getNodesAsDictionary());
                updateVisibility();
            }
            
        }
        
        private function getNodesAsDictionary():Dictionary {
            var retVal:Dictionary = new Dictionary();
            for each(var node:INode in _graph.nodes)
            {
                retVal[node] = node;
            }
            
            return retVal;
        }		
        
        public function set scrollBackgroundInDrag(f:Boolean):void {
            _scrollBackgroundInDrag = f;
        }
        
        public function set moveNodeInDrag(f:Boolean):void {
            _moveNodeInDrag = f;
        }
        
        /**
         * @inheritDoc
         * */
        public function get showHistory():Boolean {
            return _showCurrentNodeHistory;
        }
        
        /**
         * @private
         * */
        public function set showHistory(h:Boolean):void {
            /* check for a change */
            if(_showCurrentNodeHistory != h) {
                _showCurrentNodeHistory = h;
                
                /* makes no sense without root set */
                if(_currentRootVNode != null) {
                    /* becomes only active if we have the limit active */
                    if(_visibilityLimitActive) {
                        /* now update the visibility. This also applies the
                        * history information to the node visibility */
                        updateVisibility();
                    }
                }
            }
        }
        
        /**
         * @inheritDoc
         * */
        public function get scale():Number {
            return _scale;
        }
        
        /**
         * @inheritDoc
         * */
        public override function get scaleY():Number
        {
            var curScale:Number;
            curScale = super.scaleY;
            var parentComp:DisplayObject = this.parent;
            while(parentComp && !(parentComp is VisualGraph))
            {
                curScale *= parentComp.scaleY;
                parentComp = parentComp.parent;
            }
            return curScale;
        }
        
        /**
         * @inheritDoc
         * */		
        public override function get scaleX():Number
        {
            var curScale:Number;
            curScale = super.scaleX;
            var parentComp:DisplayObject = this.parent;
            while(parentComp && !(parentComp is VisualGraph))
            {
                curScale *= parentComp.scaleX;
                parentComp = parentComp.parent;
            }
            return curScale;
        }
        
        /**
         * @private
         * */
        public function set scale(s:Number):void {
                        
            var w:Number = width - width/s;
            var h:Number = height - height/s;
            
            //the scroll takes care of the refresh            
            scroll(-w/2 - _origin.x ,-h/2 - _origin.y, false);
            scaleX = s;
            scaleY = s;
            _scale = s;
            
            dispatchEvent(new VisualGraphEvent(VisualGraphEvent.GRAPH_SCALED));
        }
        
        
        /**
         * This initialises a VGraph from a Graph object.
         * I.e. it crates a VNode for every Node found in
         * the Graph and a VEdge for every Edge in the Graph.
         * Careful, this currently does not check if the VGraph
         * was already initialised and it does not purge anything.
         * Things could break if used on an already initialized VGraph.
         * */
        public function initFromGraph():void {
            
            var node:INode;
            var edge:IEdge;
            var nodes:Array = new Array;
            
            /* create the vnode from the node */
            for each(node in _graph.nodes) {
                this.createVNode(node);
                //LogUtil.debug(_LOG, "created VNode for node:"+node.id);
              nodes.push(node);
            }
            this._allNode = new ArrayCollection(nodes.reverse());
            /* we also create the edge objects, since they
            * may carry additional label information or something
            * like that, but they do not have a view */
            for each(edge in _graph.edges) {
                this.createVEdge(edge);
            }
            
            
        }
        
        /**
         * @inheritDoc
         * */
        public function clearHistory():void {
            _currentVNodeHistory = new Array();
        }
        
        
        
        /**
         * @inheritDoc
         * */
        public function calcNodesBoundingBox():Rectangle {
            
            var children:Array;
            var result:Rectangle;
            
            /* get all children of our canvas, these should only
            * be node views and the edge drawing surface. */
            children = _canvas.getChildren();
            
            /* init the rectangle with some large values. 
            * Originally I wanted to use Number.MAX_VALUE / Number.MIN_VALUE but
            * ran into serious numerical problems, thus 
            * we use +/- 999999 for now, although this is 
            * more like a hack.
            * Note that the coordinates are reversed, i.e. the origin of the rectangle
            * has been pushed to the far bottom right, and the height and width
            * are negative */
            result = new Rectangle(999999, 999999, -999999, -999999);
            
            //LogUtil.debug(_LOG, "THIS CANVAS currently HAS:"+children.length+" children!!");
            
            /* if there are no children at all, there may be something
            * wrong as it should at least contain the drawing surface */
            if(children.length == 0) {
                LogUtil.warn(_LOG, "Canvas has no children, not even the drawing surface!");
                return null;
            }
            
            /* The children should only be the visible node's views and
            * the drawing surface for the edges, so we
            * add a safeguard here to see of these are actually much more */
            
            /* since the edge labels were introduced this no longer works
            * because we also need to count each displayed edge label
            * but we have no counter yet for that, so the check is commented
            * for now
            if(children.length > _noVisibleVNodes + 1) {
            throw Error("Children are more than visible nodes plus drawing surface");
            }
            */
            
            /* now walk through all children, which are UIComponents
            * and not our drawing surface and expand the result rectangle */
            for(var i:int = 0;i < children.length; ++i) {
                
                var view:UIComponent = (children[i] as UIComponent);
                
                /* only consider currently visible views */
                if(view.visible) {
                    if(view != _drawingSurface) {
                        result.left = Math.min(result.left, view.x);
                        result.right = Math.max(result.right, view.x + view.width);
                        result.top = Math.min(result.top, view.y);
                        result.bottom = Math.max(result.bottom, view.y+view.height);
                        trace("view.width    "+view.width+"   "+view.height)
                    } else {
                        if(children.length == 1) {
                            /* only child is the drawing surface, we return an empty Rectangle
                            * anchored in the middle */
                            return new Rectangle(_canvas.width / 2, _canvas.height / 2, 0, 0);
                        }
                    }
                }
            }
            return result;
        }
        
        /** 
         * @inheritDoc
         * */
        public function createNode(sid:String = "", o:Object = null,isAddtoNode:Boolean= true):IVisualNode {
            
            var gnode:INode;
            var vnode:IVisualNode;
            
            /* first add a new node to the underlying graph */
            gnode = _graph.createNode("",sid,o,isAddtoNode);
            
            /* Then create the VNode with associated with the graph node */
            vnode = createVNode(gnode);
            
            /* since it is a requirement from most layouters
            * to always have a current root node
            * we assign the current root node to the newly
            * created node so we have one. Note that this does
            * not affect the root node history. */
            _currentRootVNode = vnode;
            
            return vnode;
        }
        
        /**
         * @inheritDoc
         * */
        public function removeNode(vn:IVisualNode):void {
            
            var n:INode;
            var e:IEdge;
            var ve:IVisualEdge;
            var i:int;
            
            n = vn.node;
            
            /* if the current root node is the
            * node to be removed it must be
            * changed.
            *
            * First, we set it to null, then we remove the
            * node, then at the end we reset it
            * to the first node still in the
            * nodes array */
            if(vn == _currentRootVNode) {
                /* temporary set to null */
                _currentRootVNode = null;
            }
            
            /* remove all incoming edges */
            while(n.inEdges.length > 0) {
                e = n.inEdges[0] as IEdge;
                ve = e.vedge;
                removeVEdge(ve);
                _graph.removeEdge(e);
            }
            
            /* remove all outgoing edges */
            while(n.outEdges.length > 0) {
                e = n.outEdges[0] as IEdge;
                ve = e.vedge;
                removeVEdge(ve);
                _graph.removeEdge(e);
            }
            
            /* remove the vnode */
            removeVNode(vn);
            
            /* remove the node from the graph */
            _graph.removeNode(n);
            
            /* now set a new root node, implies that there is
            * still a node */
            if(_currentRootVNode == null && _graph.noNodes > 0) {
                _currentRootVNode = (_graph.nodes[0] as INode).vnode;
            }
            
            /* since we removed also edges, we need a refresh */
            refresh();
        }
        
        
        /** 
         * @inheritDoc
         * */
        public function linkNodes(v1:IVisualNode, v2:IVisualNode):IVisualEdge {
            
            var n1:INode;
            var n2:INode;
            var e:IEdge;
            var ve:IVisualEdge;
            
            
            /* make sure both nodes do exist */
            if(v1 == null || v2 == null) {
                throw Error("linkNodes: one of the nodes does not exist");
                //return null;
            }
            
            n1 = v1.node;
            n2 = v2.node;
            
            /* now first link the graph nodes and create the corresponding edge */
            e = _graph.link(n1,n2,null);
            
            /* if the edge existed already, e is just the
            * already existing edge. But if it existed
            * previously it might already have a VEdge.
            * So we only create a new VEdge, if it did not exist
            * already. */		
            if(e == null) {
                throw Error("Could not create or find Graph edge!!");
            } else {
                if(e.vedge == null) {
                    /* we have a new edge, so we create a new VEdge */
                    ve = createVEdge(e);
                } else {
                    /* existing one, so we use the existing vedge */
                    LogUtil.info(_LOG, "Edge already existed, returning existing vedge");
                    ve = e.vedge;
                }
            }
            
            //LogUtil.debug(_LOG, "linkNodes, created edge "+(e as Object).toString()+" from nodes: "+n1.id+", "+n2.id);
            
            /* this changes the layout, so we have to do a full redraw */
            // if we link nodes we may not necesarily want to draw();
            /* just refresh the edges */
            refresh();
            return ve;
        }
        
        /** 
         * @inheritDoc
         * */
        public function unlinkNodes(v1:IVisualNode, v2:IVisualNode):void {
            
            var n1:INode;
            var n2:INode;
            var e:IEdge;
            var ve:IVisualEdge;
            
            /* make sure both nodes exist */
            if(v1 == null || v2 == null) {
                throw Error("unlink nodes: one of the nodes does not exist");
                return;
            }
            
            n1 = v1.node;
            n2 = v2.node;
            
            /* find the graph edge */
            e = _graph.getEdge(n1,n2);
            
            /* if we do not get an edge, it may simply not exist */
            if(e == null) {
                LogUtil.warn(_LOG, "No edge found between: "+n1.id+" and "+n2.id);
                return;
            }
            
            /* now get and remove the VEdge first */
            ve = e.vedge;			
            removeVEdge(ve);
            
            /* now remove the edge itself, basically
            * unlinking the nodes */
            _graph.removeEdge(e);
            
            dealData(n2,n1);
            refresh();
        }
        
        private function dealData(toINode:INode,fromNode:INode):void{
        								 //如果已经配置了参数
//							 var toINode:INode = this._currentEdge.edge.node2;
							 var inputs:Dictionary = toINode.inputs as Dictionary;
							
							 if(inputs.hasOwnProperty(fromNode.id.toString())){
							 		if(fromNode.id == 1){
							 			var rootInputs:Dictionary = fromNode.inputs as Dictionary;
							 			var rootOutputs:Dictionary = fromNode.outputs as Dictionary;
							 			for (var key:String in rootInputs[toINode.id.toString()] )
							 				delete rootOutputs[key];
										delete rootInputs[toINode.id.toString()];																			
							 		}

							 			delete inputs[fromNode.id.toString()];
							 }
							var condiction:Dictionary = toINode.condition as Dictionary;
							 if(condiction.hasOwnProperty(fromNode.id.toString())){
							 	delete condiction[fromNode.id.toString()];
							 }
							 
							 var whileCondiction:Dictionary = toINode.whileCondition as Dictionary;
							 if(whileCondiction.hasOwnProperty(fromNode.id.toString())){
							 	delete whileCondiction[fromNode.id.toString()];
							 }
							 
							 
							 
        }
        
        /**
         * @inheritDoc
         * */
        public function scroll(deltaX:Number, deltaY:Number, reset:Boolean):void {
            
            //set the x and y of each node with the diff
            // do not commit the change because
            // we want it to change the same time as the arrows do
            for each(var node:INode in _graph.nodes)
            {
                node.vnode.x += deltaX;
                node.vnode.y += deltaY;
            }
            
            //if we are resetting the origin do that
            if(reset) {
                _origin = new Point(0,0);
            }
            
            //update the origin with the new delta
            _origin.offset(deltaX,deltaY);
            
            //redraw everything on the next updateDisplayList
            refresh();
        }
        
        /**
         * @inheritDoc
         * */
        public function redrawNodes():void
        {
            if(_graph == null) {
                LogUtil.debug(_LOG, "_graph object in VisualGraph is null");
                return;
            }
            
            for each(var node:INode in _graph.nodes) {
                if(node.vnode !=null && node.vnode.view != null) {
                    node.vnode.commit();
                    node.vnode.view.invalidateDisplayList();
                }
            }
        }
        
        /**
         * @inheritDoc
         * */
        public function refresh():void {
            /* this forces the next call of updateDisplayList()
            * to redraw all edges and all nodes*/
            _forceUpdateEdges = true;
            _forceUpdateNodes = true;
            if(_graph == null) {
                return;
            }
            //we want this because we have our own 
            //specific display list things in updateDisplayList
            invalidateDisplayList();
        }
        
        /**
         * @inheritDoc
         * */
        public function draw(flags:uint = 0):void {	
            
            var completeFunction:Function = function():void
            {
                /* after the layout was done, the layout has
                * probably changed again, the layouter will have
                * itself set to that, but has maybe not
                * invalidated the display list, so we make sure it
                * happens here (may not always be necessary) */
                invalidateDisplayList();
                
                /* dispatch this change event, so some UI items
                * in the application can poll for updated values
                * for labels or something.
                * XXX To do: specify a subtype for more specific changes
                */
                
//                dispatchEvent(new VGraphEvent(VGraphEvent.VGRAPH_CHANGED));
            }
            
            /* first refresh does layoutChanges to true and
            * invalidate display list */
//            refresh();
            
            if(flags == VisualGraph.DF_RESET_LL) {
                if(_layouter != null && _layouter.linkLength == 0) {
                    _layouter.linkLength = 100;
                }
            }
            
            /* we need to do some sanity checks, e.g. if the canvas window
            * size was reduced to 0 or linklength 0 or similar things,
            * the layouter might crash */
            if(_layouter == null ||
                _currentRootVNode == null ||
                _graph.noNodes == 0 ||
                width == 0 ||
                height == 0 ||
                _layouter.linkLength <= 0)
            {
                completeFunction();
                return;	
            }
            
           _layouter.layoutPass();
            completeFunction();
        }
        
        /**
         * Refresh the VGraph fully. I.e. recreate and
         * reassign all data objects, etc.
         * This is a heavy operation */
        public function fullVGraphRefresh(xmlData:XML = null, directional:Boolean = false):void {
            

            var graph:IGraph;	
            var oldroot:IVisualNode;
            var oldsid:String;
            var newroot:INode;
            var theXMLData:XML = xmlData;
            var layouter:ILayoutAlgorithm;
            
            /* if we do not have been passed an XML object
            * we try to get one from the old graph */
            if(theXMLData == null && _graph != null) {
                theXMLData = _graph.xmlData;
            }
            
            /* still null? then we have to bail out */
            if(theXMLData == null) {
                LogUtil.warn(_LOG, "No XML object passed or found in old graph");
                return;
            }
            
            /* reset layouter and remember it */			
            if(_layouter != null) {
                _layouter.resetAll();
                layouter = _layouter;
                _layouter = null;
                
            }
            
            /* init a graph object with the XML data */
            graph = new Graph("myXMLbasedGraphID",directional,theXMLData);
            
            /* remember the old root and id */
            oldroot = _currentRootVNode;
            oldsid = oldroot.node.stringid;
            
            /* reapply the previous layouter 
            * IMPORTANT: this has to be done before the
            * graph object is set, because otherwise the graph
            * attribute in the layouter will not be updated!
            */
            _layouter = layouter;		
            
            
            /* set the graph in the VGraph object, this automatically
            * initializes the VGraph items */
            this.graph = graph;
            
            
            
            /* setting a new graph invalidated our old root, we need to reset it */
            /* we try to find a node, that has the same string-id as the old root node */
            newroot = _graph.nodeByStringId(oldsid);
            if(newroot != null) {
                this.currentRootVNode = newroot.vnode;
            } else {
                throw Error("Cannot set a default root, bailing out");
            }
            
            /* send an event for controls to reapply their currently
            * set values to layouters */
            this.dispatchEvent(new VGraphEvent(VGraphEvent.LAYOUTER_CHANGED));
            
            /* trigger a redraw
            * XXXX think if we should do that here */
            this.draw(VisualGraph.DF_RESET_LL);
        }		
        
        /**
         * this function takes the node with the specified
         * string id and selects it as a root
         * node, automatically centering the layout around it
         * */
        public function centerNodeByStringId(nodeID:String):IVisualNode {
            
            var newroot:INode;
            
            if(_graph == null) {
                LogUtil.warn(_LOG, "VGraph has no Graph object, probably not correctly initialised, yet");
                return null;
            }
            
            newroot = _graph.nodeByStringId(nodeID);
            
            /* if we have a node, set its vnode as the new root */
            if(newroot) {
                /* is it really a new node */
                if(newroot.vnode != _currentRootVNode) {
                    /* set it */
                    this.currentRootVNode = newroot.vnode;
                    return newroot.vnode;
                } else {
                    return _currentRootVNode;
                }
            }
            LogUtil.warn(_LOG, "Node with id:"+nodeID+" not found!");
            return null;
        }
        
        
        
        /**
         * This calls the base updateDisplayList() method of the
         * Canvas and in addition redraws all edges if the layouter
         * indicates that the layout has changed.
         * 
         * @inheritDoc
         * */
        
        override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
            /* call the original function */
            super.updateDisplayList(unscaledWidth,unscaledHeight);
            
            /* now add part to redraw edges */
            if(_layouter) {
                
                if(_layouter.layoutChanged) {
                    
                    redrawEdges();
                    redrawNodes();
                    
                    _forceUpdateNodes = false;
                    _forceUpdateEdges = false;
                    _layouter.layoutChanged = false;
                }
                
                if(_forceUpdateNodes) {
                    redrawNodes();
                    _forceUpdateNodes = false;
                }
                
                if(_forceUpdateEdges) {
                    redrawEdges();
                    _forceUpdateEdges = false;
                }
            }
            
        }
        
        /* private methods */
        
        /**
         * Creates VNode and requires a Graph node to associate
         * it with. Originally also created the view, but we no
         * longer do that directly but only on demand.
         * @param n The graph node to be associated with.
         * @return The created VisualNode.
         * */
        protected function createVNode(n:INode):IVisualNode {
            
            var vnode:IVisualNode;
            
            /* as an id we use the id of the graph node for simplicity
            * for now, it is not really used separately anywhere
            * we also use the graph data object as our data object.
            * the view is set to null and remains so. */
            vnode = new VisualNode(this, n, n.id, null, n.data);
            
            /* if the node should be visible by default 
            * we need to make sure that the view is created */
            if(newNodesDefaultVisible) {
                setNodeVisibility(vnode, true);
            }
            
            /* now set the vnode in the node */
            n.vnode = vnode;
            /* add the node to the hash to keep track */
            _vnodes[vnode] = vnode;
            
            
            return vnode;
        }
        
        /**
         * Removes a VNode, this also removes the node's view
         * if it existed, but does not touch the Graph node.
         * @param vn The VisualNode to be removed.
         * */
        protected function removeVNode(vn:IVisualNode):void {
            
            var view:UIComponent;
            
            /* get access to the node's view, but get the 
            * raw view to avoid unnecessary creation of a view
            */
            view = vn.rawview;
            
            /* delete reference to the view from the node */
            vn.view = null;
            
            /* remove the reference to this node from the graph node */
            vn.node.vnode = null;
            
            /* now remove the view component if it existed */
            if(view != null) {
                removeComponent(view);
            }
            
            /* remove from the visible vnode map if present */
            if(_visibleVNodes[vn] != undefined) {
                delete _visibleVNodes[vn];
                --_noVisibleVNodes;
            }
            
            /* remove from tracking hash */
            delete _vnodes[vn];
            
            /* this should clean up all references to this VNode
            * thus freeing it for garbage collection */
        }
        
        
        /**
         * Creates a VEdge from a graph Edge.
         * @param e The Graph Edge.
         * @return The created VEdge.
         * */
        protected function createVEdge(e:IEdge):IVisualEdge {
            
            var vedge:IVisualEdge;
            var n1:INode;
            var n2:INode;
            var lStyle:Object;
            var edgeAttrs:XMLList;
            var attr:XML;
            var attname:String;
            var attrs:Array;
            
            /* create a copy of the default style */
            lStyle = ObjectUtil.copy(_defaultEdgeStyle);
            
            /* extract style data from associated XML data for each parameter */
            attrs = ObjectUtil.getClassInfo(lStyle).properties;
            
            for each(attname in attrs) {
//            	trace(attname)
                if(e.data != null && (e.data as XML).attribute(attname).length() > 0) {
                    lStyle[attname] = e.data.@[attname];
                }
            }
            
            vedge = new VisualEdge(this, e, e.id, e.data, null, lStyle);
            
            /* set the VisualEdge reference in the graph edge */
            e.vedge = vedge;
            
            /* check if the edge is supposed to be visible */
            n1 = e.node1;
            n2 = e.node2;
            
            /* if both nodes are visible, the edge should
            * be made visible, which may also create a label
            */
            if(n1.vnode.isVisible && n2.vnode.isVisible) {
                setEdgeVisibility(vedge, true);
            }
            
            /* add to tracking hash */
            _vedges[vedge] = vedge;
            
            return vedge;
        }
        
        /**
         * Remove a VisualEdge, but leaves the Graph Edge alone.
         * @param ve The VisualEdge to be removed.
         * */
        protected function removeVEdge(ve:IVisualEdge):void {
            
            /* just in case */
            if(ve == null) {
                return;
            }
            
            /* first turn it invisible, which should
            * remove the labelview */
            setEdgeVisibility(ve, false);
            
            /* remove the reference from the real edge */
            ve.edge.vedge = null;
            
            /* remove from tracking hash */
            delete _vedges[ve];
            
            /* that should actually do */
        }
        
        /**
         * Purges the VGraph by dropping all VNodes and VEdges.
         * This is a bit tricky, since we do not really
         * keep track of them in the VGraph, they are only referenced
         * by the Graph nodes and egdes.
         * */
        protected function purgeVGraph():void {
            
            var ves:Array = new Array;
            var vns:Array = new Array;
            var ve:IVisualEdge;
            var vn:IVisualNode;
            
            /* this appears rather inefficient, however
            * ObjectUtil.copy does not work on dictionaries
            * currently I have no other solution
            */
            for each(ve in _vedges) {
                ves.unshift(ve);
            }
            for each(vn in _vnodes) {
                vns.unshift(vn);
            }
            
            LogUtil.debug(_LOG, "purgeVGraph called");
            
            if(_graph != null) {
                for each(ve in ves) {
                    removeVEdge(ve);
                }
                for each(vn in vns) {
                    removeVNode(vn);
                }
            } else {
                LogUtil.warn(_LOG, "we had no graph to purge from, so nothing was done");
            }				
        }
        
        /**
         * Redraw all edges, this is called from the updateDisplayList()
         * method.
         * @inheritDoc
         * */
        public function redrawEdges():void {
            
            var vn1:IVisualNode;
            var vn2:IVisualNode;
            var vedge:IVisualEdge;
            
            /* make sure we have a graph */
            if(_graph == null) {
                LogUtil.debug(_LOG, "_graph object in VisualGraph is null");
                return;
            }
            
            /* clear the drawing surface and remove previous
            * edges */
            _drawingSurface.graphics.clear();
            
            /* now walk through all currently visible egdes */
            for each(vedge in _visibleVEdges) {
                
                _edgeRenderer.draw(vedge);
            }
            
        }
        
        /**
         * Lookup a node by its UIComponent. This is more a convenience
         * method with some sanity check. Primarily used by event handlers.
         * @param c The component to find the VisualNode for.
         * @return The found Node.
         * @throws An Error if the component was not registered in the map.
         * */
        protected function lookupNode(c:UIComponent):IVisualNode {
            var vn:IVisualNode = _viewToVNodeMap[c];
            if(vn == null) {
//                //throw Error("Component not in viewToVNodeMap");
                mx.controls.Alert.show("Component not in viewToVNodeMap");
            }
            return vn;
        }
        
        protected function lookupEdge(c:UIComponent):IVisualEdge{
        	var ve:IVisualEdge = this._viewToVEdgeMap[c];
            if(ve == null) {
                throw Error("Component not in viewToVEdgeMap");
            }
            return ve;
        }
        
        
        
        /**
         * Create a "view" object (UIComponent) for the given node and
         * return it. These methods are only exported to be used by
         * the VisualNode. Alas, AS does not provide the "friend" directive.
         * Not sure how to get around this problem right now.
         * @param vn The node to replace/add a view object.
         * @return The created view object.
         * */
        protected function createVNodeComponent(vn:IVisualNode):UIComponent {
            
            var mycomponent:UIComponent = null;
            
            /*
            * a possible view factory is our own implementation
            * of such a Factory, currently not used.
            if(_viewFactory != null) {
            result = viewFactory.getView(VNode) as UIComponent;
            }
            */
            
            if(_itemRendererFactory != null) {
                mycomponent = _itemRendererFactory.newInstance();
            } else {
                mycomponent = new UIComponent();
            }			
            
            /* assigns the item (VisualNode) to the IDataRenderer part of the view
            * this is important to access the data object of the VNode
            * which contains information for rendering. */		
            if(mycomponent is IDataRenderer) {
                (mycomponent as IDataRenderer).data = vn;
            }
            
            /* set initial x/y values */
            mycomponent.x = _canvas.width / 2.0;
            mycomponent.y = _canvas.height / 2.0;
            
//            mx.controls.Alert.show("I am listening");
            
            /* add event handlers for dragging and double click */			
            mycomponent.doubleClickEnabled = true;
            
            mycomponent.addEventListener(MouseEvent.DOUBLE_CLICK, nodeDoubleClick);
            mycomponent.addEventListener(MouseEvent.MOUSE_DOWN, nodeMouseDown);
            mycomponent.addEventListener(MouseEvent.ROLL_OVER, nodeRollOver);
            mycomponent.addEventListener(MouseEvent.ROLL_OUT, nodeRollOut);
            mycomponent.addEventListener(MouseEvent.CLICK,nodeMouseClick);
            
            /* enable bitmap cachine if required */
            mycomponent.cacheAsBitmap = cacheRendererObjects;
            
            /* add the component to its parent component */
            _canvas.addChild(mycomponent);
            
            /* do we have an effect set for addition of
            * items? If yes, create and start it. */
            if(addItemEffect != null) {
                addItemEffect.createInstance(mycomponent).startEffect();
            }
            
            /* register it the view in the vnode and the mapping */
            vn.view = mycomponent;
            _viewToVNodeMap[mycomponent] = vn;
            
            /* increase the component counter */
            ++_componentCounter;
            
            /* assertion there should not be more components than
            * visible nodes */
            if(_componentCounter > (_noVisibleVNodes)) {
                throw Error("Got too many components:"+_componentCounter+" but only:"+_noVisibleVNodes
                    +" nodes visible");
            }
            
            /* we need to invalidate the display list since
            * we created new children */
            refresh();
            
            return mycomponent;
        }
        private function rollDeal(e:MouseEvent):void{
        	var comp:UIComponent;
            var vnode:IVisualNode;
            
            
            /* get the view object that was klicked on (actually
            * the one that has the event handler registered, which
            * is the VNode's view */
            comp = (e.currentTarget as UIComponent);           
            /* get the associated VNode */
            vnode = lookupNode(comp);
            

			if(vnode!= null){
				        var evt:VisualNodeEvent = new VisualNodeEvent(VisualNodeEvent.DOUBLE_CLICK, vnode.node,e.ctrlKey);
			            dispatchEvent(evt);
			            //LogUtil.debug(_LOG, "double click!");
												
			        	var build:Canvas = this.parentApplication.mashupViews.getChildByName("mashupBuild") as Canvas; 
     					var hbox:HBox = build.getChildByName("hbox") as HBox;
     					var ravis:Ravis = hbox.getChildAt(1) as Ravis;
						ravis.currentNodeX =  vnode;											
						var tpToolBar:toolBar = ravis.tpToolBar;
						
				if(e.type == MouseEvent.ROLL_OVER){
						tpToolBar.x = vnode.viewX + vnode.view.width/1.5;
						tpToolBar.y = vnode.viewY- vnode.view.height /2; 			
						tpToolBar.visible = true;					
				}else if(e.type == MouseEvent.ROLL_OUT){
						tpToolBar.visible = false;		
				}

					
			}
        }
        private function nodeRollOver(e:MouseEvent):void {
        	      	
            CursorManager.removeAllCursors();
           if(!VisualGraph.mode)
            				this.rollDeal(e);
 
			
//			return vnode;         	
        }
        
        private function nodeRollOut(e:MouseEvent):void {
            CursorManager.setCursor(HAND_CURSOR,3);
             if(!VisualGraph.mode)
                        this.rollDeal(e);
        }
        
        /**
         * Remove a "view" object (UIComponent) for the given node and specify whether
         * this should honor any specified add/remove effects.
         * These methods are only exported to be used by
         * the VisualNode. Alas, AS does not provide the "friend" directive.
         * Not sure how to get around this problem right now.
         * @param component The UIComponent to be removed.
         * @param honorEffect To specify whether the effect should be applied or not.
         * */
        protected function removeComponent(component:UIComponent, honorEffect:Boolean = true):void {
            
            var vn:IVisualNode;
            
            /* if there is an effect, start the effect and register a
            * handler that actually calls this method again, but
            * with honorEffect set to false */
            if(honorEffect && (removeItemEffect != null)) {
                removeItemEffect.addEventListener(EffectEvent.EFFECT_END,
                    removeEffectDone);
                removeItemEffect.createInstance(component).startEffect();
            } else {
                /* remove the component from it's parent (which should be the canvas) */
                if(component.parent != null) {
                    component.parent.removeChild(component);
                }
                
                /* remove event mouse listeners */
                component.removeEventListener(MouseEvent.DOUBLE_CLICK,nodeDoubleClick);
                component.removeEventListener(MouseEvent.MOUSE_DOWN,nodeMouseDown);
                component.removeEventListener(MouseEvent.CLICK,nodeMouseClick);
                component.removeEventListener(MouseEvent.MOUSE_UP, dragEnd);
                
                /* get the associated VNode and remove the view from it
                * and also remove the map entry */
                vn = _viewToVNodeMap[component];
                vn.view = null;
                delete _viewToVNodeMap[component];
                
                /* decreate component counter */
                --_componentCounter;
                
                //LogUtil.debug(_LOG, "removed component from node:"+vn.id);
            }
        }
        
        private var _currentEdge:IVisualEdge;
        public function get currentEdge():IVisualEdge{
        	return _currentEdge;
        }
        private function edgeDoubleClick(e:MouseEvent):void{
        	if(mode){
        		var comp:UIComponent;
        		var vedge:IVisualEdge;
			            
			            
			            /* get the view object that was klicked on (actually
			            * the one that has the event handler registered, which
			            * is the VNode's view */
			            comp = (e.currentTarget as UIComponent);           
			            /* get the associated VNode */
			            vedge = this.lookupEdge(comp);
			            this._currentEdge = vedge;
			
						if(vedge != null){
							        var evt:VisualEdgeEvent = new VisualEdgeEvent(VisualEdgeEvent.EDGE_DOUBLE_CLICK,vedge.edge,e.ctrlKey);
						            dispatchEvent(evt);
						            //LogUtil.debug(_LOG, "double click!");
						            
						            var fromNode:String = this.getNamefromId(vedge.edge.node1.vnode);
						            var toNode:String = this.getNamefromId(vedge.edge.node2.vnode);
								    this.edgeSetPara(fromNode,toNode);   //fromNode,toNode

//						            this.flowDesi(vedge);

						}
        	}else{
        		mx.controls.Alert.show("It is not in the Edit Mode,edgeDoubleclick is not enable");
        	}

}

		
		private function edgerollDeal(e:MouseEvent):void{
						var comp:UIComponent;
			            var vedge:IVisualEdge;
			            
			            
			            /* get the view object that was klicked on (actually
			            * the one that has the event handler registered, which
			            * is the VNode's view */
			            comp = (e.currentTarget as UIComponent);           
			            /* get the associated VNode */
			            vedge = this.lookupEdge(comp);
			            this._currentEdge = vedge;
			
						if(vedge != null){
							        var evt:VisualEdgeEvent = new VisualEdgeEvent(VisualEdgeEvent.EDGE_DOUBLE_CLICK,vedge.edge,e.ctrlKey);
						            dispatchEvent(evt);
						}
		}
        
        private function edgeRollOver(e:MouseEvent):void{
        		CursorManager.removeAllCursors();
        		this.edgerollDeal(e);

        		
        }
        
		private function flowDesi(currentEdge:IVisualEdge):void{
			          
				          var vnode1:IVisualNode =currentEdge.edge.node1.vnode;
				          var vnode2:IVisualNode = currentEdge.edge.node2.vnode;
				          var id1:String = vnode1.id.toString();
				          var id2:String = vnode2.id.toString();
				          
//				          mx.controls.Alert.show(id1+"  "+id2);
				          
				   var dic1:Dictionary = Graph(this.graph).getDic1();
           			var dataCom:Array = new Array();
           
            for (var key:String in dic1){
         
            	if(id1 == dic1[key]){
//            		mx.controls.Alert.show(" id:  "+ id1 + " name : "+key);
					var key1:String=key;
					dataCom.push(key);

            	}else if(id2== dic1[key]){
            		var key2:String = key;
//            		mx.controls.Alert.show(" id:  "+ id2 + " name : "+key);
            		dataCom.push(key);
            	}
            	if(dataCom.length ==2)
            			break;
            }
            
             if(key1 == "Output_0" || key2=="Output_0"){
		  				mx.controls.Alert.show("The edge to  node: Output no need to match the parameters! ");
		  				return ;
  			}
          				var flowDes:flowDesicion = new flowDesicion();
          				flowDes.addEventListener("fromNodeSure",fromNodeSure);
						PopUpManager.addPopUp(flowDes,this,false);
						flowDes.FromNode.dataProvider = dataCom;
						flowDes.toNode.dataProvider = dataCom;
						PopUpManager.centerPopUp(flowDes);
		}
        
        private function fromNodeSure(e:Event):void{
        		var flowDe:flowDesicion = e.currentTarget as flowDesicion;
        		var fromNode:String =flowDe.FromNode.selectedItem.toString();
        		var toNode:String = flowDe.toNode.selectedItem.toString();
        		
        		if(fromNode == toNode){
        			mx.controls.Alert.show("FromNode  must be different with ToNode");
        		}else{        			
        			var dic1:Dictionary = Graph(this.graph).getDic1();
        			var id1:String = this._currentEdge.edge.node1.id.toString();
					for (var key:String in dic1){        
		            	if(id1 == dic1[key]){
//		            		mx.controls.Alert.show(" id:  "+ id1 + " name : "+key);
							break;
		            	}
          		  	}
  	  				var rootName:String = String( Graph.selectedData.getItemAt(0) ) ;
					var rootId:int = int(dic1[rootName] );
					var rootNode:IVisualNode = this._graph.nodeById(rootId).vnode;
//								trace(rootName)
//          		  if(key != fromNode&& key ==dic1[rootName]){
//          		  	mx.controls.Alert.show("This edge could not be reversed ,for "+key+ "is rootNode");
//          		  	return ;
//          		  }
          		  	flowDe.closeMe();
          		  	if(key != fromNode){
          		  		         		  				
						var node1:IVisualNode =	this._currentEdge.edge.node1.vnode;
						var node2:IVisualNode = this._currentEdge.edge.node2.vnode;				
						this.unlinkNodes(node1,node2);
						var vedge:IVisualEdge = this.linkNodes(node2,node1);		

//						var index:int = (Graph.selectedDataChild[toNode] as ArrayCollection).getItemIndex(fromNode);
//						(Graph.selectedDataChild[toNode] as ArrayCollection).removeItemAt(index);
//						
//						(Graph.selectedDataChild[fromNode] as ArrayCollection).addItem(toNode);

						var index2 :int = (Graph.selectedDataChild[rootName] as ArrayCollection).getItemIndex(toNode);
						//toNode才是原来的根节点
						//判断一下原来的fromNode的父节点是不是根节点，如果不是的根节点的话，就不动原来那个fromNode的父节点,
						//把自己接到父节点上
						//如果是根节点的话，那就把根节点座位作为现在的fromNode的父节点，去掉原来的fromNode和根节点的那条边
						if(index2 != -1){
								
//							(Graph.selectedDataChild[rootName] as ArrayCollection).removeItemAt(index2);
							this.unlinkNodes(rootNode,node1);										
						}
//								(Graph.selectedDataChild[rootName] as ArrayCollection).addItem(fromNode);
						this.linkNodes(rootNode,node2);								
          		  	}         		  
          		
					this.edgeSetPara(fromNode,toNode);

				}
        		
        }
        	
        private function edgeSetPara(fromNode:String ,toNode:String):void{//fromNode:String ,toNode:String   
             if(_currentEdge != null){ 
	        	 if (_currentEdge.isLoopEdge){
						var whileCondition:Condition = new Condition();
						whileCondition.addEventListener("saveConditon",onSaveCondition);
						whileCondition.addEventListener("cancelConditon",cancelConditon);
						whileCondition.addEventListener("VariableforUserInput",setVariableforUserInput);
						PopUpManager.addPopUp(whileCondition,this,false);
						var dataprov:ArrayCollection = new ArrayCollection();			
						for  (var key:String in varWarehouse){
							dataprov.addItem(key);
						}
						this.dataPro = dataprov;
						CreateConditon(whileCondition);
						PopUpManager.centerPopUp(whileCondition);
						
						return ;
						
	        	}else{       	
	        		
	        		if(!_currentEdge.edge.isSetParameter){
			        	var httpservice:HTTPService = new HTTPService();
						var urlstr:String ="http://localhost:8080/mobileMashup/paraConfig?service1Name="+fromNode+"\&service2Name="+toNode;		
						 //"mashupBuild/data/para.xml"
						//trace ("edgeHttphandle urlstr  "+urlstr)
						httpservice.url = urlstr;
						httpservice.resultFormat ="e4x";
						httpservice.addEventListener(ResultEvent.RESULT,edgeHttphandle);			
						httpservice.send();						        			
	        		}else{

						PopUpManager.addPopUp(this._currentEdge.paraSetPanel,this,false);     
						PopUpManager.centerPopUp(this._currentEdge.paraSetPanel);
	        		}
	        	}
             }
        }
        private function cancelPara(e:Event):void{
        	var xx:ParaSet = e.currentTarget as ParaSet;
        	PopUpManager.removePopUp(xx);
//        	this.clearPara(xx);

        }
        
//        private function clearPara(xx:ParaSet):void{
//        	       xx.fromNodeVbox.removeAllChildren();
//        			xx.toNodeVbox.removeAllChildren();
//        			xx.semanticVbox.removeAllChildren();
//        }

		/**
		 * set linkage between services.
		 * */
       	private function onSet(e:Event):void{
       		var paraSetPanel:ParaSet = e.currentTarget as ParaSet;
       		if(!this._currentEdge.isLoopEdge){ //!this.isCircle(this._currentEdge)      			
       			var node1Id:String = this._currentEdge.edge.node1.id.toString();//node1的id
       			var node2Id:String  = this._currentEdge.edge.node2.id.toString();//node2的ID
       			
       			this._currentEdge.edge.node2.inputs[node1Id] = new Dictionary();
       			var tempDic:Dictionary = this._currentEdge.edge.node2.inputs[node1Id] as Dictionary;
       			
       			//获取node1的inputs 和outputs
       			var node1Outputs:Dictionary = this._currentEdge.edge.node1.outputs as Dictionary;
       			var node1Inputs:Dictionary = this._currentEdge.edge.node1.inputs as Dictionary;
       			
       			for(var j:int=0;j<paraSetPanel.toNodeVbox.getChildren().length;j++){       				
       				//node2InputName指的是第二个节点的label，即node2的输入参数input
       				var node2InputName:String =( paraSetPanel.fromNodeVbox.getChildAt(j) as Label).text;
       				//以node2InputName参数最为key建一个数组
       				tempDic[node2InputName] = new Array();
       				var tempArray:Array = tempDic[node2InputName] as Array;
       				
       				//对第一个节点做特殊处理
       				if(this._currentEdge.edge.node1.id == 1){
						//为第一个节点的参数得到type
       					var type:String =(paraSetPanel.typeVbox.getChildAt(j) as Label).text;      					
       					//只是对node1Outputs建一个key，key就是该参数
       					if(!node1Outputs.hasOwnProperty(node2InputName))
       					{
       						node1Outputs[node2InputName] ="";
       					}
       					//这里的node1Inputs输出点，即node2的id为key
       					if(!node1Inputs.hasOwnProperty(node2Id))
       					{
       						node1Inputs[node2Id] = new Dictionary;
       					}
       					     					
       					var temproot:Dictionary = node1Inputs[node2Id] as Dictionary;
       					//正对每一个参数为key建一个dictionary
       					if(!temproot.hasOwnProperty(node2InputName))
       					{
       						temproot[node2InputName] = new Array;
       					}
       					var temppara:Array = temproot[node2InputName] as Array;
       					temppara[0] = type;
       					temppara[1 ] = "";
//       					continue;
       				}
       				
       				if(paraSetPanel.toNodeVbox.getChildAt(j) is ComboBox){ // may be "Auto" or "userInput" mode.
       					if( (paraSetPanel.toNodeVbox.getChildAt(j) as ComboBox).selectedItem != null){
       						var toNode:String = (paraSetPanel.toNodeVbox.getChildAt(j) as ComboBox).selectedItem.toString();
       						tempArray[0] = toNode;
       					}else {
       						tempArray[0] = "";
       					}
       					if((paraSetPanel.selectVbox.getChildAt(j) as ComboBox).selectedItem.toString() == "Auto") { // "Auto" mode.       					
	       					var semantic:Label = paraSetPanel.semanticVbox.getChildAt(j) as Label;
	       					tempArray[1] = String(semantic.text);       						
       					} else {
       						tempArray[1] = "userInput";
       					}
       				}else if(paraSetPanel.toNodeVbox.getChildAt(j) is TextInput){
       					var toNodetext:String = (paraSetPanel.toNodeVbox.getChildAt(j) as TextInput).text.toString();
       					tempArray[0] = toNodetext;
       					tempArray[1] = "equalSemantic";//equalSemantic
       				}
       			}
       			var tempnode2:Dictionary = this._currentEdge.edge.node2.outputs as Dictionary;
       			for (var i:int =0;i<paraSetPanel.outputVbox.getChildren().length;i++){
       				var output:String =(paraSetPanel.outputVbox.getChildAt(i) as Label).text;
       				if(!tempnode2.hasOwnProperty(output))
       				{
       					tempnode2[output] ="";
       				}
       			}
       		}
       		this._currentEdge.edge.isSetParameter = true;
       		
       		var attname:String;
       		var attrs:Array;
       		var lineStyle:Object = this._currentEdge.lineStyle as Object;
       		attrs = ObjectUtil.getClassInfo(lineStyle).properties;
       		for each(attname in attrs) {
       			if(attname =="color"){
       				lineStyle[attname] = "oxffffff";
       				
       			}else if(attname =="alpha"){
       				lineStyle[attname] = "0.8";
       			}
       			
       		}
       		this.edgeRenderer.draw(this._currentEdge);
//       		this.cancelPara(e);
			PopUpManager.removePopUp(paraSetPanel);
       	}
       	
       	private  var CountLabel:int = 65;
       	
       	private static  var sybPro:Array = ["==","<",">","!=","<=",">="];
       	private var dataPro:ArrayCollection = new ArrayCollection;
       	
       	private function onSaveCondition(e:Event):void{
       		trace("in function onSaveCondition");
       		var conDi:Condition = e.currentTarget as Condition;
       		var lab:ArrayCollection =new ArrayCollection( );
       		for each(var item :Label in conDi.labelVbox.getChildren()){
       			lab.addItem(item.text);
       		}
       		var input:String =String(conDi.conditionExpression.text);
       		var textinput:ArrayCollection = new ArrayCollection();
       		for each (var ii:TextInput in conDi.textInputVbox.getChildren()){
       			textinput.addItem(ii.text);
       		}
//       		trace(textinput);
       		var theTrans:inToPost = new inToPost(input,lab);
//       		trace(String(theTrans.getnewstrs()));
       		if(theTrans.check(theTrans.getnewstrs(),textinput) ){
       			var output:String =theTrans.doTrans();
       			var temp:String = output;
       			for (var j :int= 0; j < output.length; j++) {
       				var ch:String = output.charAt(j);
       				if(ch<='Z' && ch>='A'){
       					trace("ch="+ch);
       					var index:int = ch.charCodeAt(0)-65;
       					var selectedPara:String = (conDi.paraVbox.getChildAt(index) as ComboBox).selectedItem.toString();
       					var selectedSyb:String = (conDi.sysVbox.getChildAt(index) as ComboBox).selectedItem.toString();
       					var selectedtextinput:String =textinput.getItemAt(index) as String;
       					trace (selectedPara+"  "+selectedSyb+"   "+selectedtextinput);
       					var node1Id:String = this._currentEdge.edge.node1.id.toString();
       					var conExpre:String = " ?"+node1Id+"\."+selectedPara+"  "+selectedSyb+"  "+selectedtextinput;
       					
       					temp =StringReplaceAll(temp,ch,conExpre);
//       					temp = StringReplaceAll(temp,"&","\&");
//       					temp = StringReplaceAll(temp,"|","\|");
       					trace(temp);
       				}
       			}
       			if(!this._currentEdge.isLoopEdge){ //!this.isCircle(this._currentEdge)
       				var tempcon:Dictionary = this._currentEdge.edge.node2.condition as Dictionary;
       				tempcon[this._currentEdge.edge.node1.id.toString()]= temp;
       			}
       			else
       			{
       				var tempwhile:Dictionary = 	this._currentEdge.edge.node2.whileCondition as Dictionary;
       				tempwhile[this._currentEdge.edge.node1.id.toString()] = temp;
       			}
       			
       			this._currentEdge.edge.isSetCondition =true;
       			this.cancelConditon(e);
       			this.clearCondition(conDi);
       			
       			
       		}
       	}
		
		private function clearCondition(conDi:Condition):void{
//			conDi.labelVbox.removeAllChildren();
//			conDi.paraVbox.removeAllChildren();
//			conDi.sysVbox.removeAllChildren();
//			conDi.textInputVbox.removeAllChildren();
//			conDi.AddVbox.removeAllChildren();
			
			this.CountLabel = 65;
		}
		/** 
		 * StringReplaceAll 
		 * @param source:String 源数据 
		 * @param find:String 替换对象 
		 * @param replacement:Sring 替换内容 
		 * @return String 
		 * **/  
		 private function StringReplaceAll( source:String, find:String, replacement:String ):String{  
		    return source.split( find ).join( replacement );  
		 }  
//		private var  conditionPanel:Condition;
		
		private function setCondition(e:Event):void{
			var para:ParaSet = e.currentTarget as ParaSet;
			if(this._currentEdge.edge.isSetCondition){
					PopUpManager.addPopUp(this._currentEdge.conditionPanel,para,false);
					PopUpManager.centerPopUp(this._currentEdge.conditionPanel);
			}else{
				setConditionNew(para);
			}
		}
		private function setConditionNew(para:ParaSet):void{
			trace("in setCondition")			
			 var dataprov:ArrayCollection = new ArrayCollection();
			for each(var label:Label in para.fromNodeVbox.getChildren() ){
				dataprov.addItem(label.text);
			}
			
			for  (var key:String in varWarehouse){
					dataprov.addItem(key);
			}
			this.dataPro = dataprov;
//			Alert.show(String(dataPro));
//			conditionPanel = new Condition();
			 var conInstance:Condition = new Condition();
			 this._currentEdge.conditionPanel = conInstance;
			 
			conInstance.addEventListener("saveConditon",onSaveCondition);
			conInstance.addEventListener("cancelConditon",cancelConditon);
//			trace(this._currentEdge.isLoopEdge)
//			if(this._currentEdge.isLoopEdge){
//				conInstance.addEventListener("VariableforUserInput",setVariableforUserInput);
//				
//			}
			PopUpManager.addPopUp(conInstance,para,false);
			CreateConditon(conInstance);
			PopUpManager.centerPopUp(conInstance);
	
		}
		private function cancelConditon(e:Event):void{
			var conDi:Condition = e.currentTarget as Condition;
			PopUpManager.removePopUp(conDi);
//			this.CountLabel = 65;
			this.clearCondition(conDi);
		}
		
		private function CreateConditon(conInstance:Condition):void{		
			var cnt:Label = new Label();
			var lab:String =String.fromCharCode(CountLabel);
			cnt.text = lab;
//			trace(CountLabel+"    "+cnt.text)
			conInstance.labelVbox.addChild(cnt);
			
			var para:ComboBox = new ComboBox();
			para.dataProvider = dataPro;
			BindingUtils.bindProperty(cnt, "height", para, "height");
			conInstance.paraVbox.addChild(para);
			
			var syb:ComboBox = new ComboBox();
			syb.dataProvider = sybPro;
			conInstance.sysVbox.addChild(syb);
			
			var textinput:TextInput = new TextInput();
			conInstance.textInputVbox.addChild(textinput);
			
			var addbutton:Button = new Button();
			addbutton.label ="+";
			addbutton.addEventListener(MouseEvent.CLICK,AddCondition);
			conInstance.AddVbox.addChild(addbutton);
			
			CountLabel++;
		}
		
		private function AddCondition(e:MouseEvent):void{
			if(CountLabel>90){
				mx.controls.Alert.show("Your conditions  are Too Much!!");
				return ;
			}
			var conInstance:Condition = (e.currentTarget as Button).parent.parent.parent.parent.parent as Condition;
			CreateConditon(conInstance);
			
		}		
		
		private static const ParameterMode:Array=["Auto","Custom","userInput"];
		
        private function edgeHttphandle (e:ResultEvent):void{
			var paraXml:XML = e.result as XML;
   
			if(paraXml != null &&!this._currentEdge.isLoopEdge ){
				var para:ParaSet = new ParaSet();		
				this._currentEdge.paraSetPanel = para;
				para.addEventListener("setPara",onSet);
				para.addEventListener("cancelPara",cancelPara);
				para.addEventListener("setCondition",setCondition);
				para.addEventListener("VariableforUserInput",setVariableforUserInput);
				PopUpManager.addPopUp(para,this,false);
				
				var fromVbox:VBox = para.fromNodeVbox;
				var typeVbox:VBox  = para.typeVbox;
				para.xmldata = paraXml;
				for each (var item:XML in paraXml..para2) { 								
					var name:String  = String(item.@name);
					var para1:Label = new Label();
					para1.text = name;
					fromVbox.addChild(para1);
					
					var type:String = String(item.@type);
					var type1:Label = new Label();
					type1.text = type;
					type1.visible = false;
					typeVbox.addChild(type1);		
																			
					var selectBox:VBox = para.selectVbox;
					var select:ComboBox = new ComboBox();
					select.dataProvider = ParameterMode;		
					select.addEventListener(ListEvent.CHANGE,modeChose);
					select.selectedIndex = 0;
					selectBox.addChild(select);
					this.modeChange(para,select,false);
				}
				
				/* get outputs of toNode and store them in a invisible VBox control temporarily.*/
				var outputVbox:VBox = para.outputVbox;
				for each(var output:XML in paraXml..para3){
					var out:String = String(output.@name);
					var outs:Label = new Label();
					outs.text = out;
					outs.visible = false;
					outputVbox.addChild(outs);		
				}
				
				PopUpManager.centerPopUp(para);        			       							
        	}else{
        		mx.controls.Alert.show("No such connection ,or your direction is error \n you can reverse your direction ");
				//先进行判断目前所在的这条边是不是loop边，如果是的话，那么返回的xml为空也进行那个的
        	}
        }
        	
        	
//			private function isCircle(vedge:IVisualEdge):Boolean{
//				 					var isExist:Boolean = false;
//				 					var isloop:Boolean = false;
//								 for (var nods:String in loopDictionary ){
//							 		if(nods == vedge.edge.node2.id.toString()){
//							 			 isExist = true;
//							 				break;
//							 		}
//							 }
//							 if(!isExist)return false;
//							 var temparr:ArrayCollection =  loopDictionary[nods] as ArrayCollection ;
////							 var id:String = vedge.edge.node1.id.toString();
//							 var index:int =temparr.getItemIndex(vedge.edge.node1);
//							 trace(index)
//							 if(index != -1 ) isloop = true;
//							 
//							 return isloop;
//			}
			
		private function modeChange(para:ParaSet,select:ComboBox,removable:Boolean):void{
			var key:String = select.selectedItem.toString();
			var index:int = (select.parent as VBox).getChildIndex(select);
			
			var fromVbox:VBox = para.fromNodeVbox;  //是输入的高度和模式选择的Combobox高度一致
			var  InputsName:Label = fromVbox.getChildAt(index) as Label;
			BindingUtils.bindProperty(InputsName,"height",select,"height");
			
			
			var toVbox:VBox = para.toNodeVbox as VBox;
			var xmldata:XML = para.xmldata ;
			var i:int = 0;
			for each (var item:XML in xmldata..para2){
				if(i == index){
					break;
				}
				 i++;
			}

			if(key == "Auto"){																			   
				var data:ArrayCollection = new ArrayCollection();
				i=0;
				for each (var node:XML in item.children()){
					if(i == 0) {i++;continue;}
								data.addItem(String(node.@name));	
				}
				var Cbb:ComboBox = 	new ComboBox();
	 		 
				Cbb.dataProvider = data;
				Cbb.addEventListener(ListEvent.CHANGE,datasetter);	
				toVbox.addChildAt(Cbb,index);	
				if(removable)
					toVbox.removeChildAt(index+1);				
				if(!removable)																		
					this.dataset(para,Cbb,true);//根据模式，最开始建立的时候，只建立，不删除
				else 
					this.dataset(para,Cbb,false);//根据模式，第二次建立的时候，建立，也删除
						
			}else if(key == "Custom"){
				var textinput:TextInput = new TextInput();
				textinput.text = item.defaultValue;

				toVbox.addChildAt(textinput,index);
				if(removable)
							toVbox.removeChildAt(index+1);
							
				var semanVbo:VBox = para.semanticVbox;		
				var lab:Label = new Label()
				lab.text = "";
				BindingUtils.bindProperty(lab,"height",textinput,"height");
				semanVbo.addChildAt(lab,index);
				if(removable)
					semanVbo.removeChildAt(index+1);
							
							
			}else if(key == "userInput"){
				var userinputVars:ArrayCollection = new ArrayCollection();
				var fromId:String = this._currentEdge.edge.node1.id.toString();
				var inputsForUser:Dictionary = this._currentEdge.edge.node2.userInputs[fromId];
				for  (var userVarName:String  in inputsForUser ){
					userinputVars.addItem(userVarName);
				}
				
				var userinputVarsCbb:ComboBox = new ComboBox();	 		 
				userinputVarsCbb.dataProvider = userinputVars;
				userinputVarsCbb.addEventListener(ListEvent.CHANGE,datasetter);
				userinputVarsCbb.selectedIndex = 0;
				toVbox.addChildAt(userinputVarsCbb,index);	
				if(removable)
					toVbox.removeChildAt(index+1);				
				if(!removable)																		
					this.dataset(para,userinputVarsCbb,true);//根据模式，最开始建立的时候，只建立，不删除
				else 
					this.dataset(para,userinputVarsCbb,false);//根据模式，第二次建立的时候，建立，也删除
			}
			 
		}
		private function datasetter(e:Event):void{
			var combo:ComboBox = e.currentTarget as ComboBox;
			var para:ParaSet = combo.parent.parent.parent.parent as ParaSet;
			this.dataset(para,combo,false); //建立也删除的模式
		}
		private function dataset(para:ParaSet,select:ComboBox,construct:Boolean):void{
			var index:int = (select.parent as VBox).getChildIndex(select);
			var xmldata:XML = para.xmldata ;
			var i:int = 0;
			for each (var item:XML in xmldata..para2){
				if(i == index){
					break;
				}
				 i++;
			}
			var text:String =" ";
			if(select.selectedItem != null){
				var selected:String = select.selectedItem.toString();
				for each (var node:XML in item.children()){
					if(String(node.@name) == selected)	{
						text = String(node.@semantic);												
						break;
					}
				}
			}								
			var seman:VBox = para.semanticVbox ;			
			var lab1:Label = new Label();					
			seman.addChildAt(lab1,index);
			lab1.text = text;											
			if(!construct)
				seman.removeChildAt(index+1);
			BindingUtils.bindProperty(lab1,"height",select,"height");							
		}
			
			
			private function modeChose(e:Event):void{
				var select:ComboBox = e.currentTarget as ComboBox;				
				var para:ParaSet = select.parent.parent.parent.parent as ParaSet;
				this.modeChange(para,select,true);
			}

			private function createParaBox(paras:assignMent):void{
				var flag:Boolean = false;
				for (var temp:String in  varWarehouse){
					// if varWarehouse is not empty, do the following work for once.
					flag= true;
				//上面一个选框的数据
					var paraVbox:VBox = paras.paraVbox as VBox;
					var combo:ComboBox = new ComboBox();
					var glovaria:ArrayCollection = new ArrayCollection();
					for (var item:String in varWarehouse){
						glovaria.addItem(item);
					}
					combo.dataProvider = glovaria;
					combo.selectedItem = String(glovaria.getItemAt(0));
					combo.addEventListener(ListEvent.CHANGE,typeSetter);
					trace(String(glovaria));
					paraVbox.addChild(combo);
					
					//下面一个选框
//					var variVbox:VBox = paras.variVbox as VBox;
//					var comx:ComboBox = new ComboBox();
//					comx.dataProvider = glovaria;
					
					
					
					var typeVbox:VBox = paras.typeVbox as VBox;
					var type:Label = new Label();
					var select:String = combo.selectedItem.toString();
					trace(select);
					type.text = (varWarehouse[select] as Array)[0];
					BindingUtils.bindProperty(type, "height", combo, "height");
					typeVbox.addChild(type);
					
//					BindingUtils.bindProperty(type, "text", para, "height");
					var sysVbox :VBox = paras.sysVbox as VBox;
					var lab:Label = new Label();
					lab.text = " =";
					BindingUtils.bindProperty(lab, "height", combo, "height");
					sysVbox.addChild(lab);
					
					var textinputVbox:VBox = paras.textInputVbox as VBox;
					var textinput:TextInput = new TextInput();
					textinputVbox.addChild(textinput);
					
					//赋值的add 和remove
					var addVbox:VBox = paras.addVbox as VBox;
					var addbtn:Button = new Button();
					addbtn.label = "+";
					addbtn.addEventListener(MouseEvent.CLICK,addPara);
					addVbox.addChild(addbtn);
					
					var removeVbox:VBox = paras.removeVbox as VBox;
					var removebtn:Button = new Button();
					removebtn.label = "-";
					removebtn.id = String( this.CountLabel );
					removebtn.addEventListener(MouseEvent.CLICK,removePara);
					removeVbox.addChild(removebtn);
					
					//手机用户输入的add和remove
//					var addlabel:VBox = paras.addLabel as VBox;
//					var addb:Button = new Button();
//					addb.label = "+";
//					addb.addEventListener(MouseEvent.CLICK,addPara);
//					addlabel.addChild(addb);
//					
//					var removeLabel:VBox = paras.removeLabel as VBox;
//					var removeb:Button = new Button();
//					removeb.label = "-";
//					removeb.id = String( this.CountLabel );
//					removeb.addEventListener(MouseEvent.CLICK,removePara);
//					removeLabel.addChild(removeb);
					
					this.CountLabel ++;
					if(flag)
						break;
				}
			}
			
			/**
			 * when double click on the edge, user can add variable to this linkage, which may or may not need user to input.
			 * these added variables will be considered as part of the end node.
			 * TODO: function of deleting a variable.
			 * */
			private function setVariableforUserInput(e:Event):void{
				var userinputPanel:variableForUserInput = new variableForUserInput();				
				if(e.currentTarget is ParaSet){
					var para:ParaSet = e.currentTarget as ParaSet ;
					PopUpManager.addPopUp(userinputPanel,para,false);
				}else if(e.currentTarget is Condition){
					var con:Condition = e.currentTarget as Condition;
					PopUpManager.addPopUp(userinputPanel,con,false);
				}
				
				/* get the existed variables for the end node.*/
				var existVar:VBox = userinputPanel.existingVar as VBox;
				var fromId:String = this._currentEdge.edge.node1.id.toString();
				var inputsForUser:Dictionary = this._currentEdge.edge.node2.userInputs[fromId];
				for  (var key:String  in inputsForUser ){
					var lab:Label = new Label();
					var type:String =( inputsForUser[key] as Array)[0];
					lab.text = key +":  "+type +"= "+ ( inputsForUser[key] as Array)[1];
					existVar.addChild(lab);
				}
								
				userinputPanel.addEventListener("saveVariableForUserInput",onSaveUserInput);
				userinputPanel.addEventListener("cancelVariableForUserInput",onCancelUserInput);
				
				createUserInput(userinputPanel);
				PopUpManager.centerPopUp(userinputPanel);
			}
			
			/**
			 * format: this._currentEdge.edge.node2.userInputs[fromNodeId][varName] : Array[type, value].
			 * */
			private function onSaveUserInput(e:Event):void{
				var userInput:variableForUserInput = e.currentTarget as variableForUserInput;				
				var inputsForUser:Dictionary = this._currentEdge.edge.node2.userInputs;
				var id:String = this._currentEdge.edge.node1.id.toString();
				inputsForUser[id] = new Dictionary;				
				var newVarDic:Dictionary = inputsForUser[id] ;
				
				for (var i:int =0 ;i<userInput.addVar.getChildren().length;i++){
					var newVarName:TextInput = userInput.addVar.getChildAt(i) as TextInput ;
					var type:String = ( userInput.typeVar.getChildAt(i) as ComboBox ).selectedItem.toString();
					var init:TextInput = userInput.initVar.getChildAt(i) as TextInput ;
					var value:String = String(init.text);	
					if(newVarName.text !=""){
						var key:String = String(newVarName.text);
						newVarDic[key] = new Array();
						var newarr:Array = newVarDic[key] as Array;
						newarr[0] = type;
						newarr[1] = value;					
					}
				}
				onCancelUserInput(e);
			}
			
			private function onCancelUserInput(e:Event):void{
			    var userinputPanel:variableForUserInput  = e.currentTarget as variableForUserInput;
    			PopUpManager.removePopUp(userinputPanel);
    			clearUserInput(e);
			}
			
			private function clearUserInput(e:Event):void{
			    var userinputPanel:variableForUserInput  = e.currentTarget as variableForUserInput;
				userinputPanel.addLabel.removeAllChildren();
	        	userinputPanel.addVar.removeAllChildren();
	        	userinputPanel.typeVar.removeAllChildren();
	        	userinputPanel.existingVar.removeAllChildren();
			}
			
			private  var CountUser:int = 65;
			
			private function createUserInput(paras:variableForUserInput):void{
	       		var addVar:VBox = paras.addVar as VBox;
	        	var newvar:TextInput = new TextInput();
	        	addVar.addChild(newvar);
	        	
	        	var typeVar:VBox = paras.typeVar as VBox;
	        	var type:ComboBox = new ComboBox();
	        	type.dataProvider = varType;
	        	typeVar.addChild(type);
	        	
	        	var initVar:VBox = paras.initVar as VBox;
	        	var init:TextInput = new TextInput();
	        	initVar.addChild(init);
	        	
	        	var addlab:VBox = paras.addLabel as VBox;
	        	var addBtn:Button = new Button();
	        	addBtn.label = "+";
	        	addBtn.addEventListener(MouseEvent.CLICK,addUserinputVariable);
	        	addlab.addChild(addBtn);
			}
			
	        private function addUserinputVariable(e:Event):void{
				var addbtn:Button  = e.currentTarget as Button;
				var parent:variableForUserInput = addbtn.parent.parent.parent.parent.parent.parent as variableForUserInput;
				
				this.createUserInput(parent);
        	
        	}
			
			private function typeSetter(e:Event):void{
				 var combo:ComboBox = e.currentTarget as ComboBox;
				 var key:String = combo.selectedItem.toString();			  
				 trace(key)
				 
				 var parent:VBox = combo.parent as VBox;
				 var index:int = parent.getChildIndex(combo);
//				 var grandpa:HBox = parent.parent as HBox ;
				var para:assignMent  = combo.parent.parent.parent.parent.parent as assignMent;
				 var typeVbox:VBox = para.typeVbox as VBox;
				 var type:Label = typeVbox.getChildAt(index) as Label;
				 type.text = (varWarehouse[key] as Array)[0];
				
				 trace(type)
				 
				 
				 
			}
        private function removePara(e:MouseEvent):void{
        			var btn:Button = e.currentTarget as Button;
        			var para:assignMent = btn.parent.parent.parent.parent.parent as assignMent;
        			var id:int = int(btn.id);
        			var index:int = id - 65;

        			para.paraVbox.removeChildAt(index);
        			para.typeVbox.removeChildAt(index);
        			para.sysVbox.removeChildAt(index);
        			para.textInputVbox.removeChildAt(index);
        			para.addVbox.removeChildAt(index);
        			para.removeVbox.removeChildAt(index);
//        			var paraCount:int = this.CountLabel - 65 -1;
        			this.CountLabel --;
        			for(var j:int=65;j<this.CountLabel;j++){
        					 (para.removeVbox.getChildAt(j-65) as Button).id =String( j);
        			}      			
        }
        
        
        private function addPara(e:MouseEvent):void{
        	        var btn:Button = e.currentTarget as Button;
        			var addpara:assignMent = btn.parent.parent.parent.parent.parent as assignMent;
        				createParaBox(addpara);
        	
        }
        private function edgeRollOut(e:MouseEvent):void{
        	   CursorManager.setCursor(HAND_CURSOR,3);
        	   	this.edgerollDeal(e);
        }
        
        
        
        /**
         * Create a "view" object (UIComponent) for the given edge and
         * return it.
         * @param ve The edge to replace/add a view object.
         * @return The created view object.
         * */
        protected function createVEdgeView(ve:IVisualEdge):UIComponent {
            
            var mycomponent:UIComponent = null;
            
            if(_edgeLabelRendererFactory != null) {
                mycomponent = _edgeLabelRendererFactory.newInstance();
            } else {
                /* this is only for the basic default */
                mycomponent = new Label; // this is our default label.
                mycomponent.setStyle("textAlign","center");
                
                if(ve.data != null) {
                    (mycomponent as Label).text = ve.data.@association;
                }
            }			
            
            /* assigns the edge to the IDataRenderer part of the view
            * this is important to access the data object of the VEdge
            * which contains information for rendering. */		
            if(mycomponent is IDataRenderer) {
                (mycomponent as IDataRenderer).data = ve;
            }
            
            mycomponent.doubleClickEnabled = true;
            
            mycomponent.addEventListener(MouseEvent.DOUBLE_CLICK, edgeDoubleClick);
            mycomponent.addEventListener(MouseEvent.ROLL_OVER, edgeRollOver);
            mycomponent.addEventListener(MouseEvent.ROLL_OUT, edgeRollOut);

            
            /* enable bitmap cachine if required */
            mycomponent.cacheAsBitmap = cacheRendererObjects;
            
            /* add the component to its parent component
            * this can create problems, we have to see where we
            * check for all children
            * Add after the edges layer, but below all other elements such as nodes */
            _canvas.addChildAt(mycomponent, 1);
            
            /* register it the view in the vedge and the mapping */
            /*
            if(ve.labelView != null) {
            LogUtil.debug(_LOG, "Edge:"+ve.edge.id+" has already view:"+ve.labelView.toString()+" will be overwritten");
            } else {
            LogUtil.debug(_LOG, "Edge:"+ve.edge.id+" gets new view.");
            }
            */
            ve.labelView = mycomponent;
            _viewToVEdgeMap[mycomponent] = ve;
            
            /* set initial default x/y values, these should be in the middle of the
            * edge, but depending on the edge renderer. Thus we should ask
            * the edge renderer, where it wants to place the label. This would
            * be a new method for the edge renderer interface */
            if(_edgeRenderer != null) {
                ve.setEdgeLabelCoordinates(_edgeRenderer.labelCoordinates(ve));
            } else {
                ve.setEdgeLabelCoordinates(new Point(_canvas.width / 2.0, _canvas.height / 2.0));
            }
            
            /* we need to invalidate the display list since
            * we created new children */
            refresh();
            
            return mycomponent;
        }
        
        
        /**
         * Remove a "view" object (UIComponent) for the given edge.
         * @param component The UIComponent to be removed.
         * */
        protected function removeVEdgeView(component:UIComponent):void {
            
            var ve:IVisualEdge;
            
            
            /* remove the component from it's parent (which should be the canvas) */
            if(component.parent != null) {
                component.parent.removeChild(component);
            }
            
            /* get the associated VEdge and remove the view from it
            * and also remove the map entry */
            ve = _viewToVEdgeMap[component];
            ve.labelView = null;
            delete _viewToVEdgeMap[component];
            
            /* decreate component counter */
            //--_componentCounter;
            
            //LogUtil.debug(_LOG, "removed component from :"+vn.id);
        }
        
        
        /**
         * Event handler for a removal node procedure. Calls
         * removeComponent with a flag to avoid doing the effect again.
         * */
        protected function removeEffectDone(event:EffectEvent):void {
            var mycomponent:UIComponent = event.effectInstance.target as UIComponent;
            /* call remove component again, but specify to ignore the effect */
            removeComponent(mycomponent, false);
        }
        
        /**
         * Event handler to work on double-click events.
         * Any double click also counts as a drop event to
         * the layouter. But primarily the double click
         * sets a new root node.
         * @param e The corresponding event.
         * */
         
         private var _currentNode:IVisualNode;
        
        protected function nodeDoubleClick(e:MouseEvent):void {
        	var comp:UIComponent;
        	var vnode:IVisualNode;          
				            
            /* get the view object that was klicked on (actually
            * the one that has the event handler registered, which
            * is the VNode's view */
            comp = (e.currentTarget as UIComponent);           
            /* get the associated VNode */
            vnode = lookupNode(comp);
            
            this._currentNode = vnode;
//				            var out:String ="";
//				            for each (var xx:INode in vnode.node.predecessors)
//				            		out =out + String(xx.id);
//				            		
//				            		out= out+"                "  ;
//				             for each (var yy:INode in vnode.node.successors)
//				            		out =out + String(yy.id);
//				          								mx.controls.Alert.show(out);
            var evt:VisualNodeEvent = new VisualNodeEvent(VisualNodeEvent.DOUBLE_CLICK, vnode.node,e.ctrlKey);
            dispatchEvent(evt);
            if(!mode){        	
	            //LogUtil.debug(_LOG, "double click!");

	            /* Now we change the root node, we go through
	            * our public setter method to get all associated
	            * updates done. */
	            var dic3:Dictionary = Graph(this.graph).getDic3();
	 
	            var key:String = this.getNamefromId(vnode);
	
	            var temp:INode = vnode.node;
	            
	            if(temp.id !=1){
	            	 while(1){
	            	 	var edge:IEdge =	temp.inEdges[0];
	//            	 	var toNode:String  = this.getNamefromId(temp.vnode);
	            	 	var othernode:INode = edge.othernode(temp);
	            	 	var parent:String = this.getNamefromId(othernode.vnode);
	            	 	if(Graph.selectedData.contains(parent)) {
	            	 		break;
	            	 	}
	            	 	temp = othernode;
	            	 }
	            	 Graph.preNode = parent;
	            }else Graph.preNode = this.getNamefromId(vnode);
	            
				if(dic3[key] == 0 || dic3[key] == 2){
					Graph(this.graph).flag = dic3[key];
					var httpservice:HTTPService = new HTTPService();
		//			var arr:Array = key.split(".");
		//			key =arr[1];
					var urlstr:String  = this.url+key; //="mashupBuild/data/tree"+key+"\.xml";
					
					httpservice.url = urlstr;
					httpservice.resultFormat ="e4x";
					httpservice.addEventListener(ResultEvent.RESULT,httphandle);
					httpservice.send();	
				}
				else{
					this.currentRootVNode = vnode;
					draw();
				}
           }
           else {
	           	// Set UserInputs and effects.
	        	if(vnode.id.toString() =="1" ){
	        	// If the node is UserInput node.
					var glovar:globalVar = new globalVar();
					PopUpManager.addPopUp(glovar,this,false);
					glovar.addEventListener("saveGlobalVar",saveGlobalVar);
					glovar.addEventListener("cancelGlobalVar",cancelGlobalVar);
					var existVar:VBox = glovar.existingVar as VBox;
					for  (var key2:String  in varWarehouse ){
							var lab:Label = new Label();
							var type:String =( varWarehouse[key2] as Array)[0];
							lab.text = key2 +":  "+type +"= "+ ( varWarehouse[key2] as Array)[1];
							existVar.addChild(lab);
					}
					
						this.createGloVar(glovar);
					
					PopUpManager.centerPopUp(glovar);
	        	}else {
	        		// If the node is not the UserInput node, set effects for the node.
	        		//若全局变量的个数为0，会抛出异常
	        		var assign:assignMent = new assignMent();
	        		PopUpManager.addPopUp(assign,this,false);
	        		assign.addEventListener("saveAssignment",saveAssignment);
	        		assign.addEventListener("cancelAssignment",cancelAssignment);
	        		if(vnode.node.predecessors.length>1){
	        			assign.MashupType.visible = true;
	        			assign.addEventListener("dataMashup",createDataMashup);
	        		}        		
	        		var display:VBox = assign.displayVbox as VBox;
	        		for(key in varWarehouse ){
	        			var keyvalue:String = ( varWarehouse[key] as Array)[1];
	        			if(keyvalue !=""){
	        				var dispalylab:Label = new Label();
	        				var keytype:String = ( varWarehouse[key] as Array)[0];
	        				dispalylab.text = key+":  "+keytype+" = " +keyvalue;
	        				display.addChild(dispalylab);
	        			}
	        		}
	        		this.createParaBox(assign);
//	        		this.createUserInput(assign);
	        		//mx.controls.Alert.show("In the edit mode, doubleclick is  enable if and only if this node is rootNode ")
	        		PopUpManager.centerPopUp(assign);
	        	}
           }
        }
        
        public static const DATAMASHUPTYPE:Array =["isolate","catenate"];
        private function createDataMashup(e:Event):void{       	
			var assign:assignMent = e.currentTarget as assignMent;
			var typeSelect:DataMashup = new DataMashup();
			
			typeSelect.addEventListener("MashupType",onSaveMashupType);
			PopUpManager.addPopUp(typeSelect,assign,false);
//			CreateConditon(MashupType);
			var combo:ComboBox = typeSelect.dataType as ComboBox;
			combo.dataProvider = DATAMASHUPTYPE;
			PopUpManager.centerPopUp(typeSelect);
        }
        
        private function onSaveMashupType(e:Event):void{
        	var typeSelect:DataMashup = e.currentTarget as DataMashup;
        	var node:INode = this._currentNode.node;
        	var combo:ComboBox = typeSelect.dataType as ComboBox;
        	node.mashupType = combo.selectedItem.toString();
        	
        	PopUpManager.removePopUp(typeSelect);

        }
        private function clearAssignment(xx:assignMent):void{
        	        xx.displayVbox.removeAllChildren();
        			xx.paraVbox.removeAllChildren();
        			xx.typeVbox.removeAllChildren();
        			xx.sysVbox.removeAllChildren();
        			xx.textInputVbox.removeAllChildren();
        			xx.addVbox.removeAllChildren();
        			xx.removeVbox.removeAllChildren();
        		
//        			xx.addLabel.removeAllChildren();
//        			xx.removeLabel.removeAllChildren();
//        			xx.variVbox.removeAllChildren();
        			
        				this.CountLabel = 65;
//        				this.CountUser = 65;
        }
        private function cancelAssignment(e:Event):void{
        	var assign:assignMent = e.currentTarget as assignMent;
        		this.CountLabel = 65;
        	        	PopUpManager.removePopUp(assign);
        	        
        }
        private function saveAssignment(e:Event):void{
        	var xx:assignMent = e.currentTarget as assignMent;
        	for(var j:int = 0;j<xx.getChildren().length;j++){
        		var parame:String = (xx.paraVbox.getChildAt(j) as ComboBox).selectedItem.toString();
        		var type:String = (xx.typeVbox.getChildAt(j) as Label).text.toString();
        		var value:String = (xx.textInputVbox.getChildAt(j) as TextInput).text.toString();
									
	//判断类型，目前已经决定由服务器端去进行判断，这边只要传字符串就可以了								
//									trace((varWarehouse[parame] as Array)[0]+"  "+value);
//									switch((varWarehouse[parame] as Array)[0]){										
//										case varType[0] :{
//											 for (var i:int=0;i<value.length;i++){
//											 		if(value.charAt(i)>="0" &&value.charAt(i)<="9"){
//											 			
//											 		}else{
//											 					mx.controls.Alert.show("value :  "+value+" is not type int!!!");
//											 					return ;
//											 		}
//											 }
//											break;
//										}
//										case varType[1]:{
//											break;
//										}
//										case varType[2]:{
//											if(value =="true" || value =="false"){
//												
//											}else{
//																mx.controls.Alert.show("value :  "+value+" is not type Boolean!!!");
//											 					return ;
//											}
//											break;
//										}
//										default:{
//											mx.controls.Alert.show("variable type is error!!");
//											return ;
//										}
//									}
									
									if(value ==""){
											mx.controls.Alert.show("variable value can not be null!!");
											return ;
									}
									var effect:String = parame +" = "+value;
									trace(effect)
									this._currentNode.node.effects.push(effect);
									
									if(!varWarehouse.hasOwnProperty(parame))
										(varWarehouse[parame] as Array) [1]= value;
										
									
					}
					this.clearAssignment(xx);
					this.cancelAssignment(e);
        }
        
        
        private function addVariable(e:Event):void{
        				var addbtn:Button  = e.currentTarget as Button;
        				var parent:globalVar = addbtn.parent.parent.parent.parent.parent.parent as globalVar;
        				
						this.createGloVar(parent);
        	
        }
        
        private static const varType:Array = ["int","string","boolean"];
        private function createGloVar(glovar:globalVar):void{
        	var addVar:VBox = glovar.addVar as VBox;
        	var newvar:TextInput = new TextInput();
        	addVar.addChild(newvar);
        	
        	var typeVar:VBox = glovar.typeVar as VBox;
        	var type:ComboBox = new ComboBox();
        	type.dataProvider = varType;
        	typeVar.addChild(type);
        	
        	var initVar:VBox = glovar.initVar as VBox;
        	var init:TextInput = new TextInput();
        	initVar.addChild(init);
        	
        	var addlab:VBox = glovar.addLabel as VBox;
        	var addBtn:Button = new Button();
        	addBtn.label = "+";
        	addBtn.addEventListener(MouseEvent.CLICK,addVariable);
        	addlab.addChild(addBtn);
        	
        	// assign userinput to each node.
        	var targetServiceVBox:VBox = glovar["targetService"];
        	var combo:ComboBox = new ComboBox();
        	var nodeNames:Array = new Array();
        	var dic1:Dictionary = Graph(this.graph).getDic1();
        	for (var key:String in dic1){
//        		key = key.substring(0, key.lastIndexOf("_"));
        		nodeNames.push(key);
        	}
        	combo.dataProvider = nodeNames;
        	targetServiceVBox.addChild(combo);
        }
        
        private function saveGlobalVar(e:Event):void{
        		var glovar:globalVar  = e.currentTarget as globalVar;
        		
        		/* check that data user inputs are legal.*/
				for (var j:int =0 ;j<glovar.addVar.getChildren().length;j++){
					var ii:TextInput = glovar.addVar.getChildAt(j) as TextInput ;
					trace(ii.text)
					if(ii.text !=""){
						for (var key:String in varWarehouse ){
							if(key == String(ii.text)) 
							{
								mx.controls.Alert.show("variable "+key +"  has already exist!!");														
								return ;
							}
						}
						for(var k:int =0;k<varType.length;k++)	{
							if(String(ii.text) == varType[k]) {
								mx.controls.Alert.show("variable "+String(ii.text) +"  is not avaliable ,for  "+String(ii.text)+" is a key word!!");									
								return ;												
							}
						}
										
						var type:String = ( glovar.typeVar.getChildAt(j) as ComboBox ).selectedItem.toString();
						var init:TextInput = glovar.initVar.getChildAt(j) as TextInput ;
						var value:String = String(init.text);
						var targetServiceName:String = (glovar.targetService.getChildAt(j) as ComboBox).selectedItem.toString();
						//	trace((varWarehouse[parame] as Array)[0]+"  "+value);
						//init value should be the real value ,can not be expression
						switch(type){										
							case varType[0] :{
								 for (var i:int=0;i<value.length;i++){
							 		if(value.charAt(i)>="0" &&value.charAt(i)<="9"){							 			
							 		}else{
					 					mx.controls.Alert.show("value :  "+value+" is not type int!!!");
					 					return ;
							 		}
								 }
								break;
							}
							case varType[1]:{
								break;
							}
							case varType[2]:{
								if(value =="true" || value =="false"){									
								}else{
									mx.controls.Alert.show("value :  "+value+" is not type Boolean!!!");
				 					return ;
								}
								break;
							}
							default:{
								mx.controls.Alert.show("variable type is error!!");
								return ;
							}
						}
								
						if(value ==""){
								mx.controls.Alert.show("variable value can not be null!!");
								return ;
						}
								
//							var key2:String = String(ii.text);
//							 varWarehouse[key2] = new Array();
//							var newarr:Array = varWarehouse[key2] as Array;
//							newarr[0] = type;
//							newarr[1] = value;
//							newarr[2] = targetServiceName;
//							
//							var effect:String = key2 +" = "+value;
//							this._currentNode.node.effects.push(effect);
//									this._currentNode.node.numOfedges++;							
					}
				}
				
				/* store input data.*/
				for (var l:int =0 ;l<glovar.addVar.getChildren().length;l++){
					var m:TextInput = glovar.addVar.getChildAt(l) as TextInput ;
					type = ( glovar.typeVar.getChildAt(l) as ComboBox ).selectedItem.toString();
					init = glovar.initVar.getChildAt(l) as TextInput ;
					value = String(init.text);
					if(m.text !=""){
						var key2:String = String(m.text);
						 varWarehouse[key2] = new Array();
						var newarr:Array = varWarehouse[key2] as Array;
						newarr[0] = type;
						newarr[1] = value;
						
						var effect:String = key2 +" = "+value;
						this._currentNode.node.effects.push(effect);
						this._currentNode.node.numOfedges++;				
					
					}
				}
						  
    		   this.cancelGlobalVar(e);
    		   this.removeVar(glovar);
        }
        
        
        private function cancelGlobalVar(e:Event):void{
        	var glovar:globalVar  = e.currentTarget as globalVar;
        	PopUpManager.removePopUp(glovar);

        	this.removeVar(glovar);
        }
        
        private function removeVar(glovar:globalVar):void{
        	        	glovar.addLabel.removeAllChildren();
        	        	glovar.addVar.removeAllChildren();
        	        	glovar.typeVar.removeAllChildren();
        	        	glovar.existingVar.removeAllChildren();
        	        	
        }
        private function httphandle (e:ResultEvent):void{
        	var xml:XML = e.result as XML;
        	if(xml != null){
			Ravis.xmldata = xml;
			Graph.action="addNode";
			var ravis:Ravis =this.newRavis();
			
			

        	}      	
        }
        
		private function getCurrentXml(xml:XML,findNode:String):void
		{
			var name:String = xml.@name;
			if(name == findNode) 
					tempXml = xml;
		    if(xml.children().length()>0) {
		        for each(var node:XML in xml.children())
		        	arguments.callee(node,findNode);
		
		    }
		
		    
		}
            
		public function revertToXml():XML{
			var selectedData:ArrayCollection = Graph.selectedData ;
			var selectedDataChild:Dictionary = Graph.selectedDataChild;
			 
			var tree:ArrayCollection = new ArrayCollection();
			tree.addItem(selectedData[0]);
			var xmlTemp:XML= <concept name= ""></concept>;
			xmlTemp.@name =selectedData[0];
			
			for each (var item:String in tree){
				getCurrentXml(xmlTemp,item);	 
				for each (var key:String in selectedDataChild[item]){
					var xmlDataChild:XML =  <concept name= ""></concept> ;
					xmlDataChild.@name =key;
					 	
					tempXml.appendChild(xmlDataChild);
					tree.addItem(key);
				}
				trace(xmlTemp);
			}
			return xmlTemp;
		}
		
		private var tempXml:XML;
         public function showMashup():void{
			
			Graph.action="show";
			Ravis.xmldata = this.revertToXml();
			var ravis:Ravis = this.newRavis();
			
			
            /* here we still want to implicitly redraw */
            if(mode){
            												ravis.buttonbar.visible = true;

															ravis.next.visible = false;
															ravis.back.visible = true;
															ravis.DownLoadUserManual.visible = false;

															
            }else{
            		ravis.back.visible = false;
            		ravis.buttonbar.visible = false;
            		ravis.DownLoadUserManual.visible = true;

            }
            //draw();
//			} 
        }
        
        private function newRavis():Ravis{
        	var build:Canvas = this.parentApplication.mashupViews.getChildByName("mashupBuild") as Canvas; 
     		var hbox:HBox = build.getChildByName("hbox") as HBox;		
     		hbox.removeChildAt(1);
     		var ravis:Ravis = new Ravis();
     		hbox.addChild(ravis);
     		return ravis;
        }
        
//        private function showMashupHttp(e:ResultEvent):void{
//        	        	Mashup.xml = e.result as XML;
//        	if(Mashup.xml != null){
//        	var build:Canvas = this.parentApplication.mashupViews.getChildByName("mashupBuild") as Canvas; 
//     		var hbox:HBox = build.getChildByName("hbox") as HBox;
//			
//			Graph(this._graph).action="show";
////			mx.controls.Alert.show("yueyue in httphandle");
//     		hbox.removeChildAt(1);
//     		var ravis:Ravis = new Ravis();
//     		hbox.addChildAt(	ravis,1);
//        	}      	
//        }
        
        public function Recomendation(_currentNodeX:IVisualNode):void{

			            var dic3:Dictionary = Graph(this.graph).getDic3();
			            var key:String =this.getNamefromId( _currentNodeX);
                       
			if(dic3[key] == 0 || dic3[key] == 2){
				Graph(this.graph).flag = dic3[key];
			var httpservice:HTTPService = new HTTPService();
//			var arr:Array = key.split(".");
//			key = arr[1];
			var urlstr:String = this.url+key; //"mashupBuild/data/tree"+key+"\.xml";
			httpservice.url = urlstr;
			httpservice.resultFormat ="e4x";
			httpservice.addEventListener(ResultEvent.RESULT,recomendationHttp);
			httpservice.send();
            /* here we still want to implicitly redraw */
            //draw();
			}else if(dic3[key] == 1){
				mx.controls.Alert.show("this node is an API class ,can not fetch the recmendation!!");
			}
        }
        
          private function recomendationHttp (e:ResultEvent):void{
        			var xml:XML = e.result as XML;
        	if(xml != null){
        	 Ravis.xmldata = xml;
			Graph.action = "recomend";
				this.newRavis();
     		

        	}
     		
        	
        }
        /**
         * This is the event handler for a mouse down event on a node
         * event. Currently does only one thing:
         * - Starts a drag operation of this node.
         * @param e The associated event.
         * */
        protected function nodeMouseDown(e:MouseEvent):void {
            _nodeMovedInDrag = false;
            dragBegin(e);
        }
        
        /**
         * This is the event handler for a mouse click on a node
         * The purpose of this event is to broadcast that a node has
         * been clicked on by a user, it has no other internal function
         * 
         * @param e The associated event
         */ 
        protected function nodeMouseClick(e:MouseEvent):void {
        	
            if(e.currentTarget is UIComponent) {
                
                var ecomponent:UIComponent = (e.currentTarget as UIComponent);
                
                if(_nodeMovedInDrag)
                {
                    return;	
                }
                
                /* get the associated VNode of the view */
                var evnode:IVisualNode = _viewToVNodeMap[ecomponent];

                /* stop propagation to prevent a concurrent backgroundDrag */
                e.stopImmediatePropagation();
                dispatchEvent(new VisualNodeEvent(VisualNodeEvent.CLICK,evnode.node,e.ctrlKey));
            }
            if(e.ctrlKey){
            	mx.controls.Alert.show("ctrlKey is pressed!!!");
            	
            	//如果该点已经有了，再点击那个点，就会把改点删除
//            	var index:int = this._twoNode.getItemIndex(evnode);
//	            	if(index != -1){
//	            		this._twoNode.removeItemAt(index);
//	            		
//	            	}else
	            	 if(this._twoNode.length >=2){
	            		 mx.controls.Alert.show("you have already selected two nodes ,can selecte more ,please release at least one node!!");
	            	}else{
	            		 this._twoNode.addItem(evnode);
	            	}
            			
	         }
         
        }
        
        /**
         * Start a drag operation. This sets the drag node and
         * registeres a 'MouseMove' event handler with the
         * VNode, so it can follow the mouse movement.
         * @param event The MouseEvent that was triggered by clicking on the node.
         * @see handleDrag()
         * */
        protected function dragBegin(event:MouseEvent):void {
            
            var ecomponent:UIComponent;
            var evnode:IVisualNode;
            var pt:Point;
            
            //LogUtil.debug(_LOG, "DragBegin was called...");
            
            /* if there is an animation in progress, we ignore
            * the drag attempt */
            if(_layouter && _layouter.animInProgress) {
                LogUtil.info(_LOG, "Animation in progress, drag attempt ignored");
                return;
            }
            
            /* make sure we get the right component */
            if(event.currentTarget is UIComponent) {
                
                ecomponent = (event.currentTarget as UIComponent);
                
                /* get the associated VNode of the view */
                evnode = _viewToVNodeMap[ecomponent];
                
                /* stop propagation to prevent a concurrent backgroundDrag */
                event.stopImmediatePropagation();
                
                if(evnode != null) {
                    if(!dragLockCenter) {
                        // lockCenter is false, use the mouse coordinates at the point
                        pt = new Point(ecomponent.mouseX, ecomponent.mouseY);
                    } else {
                        // lockCenter is true, ignore the mouse coordinates
                        pt = new Point(ecomponent.width/2,ecomponent.height/2);
                    }
                    
                    /* Save the offset values in the map 
                    * so we can compute x and y correctly in case
                    * we use lockCenter */
                    
                    _drag_x_offsetMap[ecomponent] = pt.x
                    _drag_y_offsetMap[ecomponent] = pt.y;
                    
                    
                    /* now we would need to set the bounds
                    * rectangle in _drag_boundsMap, but this is
                    * currently not implemented *
                    _drag_boundsMap[ecomponent] = rectangle;
                    */
                    
                    /* Register an eventListener with the component's stage that
                    * handles any mouse move. This wires the component
                    * to the mouse. On every mouse move, the event handler
                    * is called, which updates its coordinates.
                    * We need to save the drag component, since we have to 
                    * register the event handler with the stage, not the component
                    * itself. But from the stage we have no way to get back to
                    * the component or the VNode in case of the mouse move or 
                    * drop event. 
                    */
                    _dragComponent = ecomponent;
                    ecomponent.stage.addEventListener(MouseEvent.MOUSE_MOVE, handleDrag);
                    _canvas.addEventListener(MouseEvent.MOUSE_UP,dragEnd);
                    /* also register a drop event listener */
                    // ecomponent.stage.addEventListener(MouseEvent.MOUSE_UP, dragEnd);
                    
                    /* and inform the layouter about the dragEvent */
                    _nodeMouseDownLocation = globalMousePosition();
                    dispatchEvent(new VisualNodeEvent(VisualNodeEvent.DRAG_START,evnode.node,event.ctrlKey));
                    _layouter.dragEvent(event, evnode);
                } else {
                    throw Error("Event Component was not in the viewToVNode Map");
                }
            } else {
                throw Error("MouseEvent target was not UIComponent");
            }
        }
        
        /**
         * Called everytime the mouse moves after the dragBegin() method has
         * been called.  Updates the position of the Component based on
         * the location of the mouse cursor.
         * @param event The MouseMove event that has been triggered.
         */
        protected function handleDrag(event:MouseEvent):void {
            var myvnode:IVisualNode = _viewToVNodeMap[_dragComponent];
            
            /* Sometimes we get spurious events */
            if(_dragComponent == null) {
                LogUtil.info(_LOG, "received handleDrag event but _dragComponent is null, ignoring");
                return;
            }
            
            if (_moveNodeInDrag) {
                
                myvnode.viewX = mouseX - _drag_x_offsetMap[_dragComponent];
                myvnode.viewY = mouseY - _drag_y_offsetMap[_dragComponent];
                myvnode.refresh();
                _nodeMovedInDrag = true;
            }
            
            _layouter.dragContinue(event, myvnode);
            
            refresh();
        }
        
        /**
         * This handles a background drag (i.e. scroll). The
         * event listener is usually registered with the canvas,
         * i.e. this object.
         * @param event The triggered event.
         * */
        protected function backgroundDragBegin(event:MouseEvent):void {
            
            var mycomponent:UIComponent;
            const mpoint:Point = globalMousePosition();
            
            /* if there is an animation in progress, we ignore
            * the drag attempt */
            if(_layouter && _layouter.animInProgress) {
                LogUtil.info(_LOG, "Animation in progress, drag attempt ignored");
                dispatchEvent(new VisualGraphEvent(VisualGraphEvent.BACKGROUND_CLICK));
                return;
            }

            /* set the progress flag and save the starting coordinates */
            _backgroundDragInProgress = true;
            _dragCursorStartX = mpoint.x;
            _dragCursorStartY = mpoint.y;
            _mouseDownLocation = mpoint;
            
            /* register the backgroundDrag listener to react to
            * the mouse movements */
            _canvas.addEventListener(MouseEvent.MOUSE_MOVE, backgroundDragContinue);
            _canvas.addEventListener(MouseEvent.MOUSE_UP,dragEnd);
            _canvas.addEventListener(MouseEvent.ROLL_OUT,dragEnd);
            
            /* and inform the layouter about the dragEvent */
            if(_layouter) {
                _layouter.bgDragEvent(event);
            }
            
        }
        
        /**
         * This does the actual background drag by having
         * all UIComponents move to follow the mouse
         * @param event The triggered mouse move event.
         * */ 
        protected function backgroundDragContinue(event:MouseEvent):void {
            
            const mpoint:Point = globalMousePosition();
            
            var deltaX:Number;
            var deltaY:Number;
            
            if (_scrollBackgroundInDrag) {
                /* compute the movement offset of this move by
                * subtracting the current mouse position from
                * the last mouse position */
                deltaX = mpoint.x - _dragCursorStartX;
                deltaY = mpoint.y - _dragCursorStartY;
                
                deltaX /= scaleX
                deltaY /= scaleY
                /*deltaX /= (scaleX*_canvas.scaleX);
                deltaY /= (scaleY*_canvas.scaleY);*/
                
                /* scroll all objects by this offset */
                scroll(deltaX, deltaY,false);
            }
            /* and inform the layouter about the dragEvent */
            if(_layouter) {
                _layouter.bgDragContinue(event);
            }
            
            /* reset the drag start point for the next step */
            _dragCursorStartX = mpoint.x;
            _dragCursorStartY = mpoint.y;
            
            /* make sure edges are redrawn */
            _forceUpdateEdges = true;
            //invalidateDisplayList();
        }
        
        
        /**
         * This method handles the drop event (usually MOUSE_UP).
         * It stops any dragging in progress (including background drag)
         * and unregisters the current dragged node.
         * @param event The triggered event.
         * */
        protected function dragEnd(event:MouseEvent):void {
            
            const mpoint:Point = globalMousePosition();
            
            var mycomp:UIComponent;
            var myback:DisplayObject;
            var myvnode:IVisualNode;
            
            _canvas.removeEventListener(MouseEvent.ROLL_OUT,dragEnd);
            _canvas.removeEventListener(MouseEvent.MOUSE_UP,dragEnd);
            
            if(_backgroundDragInProgress) {
                
                /* if it was a background drag we stop it here */
                _backgroundDragInProgress = false;
                
                /* get the background drag object, which is usually
                * the canvasm so we just set it to this */
                myback = (this as DisplayObject);
                
                /* unregister event handler */				
                myback.removeEventListener(MouseEvent.MOUSE_MOVE,backgroundDragContinue);
                
                /* and inform the layouter about the dropEvent */
                if(_layouter) {
                    _layouter.bgDropEvent(event);
                }
                
                if(event.type == MouseEvent.ROLL_OUT) {
                    CursorManager.removeAllCursors();
                }
                
                //dispatch the drag event only if we have moved somewhere
                if(_mouseDownLocation && 
                    Math.abs(mpoint.x - _mouseDownLocation.x) > 2 ||
                    Math.abs(mpoint.y - _mouseDownLocation.y) > 2) {
                    dispatchEvent(new VisualGraphEvent(VisualGraphEvent.BACKGROUND_DRAG_END));
                }else{
                    dispatchEvent(new VisualGraphEvent(VisualGraphEvent.BACKGROUND_CLICK));                    
                }
            } else {
                
                /* if it was no background drag, the component
                * is the saved dragComponent */
                mycomp = _dragComponent;
                
                /* But sometimes the dragComponent was already null, 
                * in this case we have to ignore the thing. */
                if(mycomp == null) {
                    LogUtil.info(_LOG, "dragEnd: received dragEnd but _dragComponent was null, ignoring");
                    return;
                }
                
                /* remove the event listeners */
                // HACK: I have to check the stage because there are eventual components not added to the display list
                if (mycomp.stage != null)
                {
                    mycomp.stage.removeEventListener(MouseEvent.MOUSE_MOVE, handleDrag);
                }
                
                /* get the associated VNode to notify the layouter */
                myvnode = _viewToVNodeMap[mycomp];
                if(_layouter) {
                    _layouter.dropEvent(event, myvnode);
                }
                
                if(_nodeMouseDownLocation && 
                    Math.abs(mpoint.x - _nodeMouseDownLocation.x) > 2 ||
                    Math.abs(mpoint.y - _nodeMouseDownLocation.y) > 2) {
                    dispatchEvent(new VisualNodeEvent(VisualNodeEvent.DRAG_END,myvnode.node,event.ctrlKey));
                }
                /* reset the dragComponent */
                _dragComponent = null;
            }	
        }
        
        /**
         * return the current mouse position, used by 
         * certain drag&drop issues
         * */
        protected function globalMousePosition():Point {
            return localToGlobal(new Point(mouseX, mouseY));
        }
        
        /** 
         * 1. saves the old nodeID hash object.
         * 2. sets the new _nodeIDsWithinDistanceLimit Object from the object
         *    provided (typically provided from the GTree of a Graph).
         * 3. updates the amount of nodes in that object, by linearly
         *    counting them. This may be optimized...
         * @param vnids Object containing a hash with all node id's currently within the distance limit.
         * */
        protected function setDistanceLimitedNodeIds(vnids:Dictionary):void {
            var val:Boolean;
            var amount:uint;
            var vn:IVisualNode;
            var n:INode;
            
            /* reset the amount */
            amount = 0;
            
            /* save the old hash */
            _prevNodeIDsWithinDistanceLimit = _nodeIDsWithinDistanceLimit;
            
            /* set the new hash object */
            _nodeIDsWithinDistanceLimit = new Dictionary;
            
            /* walk through the hash and build the distanceLimit hash */
            for each(n in vnids) {
                vn = n.vnode;
                _nodeIDsWithinDistanceLimit[vn] = vn;
                
                /* increase the amount */
                ++amount;
            }
            
            /* count all entries in this hash */
            for each(val in vnids) {
                if(val) {
                    ++amount;
                }
            }
            /* set the new amount */
            _noNodesWithinDistance = amount;
            
            //LogUtil.debug(_LOG, "current visible nodeids:"+_noNodesWithinDistance);
        }
        
        /**
         * This needs to walk through all nodes in the graph, as some nodes
         * have become invisible and other have become visible. There may be
         * a better way to do this, when adjusting the visibility but it is
         * not that clear.
         * 
         * walk through the graph and the limitedGraph and
         * turn off visibility for those that are not listed in
         * both
         * beware that the limited graph has no VItems, so 
         * we don't really need it, we would rather need
         * an array of node ids....
         * */
        protected function updateVisibility():void {
            var n:INode;
            var e:IEdge;
            var edges:Array;
            var treeparents:Dictionary;
            var vn:IVisualNode;
            var vno:IVisualNode;
            
            var newVisibleNodes:Dictionary;
            var potentialInvisibleNodes:Dictionary;
            
            /* since a layouter that uses timer based iterations
            * might find itself on a changing node set, we need
            * to stop/reset anything before altering the node
            * visibility */
            if(_layouter != null) {
                _layouter.resetAll();
            }
            
            
            //LogUtil.debug(_LOG, "update node visibility");
            
            /* create a copy of the currently visible 
            * node set, as the set for nodes to potentially
            * turned invisible */
            potentialInvisibleNodes = new Dictionary;
            for each(vn in _visibleVNodes) {
                potentialInvisibleNodes[vn] = vn;
            }
            
            /* now populate the set of nodes which should be
            * turned visible, first by using the nodes  within
            * distance limit */
            newVisibleNodes = new Dictionary;
            
            for each(vn in _nodeIDsWithinDistanceLimit) {
                newVisibleNodes[vn] = vn;
            }
            
            /* now add the history nodes to the set of new visible
            * nodes if the history is enabled */
            /* Step 3: render all (new?) history nodes and nodes on the path visible (if applicable) */
            if(_showCurrentNodeHistory) {
                
                /* this is mapping in the tree that provides a parent
                * for each single node in the tree 
                * we need this to find the way to the root */
                treeparents = _graph.getTree(_currentRootVNode.node).parents;
                
                for each(vn in _currentVNodeHistory) {
                    n = vn.node;		
                    /* we cannot use vn here, because it is n that is changed
                    * in this while loop. Basically we are walking the tree
                    * backward from the current vnode's node n to the root
                    * for every vn in the history */
                    while(n.vnode != _currentRootVNode) {
                        
                        /* set it visible */
                        newVisibleNodes[n.vnode] = n.vnode;
                        //setNodeVisibility(n.vnode, true);
                        
                        /* move to the parent node */
                        n = treeparents[n];
                        if(n == null) {
                            throw Error("parent node was null but node was not root node");
                        }
                    }
                }
            }
            
            /* now from each set remove the common nodes, these
            * are the nodes that should remain visible, so they
            * must not be turned invisible and should also not
            * be turned visible again. */
            for each(vn in potentialInvisibleNodes) {
                if(newVisibleNodes[vn] != null) {
                    /* this is a common node, remove it from
                    * both dictionaries 
                    */
                    delete potentialInvisibleNodes[vn];
                    delete newVisibleNodes[vn];
                } 
            }
            
            /* now finally turn all toInvisibleNodes invisible
            * likewise any edge adjacent to an invisible node
            * will become invisible */
            for each(vn in potentialInvisibleNodes) {
                setNodeVisibility(vn, false);
            }
            
            /* and all new visible nodes to visible */
            for each(vn in newVisibleNodes) {
                setNodeVisibility(vn, true);
            }
            
            /* and now walk again to update the edges */
            for each(vn in potentialInvisibleNodes) {
                updateConnectedEdgesVisibility(vn);
            }
            
            /* and all new visible nodes to visible */
            for each(vn in newVisibleNodes) {
                updateConnectedEdgesVisibility(vn);
            }
            
            /* send an event */
            this.dispatchEvent(new VGraphEvent(VGraphEvent.VISIBILITY_CHANGED));
        }
        
        /**
         * This methods walks through all nodes and updates
         * the edge visibility (only the edge visibility)
         * taking into account three factors:
         * visibility of adjacent nodes and
         * if we want edge labels or not at all
         * */
        protected function updateEdgeVisibility():void {
            
            var vn:IVisualNode;
            
            for each(vn in _visibleVNodes) {
                updateConnectedEdgesVisibility(vn);
            }
        }
        
        /**
         * Reset visibility of all nodes, all nodes are back to visible.
         * This can be a very very heavy operation if you have many nodes. 
         * */
        protected function setAllVisible():void {
            var n:INode;
            var e:IEdge;
            
            /* not sure if this is really, really needed, but
            * since similar code was added, I optimise it a bit.
            */
            if(_graph == null) {
                LogUtil.warn(_LOG, "setAllVisible() called, but graph is null");
                return;
            }
            
            /* since a layouter that uses timer based iterations
            * might find itself on a changing node set, we need
            * to stop/reset anything before altering the node
            * visibility */
            if(_layouter != null) {
                _layouter.resetAll();
            }
            
            /* recreate those, this is cheaper probably */
            _visibleVNodes = new Dictionary;
            _noVisibleVNodes = 0;
            
            for each(n in _graph.nodes) {
                setNodeVisibility(n.vnode, true);
            }
            
            /* same for edges */
            _visibleVEdges = new Dictionary;
            
            for each(e in _graph.edges) {
                setEdgeVisibility(e.vedge, true);
            }
        }
        
        /**
         * Reset visibility of all nodes, all nodes are INVISIBLE.
         * */
        protected function setAllInVisible():void {
            
            var vn:IVisualNode;			
            var ve:IVisualEdge;
            
            /* not sure if this is really, really needed, but
            * since similar code was added, I optimise it a bit.
            */
            if(_graph == null) {
                LogUtil.warn(_LOG, "setAllInVisible() called, but graph is null");
                return;
            }
            
            /* since a layouter that uses timer based iterations
            * might find itself on a changing node set, we need
            * to stop/reset anything before altering the node
            * visibility */
            if(_layouter != null) {
                _layouter.resetAll();
            }
            
            for each(vn in _visibleVNodes) {
                setNodeVisibility(vn, false);
            }
            
            for each(ve in _visibleVEdges) {
                setEdgeVisibility(ve, false);
            }
        }
        
        /**
         * Reset visibility of all edges to INVISIBLE.
         * */
        protected function setAllEdgesInVisible():void {
            var ve:IVisualEdge;
            for each(ve in _visibleVEdges) {
                setEdgeVisibility(ve, false);
            }
        }	
        
        /**
         * This sets a VNode visible or invisible, updating all related
         * data.
         * @param vn The VisualNode to be turned invisible or not.
         * @param visible The indicator if visible or not.
         * */
        protected function setNodeVisibility(vn:IVisualNode, visible:Boolean):void {
            
            var comp:UIComponent;
            
            /* was there actually a change, if not issue a warning */
            if(vn.isVisible == visible) {
                LogUtil.warn(_LOG, "Tried to set node:"+vn.id+" visibility to:"+visible.toString()+" but it was already.");
                return;
            }
            
            if(visible == true) {
                
                /* set the node to visible, this might create a view for it */
                vn.isVisible = true;
                /* add it to the hash of currently visible nodes */
                _visibleVNodes[vn] = vn;
                /* increase the counter */
                ++_noVisibleVNodes;
                
                /* create the node's view */
                comp = createVNodeComponent(vn);
                
                /* set it to visible, should be default anyway */
                comp.visible = true;
                
            } else { // i.e. set to invisible 
                /* render node invisible, thus potentially destroying its view */
                vn.isVisible = false;
                /* remove it from the hash */
                delete _visibleVNodes[vn];
                /* decrease the counter */
                --_noVisibleVNodes;
                
                /* remove the view if there is one */
                if(vn.view != null) {
                    removeComponent(vn.view, false);
                }
            }
        }
        
        
        /**
         * This sets a VEdge visible or invisible, updating all related
         * data.
         * @param ve The VisualEdge to be turned invisible or not.
         * @param visible The indicator if visible or not.
         * */	
        protected function setEdgeVisibility(ve:IVisualEdge, visible:Boolean):void {
            
            var comp:UIComponent;
            
            /* was there actually a change, if not issue a warning */
            if(ve.isVisible == visible) {
                //LogUtil.warn(_LOG, "Tried to set vedge:"+ve.id+" visibility to:"+visible.toString()+" but it was already.");
                return;
            }
            
            if(visible == true) {
                
                /* add it to the hash of currently visible nodes */
                _visibleVEdges[ve] = ve;
                
                /* check if there is no view and we need one */
                if(_displayEdgeLabels && ve.labelView == null) {
                    comp = createVEdgeView(ve);
                }
                
                /* set the edges view to visible */
                ve.isVisible = true;
                
            } else { // i.e. set to invisible 
                /* render node invisible, thus potentially destroying its view */
                ve.isVisible = false;
                /* remove it from the hash */
                delete _visibleVEdges[ve];
                
                /* remove the view if there is one */
                if(ve.labelView != null) {
                    removeVEdgeView(ve.labelView);
                }
            }
        }
        
        /**
         * This methods walks through all edges connected
         * to a node and sets them either visible or invisible
         * depending on the visibility of the given node and
         * the node on the other end. An edge is only visible
         * if both nodes are visible.
         * @param vn The VisualNode of which connected edges should be updated.
         * */
        protected function updateConnectedEdgesVisibility(vn:IVisualNode):void {
            
            var edges:Array;
            var ovn:IVisualNode;
            var e:IEdge;
            
            /* now here we have to test each edges othernode
            * if it is also visible */
            edges = vn.node.inEdges;
            
            /* concat might lead to duplication in the case of
            * undirected graphs... :( not sure how to efficiently
            * only add items which are not there, yet?
            */
            edges = edges.concat(vn.node.outEdges);
            
            for each(e in edges) {
                
                /* get the other node at the end of the edge */
                ovn = e.othernode(vn.node).vnode;
                
                /* if this node either is still visible or in the
                * list to become visible, then the edge is also
                * visible */
                if(vn.isVisible && ovn.isVisible) {
                    setEdgeVisibility(e.vedge,true);
                } else {
                    setEdgeVisibility(e.vedge,false);
                }
            }
        }
        
        public function saveAll():void{
        
        	for each(var tem:Node in this._graph.nodes){
        		tem.backupNode();
        	}        			
        			
        	this._allNode.removeAll();
        	var temp:Array = new Array;
        	for each( tem in this._graph.nodes)
        	{
        		temp.unshift(tem);
        	}

        	this._allNode = new ArrayCollection(temp);								
        	if(!this.isAllEdgeSetPara()){
				mx.controls.Alert.show("Some Edge may not set Parameter , please check it !!");
				return;
        	}
        	
        	this.setTrueCondition();
        	var tempnodes:Array = new  Array();
        	for each (var tempnode:INode in  this._allNode){
        		tempnodes.push(tempnode);
        	}
        	var nodelist:ArrayCollection = new ArrayCollection(tempnodes);
        	var loop:Loop = new Loop(nodelist);
        	
        	var virtualNode:INode = new Node(0,"0",null,null);
        	loop.findcycle();
        	var loops:Array = loop.output;
        	loops =this.sortLoop(loops);
        	for each(var eachLoop:Array in loops){
        		var start:INode = this.getNodeById(eachLoop[0]);
        		var end:INode = this.getNodeById(eachLoop[eachLoop.length-1]);
        		if(start.id == end.id)
        			continue;
        		virtualNode.successors = new Array;
        		virtualNode.successors.push(start);
        		if(! this.mergeIf(virtualNode,start,end)){
        			mx.controls.Alert.show("Only one Output is Permitted!!!");
        			return;
        		}
        	}

			this.mergeLoop();
				
			var node:INode = getFirstNode();				
			virtualNode.successors = new Array();
			virtualNode.successors.push(node);		
			if(!this.mergeIf(virtualNode,node)){
				mx.controls.Alert.show("Only one Output is Permitted!!!");
				return;
			}			

			var xmlString:String = "";
			xmlString += '<?xml version="1.0" encoding="UTF-8"?>';
			xmlString += '<mashup xmlns="http://www.zju.edu.cn">';
			xmlString += '<variables>';
			var para:Array = new Array;
			for  (var vari:String  in varWarehouse){
		 		para.push(vari);
		   		xmlString +='<variable name="'+vari+'" type="'+(varWarehouse[vari] as Array)[0]
		   			+'" value="'+(varWarehouse[vari] as Array)[1]+'" />';
			}
			xmlString += '</variables>';
			xmlString += '<process>';
			
			var tempIno:INode= getFirstNode();
			xmlString = this.finalResult(tempIno,xmlString);
			xmlString +='</process></mashup>';

			/* for test new engine */
//			xmlString = "" + 
//					"<?xml version=\"1.0\" encoding=\"UTF-8\"?>" + 
//					"<mashup xmlns=\"http://www.zju.edu.cn\">" + 
//					"							<variables>" + 
//					"								<variable name=\"continue1\" type=\"boolean\" value=\"true\" />" + 
//					"							</variables>" + 
//					"							<process>" + 
//					"								<while id=\"while1\">" + 
//					"									<condition>${continue}==true</condition>" + 
//					"									<invoke id=\"invoke1\" portType=\"MobileGps\" operation=\"getLocation\">" + 
//					"										<inputVariables>" + 
//					"										</inputVariables>" + 
//					"										<outputVariables>" + 
//					"											<outputVariable name=\"Latitude\" type=\"string\" />" + 
//					"											<outputVariable name=\"Longitude\" type=\"string\" />" + 
//					"										</outputVariables>" + 
//					"									</invoke>" + 
//					"									<getTerminalInput name=\"radius\" label=\"Radius\" type=\"real\" control=\"text\" value=\"5\" />" + 
//					"									<getTerminalInput name=\"search_text\" label=\"Keywords\" type=\"string\" control=\"text\" value=\"flower\" />" + 
//					"									<getTerminalInput name=\"number\" label=\"Number\" type=\"real\" control=\"text\" value=\"5\" />" + 
//					"									<invoke id=\"invoke2\" portType=\"Flickr\" operation=\"getPhotos\">" + 
//					"										<inputVariables>" + 
//					"												<inputVariable name=\"search_text\" type=\"string\" value=\"${search_text}\" />" + 
//					"												<inputVariable name=\"number\" type=\"real\" value=\"${number}\" />" + 
//					"												<inputVariable name=\"lat\" type=\"real\" value=\"${invoke1.Latitude}\" />" + 
//					"												<inputVariable name=\"lon\" type=\"real\" value=\"${invoke1.Longitude}\" />" + 
//					"												<inputVariable name=\"radius\" type=\"real\" value=\"${radius}\" />" + 
//					"										</inputVariables>" + 
//					"										<outputVariables>" + 
//					"											<outputVariable name=\"thumbnailUrl\" type=\"string\" />" + 
//					"											<outputVariable name=\"title\" type=\"string\" />" + 
//					"											<outputVariable name=\"longitude\" type=\"string\" />" + 
//					"											<outputVariable name=\"latitude\" type=\"string\" />" + 
//					"										</outputVariables>" + 
//					"									</invoke>" + 
//					"									<getTerminalInput name=\"status\" label=\"status\" type=\"string\" control=\"text\" value=\"Smile~\" />" + 
//					"									<getTerminalInput name=\"selectedSinaWeibo\" label=\"SinaWeibo\" type=\"boolean\" control=\"checkbox\" value=\"true\" />" + 
//					"									<ifBlock id=\"ifBlock1\">" + 
//					"										<if id=\"if1\">" + 
//					"											<condition>${selectedSinaWeibo}==true</condition>" + 
//					"											<invoke id=\"invoke3\" portType=\"SinaMicroBlog\" operation=\"updateStatus\">" + 
//					"												<inputVariables>" + 
//					"													<inputVariable name=\"Status\" type=\"string\" value=\"${invoke2.thumbnailUrl}\" />" + 
//					"												</inputVariables>" + 
//					"												<outputVariables>" + 
//					"												</outputVariables>" + 
//					"											</invoke>" + 
//					"										</if>" + 
//					"									</ifBlock>" + 
//					"									<getTerminalInput name=\"continueOrNot\" label=\"continue?\" type=\"boolean\" control=\"popButton\" value=\"true\" />" + 
//					"									<assign var=\"continue1\" value=\"${continueOrNot}\" />" + 
//					"								</while>" + 
//					"							</process>" + 
//					"						</mashup>";

			/* for test*/
//			xmlString = '<mashup xmlns="http://www.zju.edu.cn"><variables/><process><invoke id="invoke2" portType="MobileGps" operation="getLocation"><inputVariables/><outputVariables><outputVariable name="Latitude" type="string"/><outputVariable name="Longitude" type="string"/></outputVariables></invoke><getTerminalInput name="k" label="k" type="string" control="text" value="sky"/><getTerminalInput name="n" label="n" type="int" control="text" value="3"/><getTerminalInput name="r" label="r" type="int" control="text" value="20"/><invoke id="invoke3" portType="Flickr" operation="getPhotos"><inputVariables><inputVariable name="lat" type="string" value="${invoke2.Latitude}"/><inputVariable name="number" type="string" value="${n}"/><inputVariable name="lon" type="string" value="${invoke2.Longitude}"/><inputVariable name="radius" type="string" value="${r}"/><inputVariable name="search_text" type="string" value="${k}"/></inputVariables><outputVariables><outputVariable name="longitude" type="string"/><outputVariable name="thumbnailUrl" type="string"/><outputVariable name="title" type="string"/><outputVariable name="latitude" type="string"/></outputVariables></invoke><invoke id="invoke4" portType="SinaMicroBlog" operation="updateStatus"><inputVariables><inputVariable name="Status" type="string" value="${invoke3.thumbnailUrl}"/></inputVariables><outputVariables/></invoke></process></mashup>';
			var xml:XML = new XML(xmlString);
			mx.controls.Alert.show(xml.toString());
			/* send the result mashup to the server.*/
			sendResultMashup(xml);
			/*****************************************/
			

			
			for each(var nod:Node in this._graph.nodes){
				nod.recoverNode();					
			}
        }
        
        private function getFirstNode():INode{
        		var tempIno:INode= null;
				for each(var tempInode:INode in this._allNode){
					 if(tempInode.predecessors.length == 0){
					 		tempIno = tempInode;
					 		break;
					 }	 	
				}
				return tempIno;
        }
        
        private function sendResultMashup(resultMashup:XML):void {
        	var uv:URLVariables = new URLVariables();
        	uv.mashupString = resultMashup;
        	trace(resultMashup);
        	uv.resultPageConfig = AppViewManager.getResult();
			/* for test */
//			uv.resultPageConfig = 'var resultConfigItems = [{target: "invoke3.thumbnailUrl",left: "0.28125",top: "0.2625",width: "0.5",height: "0.09166666666666666",type: "IMAGE",name: "",},];';
        	trace(uv.resultPageConfig);
        	var u:URLRequest = new URLRequest(RESULTMASHUPURL);
			u.method = "POST";
			u.data = uv;
			
			/* open a new tab to download the result files.*/
			navigateToURL(u,"_blank");
        }
        
        private function finalResult(no:INode,xmlString:String):String{
        	xmlString = this.stringDeal(xmlString,no.xmldata.toXMLString());
        	for each(var node:INode in no.successors){
        		xmlString = finalResult(node,xmlString);
        	}
        	
        	return xmlString;
        }
        
        private function getNodeById(id:String ):INode{
        			var node:INode =null;
        		for each (var nodex:INode in this._allNode){
        				if(nodex.id.toString() == id){
        						node = nodex;
        							break;
        				}
        							
        		}
        	return node;
        	
        }
        private function setTrueCondition():void{       	
			for each(var edge:Edge in this._graph.edges){
				if(edge.vedge.isLoopEdge){
					 var fromNode:INode  = edge.node1;
					 var toNode:INode = edge.node2;
					 if(!toNode.whileCondition.hasOwnProperty(String(fromNode.id))){
					 	toNode.whileCondition[fromNode.id] = "?_TRUE";
					 }
				}
			}
		
        }

        private function isAllEdgeSetPara():Boolean{
        		for each (var edge:Edge in this._graph.edges){  
        				if(edge.node2.successors.length == 0 || edge.vedge.isLoopEdge){
        								continue;
        				}     		
        				 if(!edge.isSetParameter)
        			 		return false;     			 		
        		}
        		
        		return true;
        }
        
        private var isCombine:Boolean = true;
        
        public function mergeIf(virtualNode:INode,sentinel:INode,endNode:INode=null):Boolean{

			this.dfsSearch(virtualNode,sentinel,endNode);
			return this.isCombine;
		
		}
	
		public function dfsSearch(node:INode,sentinel:INode,endNode:INode=null):void{
				
			if(endNode !=null &&node.id == endNode.id)
					return ;
			var successors:Array = node.successors.reverse();
			for (var j:int =0;j<successors.length;j++){
					var no:INode = successors[j] as INode;
					dfsSearch(no,sentinel,endNode);			
					
					var allpath:Array= Loop.dfspathEngine(no,endNode);
					
					if(allpath.length >1){
					var intersection:Array = Loop.intersectionFind(allpath);
					if(intersection.length >1){					
						var id:String =intersection[1] ;
		
						//归并每一条路
						var xmlString :String = "";
						for each(var path:Array in allpath){						
								for (var i:int =1;i<path.length;i++){
									if(path[i] == id)
											break;
											var inode:INode = this.getNodeById(path[i] );
											var xml:XML = inode.xmldata;
											xmlString = this.stringDeal(xmlString,xml.toXMLString());
							}
							
							for (i=1;i<path.length;i++){
											if(path[i] == id)
											break;
								    var deleNode:INode = this.getNodeById(path[i]);
									var indexdele:int = this._allNode.getItemIndex(deleNode);
									this._allNode.removeItemAt(indexdele);
							}
							
						}
								var fromNode:INode = no;	
								xmlString =this.stringDeal(xmlString,fromNode.xmldata.toXMLString(),true);
					
								var toNode:INode = this.getNodeById(id) as INode;
								xmlString =this.stringDeal(xmlString,toNode.xmldata.toXMLString());
						
									xmlString ="<rootNode>"+xmlString+"</rootNode>"
							
							var newxml:XML = new XML(xmlString);	
							
						var newVnode:IVisualNode = this.createNode("",null,false);
					
						var newNode:INode = newVnode.node;
						for each(var xx:INode  in  fromNode.predecessors ){
							 newNode.predecessors.push(xx);
						}
				
					for each(var tempnode:INode  in  fromNode.predecessors ){
								var tempindex:int = tempnode.successors.indexOf(fromNode);
								tempnode.successors[tempindex] = newNode;
					}
		
						
						for each(xx in toNode.successors)
									newNode.successors.push(xx);
					
						for each(tempnode in toNode.successors){
							tempindex = tempnode.predecessors.indexOf(toNode);
							tempnode.predecessors[tempindex] = newNode;
						}
						newNode.numOfedges = toNode.numOfedges;
						newNode.xmldata = newxml;
						if(fromNode.id == sentinel.id)
								newNode.whileCondition = fromNode.whileCondition;
						
						this._allNode.addItem(newNode);
						
						var index:int = this._allNode.getItemIndex(fromNode);
						this._allNode.removeItemAt(index);
						index = this._allNode.getItemIndex(toNode);
						this._allNode.removeItemAt(index);
						
//							if(loopDictionary.hasOwnProperty(fromNode.id)){
//								loopDictionary[newNode.id] = loopDictionary[fromNode.id] ;
//								delete loopDictionary[fromNode.id];
//								}
//								
//							if(loopDictionary.hasOwnProperty(toNode.id)){
//								loopDictionary[newNode.id] = loopDictionary[toNode.id] ;
//								delete loopDictionary[toNode.id];
//								}
						
					}
					else {
						
							this.isCombine = false;
					}
					}
					
			}
		}
	
		private function singleNode(no:INode):void{
				var xmlStringx :String = "";	 		
				xmlStringx =this.stringDeal(xmlStringx,no.xmldata.toXMLString());
				var whileConditionId: Dictionary =no.whileCondition as Dictionary;
					for (var key:String in whileConditionId){
	    				xmlStringx = "<repeat-while>\n<whileCondition>\n"+whileConditionId[key]+"\n</whileCondition><whileProcess><sequence>\n"+xmlStringx;
				 		xmlStringx+="	</sequence></whileProcess></repeat-while>";
				 	}
				 	no.xmldata = new XML(xmlStringx);
		}
		
		private function singleLoop(no:INode):void{
				var xmlStringx :String = "";	 		
				xmlStringx =this.stringDeal(xmlStringx,no.xmldata.toXMLString());
				var whileConditionId: Dictionary =no.whileCondition as Dictionary;
				var key:String = String(no.id);
	    		xmlStringx = "<repeat-while>\n<whileCondition>\n"+whileConditionId[key]+"\n</whileCondition><whileProcess><sequence>\n"+xmlStringx;
				xmlStringx+="	</sequence></whileProcess></repeat-while>";			
				no.xmldata = new XML(xmlStringx);
	
		}
		private function mergeLoop():void{
					
		        	var tempnodes:Array = new  Array();
			 		for each (var tempnode:Node in  this._allNode){
			 			tempnodes.push(tempnode);
			 		}		 		
			 		var nodelist:ArrayCollection = new ArrayCollection(tempnodes);		 		
	//		 		if(nodelist.length == 1){
	//					var no:INode = nodelist.getItemAt(0) as INode;
	//				 	singleNode(no);
	//				 	return;
	//		 		}				
					var loop:Loop = new Loop(nodelist);				
					loop.findcycle();
					var loops:Array = loop.output;
					loops =this.sortLoop(loops);
					
					while(loops.length != 0){
						var temp:Array = loops[0] as Array;
						var xmlString:String  ="";
						//当在同一个节点上进行循环时
						if(temp.length == 1){
							var single:INode = this.getNodeById(temp[0]);
							xmlString = this.stringDeal(xmlString,single.xmldata.toXMLString());
	//						singleLoop(single);
	//						//消去循环
	//						var ind:int = single.successors.indexOf(single);
	//						if(ind !=-1)
	//							single.successors.splice(ind,1);
	//							trace(single.xmldata)
	//						return;
						}else{						
							for (var i:int =0;i<temp.length;i++){
								var node:INode = this.getNodeById(temp[i]);// this._graph.nodeById(id);
								xmlString = this.stringDeal(xmlString,node.xmldata.toXMLString());
							}
						}
		
						var whileConditionId: Dictionary =this.getNodeById(temp[0]).whileCondition as Dictionary;
						 xmlString = "<repeat-while>\n<whileCondition>\n"+whileConditionId[temp[temp.length-1]]+"\n</whileCondition><whileProcess><sequence>\n"+xmlString;
						 xmlString+="	</sequence></whileProcess></repeat-while>";
						var newxml:XML = new XML(xmlString);		
							
						var newVnode:IVisualNode = this.createNode("",null,false);
						var newNode:INode = newVnode.node;
						var fromNode:INode = this.getNodeById(temp[0]);
						var toNode:INode = this.getNodeById(temp[temp.length-1]) as INode;
																						
						for each(var xx:INode  in fromNode.predecessors)
										if(xx.id != toNode.id)
															newNode.predecessors.push(xx);
						for each(var tempnodex:INode  in  fromNode.predecessors ){
									if(tempnodex.id != toNode.id){
									var tempindex:int = tempnodex.successors.indexOf(fromNode);
									tempnodex.successors[tempindex] = newNode;
									}
						}
		
							for each(var yy:INode in toNode.successors){
										if(yy.id != fromNode.id)
													newNode.successors.push(yy);
										
										}
							for each(tempnodex in toNode.successors){							
								if(tempnodex.id !=fromNode.id){
										tempindex = tempnodex.predecessors.indexOf(toNode);
										tempnodex.predecessors[tempindex] = newNode;
								}
							}
							newNode.numOfedges = toNode.numOfedges;
							newNode.xmldata = newxml;
		
							this._allNode.addItem(newNode);
							for each(var tempid:String   in temp){
							var deleNode:INode =this.getNodeById(tempid) ;//graph.nodeById(int(tempid));
							var indexdele:int = this._allNode.getItemIndex(deleNode);
							this._allNode.removeItemAt(indexdele);
							}		
							
								loops =dealPath(newNode,temp,loops);				
								loops = this.sortLoop(loops);
						
		//				if(loopDictionary.hasOwnProperty(fromNode.id)){
		//							loopDictionary[newNode.id] = loopDictionary[fromNode.id] ;
		//							delete loopDictionary[fromNode.id];
		//				}				
				}
		}
				
		private function dealPath(newNode:INode,temparr:Array,loopsarr:Array):Array{
			var temp:String = temparr.toString();
			 //temp+=",";
			var loops:Array = new Array();
			for each(var loop:Array in loopsarr){
				
				var str:String = loop.toString();
				//str+=",";
				if(temp == str)  continue;
				//trace(temp.charAt(0))
				//trace(temp.charAt(temp.length-2))
				var start:int = str.indexOf(temp.charAt(0));
				if(start == -1){
					 loops.push(loop);
				}else{
					//for temp[temp.length-1] = ","
					var end:int = str.indexOf(temp.charAt(temp.length-1));
					var star:String = str.substring(0,start);
					
					star+=newNode.id +",";
					if(end < str.length-1)
							star+= str.substring(end+2);
					var arr:Array = star.split(",");
					loops.push(arr);
				}
				 
			}
		
			return loops;
								 
		}
		private function sortLoop(loops:Array):Array{
	 
			var deleLoop:Array = new Array();       		
			loops.sort(Array.length);       		
			for (var i:int =0;i<loops.length;i++){
					var arr:Array = loops[i]  as Array;
					for (var j:int =i+1;j<loops.length;j++){
						var one:Array = loops[j] as Array;
						 if(arr.length != one.length) continue;
						 else {
						 		if(arr[0] ==one[0] &&arr[arr.length -1] == one[one.length-1]){
						 					deleLoop.push(i);
						 		}
						 }
					}
			}
			
			
			for each(var ss:int in deleLoop)
							loops.splice(ss,1);
			//for each(var item:Array in loops)
						//trace(item.toString())
			
			return loops;
	    }
	    
	    private function stringDeal(xmlStringx:String ,xmldata:String,pre:Boolean = false ):String{
    	var tempArrayx:Array =xmldata.split("otNode>");
		if(tempArrayx.length >1){
			var indexx:int = (tempArrayx[1] as String).indexOf("</ro");
			var strx:String = (tempArrayx[1] as String).substring(0,indexx);
			if(pre){
				xmlStringx =strx +"\n"+ xmlStringx ;
			}else{
				xmlStringx =xmlStringx +"\n"+strx;
			}
							
		}else{
			if(pre){
				xmlStringx = xmldata+"\n"+xmlStringx ;
			}else{
			 	xmlStringx = xmlStringx+"\n"+ xmldata;
			}
		}							
						 
		return xmlStringx;
    }
        
    }
}
