package dart.mashup.mashup
{
	public class TilePacketRelationItem
	{
		private var tilePacket:TilePacket;
		private var relation:Relation;
		private var type:String;
		
		public function TilePacketRelationItem(tilePacket:TilePacket, relation:Relation)
		{
			this.tilePacket = tilePacket;
			this.relation = relation;
			this.type = relation.getRelationType();
		}
		
		public function getTilePacket():TilePacket
		{
			return this.tilePacket;
		}
		
		public function getRelation():Relation
		{
			return this.relation;
		}

		public function getRelationType():String
		{
			return this.type;
		}
		
		
	}
}