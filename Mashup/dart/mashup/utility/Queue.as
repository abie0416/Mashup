// Notice: If this code works, it was written by Lu Bin. 
//         Else, I don't know who wrote it. HiaHia...

package dart.mashup.utility
{
	import mx.collections.ArrayCollection;
	
	public class Queue
	{
		private var queueArr:ArrayCollection;
		private var dataIndex:int = -1;
		private var dataSize:int = 0;
		private var popedDataSize:int = 0;
		
		public function Queue()
		{
			this.queueArr = new ArrayCollection();
			dataIndex = -1;
			dataSize = popedDataSize = 0;
		}
		
		public function push(obj:Object):void
		{
			this.queueArr.addItem(obj);
			if(dataIndex == -1)
				dataIndex = 0;
			dataSize ++;	
		}
		
		public function pop():Object
		{
			if(dataIndex == -1)
				return null;
			dataIndex++;
			popedDataSize++;
			dataSize--;
			
			return queueArr.getItemAt(dataIndex - 1);			 
		}
		
		public function isEmpty():Boolean
		{
			return dataSize == 0 ? true : false;
		}
		
		public function find(obj:Object):int
		{
			var index:int = queueArr.source.indexOf(obj);
			
			if(index == -1)
				return index;
			
			return index < dataIndex ? 0 : 1;
		}

	}
}