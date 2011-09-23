package dart.mashup.mashup
{
	import dart.mashup.tile.Service;
	
	import mx.collections.ArrayCollection;
	
	public class MashupPathBuilder
	{
		private var mpItemArr:ArrayCollection;
		
		public function MashupPathBuilder()
		{
			this.mpItemArr = new ArrayCollection();
		}
		
		var times:int = 0;
		public function getFinalMP():ArrayCollection
		{
			var ac:ArrayCollection = new ArrayCollection();
			times++;	
			for(var i:int = 0; i < mpItemArr.length; i++){
				var mpi:MashupPathItem = mpItemArr.getItemAt(i) as MashupPathItem;
				if(mpi.getRefCount() > 0)
					ac.addItem(mpi);
			//	else{
				/*	for(var j:int = 0; j < mpItemArr.length; j++){
						var tmpMPI:MashupPathItem = mpItemArr.getItemAt(j) as MashupPathItem;
						var pArr:ArrayCollection = tmpMPI.getParentIndexArr();
						for(var k:int = 0; k < pArr.length; k++){
							var pi:int = pArr.getItemAt(k) as int;
							if(pi == i)
								pArr.removeItemAt(k);
						}
					} */
				//}
			} 
			if(times == 3)
				trace("fadsf");
			
			for(var j:int = 0; j < ac.length; j++){
				var tMPI:MashupPathItem = ac.getItemAt(j) as MashupPathItem;
				var pArr:ArrayCollection = tMPI.getParentIndexArr();
				for(var k:int = 0; k < pArr.length; k++){
					var pi:int = pArr.getItemAt(k) as int;
					var pMPI:MashupPathItem = this.getMPIAt(pi);
					if(pMPI.getRefCount() <= 0){
						pArr.removeItemAt(k);
						tMPI.relatedFromParams.removeItemAt(k);
						k--;
					}
					else{
						var index:int = getIndex(ac, pMPI);
						pArr.setItemAt(index, k);
					}	
				}
			}
			this.mpItemArr.removeAll();
			for(var m:int = 0; m < ac.length; m++){
				this.mpItemArr.addItem(ac.getItemAt(m));
			}
			return ac;
		}
		
		private function getIndex(ar:ArrayCollection, mpi:MashupPathItem):int
		{
			for(var i:int = 0; i < ar.length; i++){
				var tMPI:MashupPathItem = ar.getItemAt(i) as MashupPathItem;
				if(tMPI.tilePacket.tile.name == mpi.tilePacket.tile.name)
					return i; 
			}
			
			return -1;
		}
		public function removeAllMPI():void
		{
			for(var i:int = 0; i < mpItemArr.length; i++){
				var mpi:MashupPathItem = mpItemArr.getItemAt(i) as MashupPathItem;
				mpi.getTilePacket().resetChosen();
				mpi.referencedCount = 0;
			}			
			this.mpItemArr.removeAll();
		}
		public function find(tp:TilePacket, s:Service):int
		{
			var length:int = mpItemArr.length;
			
			for(var i:int = 0; i < length; i++){
				var mpi:MashupPathItem = mpItemArr.getItemAt(i) as MashupPathItem;
				if(mpi.equalsTo2(tp, s))
					return i;
			}
			
			return -1;
		}
		
		public function addItem(mpi:MashupPathItem):int
		{
			this.mpItemArr.addItem(mpi);	
			return this.mpItemArr.length - 1;
		}
		
		public function removeMPI(index:int):void
		{
			//this.mpItemArr.removeItemAt(index);
			
		}
		
		public function getParents(mpi:MashupPathItem):ArrayCollection
		{
			var parentMPI:ArrayCollection = new ArrayCollection();
			var indexArr:ArrayCollection = mpi.getParentIndexArr();
			var n:int = indexArr.length;
			
			for(var i:int = 0; i < n; i++){
				var tmpMPI:MashupPathItem = this.getMPIAt(indexArr.getItemAt(i) as int);
				if(tmpMPI.getRefCount() <= 0)
					continue;
				parentMPI.addItem(tmpMPI);
			}
			
			return parentMPI;
		}
			
		
		public function getMPIIndex(mpi:MashupPathItem):int
		{
			var i:int;
			
			for(i = 0; i < this.mpItemArr.length; i++){
				var tmp:MashupPathItem = this.getMPIAt(i);
				if(tmp.getTilePacket().getTile().name == mpi.getTilePacket().getTile().name 
				&& tmp.getService().name == mpi.getService().name)
				return i;
			}
			
			return -1;
			
		}
		
		public function getParentIndexInMPI(mpi:MashupPathItem, parent:MashupPathItem):int
		{
			var parentIndexArr:ArrayCollection = mpi.getParentIndexArr();
			
			for(var i:int = 0; i < parentIndexArr.length; i++){
				var tmpMPI:MashupPathItem = this.getMPIAt(parentIndexArr.getItemAt(i) as int);
				if(tmpMPI.equalsTo(parent))
					return i;
			}	
			
			return -1;
		}
				
		public function getMPIAt(index:int):MashupPathItem
		{
			return this.mpItemArr.getItemAt(index) as MashupPathItem;
		}
		
		public function getMPIByTp(tp:TilePacket):ArrayCollection
		{
			var n:int = this.mpItemArr.length;
			var tmpArr:ArrayCollection = new ArrayCollection();
			var tpName:String = tp.getTile().name;
			
			for(var i:int = 0; i < n; i++){
				var mpi:MashupPathItem = this.mpItemArr.getItemAt(i) as MashupPathItem;
				var tmpTP:TilePacket = mpi.getTilePacket();
				if(tmpTP.getTile().name == tpName)
					tmpArr.addItem(mpi);	
			}
			
			return tmpArr;
		}
		public function getItemNumber():int
		{
			return this.mpItemArr.length;
		}
		
		public function setRoot():void
		{
			var n:int = this.mpItemArr.length;
			
			for(var i:int = 0; i < n; i++){
				var mpi:MashupPathItem = this.mpItemArr.getItemAt(i) as MashupPathItem;
				if(mpi.getRefCount() <= 0)
					continue;
				if(mpi.getParentIndexArr().length <= 0)
					mpi.setRoot();
			}
		}
		
		public function setMPIDepth():int
		{
			/* return max depth of this path */
			var n:int = this.mpItemArr.length;
			var tmpArr:ArrayCollection = new ArrayCollection();
			var i:int;
			var max:int = 0;
			
			for(i = 0; i < n; i++){
				var mpi2:MashupPathItem = this.mpItemArr.getItemAt(i) as MashupPathItem;
				mpi2.setDepth(0);
        		var parentIndexArr:ArrayCollection = mpi2.getParentIndexArr();
        		var parentNum:int = parentIndexArr.length;
        		var tmpNum:int = parentNum;
        		for(var k:int = 0; k < parentNum; k++){
        			var parentIndex:int = parentIndexArr.getItemAt(k) as int;
        		    var tmpMPI:MashupPathItem = this.getMPIAt(parentIndex);
        			if(tmpMPI.getRefCount() <= 0)
        				tmpNum--;
        		}
        		if(tmpNum == 0)
        			tmpArr.addItem(true);
        		else
					tmpArr.addItem(false);
			}
				
				
			for(i = 0; i < n; i++){
				var mpi:MashupPathItem = this.mpItemArr.getItemAt(i) as MashupPathItem;
				if(mpi.getRefCount() <= 0)
					continue;
				var tmp:int =  doSetDepth(mpi, tmpArr);
				max = max < tmp ? tmp : max;
			}
			
			return max;			
		}
		
		private function doSetDepth(mpi:MashupPathItem, tmpArr:ArrayCollection):int
		{
        	var parentIndexArr:ArrayCollection = mpi.getParentIndexArr();
        	var parentNum:int = parentIndexArr.length;
        	var depth:int = 0;
        	/* 计算该MPI的深度 */
        	for(var k:int = 0; k < parentNum; k++){
        		var parentIndex:int = parentIndexArr.getItemAt(k) as int;
        		var tmpMPI:MashupPathItem = this.getMPIAt(parentIndex);
        		if(tmpMPI.getRefCount() <= 0)
        			continue;
        		var processed:Boolean = tmpArr.getItemAt(parentIndex) as Boolean;
        		if(processed)
        			depth = tmpMPI.getDepth() + 1;
        		else
					depth = doSetDepth(tmpMPI, tmpArr) + 1;
				if(depth > mpi.getDepth())
					mpi.setDepth(depth);
        	} 
        	
        	for(var i:int = 0; i < parentNum; i++){
        		var index:int = parentIndexArr.getItemAt(i) as int;
        		tmpArr.setItemAt(true, index);
        	}
   		
        	return depth;
        }
        
        public function setMPIType():void
        {
        	var parentIndexArr:ArrayCollection = new ArrayCollection();
        	var i:int;
        	
        	for(i = 0; i < this.mpItemArr.length; i++){
        		var tmpMPI:MashupPathItem = this.getMPIAt(i);
        		if(tmpMPI.getRefCount() <= 0)
        			continue;
        		var parentArrItem:ArrayCollection = tmpMPI.getParentIndexArr();
        		var parentNum:int = parentArrItem.length;
        		if(parentNum == 0)
        			tmpMPI.setType("root");
        		else
        			for(var k:int = 0; k < parentNum; k++){
        				var parentIndex:int = parentArrItem.getItemAt(k) as int;
        				parentIndexArr.addItem(parentIndex);
        			}
        	}
        	var j:int;
        	var type:String;
        	for(i = 0; i < this.mpItemArr.length; i++){
            	var tmpMPI2:MashupPathItem = this.getMPIAt(i);
        		if(tmpMPI2.getRefCount() <= 0 || tmpMPI2.getType() == "root")
        			continue;    		
        		for(j = 0; j < parentIndexArr.length; j++){
        			var item:int = parentIndexArr.getItemAt(j) as int;
        			if(item == i){
        				type = "midNode";
        				break;
        			}
        		}
        		if(j == parentIndexArr.length)
        			type = "leaf";
        		tmpMPI2.setType(type);
        	}
        	
        }			
		

	}
}