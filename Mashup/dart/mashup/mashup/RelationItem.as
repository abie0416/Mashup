package dart.mashup.mashup
{
	import dart.mashup.tile.Param;
	import dart.mashup.tile.Service;
	
	import mx.collections.ArrayCollection;
	
	public class RelationItem
	{
		private var oper1:Service;
		private var oper2:Service;
		private var relatedFromParams:ArrayCollection;
		private var relatedToParams:ArrayCollection;
		private var relationType:String; /* from, to , both */
		
		public function RelationItem(oper1:Service, oper2:Service)
		{
			relatedFromParams = new ArrayCollection();
			relatedToParams = new ArrayCollection();
			this.oper1 = oper1;
			this.oper2 = oper2;
		}
		
		public function getOper1():Service
		{
			return this.oper1;
		}
		
		public function getOper2():Service
		{
			return this.oper2;
		}
		
		public function getRelatedFromParams():ArrayCollection
		{
			return this.relatedFromParams;
		}
		
		public function getRelatedToParams():ArrayCollection
		{
			return this.relatedToParams;
		}
		
		public function swapRelatedParams(rps:ArrayCollection):void
		{
			var length:int = rps.length;
			
			for(var i:int = 0; i < length; i++){
				var pp:ParamPair = rps.getItemAt(i) as ParamPair;
				pp.swapParam();
			}	
		}
		
		public function swapRelatedParams2(rps:ArrayCollection):ArrayCollection
		{
			var length:int = rps.length;
			var newRPS:ArrayCollection = new ArrayCollection();
			
			for(var i:int = 0; i < length; i++){
				var pp:ParamPair = rps.getItemAt(i) as ParamPair;
				newRPS.addItem(swapParamPair(pp));
			}	
			
			return newRPS;
		}
		
		public function swapParamPair(pp:ParamPair):ParamPair
		{
			var p1:Param = pp.getParam1();
			var p2:Param = pp.getParam2();
			var type:String = pp.getType() == "from" ? "to" : "from";
			
			return new ParamPair(p2, p1, type);
		}
				
		public function setRelatedFromParam(p:ArrayCollection):void
		{
			this.relatedFromParams = p;
		}
		
		public function setRelatedToParam(p:ArrayCollection):void
		{
			this.relatedToParams = p;
		}
		
		public function setRelationType():String
		{
			var length1:int = relatedFromParams.length;
			var length2:int = relatedToParams.length;
			
			if(length1 > 0 && length2 > 0)
				this.relationType = "both";
			else
				if(length1 > 0)
					this.relationType = "from";
				else
					this.relationType = "to";
					
			return this.relationType;
			
		}
		
		public function setRT(t:String):void
		{
			this.relationType = t;
		}
		public function getRelationType():String
		{
			return this.relationType;	
		}

	}
}