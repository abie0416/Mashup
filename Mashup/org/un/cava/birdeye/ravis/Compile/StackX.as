package  org.un.cava.birdeye.ravis.Compile
{
	public class StackX
	{
		private var maxSize:int;
		private var stackArray:Array;
		private var top:int;
		
		public function StackX(s:int)
		{
			   maxSize = s;
			   stackArray = new  Array();
			   top = -1;
		}

		// --------------------------------------------------------------
			public function push( j:String) :void// put item on top of stack
			{
			   stackArray[++top] = j;
			}
			
			// --------------------------------------------------------------
			public function  pop():String// take item from top of stack
			{
			   return stackArray[top--];
			}
			
			// --------------------------------------------------------------
			public  function peek():String // peek at top of stack
			{
			   return stackArray[top];
			}
			
			// --------------------------------------------------------------
			public function isEmpty() :Boolean// true if stack is empty
			{
			   return (top == -1);
			}
			
			// -------------------------------------------------------------
			public function size():int // return size
			{
			   return top + 1;
			}
			
			// --------------------------------------------------------------
			public function peekN(n:int):String // return item at index n
			{
			   return stackArray[n];
			}
			
			// --------------------------------------------------------------
			public function  displayStack( s:String):void {
//			   System.out.print(s);
//			   System.out.print("Stack (bottom-->top): ");
//			   for (int j = 0; j < size(); j++) {
//			    System.out.print(peekN(j));
//			    System.out.print(' ');
//			   }
//			   System.out.println("");
			}
			// --------------------------------------------------------------
			} // end class StackX
			// //////////////////////////////////////////////////////////////
			
			}