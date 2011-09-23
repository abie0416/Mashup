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
package org.un.cava.birdeye.ravis.graphLayout.data {
	
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	import mx.core.IDataRenderer;
	
	import org.un.cava.birdeye.ravis.graphLayout.visual.IVisualNode;
	
	
	/**
	 * Implements the Node data structure, which is part of
	 * a graph. Nodes can be connected via directional or
	 * non-directional edges. A node has an id, a String id
	 * and may be associated with a visual node.
	 * */
	public class Node extends EventDispatcher implements INode, IDataRenderer {
	
		/**
		 * @internal
		 * attributes
		 * */
		protected var _inEdges:Array;
		protected var _outEdges:Array;
		protected var _dataObject:Object;
		protected var _id:int;
		protected var _stringid:String; // this is used by the app, so we need to add it
		protected var _vnode:IVisualNode;
		protected var _name:String;
		
		/**
		 * @internal
		 * for convenience we keep track of
		 * the predecessors and successors
		 * 
		 * NOTE: this may create rather heavy, large
		 * objects (although we only ever store references)
		 * maybe all this should just be kept within
		 * the graph object....
		 * */
		protected var _predecessors:Array;
		protected var _successors:Array;

		protected var _backupPredecessors:Array;
		protected var _backupSuccessors:Array;
		protected var _needRedo:Boolean;
		
		
		protected var _condition:Dictionary;
		protected var _inputs:Dictionary; // format: inputs[fromNodeId][varName] : Array[?].
		protected var _outputs:Dictionary;
		
		protected var _numOfoutedges:int;
		protected var _effects:Array;
		protected var _userInputs:Dictionary; // format: userinputs[fromNodeId][varName] : Array[type, value].
		
		protected var _mashupType:String;
		
		protected var _xml:XML;
		protected var _whileCondition:Dictionary;
		
		/**
		 * The constructor assigns the two ids and may also be used
		 * to associate a VisualNode and/or a data object.
		 * @param id The internal (numeric) id of the node.
		 * @param sid The string id of the node (typically specified in XML).
		 * @param vn The associated VisualNode of the node (may be null).
		 * @param o The associated data object of the node (may be null).
		 * */
		public function Node(id:int, sid:String, vn:IVisualNode, o:Object ) {
			_inEdges = new Array;
			_outEdges = new Array;
			_predecessors = new Array;
			_successors = new Array;
			_backupPredecessors =  new Array;
			_backupSuccessors =  new Array;
//			_name = name;
			_id = id;
			_stringid = sid;
			_dataObject = o;
			_vnode = vn;
			
			
			_condition =  new Dictionary;
			_inputs = new Dictionary();
			_outputs = new Dictionary();
			_effects = new Array();
			_userInputs = new Dictionary();
			_whileCondition = new Dictionary();
			_needRedo = false;
			_mashupType = "";
			
		}
	
		public function set name(name:String):void{
			this._name = name;
			
		}
		
		public function get name():String{
			return this._name;
			
		}
		
		public function set whileCondition (whileCon:Dictionary):void{
			this._whileCondition = whileCon;
		}
		
		public function get whileCondition ():Dictionary{
				return this._whileCondition;
		}
									 /**
		 * set the xmldata of  the node;
		 * */
		 
		 public function set needRedo(need:Boolean):void{
		 	this._needRedo = need;
		 }
		 
		public function set xmldata (xml:XML):void{
			this._xml = xml;
		}
		
		public function set userInputs(userInputs:Dictionary):void{
					this._userInputs = userInputs;
		}
		public function get userInputs():Dictionary{
			 return _userInputs;			 
		}
		
		public function set mashupType(type:String):void{
			_mashupType = type;
		}
		public function get mashupType():String{
			return _mashupType;
		}		
		
		 public function get xmldata ():XML{
		 	if(this._xml == null &&_needRedo){
		 		var tempInputs:Dictionary = this._inputs as Dictionary;
		 		var xmlString:String="";
		 		/* if this node is the USERINPUT node, then xmlString will be left empty.*/
		 		if(_id != 1) {
			 		for (var keyInputs:String in tempInputs ){
			 			if(this._condition[keyInputs] != null){
			 				xmlString +="<if-then-else><ifCondition>";
			 				xmlString+=this._condition[keyInputs]+"\n";
			 				xmlString += "</ifCondition>\n<then>";
			 			}
			 			var temparr:Array = this._name.split(".");
			 			var index:int = (temparr[1] as String).indexOf("_");
			 			var servicename:String =  (temparr[1] as String).substring(0,index);
			 			var apiname:String = temparr[0] as String;
			 			//data which needs user inputs when mashup is running.
			 			var userForPhone:Dictionary = _userInputs[keyInputs] as Dictionary;
		 				for(var terminalInputName:String  in userForPhone ){
	 						xmlString += '<getTerminalInput '
	 								+ 'name="'+terminalInputName+'" '
	 								+ 'label="'+terminalInputName+'" '
	 								+ 'type="'+userForPhone[terminalInputName][0]
	 								+ '" control="text" value="'+userForPhone[terminalInputName][1]+'" />';
		 				}
			 			
			 			xmlString += '<invoke id ="invoke'+this.stringid+'" portType="'+apiname+'" operation="'+servicename+'">';
			 			xmlString += '<inputVariables>';
		 				var tempkey:Dictionary = tempInputs[keyInputs] as Dictionary;
		 				for(var para:String in tempkey ){
		 					var arr:Array =  tempkey[para] as Array;
		 					if(arr[1] == "equalSemantic"){
		 						xmlString +="<inputVariable name = \""+para+"\" defaultValue=\""+arr[0]+"\"\ />\n";	//+keyInputs+"."
		 					}else if(arr[1]== "userInput"){
		 						xmlString += '<inputVariable name = "'+para+'" type="string" value="${'+arr[0]+'}" />\n';	//+keyInputs+"."
		 					}else {
		 						// TODO: value of type.
		 						xmlString += '<inputVariable name = "'+para+'" type="string" value="${invoke'+keyInputs+"."+arr[0]+'}" />';
		 					}
		 				}
			 			xmlString += '</inputVariables>';
			 			xmlString += '<outputVariables>';
			 			for  (var xx:String in this._outputs){
			 				xmlString +='<outputVariable name = "'+xx+'" type="string" />';
			 			}
			 			xmlString +='</outputVariables>\n';
			 			
			 			//mashupType
	//		 			if(this.predecessors.length >1){		 				
	//		 				xmlString += "<mashupType>\n";
	//		 				if(this._mashupType != "")
	//		 					xmlString +=_mashupType+"\n";
	//		 				else xmlString +=VisualGraph.DATAMASHUPTYPE[0]+"\n";
	//		 				xmlString +="</mashupType>\n";
	//		 			}
			 			xmlString +="</invoke>";
			 			if(this._condition[keyInputs] != null){
			 				xmlString +="</then>\n</if-then-else>\n";
			 			}			 			
			 		}
		 		}
		 		if(xmlString != "") {
		 			xmlString= "<rootNode>"+xmlString+"</rootNode>";
		 		}	 			
		 		var xmlsrc:XML=new XML(xmlString);
		 		this._xml = xmlsrc;
			 }
			 
			 return this._xml;
		}
	
			/**
		 * @inheritDoc
		 * */
		 
		 public function set numOfedges(num:int):void{
		 		this._numOfoutedges = num;
		 }
		 
		 public function get numOfedges():int{
		 	 return this._numOfoutedges;
		 }
		public function set condition (cond:Dictionary):void{
			this._condition = cond;
		}
		public function get condition ():Dictionary{
			return this._condition;
		}
		
		
		 public function get inputs():Dictionary{
		 		return _inputs;
		 }
		 
		public function set inputs(para:Dictionary):void{
		 		this._inputs= para;
		 }
		 
		public function get outputs():Dictionary{
		 		return _outputs;
		 }
		 
		public function set outputs(para:Dictionary):void{
		 		this._outputs= para;
		 }
		 
		 /**
		 * set the effects of the node;
		 * */
		public function set effects (effect:Array):void{
			this._effects = effect;
		}
		
		public function get effects():Array{
			return this._effects;
		}
		
		 
		/**
		 * @inheritDoc
		 * */
		public function addInEdge(e:IEdge):void {
			
			/* the next assumes that the Edge knows
			 * already both its endpoints (which should
			 * always be the case */
			
			/* the IN coming edge, so this means we are the TO
			 * node and the other must be the from Node */
			if(e.othernode(this) == null) {
				throw Error("Edge:"+e.id+" has no fromNode");
			}
			_predecessors.unshift(e.othernode(this));
			_inEdges.unshift(e);
		}
		
		/**
		 * @inheritDoc
		 * */
		public function addOutEdge(e:IEdge):void {
			/* same story here */
			if(e.othernode(this) == null) {
				throw Error("Edge:"+e.id+" has no toNode");
			}
			//LogUtil.debug(_LOG, "added successor node:"+e.othernode(this).id+" to node:"+_id);
			_successors.unshift(e.othernode(this));
			_outEdges.unshift(e);
			this._numOfoutedges ++;
		}
		
		/**
		 * @inheritDoc
		 * */
		public function removeInEdge(e:IEdge):void {
			/* get the other node, as it must be deleted
			 * from the predecessor list */
			var otherNode:INode = e.othernode(this); // because it is an IN edge
			var theEdgeIndex:int = _inEdges.indexOf(e);
			var theNodeIndex:int = _predecessors.indexOf(otherNode);
			
			if(theEdgeIndex == -1) {
				throw Error("Could not find edge: "+e.id+" in InEdge list of node: "+_id);
			} else {
				_inEdges.splice(theEdgeIndex,1);
			}
			if(otherNode == null) {
				throw Error("Edge:"+e.id+" has no node 1");
			}
			if(theNodeIndex  == -1) {
				throw Error("Could not find node: "+otherNode.id+" in predecessor list of node: "+_id);
			} else {
				_predecessors.splice(theEdgeIndex,1);
			}
		}
		
		/**
		 * @inheritDoc
		 * */
		public function removeOutEdge(e:IEdge):void {
			/* get the other node, as it must be deleted
			 * from the successor list */
			var otherNode:INode = e.othernode(this); // because it is an OUT edge
			var theEdgeIndex:int = _outEdges.indexOf(e);
			var theNodeIndex:int = _successors.indexOf(otherNode);
			
			if(theEdgeIndex == -1) {
				throw Error("Could not find edge: "+e.id+" in OutEdge list of node: "+_id);
			} else {
				_outEdges.splice(theEdgeIndex,1);
			}
			if(otherNode == null) {
				throw Error("Edge: "+e.id+" has no node 2");
			}
			if(theNodeIndex  == -1) {
				throw Error("Could not find node: "+otherNode.id+" in predecessor list of node: "+_id);
			} else {
				_successors.splice(theEdgeIndex,1);
			}
		}
		
		/**
		 * @inheritDoc
		 * */
		public function get successors():Array {
			return _successors;
		}
		
		public function set successors(suc:Array):void {
				 _successors = suc ;
		}
		
		/**
		 * @inheritDoc
		 * */
		public function get outEdges():Array {
			return _outEdges;
		}
		
		public function set outEdges(outEdge:Array):void {
				 _outEdges =outEdge;
		}
		
		/**
		 * @inheritDoc
		 * */
		public function get inEdges():Array {
			return _inEdges;
		}
		public function set inEdges(inEdge:Array):void {
					 _inEdges = inEdge;
		}
		
		/**
		 * @inheritDoc
		 * */
		public function get predecessors():Array {
			return _predecessors;
		}
		
		public function set predecessors(pre:Array):void {
				 _predecessors = pre;
		}
		
		/**
		 * @inheritDoc
		 * */
		public function set data(o:Object):void {
			_dataObject = o;
		}
		
		/**
		 * @inheritDoc
		 * */
		public function get data():Object	{
			return _dataObject;
		}
		
		/**
		 * @inheritDoc
		 * */
		public function get vnode():IVisualNode {
			return _vnode;
		}
		
		/**
		 * @inheritDoc
		 * */
		public function set vnode(v:IVisualNode):void {
			_vnode = v;
		}
		
		/**
		 * @inheritDoc
		 * */
		public function get id():int {
			return _id;
		}
		
		/**
		 * @inheritDoc
		 * */
		public function get stringid():String {
			return _stringid;
		}
		
		// for mashup file creation, to solve the problem of saving the mashup for more than once. 
		public  function backupNode():void{
			
			var len:int = _backupSuccessors.length;
			_backupSuccessors.splice(0,len);
			len = _backupPredecessors.length;
			_backupPredecessors.splice(0,len);
			
			for each(var item:Node in _successors)
					_backupSuccessors.unshift(item);
						
			for each(item in _predecessors)
					_backupPredecessors.unshift(item);			
					
			_needRedo = true;
		}
		
		public function recoverNode():void{
			
				var len:int = _successors.length;
				_successors.splice(0,len);
				len = _predecessors.length;
				_predecessors.splice(0,len);
				
				for each(var item:Node in  _backupSuccessors){
					_successors.unshift(item);
				}
				for each(item in _backupPredecessors){
					_predecessors.unshift(item);
				}
				
				_needRedo = false;
		}
	}
}
