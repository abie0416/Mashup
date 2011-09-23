package org.un.cava.birdeye.ravis.Compile
{
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	
public class inToPost  // infix to postfix conversion
{
private var theStack:StackX;

private var input:String="";

private var Coll:ArrayCollection;

private var output:String = "";
private var newstrs:Array= new Array();


// --------------------------------------------------------------
public function inToPost(inx:String,Coll:ArrayCollection) // constructor
{
 	this. Coll = Coll;
     var str:String ="";
 for (var j :int= 0; j < inx.length; j++) // for each char
   {
    var ch:String = inx.charAt(j);
    switch(ch){
    	case " ":break;
    	case "&":str=str+ch;break;
    	case "|":str= str+ch;break;
    	default:{
    		str=str+" "+ch+" ";
    	}
    	
    	
    }
   }
   var newstr:Array = str.split(" ");
   for each (var item:String in newstr){
   			if(item!=""){
   				this.newstrs.push(item);
   				input =input+item;
   				trace(input)
   				trace(newstrs)
   			}
   }
  
   	 	trace(newstrs)
   	 var stackSize:int =input.length;
   theStack = new StackX(stackSize);
}
		public function getnewstrs():Array{
			return this.newstrs;
		}
		public function check(newstr:Array,textinput:ArrayCollection):Boolean{
			var theStacka:StackX =new  StackX(newstr.toString().length);
			trace(String(newstr.toString()))
			for (var j:int = 0;j<newstr.length;j++){
					var ch:String = newstr[j];
					trace(ch+"xiexie")
				    switch(ch){
    						case "":{trace("Blank is here");break;}
    						case " ":break;
    						case "&&":{
    							j++;
    							if(j==newstrs.length){
    								  			mx.controls.Alert.show("Your expression is error near "+ch);
    											return false;
    							}
    							var right:String = newstr[j];//String(newstr.getItemAt(j));
    							trace(theStacka.isEmpty())
    							if(Coll.contains(right)&& !theStacka.isEmpty()){//(right<="Z" &&right>="A" 

    							}else if(right == " "){
    								
    							}else if(right =="("){
    								j--;
//    								newstr.push(right);
    							}else {
    								mx.controls.Alert.show("Your expression is error near "+ch);
    								return false;
    							}
    						break;
    						}
    						case "||":{
    							    							j++;
    							var right:String =newstr[j];//String(newstr.getItemAt(j));
    							if( Coll.contains(right)&& !theStacka.isEmpty() ){//right<="Z" &&right>="A"

    							}else if(right == " "){
    								
    							}else if(right =="("){
    								j--;
    							}else {
    								mx.controls.Alert.show("Your expression is error near "+ch);
    								return false;
    							}
    						break;
    						}
    						case"(":{
    							var temp:Array = new Array();
    							for (var i:int=j+1;i<newstr.length;i++){
    								trace(newstr[i] )
    								if(newstr[i]  == ")"){
    									if(!this.check(temp,textinput)) return false;
    									else{
    										j=i;theStacka.push("flag");break;
    									}
    								}else{
    									temp.push(newstr[i]);
    									trace(temp.toString())
    								}
    							}
    							if(i>=newstr.length){
    								mx.controls.Alert.show("No matchable right pargen");
    								return false;
    							}
    							
    							break;
    						}
    						default:{
    							if(Coll.contains(ch) ){
    								if(i==newstr.length-1){
    										var index:int = ch.charCodeAt(0)-65;
												 if(String(textinput.getItemAt(index)) ==""){
												 mx.controls.Alert.show("Error  in the expression :  Condition  "+ch+" is unused , since it's textInput is null ");
												  return false;
												    }
    								}//如果ch是最后一个字符的情况，要注意
    								else if(newstr[i+1] !="&&" && newstr[i+1] !="||" ){
    										    mx.controls.Alert.show("Unexpected Token:"+ch+" in the Expression!!");
    											return false;
    								}else{
 												
												  var index:int = ch.charCodeAt(0)-65;
												 if(String(textinput.getItemAt(index)) ==""){
												 mx.controls.Alert.show("Error  in the expression :  Condition  "+ch+" is unused , since it's textInput is null ");
												   			return false;
												    }
												}
    									theStacka.push(ch);
    										break;
    								}else{
			    								mx.controls.Alert.show("Unexpected symbol:"+ch+" in the Expression!!");
			    								return false;
    								}
    	
				    }
				
				    }
			}
			return true;
		} 
public function getOutput():String{
			return output;
}

// --------------------------------------------------------------
public  function doTrans():String// do translation to postfix
{
 	
   for (var j :int= 0; j < newstrs.length; j++) // for each char
   {
    var ch:String = newstrs[j]; // get it
//    theStack.displayStack("For " + ch + " "); // *diagnostic*
	trace(ch)
    switch (ch) {
						    case "&&": // it's + or -
						    case "||":
						     gotOper(ch, 1); // go pop operators
						     break; // (precedence 1)
						    case '(': // it's a left paren
						     theStack.push(ch); // push it
						     break;
						    case ')': // it's a right paren
						     gotParen(ch); // go pop operators
						     break;
						    default:
						    { // must be an operand	    	
						     		output = output +" "+ ch; // write it to output
						    		 break;
						    }  	

   			 } // end switch
   } // end for
   
   while (!theStack.isEmpty()) // pop remaining opers
   {
//    theStack.displayStack("While "); // *diagnostic*
    output = output +" "+ theStack.pop(); // write to output
   }
//   theStack.displayStack("End   "); // *diagnostic*
   mx.controls.Alert.show( output); // return postfix
   return this.output;
} // end doTrans()
// --------------------------------------------------------------

public function gotOper( opThis:String,  prec1:int):void { // got operator from input
   while (!theStack.isEmpty()) {
    var opTop:String = theStack.pop();
    if (opTop == '(') // if it's a '('
    {
     theStack.push(opTop); // restore '('
     break;
    } else // it's an operator
    {
     var prec2:int; // precedence of new op

     if (opTop =="&&" || opTop == '||') // find new op prec
      prec2 = 1;
     else
      prec2 = 2;
     if (prec2 < prec1) // if prec of new op less
     { // than prec of old
      theStack.push(opTop); // save newly-popped op
      break;
     } else
      // prec of new not less
      output = output + " " +opTop; // than prec of old
    } // end else (it's an operator)
   } // end while
   theStack.push(opThis); // push new operator
} // end gotOp()
// --------------------------------------------------------------

public function gotParen( ch:String):void { // got right paren from input
   while (!theStack.isEmpty()) {
    var chx:String = theStack.pop();
    if (chx == '(') // if popped '('
     break; // we're done
    else
     // if popped operator
     output = output +" "+ chx; // output it
   } // end while
} // end popOps()
// --------------------------------------------------------------
} // end class InToPost
// //////////////////////////////////////////////////////////////
}
