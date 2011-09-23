package dart.mashup.mashup
{
	import dart.mashup.tile.Param;
	
	public class ParamPair
	{
		private var param1:Param;
		private var param2:Param;
		private var type:String; /* 'from' === param1's vaule is from param2; 'to' === param2's value is from param1 */
		
		public function ParamPair(param1:Param, param2:Param, type:String)
		{
			this.param1 = param1;
			this.param2 = param2;
			this.type = type;
		}
		
		public function swapParam():void
		{
			var tmp:Param = this.param1;
			this.param1 = this.param2;
			this.param2 = tmp;
		}
		
		
		public function getParam1():Param
		{
			return this.param1;
		}
		
		public function getParam2():Param
		{
			return this.param2;
		}
		
		public function getType():String
		{
			return this.type;
		}

	}
}