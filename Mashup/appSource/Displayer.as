package appSource
{
	public class Displayer
	{
		import mx.collections.ArrayCollection;
		
		public var name:String;
        public var children:ArrayCollection;
        
        public function Displayer(_name:String, _children:ArrayCollection = null){
            this.name = _name;
            if(_children != null)
                this.children = _children;
        }
	}
}