// Notice: If this code works, it was written by Lu Bin. 
//         Else, I don't know who wrote it. HiaHia...
// It's for build relationship between mashup tiles !! key code !

package dart.mashup.mashup
{
	import dart.mashup.ontology.Attribute;
	import dart.mashup.ontology.Ontology;
	import dart.mashup.tile.Param;
	import dart.mashup.tile.Service;
	import dart.mashup.tile.Tile;
	import dart.mashup.utility.Queue;
	
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	
	public class RelationBuilder
	{
		private var tileQueue:Queue;
		private var tiles:ArrayCollection;
		private var relationArr:ArrayCollection;
		private var rootClass:Ontology;
		
		public function RelationBuilder(tiles:ArrayCollection, rootClass:Ontology)
		{
			this.relationArr = new ArrayCollection();
			this.tileQueue = new Queue();
		//	this.tileQueue.push(t);
			this.tiles = tiles;
			this.rootClass = rootClass;	
		}
		
		/* 返回的是按照深度排列的tile列表 */
		public function build(dt:Tile, relationDic:Dictionary = null):ArrayCollection
		{
			var length:int = this.tiles.length;
			this.tileQueue.push(dt);
			var lastPushedTile:Tile = dt;
			var depthFlag:Boolean = false;
			var depth:int = 0;
			var count:int = 0;
			var tmpTile:Tile;
			var tpArrArr:ArrayCollection = new ArrayCollection();
			var tpArrItem:ArrayCollection = new ArrayCollection();
			tpArrItem.addItem(dt);
			tpArrArr.addItem(tpArrItem);
			tpArrArr.addItem(new ArrayCollection());
			/* 为了加快显示速度 */
			//var startIndex:int = Math.ceil(Math.random()* 60);
			//var endIndex:int = startIndex + 50;
			while(!tileQueue.isEmpty())
			{
				var t:Tile = tileQueue.pop() as Tile;
				var tmpArr:ArrayCollection = tpArrArr.getItemAt(depth + 1) as ArrayCollection;
				for(var i:int = 0; i < length; i++){
				//for(var i:int = startIndex; i < endIndex; i++){
					var tmp:Tile = tiles.getItemAt(i) as Tile;
					var flag:int = this.tileQueue.find(tmp);
					/* 0: in poped part of the queue
					   1: in data part of the queue
					   -1: not in the queue */
					if(flag != 0){
					//	var r:Relation = match(t, tmp);
					// 不使用match，直接使用relationDic
						var tmpDic:Dictionary = relationDic[t.name] as Dictionary;
						if(tmpDic[tmp.name] != null){
							var r:Relation = tmpDic[tmp.name];
							if(!r.isEmpty()){
								relationArr.addItem(r);
							 	if(flag == -1){
									this.tileQueue.push(tmp);
									tmpArr.addItem(tmp);
									tmpTile = tmp;
									count++;
							 	}
							}
						}
					}
				}
				if(count > 0 && t.name == lastPushedTile.name){
					tpArrArr.addItem(new ArrayCollection());
					count = 0;
					depth++;
					lastPushedTile = tmpTile;
				}		
			}
			
			if(tpArrArr.length == depth + 1)
				return tpArrArr;
			else
				tpArrArr.removeItemAt(tpArrArr.length - 1);
				
			return tpArrArr;
		}
		
		public function getRelationArr():ArrayCollection
		{ 
			return this.relationArr;
		}
		
		public function match(t1:Tile, t2:Tile):Relation
		{
			var services1:ArrayCollection = t1.services;
			var services2:ArrayCollection = t2.services;
			var length1:int = services1.length;
			var length2:int = services2.length;
			var relation:Relation = new Relation(t1, t2);
			 			
			for(var i:int = 0; i < length1; i++){
				var s1:Service = services1.getItemAt(i) as Service;
				var inParam1:ArrayCollection = s1.inParam;
				var outParam1:ArrayCollection = s1.outParam;
				for(var j:int = 0; j < length2; j++){
					var s2:Service = services2.getItemAt(j) as Service;
					var inParam2:ArrayCollection = s2.inParam;
					var outParam2:ArrayCollection = s2.outParam;
					var matchedFromParamPair:ArrayCollection = new ArrayCollection();
					getMatchedParamPair(inParam1, outParam2, matchedFromParamPair, "from");
					var matchedToParamPair:ArrayCollection = new ArrayCollection();
					getMatchedParamPair(outParam1, inParam2, matchedToParamPair, "to");
					if(matchedFromParamPair.length > 0 || matchedToParamPair.length > 0){
						var ri:RelationItem = new RelationItem(s1, s2);
						if(matchedFromParamPair.length > 0)
							ri.setRelatedFromParam(matchedFromParamPair);
						if(matchedToParamPair.length > 0)
							ri.setRelatedToParam(matchedToParamPair);
						relation.setRelationType(ri.setRelationType());
						relation.addRelationItem(ri);
					}
				}		
			}	 
			
			return relation;
		}
		
		public function swapRelation(r:Relation):Relation
		{
			var t1:Tile = r.getTile1();
			var t2:Tile = r.getTile2();
			var relation:Relation = new Relation(t2, t1);
			var type:String = r.getRelationType();
			
			if(type == "from")
				relation.setRelationType("to");
			else
				if(type == "to")
					relation.setRelationType("from");
				else
					relation.setRelationType("both");
			var ris:ArrayCollection = r.getRelationItems();
			
			for(var i:int = 0; i < ris.length; i++){
				var ri:RelationItem = ris.getItemAt(i) as RelationItem;
				relation.addRelationItem(r.swapRI(ri));
			}
			
			return relation;
		}
		
		private function getMatchedParamPair(paramArr1:ArrayCollection, paramArr2:ArrayCollection, matchedParamPair:ArrayCollection, type:String):void
		{
			var length1:int = paramArr1.length;
			var length2:int = paramArr2.length;
			
			for(var i:int = 0; i < length1; i++){
				var p1:Param = paramArr1.getItemAt(i) as Param;
				for(var j:int = 0; j < length2; j++){
					var p2:Param = paramArr2.getItemAt(j) as Param;
					if(p1.classAttr == p2.classAttr && p1.className == p2.className){
						if((type == "from" && p1.required) || (type == "to" && p2.required))							
							matchedParamPair.addItem(new ParamPair(p1, p2, type));		
					}
					else
						if(p1.classAttr == p2.classAttr && belongToRootClass(p1.classAttr)){
						/*  该属性属于基类Object*/	
							if((type == "from" && p1.required) || (type == "to" && p2.required))
								matchedParamPair.addItem(new ParamPair(p1, p2, type));
						}
						else
							//if((p1.classAttr == "allType" && type == "from") || (p2.classAttr == "allType" && type == "to"))
							if(p1.classAttr == "allType" || p2.classAttr == "allType")
								matchedParamPair.addItem(new ParamPair(p1, p2, type));
				}
			}	
		}
		
		private function belongToRootClass(attr:String):Boolean 
		{
			var attrArr:ArrayCollection = rootClass.attributes;
			
			for(var i:int = 0; i < attrArr.length; i++){
				var attrItem:Attribute = attrArr.getItemAt(i) as Attribute;
				if(attrItem.name == attr)
					return true;
			}
			
			return false;
				
		} 
		
		private function addToRelationList(t1:Tile):void
		{
			
		}

	}
}