package dart.mashup.mashup
{
	import dart.mashup.tile.Service;

	public class ServiceDic
	{
		private var tilePacket:TilePacket;
		private var service:Service;
		private var serviceDic:Array;
		
		public function ServiceDic(s:Service, tp:TilePacket)
		{
			this.service = s;
			this.tilePacket = tp;
			serviceDic = new Array();
		}
		
		public function addServiceRelationItem(tp:TilePacket, ri:RelationItem):void
		{
			var s1:Service = ri.getOper1();
			var s2:Service = ri.getOper2();
			var s:Service;
			var tmpType:String = ri.getRelationType();
			if(this.service.name == s1.name){
				s = s2;
			}
			else{
				s = s1;
				if(tmpType == "from")
					tmpType = "to";
				else
					if(tmpType == "to")
						tmpType = "from";
			}
			var tmpStr:String;
			if(tmpType == "both"){
				tmpStr = "--> " + this.service.name;
				serviceDic.push({relationItem:ri, tpName:tp.getTile().name, tilePacket:tp, service:s, description:s.desc, type:tmpStr});
				tmpStr = "<-- " + this.service.name;
				serviceDic.push({relationItem:ri, tpName:tp.getTile().name, tilePacket:tp, service:s, description:s.desc, type:tmpStr});
			}
			else{
				if(tmpType == "from")
					tmpStr = "--> " + this.service.name;
				else
					tmpStr = "<-- " + this.service.name;
				serviceDic.push({relationItem:ri, tpName:tp.getTile().name, tilePacket:tp, service:s, description:s.desc, type:tmpStr});
			}
		}
		
		public function getService():Service
		{
			return this.service;
		}
		
		public function getServiceDic():Array
		{
			return this.serviceDic;
		}
		
		public function toString():String
		{
			return this.service.name;
		}
		
		public function getTilePacket():TilePacket
		{
			return this.tilePacket;
		}

	}
}