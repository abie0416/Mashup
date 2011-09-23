package dart.mashup.mashup
{
	import dart.mashup.tile.Tile;
	
	import mx.collections.ArrayCollection;
	
	public class MPathCandidate
	{
		public var description:String;
		public var name:String;
		public var mpiArr:ArrayCollection;
		public var p:Number; /* similarity weight */
		public var oper:String = "";
		
		public function MPathCandidate(s1:String = "", desc:String = "", t1:Tile = null, t2:Tile = null, 
		type:String = "", mpiArr:ArrayCollection = null, p:Number = 0.0, ri:RelationItem = null, flag:Boolean = true)
		{
			var str1:String = "";
			var str2:String = "";
			if(flag){
				str1 = t2.name + ": " + t2.text;
				if(str1.length > 80)
					str1 = str1.substr(0, 75) + "...";
				str2 = t1.name + ": " + t1.text;
				if(str2.length > 80)
					str2 = str2.substr(0, 75) + "...";					
				if(type == "from"){
					this.name = t2.name + "-->" + t1.name;
				
					this.description = str1 + "\n" + str2;
					this.oper = "Mashupable Operations: " + ri.getOper2().name + "\n->" + ri.getOper1().name;
				}
				else{
					this.name = t1.name + "-->" + t2.name;
					this.description = str2 + "\n" + str1;
					this.oper = "Mashupable Operations: " + ri.getOper1().name + "\n->" + ri.getOper2().name;
				}
				if(this.description.length > 150)
					this.description = this.description.substr(0, 197) + "..."; 
			}
			else{
				this.name = s1;
				this.description = desc;
			}
			this.mpiArr = mpiArr;
			this.p = p;
			
			
		}

	}
}