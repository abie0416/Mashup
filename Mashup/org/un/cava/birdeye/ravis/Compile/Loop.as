package  org.un.cava.birdeye.ravis.Compile
{
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	
	import org.un.cava.birdeye.ravis.graphLayout.data.INode;
	import org.un.cava.birdeye.ravis.graphLayout.data.Node;
	
	
	
	public class Loop
	{
		private var nodelist:ArrayCollection;
		private var a:ArrayCollection ;
		
		private var _output:Array;

		public function Loop(nodelist:ArrayCollection)
		{
			this.nodelist = nodelist;
			a = new ArrayCollection();
			_output = new Array();
		
		}


	public function get output():Array{
		 return this._output;
	}

	public  function findcycle():void {//删去无用边和顶点
		var now:Node = null;
		if (nodelist.length == 0)
			mx.controls.Alert.show("No Loop!");
//		for each (var tem:Node in  nodelist) {
//			
//			if (tem.successors.length == 0) {
//				now = tem;
//				break;
//			}
//		}
//		if (now == null) {
			
			findloop();
//		} else  {
//			var index:int = nodelist.getItemIndex(now);
//			
//			nodelist.removeItemAt(index);
//			 var next:Array = arrReverse(now.successors) ;
//			for each( var item:INode in  next)
//						item.numOfedges--;
//			findcycle();
//		}
	}

	private function findloop():void {
		while (nodelist.length != 0) {
		
			var tem:INode = nodelist.getItemAt(0) as INode;
			a.addItem(tem);
				
			var history:ArrayCollection = new ArrayCollection();

			history.addItem(tem);
			var loop1:String = "";
			dfsfind(tem, history,loop1);
			
//			for each(var i:INode in nodelist){
//				
//						trace(i.id)
//			}

			for each(var item:INode in a){
				
//				trace(item.id)
				var index:int = nodelist.getItemIndex(item);
				
				nodelist.removeItemAt(index);
			}
			a.removeAll();
		}
	}
	public static function arrReverse(arr:Array):Array{
		var tem:Array = new Array();
		for each(var ele:INode in arr){
				tem.push(ele);
		}
		return tem.reverse();
	}
	
	
	private function dfsfind( tem:INode, history:ArrayCollection,loop0:String):void {
		
		loop0 = loop0+ tem.id+"*";
		
		var next:Array = arrReverse(tem.successors);
		for each ( var t:INode in  next) {						
			if (!history.contains(t)) {
				if(!a.contains(t)){
					a.addItem(t);
				}							
				history.addItem(t);
				dfsfind(t, history,loop0);
				var indexs:int = history.getItemIndex(t);
				history.removeItemAt(indexs);
			} else {
				var s:String = String(t.id) ;
//				for (var i:int = history.getItemIndex(tem); i <= history.getItemIndex(t); i++)
//					s =( history.getItemAt(i) as Node).id + s;					
					var index:int = loop0.indexOf(s);
					var xx:String = loop0.substring(index);
					var arr:Array = xx.split("*");
					arr.pop();
					this._output.push(arr);
					trace(arr.toString()+"       "+xx+"       "+s+"   "+loop0);
			}
		}
	}
	
	
	
	public static  function intersectionFind(allPath:Array):Array{
				var tempArr:Array = new Array;
				
							var myString:String;
							//下面是将产生的二维数组变成一个字符串形式.
							myString=allPath.toString();
//							trace(myString)
							var myArray:Array=new Array();
							var myOtherArray:Array=new Array();
								//然后再将之存到数组中.以","作为分格符.
							myArray=myString.split(",");
							for (var i:Number=0; i<myArray.length; i++) {
							//没有查到,就把数组中的内容放存放到新的数组中,在这里最终的结果将会形成并集.
							 if (myOtherArray.indexOf(myArray[i])==-1) {
							  myOtherArray.push(myArray[i]);
							 }
							}
							var h:int=0;
							//然后再通过二重循环来比较新的并集数组与原组合的数组是否相等.数值一一比较.
							//如果相等,就加h一次,这里主要是判断相同的数的个数是否与数组的个数相等,如果相等,就表示有交集.比较完之后,h要变为零.
							for (var j:Number=0; j<myOtherArray.length; j++) {
							 for (var k:Number=0; k<myArray.length; k++) {
							  if (myOtherArray[j]==myArray[k]) {
							   h++;
							  }
							 }
							 if (h==allPath.length) {
							  tempArr.push(myOtherArray[j]);
							 }
							 h=0;
							}
							
				return tempArr;
				
	}
	
	
			
			public static  function dfspathEngine(node:INode,endNode:INode=null):Array{

				 var arr:String =  "";
				 var allPath:Array = new Array;
				 dfspath(node,arr,allPath,endNode);
				 
					return allPath;
			}
			private  static function dfspath(node:INode,path:String,allPath:Array,endNode:INode=null):void{
						trace (node.id);
						 path = path + node.id+"*";
					
				if(node.successors.length == 0 || (endNode != null &&node.id == endNode.id) ){
						var arr:Array = path.split("*");						
						arr.pop();
//						trace(arr.toString())
						allPath.push(arr);
						return ;
				}
					var tem:Array =node.successors.reverse();
//				for each(var no:INode in tem){
				for (var i:int =0;i<tem.length;i++){
							var no:INode = tem[i] as INode;
						dfspath(no,path,allPath,endNode);		
				}

				
			}

	}
}