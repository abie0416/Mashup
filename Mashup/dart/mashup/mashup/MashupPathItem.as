package dart.mashup.mashup
{
	import dart.mashup.tile.Service;
	import dart.mashup.tile.Tile;
	
	import mx.collections.ArrayCollection;
	
	public class MashupPathItem
	{
		public var tilePacket:TilePacket;
		private var service:Service;
		/* relatedParams and parent should have the same size, so that we can get the right relatedParams for each parent */
		public var relatedFromParams:ArrayCollection;
		public var parent:ArrayCollection;
		public var referencedCount:int = 0;
		private var depth:int = 0;
		private var isRoot:Boolean = false;
		public var hasSetParamValue:Boolean = false;
		/* 设置该MPI在整个mashup路径中的属性 */
		/* 'root', 'midNode', 'leaf' */
		private var type:String;
		
		public var tile:Tile;
		
		public function MashupPathItem()
		{
			this.parent = new ArrayCollection();
			this.relatedFromParams = new ArrayCollection();
		}
		
		public function clone(mpi:MashupPathItem, tp:TilePacket = null, flag:Boolean = true):void
		{
			if(flag)
				this.tilePacket = tp;
			this.service = mpi.getService();
			var trfp:ArrayCollection = mpi.getRelatedFromParams();
			for(var i:int = 0; i < trfp.length; i++)
				this.relatedFromParams.addItem(trfp.getItemAt(i));
			var pArr:ArrayCollection = mpi.getParentIndexArr();
			for(var j:int = 0; j < pArr.length; j++)
				this.parent.addItem(pArr.getItemAt(j));
			//this.referencedCount += this.parent.length;
		//	this.relatedFromParams = mpi.getRelatedFromParams();
		//	this.parent = mpi.getParentIndexArr();
			if(flag)
				this.tile = mpi.tile;
			else
				this.tile = mpi.getTilePacket().tile;
		}
		public function setTile(t:Tile):void
		{
			this.tile = t;
		}
		
		public function setTilePacket(tp:TilePacket):void
		{
			this.tilePacket = tp;
		}
		
		public function setService(s:Service):void
		{
			this.service = s;
		}
		
		public function setParent(index:int, rp:ArrayCollection = null):void
		{
			this.parent.addItem(index);
			this.relatedFromParams.addItem(rp);
		}
		
		public function setType(type:String):void
		{
			this.type = type;
		}
		
		public function removeParent(value:int):void
		{
			var n:int = parent.length;
			var i:int;
			
			for(i = 0; i < n; i++){
				var tmpValue:int = this.parent.getItemAt(i) as int;
				if(tmpValue == value)
					break;
			}
			this.parent.removeItemAt(i);
			this.relatedFromParams.removeItemAt(i);
		}
		
		
		public function getRelatedFromParams():ArrayCollection
		{
			return this.relatedFromParams;
		}
		
		public function getTilePacket():TilePacket
		{
			return this.tilePacket;
		}
		
		public function getTile():Tile
		{
			return this.tile;
		}
		
		public function getService():Service
		{
			return this.service;
		}
		
		public function getParentIndexArr():ArrayCollection
		{
			return this.parent;
		}
		
		public function getType():String
		{
			return this.type;
		}
		
		public function increaseRefCount():void
		{
			if(this.referencedCount <= 0)
				this.referencedCount = 1;
			else
				this.referencedCount ++; 
		}
		
		public function descreaseRefCount():int
		{
			/* 如果 <0 ==》 这个MPI已被删除 (逻辑删除)*/
			this.referencedCount --;
			
			return this.referencedCount;
		}
		
		public function getRefCount():int
		{
			return this.referencedCount;
		}
		
		public function setDepth(d:int):void
		{
			this.depth = d;	
		}
		
		public function getDepth():int
		{
			return this.depth;
		}
		
		public function setRoot():void
		{
			this.isRoot = true;
		}
		
		public function isPathRoot():Boolean
		{
			return this.isRoot;
		}
		
		public function equalsTo(mpi:MashupPathItem):Boolean
		{
			return (this.tilePacket.getTile().name == mpi.tilePacket.getTile().name && this.service.name == mpi.service.name);  
		}
		
		public function equalsTo2(tp:TilePacket, s:Service):Boolean
		{
			// 为了测试起见， 缩小等于的范围
		//	return (this.tilePacket.getTile().name == tp.getTile().name && this.service.name == s.name);
			return  this.tilePacket.getTile().name == tp.getTile().name; 
		}
		
		public function toString():String
		{
			return this.service.toString();
		}

	}
}