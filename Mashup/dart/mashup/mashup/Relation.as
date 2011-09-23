package dart.mashup.mashup
{
	import dart.mashup.tile.Service;
	import dart.mashup.tile.Tile;
	
	import mx.collections.ArrayCollection;
	
	public class Relation
	{
		private var t1:Tile;
		private var t2:Tile;
		private var relations:ArrayCollection;
		private var type:String;
		
		public function Relation(t1:Tile, t2:Tile)
		{
			this.relations = new ArrayCollection();
			this.t1 = t1;
			this.t2 = t2;
			type = "";
		}
		
		public function addRelationItem(item:RelationItem):void
		{
			this.relations.addItem(item);
		}
		
		public function getRelationItems():ArrayCollection
		{
			return this.relations;
		}
		
		public function isEmpty():Boolean
		{
			return this.relations.length == 0 ? true : false; 
		}
		
		public function getTile1():Tile
		{
			return this.t1;
		}
		
		public function getTile2():Tile
		{
			return this.t2;
		}
		
		public function setRelationType(type:String):void
		{
			if(this.type == "")
				this.type = type;
			else
				if((this.type == "from" && type == "to") || (this.type == "to" && type == "from"))
						this.type = "both";
		}
		
		public function getRelationType():String
		{
			return this.type;
		}
		
		public function getRelationItem(t:String):RelationItem
		{
			var ri:RelationItem;
			for(var i:int = 0; i < this.relations.length; i++){
				ri = this.relations.getItemAt(i) as RelationItem;
				if(ri.getRelationType() == t || ri.getRelationType() == "both")
					return ri;
			}
			
			return ri;
			
		}
		public function swapRI(ri:RelationItem):RelationItem
		{
			var s1:Service = ri.getOper1();
			var s2:Service = ri.getOper2();
			var newRI:RelationItem = new RelationItem(s2, s1);
			var type:String = ri.getRelationType();
		
			if(type == "from") 
				newRI.setRT("to");
			else
				if(type == "to")
					newRI.setRT("from");
				else
					newRI.setRT("both");		
			var rfParam:ArrayCollection = ri.getRelatedFromParams();
			newRI.setRelatedToParam(ri.swapRelatedParams2(rfParam));
			newRI.setRelatedFromParam(ri.swapRelatedParams2(ri.getRelatedToParams()));
				
			return newRI;		
		}
		
		public function findRelationItem(s1:String, s2:String):RelationItem
		{
			for(var i:int = 0; i < this.relations.length; i++){
				var ri:RelationItem = relations.getItemAt(i) as RelationItem;
				if(ri.getOper1().name == s1 && ri.getOper2().name == s2)
					return ri;
			}
			
			return null;
		}

	}
}