package dart.mashup.mashup
{
	import dart.mashup.mashupApp.MashupApp;
	import dart.mashup.tile.Tile;
	
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	import mx.collections.Sort;
	import mx.collections.SortField;

	
	public class MPathRecommendor
	{
		public var relationDic:Dictionary;
		public var mashupApp:ArrayCollection;
		public var mpBuilder:MashupPathBuilder;
		public var tileDic:Dictionary;
		public var currentTile:Tile = null;
		public var candidateArr:ArrayCollection = new ArrayCollection();
		public var candidatePeople:ArrayCollection = new ArrayCollection();
		public var candidateUnusual:ArrayCollection = new ArrayCollection();
		public var repository:ArrayCollection = new ArrayCollection();
		
		public function MPathRecommendor(rd:Dictionary, ma:ArrayCollection, mb:MashupPathBuilder, td:Dictionary, size:int = -1)
		{
			this.relationDic = rd; 
			this.mashupApp = ma;
			this.mpBuilder = mb; 
			this.tileDic = td;
			setRepository(size);
		}
		
		private function setRepository(size:int):void
		{
			var length:int = size == -1 ? mashupApp.length : size;
			
			repository.removeAll();
			for(var i:int = 0; i < length; i++){
				var mashupAppItem:MashupApp = this.mashupApp.getItemAt(i) as MashupApp;
				var mpiArr:ArrayCollection = deserialize(mashupAppItem.tileSource);
				repository.addItem(mpiArr);
			}			
		}
		
		public function setCurrentTP(t:Tile):void
		{
			this.currentTile = t;			
		}
		public function doRecommend(type:String):void
		{	
			if(type == "robot"){
				this.candidateArr.removeAll();
				this.candidateUnusual.removeAll();
				recommendByRobot();
				//sortCandidate();
				var d:int = this.candidateUnusual.length / 10;
				var arr:ArrayCollection = new ArrayCollection();
				
				var s:int = 0;
				for(var i:int = 0; i < 10; i++){
					arr.addItem(this.candidateUnusual.getItemAt(s));
					s += d;
				}
				this.candidateUnusual = arr;
			}
			else			
				recommendByPeople();
		} 
		private function getResult(arr:ArrayCollection, canDic:Dictionary, type:String):void
		{
			var tmpRes:ArrayCollection = new ArrayCollection();
			var indexArr:ArrayCollection = new ArrayCollection();
			var tmpArr:ArrayCollection = new ArrayCollection();
			for(var prop:* in canDic){
				var ta:ArrayCollection = canDic[prop] as ArrayCollection;
				indexArr.addItem(0);
				tmpArr.addItem(ta);
			}
			var flag:int = 0;
			
			while(1){
				var nowIndex:int = -1;
				var nowValue:int = -1;
				var minObj:Object = null;
				var min:Number = 10;
				for(var i:int = 0; i < indexArr.length; i++){
					var index:int = indexArr.getItemAt(i) as int;
					var objArr:ArrayCollection= tmpArr.getItemAt(i) as ArrayCollection;
					if(index >= objArr.length){
						flag++;
						continue;
					}
					var obj:Object = objArr.getItemAt(index);
					var sw:Number = obj.probility as Number;
					if(sw <= min){
						min = sw;
						nowIndex = i;
						nowValue = index;
						minObj = obj;
					}
				}
				if(flag >= indexArr.length)
					break;
				indexArr.setItemAt(nowValue + 1, nowIndex);
				tmpRes.addItem(minObj);
			}
			var sIndex:int = 0;
			var len:int = 10;
			var tArr:ArrayCollection = this.candidateUnusual;
			if(type == "robot"){
				sIndex = tmpRes.length - 10;
				tArr = this.candidateArr;
			}
			var count:int = 0;
			while(count < 10){
				tArr.addItem(tmpRes.getItemAt(sIndex));
				sIndex++;
				count++;
			}
			
		}
		public function recommendByPeople():void
		{
			this.candidatePeople.removeAll();
			recommendByMashupApp();
		}
		private function recommendByRobot1():void
		{
			var i:int;
			var tmpDic:Dictionary = relationDic[currentTile.name] as Dictionary;
			var tmpCount2:int = 0;
			for (var prop:* in tmpDic){
				tmpCount2++;
				var tName:String = prop as String;
				var r:Relation = tmpDic[tName] as Relation;
				var type:String = r.getRelationType();
				var iterCount:int = type == "both" ?  2 : 1;
				var nowType:String = type == "both" ? "from" : type;
				while(iterCount-- > 0){
					tmpCount2++;
					var tmpCount:int = 0;
					for(var k:int = 0; k < repository.length; k++){
						var mpiArr:ArrayCollection = repository.getItemAt(k) as ArrayCollection;
						if(doFind(currentTile.name, tName, mpiArr, nowType))
							tmpCount++;
					}
					var p:Number = Number(tmpCount / repository.length);
					if(candidateArr.length < 10){
						var ri:RelationItem = r.getRelationItem(nowType);
						var newArr:ArrayCollection = cloneMP(currentTile.name, tName, nowType, null, ri);
						candidateArr.addItem({MCandidate: new MPathCandidate("", "", currentTile, tileDic[tName] as Tile, nowType, newArr, p, ri, true), probility:p});
					}
					else{
						sortCandidate(candidateArr);
						var obj:Object = candidateArr.getItemAt(0);
		                var minC:MPathCandidate = obj.MCandidate as MPathCandidate;
		                
		                if(minC.p < p){
		                	var ri2:RelationItem = r.getRelationItem(nowType);
		                	var newArr2:ArrayCollection = cloneMP(currentTile.name, tName, nowType, null, ri2);
		                	candidateArr.setItemAt({MCandidate: new MPathCandidate("", "", currentTile, tileDic[tName] as Tile, nowType, newArr2, p, ri2, true), probility:p}, 0);
		                	sortCandidate(candidateArr);
		                }
		                else{
		                	if(p == 0){
		                	var ri3:RelationItem = r.getRelationItem(nowType);
		                	var newArr3:ArrayCollection = cloneMP(currentTile.name, tName, nowType, null, ri3);
		                	this.candidateUnusual.addItem({MCandidate: new MPathCandidate("", "", currentTile, tileDic[tName] as Tile, nowType, newArr3, p, ri3, true), probility:p});
		                	}	                	
		                }
					} 
					nowType = "to";
				}
			}
		}
		var times:int = 0;
		public function recommendByRobot():Boolean
		{
			times++;

			
			var currentMPArr:ArrayCollection = mpBuilder.getFinalMP();
			if(times == 2)
				trace("fedfds");
			if(currentMPArr.length == 0){
				recommendByRobot1();
				return false;
			}
			else{
			var i:int;
			var resIndexArr:ArrayCollection = new ArrayCollection();
			for(i = 0; i < repository.length; i++)
				resIndexArr.addItem(-1);
			var count1:int = 0;
			for(i = 0; i < currentMPArr.length; i++){
				var mpi:MashupPathItem = currentMPArr.getItemAt(i) as MashupPathItem;
				var tp:TilePacket = mpi.getTilePacket();
				var t:Tile = tp.getTile();
				var pMP:ArrayCollection = mpBuilder.getParents(mpi);
				for(var j:int = 0; j < pMP.length; j++){
					var pMPI:MashupPathItem = pMP.getItemAt(j) as MashupPathItem;
					var pTile:Tile = pMPI.getTilePacket().getTile();
					find(t, pTile, resIndexArr);
				}
			}			
			for(i = 0; i < resIndexArr.length; i++){
				var tv:int = resIndexArr.getItemAt(i) as int;
				count1 = (tv == -1 ? count1 : count1 + 1);
			}
			var tmpCount2:int = 0;
			for(i = 0; i < currentMPArr.length; i++){
				var mpi2:MashupPathItem = currentMPArr.getItemAt(i) as MashupPathItem;
				var tp2:TilePacket = mpi2.getTilePacket();	
				var tmpDic:Dictionary = relationDic[tp2.tile.name] as Dictionary;
				for (var prop:* in tmpDic){
					tmpCount2++;
					var tName:String = prop as String;
					if(!exist(tp2.tile.name, tName, currentMPArr)){
						var r:Relation = tmpDic[tName] as Relation;
						var type:String = r.getRelationType();
						var iterCount:int = type == "both" ?  2 : 1;
						var nowType:String = type == "both" ? "from" : type;
						while(iterCount-- > 0){
							var tmpCount:int = 0;
							tmpCount2++;
							for(var k:int = 0; k < resIndexArr.length; k++){
								var tmp:int = resIndexArr.getItemAt(k) as int;
								if(tmp == -1)
									continue;
								var mpiArr:ArrayCollection = repository.getItemAt(k) as ArrayCollection;
								if(doFind(tp2.tile.name, tName, mpiArr, nowType))
									tmpCount++;
							}
							var p:Number = Number(tmpCount / count1);
							if(candidateArr.length < 10){
								var ri:RelationItem = r.getRelationItem(nowType);
								var newArr:ArrayCollection = cloneMP(tp2.tile.name, tName, nowType, currentMPArr, ri);
								candidateArr.addItem({MCandidate: new MPathCandidate("", "", tileDic[tp2.tile.name] as Tile, tileDic[tName] as Tile, nowType, newArr, p, ri, true), probility:p});
								sortCandidate(candidateArr);
							}
							else{
								var obj:Object = candidateArr.getItemAt(0);
				                var minC:MPathCandidate = obj.MCandidate as MPathCandidate;
				                if(minC.p < p || (minC.p == p && tmpCount2 % 2 == 0)){
				                	var ri2:RelationItem = r.getRelationItem(nowType);
				                	var newArr2:ArrayCollection = cloneMP(tp2.tile.name, tName, nowType, currentMPArr, ri2);
				                	candidateArr.setItemAt({MCandidate: new MPathCandidate("", "", tileDic[tp2.tile.name] as Tile, tileDic[tName] as Tile, nowType, newArr2, p, ri2, true), probility:p}, 0);
				                	sortCandidate(candidateArr);
				                }
				                else{
				                	if(p == 0){
				                		var ri3:RelationItem = r.getRelationItem(nowType);
				                		var newArr3:ArrayCollection = cloneMP(tp2.tile.name, tName, nowType, currentMPArr, ri3);
				                		candidateUnusual.addItem({MCandidate: new MPathCandidate("", "", tileDic[tp2.tile.name] as Tile, tileDic[tName] as Tile, nowType, newArr3, p, ri3, true), probility:p});
				                	}				                		
				                	}
							} 
							nowType = "to";
						}
					}
				}
			}
			}
			
			return true;	
		}
		
		private function cloneMP1(t1:String, t2:String, type:String, ri:RelationItem):ArrayCollection
		{
			var newArr:ArrayCollection = new ArrayCollection();
			var nMPI:MashupPathItem = new MashupPathItem();
			var tmp:Tile = tileDic[t1] as Tile;
			nMPI.setTile(tmp);
			nMPI.setService(ri.getOper1());
			nMPI.increaseRefCount();
			var nMPI2:MashupPathItem = new MashupPathItem();
			var tmp2:Tile = tileDic[t2] as Tile;
			nMPI2.setTile(tmp2);
			nMPI2.setService(ri.getOper2());
			nMPI2.increaseRefCount();
			
			if(type == "from"){
				newArr.addItem(nMPI2);
				newArr.addItem(nMPI);
				var d:Dictionary = relationDic[t1] as Dictionary;
				var r:Relation = d[t2] as Relation;
				var ri:RelationItem = r.getRelationItems().getItemAt(0) as RelationItem;		
				nMPI.setParent(0, ri == null ? null : ri.getRelatedFromParams());
				nMPI2.increaseRefCount();
				nMPI.setDepth(1);
			}
			else{
				newArr.addItem(nMPI);
				newArr.addItem(nMPI2);
				var d2:Dictionary = relationDic[t2] as Dictionary;
				var r2:Relation = d2[t1] as Relation;
				var ri2:RelationItem = r2.getRelationItems().getItemAt(0) as RelationItem;		
				nMPI2.setParent(0, ri2 == null ? null : ri2.getRelatedFromParams());
				nMPI.increaseRefCount();		
				nMPI2.setDepth(1);		
			}
			
			return newArr;
				
		}
		
		private function cloneMP(tName:String, newTName:String, type:String, cmp:ArrayCollection, ri:RelationItem):ArrayCollection
		{
			if(cmp == null)
				return cloneMP1(tName, newTName, type, ri);
			//if(newTName == "Upcoming" && tName == "Flickr")
			//	trace("hrere");
			var newArr:ArrayCollection = new ArrayCollection();
			var index:int = -1;
			var index2:int = -1;
			var i:int;
			for(i = 0; i < cmp.length; i++){
				var mpi:MashupPathItem = cmp.getItemAt(i) as MashupPathItem;
				if(mpi.getTilePacket().tile.name == tName)
					index = i;
				else
					if(mpi.getTilePacket().tile.name == newTName)
						index2 = i;
				var newMPI:MashupPathItem = new MashupPathItem();
				newMPI.clone(mpi, null, false);
				newArr.addItem(newMPI);
			}
			var tMPI:MashupPathItem = newArr.getItemAt(index) as MashupPathItem;
			var nMPI:MashupPathItem;
			if(index2 == -1){
				nMPI = new MashupPathItem();
				var tmp:Tile = tileDic[newTName] as Tile;
		//		trace(newTName + "  " + tmp.name);
				nMPI.setTile(tmp);
			//	nMPI.setService(tmp.services.getItemAt(0) as Service);
				nMPI.setService(ri.getOper2());
				nMPI.increaseRefCount();
				newArr.addItem(nMPI);
				index2 = newArr.length - 1;
			}
			else{
				nMPI = newArr.getItemAt(index2) as MashupPathItem;
			}
			if(type == "from"){
				var d:Dictionary = relationDic[tName] as Dictionary;
				var r:Relation = d[newTName] as Relation;
				var ri:RelationItem = r.getRelationItems().getItemAt(0) as RelationItem;		
				tMPI.setParent(index2, ri == null ? null : ri.getRelatedFromParams());
				nMPI.increaseRefCount();
			}
			else{
				var d2:Dictionary = relationDic[newTName] as Dictionary;
				var r2:Relation = d2[tName] as Relation;
				var ri2:RelationItem = r2.getRelationItems().getItemAt(0) as RelationItem;		
				nMPI.setParent(index, ri2 == null ? null : ri2.getRelatedFromParams());
				tMPI.increaseRefCount();				
			}
			var maxIndex:int = setMPIDepth(newArr);
			var tmpDic:Dictionary = getParentsDic(newArr);
			// insertion sort 
			var j:int; var k:int;
			for(j = 1; j < newArr.length; j++){
				var mpi2:MashupPathItem = newArr.getItemAt(j) as MashupPathItem;
				var nowIndex:int = j ;
				var tmpD:int = mpi2.getDepth();
				k = j - 1;
				while(k >= 0){
					var nowMPI:MashupPathItem = newArr.getItemAt(k) as MashupPathItem;
					if(nowMPI.getDepth() > tmpD){
						newArr.setItemAt(nowMPI, k + 1);
					//	updateParentIndex(newArr, k, k + 1);
						k--;
					}
					else
						break;
				}
				newArr.setItemAt(mpi2, k + 1);
			//	updateParentIndex(newArr, j, k + 1);
			}
			
			// set parent index 
			for(j = 0; j < newArr.length; j++){
				var mpi3:MashupPathItem = newArr.getItemAt(j) as MashupPathItem;
				var pArr:ArrayCollection = mpi3.getParentIndexArr();
				pArr.removeAll();
				var rfArr:ArrayCollection = mpi3.getRelatedFromParams();
				rfArr.removeAll();
				var pDic:Dictionary = tmpDic[mpi3.tile.name];
				for(var prop:* in pDic){
					var pName:String = prop as String;
					var rf:ArrayCollection = pDic[prop] as ArrayCollection;
					var pIndex3:int = getMPIIndex(pName, newArr);
					mpi3.setParent(pIndex3, rf);
					// 备份relatedFromParams
				}
			}
			return newArr;
		}
		
		private function getMPIIndex(tName:String, arr:ArrayCollection):int
		{
			for(var i:int = 0; i < arr.length; i++){
				var mpi:MashupPathItem = arr.getItemAt(i) as MashupPathItem;
				if(mpi.tile.name == tName)
					return i;
			}
			
			return -1;
		}
		public function setMPIDepth(arr:ArrayCollection):int
		{
			/* return max depth of this path */
			var n:int = arr.length;
			var tmpArr:ArrayCollection = new ArrayCollection();
			var i:int;
			var max:int = 0;
			var index:int = -1;
			for(i = 0; i < n; i++){
				var mpi2:MashupPathItem = arr.getItemAt(i) as MashupPathItem;
				mpi2.setDepth(0);
        		var parentIndexArr:ArrayCollection = mpi2.getParentIndexArr();
        		var parentNum:int = parentIndexArr.length;
        		var tmpNum:int = parentNum;
        		for(var k:int = 0; k < parentNum; k++){
        			var parentIndex:int = parentIndexArr.getItemAt(k) as int;
        		    var tmpMPI:MashupPathItem = arr.getItemAt(parentIndex) as MashupPathItem;
        			if(tmpMPI.getRefCount() <= 0)
        				tmpNum--;
        		}
        		if(tmpNum == 0)
        			tmpArr.addItem(true);
        		else
					tmpArr.addItem(false);				
			}
						
			for(i = 0; i < n; i++){
				var mpi:MashupPathItem = arr.getItemAt(i) as MashupPathItem;
				var tmp:int =  doSetDepth(mpi, tmpArr, arr);
				if(max < tmp){
					max = tmp;
					index = i;
				}
			}
			
			return index;			
		}
		
		private function doSetDepth(mpi:MashupPathItem, tmpArr:ArrayCollection, arr:ArrayCollection):int
		{
        	var parentIndexArr:ArrayCollection = mpi.getParentIndexArr();
        	var parentNum:int = parentIndexArr.length;
        	var depth:int = 0;
        	/* 计算该MPI的深度 */
        	for(var k:int = 0; k < parentNum; k++){
        		var parentIndex:int = parentIndexArr.getItemAt(k) as int;
        		var tmpMPI:MashupPathItem = arr.getItemAt(parentIndex) as MashupPathItem;
        		var processed:Boolean = tmpArr.getItemAt(parentIndex) as Boolean;
        		if(processed)
        			depth = tmpMPI.getDepth() + 1;
        		else
					depth = doSetDepth(tmpMPI, tmpArr, arr) + 1;
				if(depth > mpi.getDepth())
					mpi.setDepth(depth);
        	} 
        	
        	for(var i:int = 0; i < parentNum; i++){
        		var index:int = parentIndexArr.getItemAt(i) as int;
        		tmpArr.setItemAt(true, index);
        	}
        	
        	return depth;
        }		
		private function updateParentIndex(arr:ArrayCollection, oldIndex:int, newIndex:int):void
		{
			for(var i:int = 0; i < arr.length; i++){
				var mpi:MashupPathItem = arr.getItemAt(i) as MashupPathItem;
				var pArr:ArrayCollection = mpi.getParentIndexArr();
				for(var j:int = 0; j < pArr.length; j++){
					var pi:int = pArr.getItemAt(j) as int;
					if(pi == oldIndex) 
						pArr.setItemAt(newIndex, j);
				}
			}
		}
		private function updateDepth(index:int, arr:ArrayCollection):void
		{
			for(var i:int = 0; i < arr.length; i++){
				var mpi:MashupPathItem = arr.getItemAt(i) as MashupPathItem;
				var pIndexArr:ArrayCollection = mpi.getParentIndexArr();
				for(var j:int = 0; j < pIndexArr.length; j++){
					var tmpIndex:int = pIndexArr.getItemAt(j) as int;
					if(tmpIndex == index){
						var pMPI:MashupPathItem = arr.getItemAt(index) as MashupPathItem;
						var d:int = pMPI.getDepth() + 1;
						if(d > mpi.getDepth()){
							mpi.setDepth(d);
							updateDepth(i, arr);
						}
						break;
					}
				}
			}	
		}
		private function find(t:Tile, pTile:Tile, ia:ArrayCollection):void
		{	
			for(var k:int = 0; k < repository.length; k++){
				var mpiArr:ArrayCollection = repository.getItemAt(k) as ArrayCollection;
				if(doFind(t.name, pTile.name, mpiArr))
					ia.setItemAt(1, k);		
			}
		}
		
		private function doFind(tName:String, pTName:String, mpiArr:ArrayCollection, type:String = "from"):Boolean
		{
			if(type == "to"){
				var str:String = tName;
				tName = pTName;
				pTName = str;
			}
			for(var i:int = 0; i < mpiArr.length; i++){
				var mpi:MashupPathItem = mpiArr.getItemAt(i) as MashupPathItem;
				var t:Tile = mpi.tile;
				if(t.name == tName){
					var pIndexArr:ArrayCollection = mpi.getParentIndexArr();
					for(var j:int = 0; j < pIndexArr.length; j++){
						var index:int = pIndexArr.getItemAt(j) as int;
						var pMPI:MashupPathItem = mpiArr.getItemAt(index) as MashupPathItem;
						if(pTName == pMPI.tile.name)
							return true;
					}
				}
			}
			
			return false;
		}

		private function calcProbility(t1:String, t2:String, type:String):void
		{
						
		}
		
		private function exist(t1:String, t2:String, currentMPArr:ArrayCollection):Boolean
		{
			var index1:int = -1;
			var index2:int = -1;
			
			if(t1 == "UserInput" || t2 == "UserInput")
				return true;
			for(var i:int = 0; i < currentMPArr.length; i ++){
				var mpi:MashupPathItem = currentMPArr.getItemAt(i) as MashupPathItem;
				if(mpi.getRefCount() <= 0 ){
			//		trace("<=0  " + mpi.getTilePacket().getTile().name)
					continue;
				}
				if(mpi.getTilePacket().tile.name == t1)
					index1 = i;
				else
					if(mpi.getTilePacket().tile.name == t2)
						index2 = i;
				var pIndexArr:ArrayCollection = mpi.getParentIndexArr();
				for(var j:int = 0; j < pIndexArr.length; j++){
					var index:int = pIndexArr.getItemAt(j) as int;
					var pMPI:MashupPathItem = mpBuilder.getMPIAt(index) as MashupPathItem;
					if(pMPI.getRefCount() <= 0)
						continue;
					var tName:String  = pMPI.getTilePacket().getTile().name;
					if((tName == t1 && mpi.getTilePacket().getTile().name == t2) || (tName == t2 && mpi.getTilePacket().tile.name == t1))
						return true;
				}
			}
			
			if(index1 != -1 && index2 != -1 && index1 > index2)
				return true;
			return false;
		}
		public function recommendByMashupApp(): void
		{
			var i:int;
			var minSW:Number = 10.0;
			var minIndex:int = 0;
			/* recommended by existing mashupApps */
			var currentMPArr:ArrayCollection = mpBuilder.getFinalMP();
			for(i = 0; i < mashupApp.length; i++){
				var mashupAppItem:MashupApp = mashupApp.getItemAt(i) as MashupApp;
				var mpiArr:ArrayCollection = deserialize(mashupAppItem.tileSource);
				
				var sw:Number = calcSimilarityWeight(mpiArr, currentMPArr, currentTile);
				if(candidatePeople.length < 10){
					candidatePeople.addItem({MCandidate: new MPathCandidate(mashupAppItem.name, mashupAppItem.description, null, null, "", mpiArr, sw, null, false), probility:sw});
				}
				else{
					sortCandidate(candidatePeople);
					var minObj:Object = candidatePeople.getItemAt(0);
	                var minC:MPathCandidate = minObj.MCandidate as MPathCandidate;
	                if(minC.p < sw){
	                	candidatePeople.setItemAt({MCandidate: new MPathCandidate(mashupAppItem.name, mashupAppItem.description, null, null, "", mpiArr, sw, null, false), probility:sw}, 0);
	                	sortCandidate(candidatePeople);
	                }
				}
			}
		}
		
		private function calcSimilarityWeight(mapp:ArrayCollection, currentMPArr:ArrayCollection, currentTile:Tile = null):Number
		{
			var sw:Number = 0.0;
			var currentMPLength:int = 0;
			var graphNum:int = 0;
			var itemNum:int = 0;
		//	var resObj:Object = new Object();
		///	resObj.graphNum = 0;
		//	resObj.itemNum = 0;
			var dic:Dictionary = getParentsDic(mapp);
			if(currentMPArr.length == 0){
				if(dic[currentTile.name] != null)
					itemNum ++;
				sw = Number(itemNum / mapp.length);
			}
			else{
				for(var i:int = 0; i < currentMPArr.length; i++){
					var cmpItem:MashupPathItem = currentMPArr.getItemAt(i) as MashupPathItem;
					var pMP:ArrayCollection = mpBuilder.getParents(cmpItem);
					currentMPLength += pMP.length;
					for(var j:int = 0; j < pMP.length; j++){
						var pItem:MashupPathItem = pMP.getItemAt(j) as MashupPathItem;
						var tmpDic:Dictionary = dic[cmpItem.getTilePacket().tile.name];
						if(tmpDic != null){
							itemNum++;
							if(tmpDic[pItem.getTilePacket().tile.name] != null)
								graphNum++;
						}
						//var canPMP:ArrayCollection = mapp		
					}
				}
				
				sw = Number(graphNum / currentMPLength) + Number(itemNum / currentMPArr.length);
			}
			
			return sw;
		}
		
		private function getParentsDic(mapp:ArrayCollection):Dictionary
		{
			var dic:Dictionary = new Dictionary();
			
			for(var i:int = 0; i < mapp.length; i++){
				var mpi:MashupPathItem = mapp.getItemAt(i) as MashupPathItem;
				var tmpArr:Dictionary = new Dictionary()
				dic[mpi.tile.name] = tmpArr;
				var pIndexArr:ArrayCollection = mpi.getParentIndexArr();
				var rf:ArrayCollection = mpi.getRelatedFromParams();
				for(var j:int = 0; j < pIndexArr.length; j++){
					var index:int = pIndexArr.getItemAt(j) as int;
					var tmpMPI:MashupPathItem = mapp.getItemAt(index) as MashupPathItem;
					tmpArr[tmpMPI.tile.name] = rf.getItemAt(j);
				}
				//	tmpArr.addItem(mapp.getItemAt(pIndexArr.getItemAt(j)));
			}
			
			return dic;
		}
		private function sortCandidate(arr:ArrayCollection):void
		{
			/* sort the result first */
 			var dataSortField:SortField = new SortField("probility");
            dataSortField.numeric = true;
            /* Create the Sort object and add the SortField object created earlier to the array of fields to sort on. */
            var numericDataSort:Sort = new Sort();
            numericDataSort.fields = [dataSortField];	
            /* Set the ArrayCollection object's sort property to our custom sort, and refresh the ArrayCollection. */
            arr.sort = numericDataSort;
            arr.refresh();			
		}
		private function deserialize(mpStr:String):ArrayCollection
		{
			var result:ArrayCollection = new ArrayCollection();
			var mpiStrArr:Array = mpStr.split("    ");
			var i:int;
			
			for(i = 0; i < mpiStrArr.length; i++){
				var mpi:MashupPathItem = new MashupPathItem();
				var mpiStr:String = mpiStrArr[i] as String;
				mpiStr = mpiStr.substring(1, mpiStr.length - 1);
				var eleArr:Array = mpiStr.split("  ,  ");
				var tName:String = eleArr[0].substr(eleArr[0].indexOf(":") + 1);
				var tile:Tile = tileDic[tName] as Tile;
				mpi.setTile(tile);
				var sName:String = eleArr[1].substr(eleArr[1].indexOf(":") + 1);
				mpi.setService(tile.findService(sName));
				var type:String = eleArr[2].substr(eleArr[2].indexOf(":") + 1);
				mpi.setType(type);
				mpi.increaseRefCount();
				setParents(mpi, eleArr[5], result);
				result.addItem(mpi);
				
			}
			
			return result;
		}
		
		private function setParents(mpi:MashupPathItem, eleArr:String, result:ArrayCollection):void
		{
			var tmpStr:String = eleArr.substr(eleArr.indexOf(":") + 1);
			if(tmpStr == "[]")
				return ;
			var str:String = tmpStr.substring(1, tmpStr.length - 1);
			var paraArr:Array = str.split("+++");  
			var i:int;
			
			for(i = 0; i < paraArr.length; i++){
				var pItem:String = paraArr[i] as String;
				var index:int = pItem.lastIndexOf(".");
				var tName:String = pItem.substring(0, index);
				var sName:String = pItem.substr(index + 1, pItem.length);
				var d:Dictionary = relationDic[mpi.tile.name] as Dictionary;
				var r:Relation = d[tName] as Relation;
			//	trace(mpi.tile.name + "." + mpi.getService().name + "\t" + tName + "." + sName);
				var ri:RelationItem = r.findRelationItem(mpi.getService().name, sName);
				for(var j:int = 0; j < result.length; j++){
					var tmpMPI:MashupPathItem = result.getItemAt(j) as MashupPathItem;
					if(tmpMPI.tile.name == tName && tmpMPI.getService().name == sName){
						if(ri != null)
							mpi.setParent(j, ri.getRelatedFromParams());
						else
							mpi.setParent(j, null);
						if(tmpMPI.getDepth() + 1 > mpi.getDepth())
							mpi.setDepth(tmpMPI.getDepth() + 1);
						tmpMPI.increaseRefCount();
						break;
					}
				}		
			}
		}
		

	}
}