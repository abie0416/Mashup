package dart.mashup.mashup
{
	import dart.mashup.tile.Service;
	import dart.mashup.tile.Tile;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import mx.collections.ArrayCollection;
	import mx.core.UIComponent;
	import mx.effects.Effect;
	import mx.effects.Fade;
	import mx.effects.Move;
	import mx.effects.Zoom;
	import mx.events.EffectEvent;
	
	
	public class TilePacket extends UIComponent
	{
        public var radius:Number         = 20;
        private var fillColor:uint;
        private var lineColor:uint;
        private var borderColor:uint;
		private var fillColorArr:Array = new Array(0x330099, 0x993399, 0xFF0099, 0x6600FF, 0xFF6666, 0x00CC33, 0x33CC00, 0x993366, 0xCC66FF, 0xFF9900);
		private var lineColorArr:Array = new Array(0x000CCC, 0xFF33FF, 0xFF3366, 0x0000FF, 0xFF0000, 0x33FF00, 0x00FF00, 0xFF3366, 0xFF00FF, 0xFFCC00);
		private var zoom:Zoom;
		public var tile:Tile;
		public var relationArr:ArrayCollection; //{[tilePacketRelationItem], ... ...}
		public var tileX:Number;
		public var tileY:Number;
		/* circle variables */
		public var child:Sprite = null;
		public var label:TextField = null;
		public var format:TextFormat = null;
		/* check if there is a mashuppath on this tilepacket */
		public var isChosen:Boolean = false;
		public var visibleTPArr:ArrayCollection = new ArrayCollection();
		
        private function drawCircle(text:String, x:Number, y:Number, size:int = 12):void {
        	if(child == null){
        		child = new Sprite();
        		label = new TextField();
        		format = new TextFormat();
        		/* initialize format and label variables */
	            format.color = 0xFFFFFF;
	            format.size = size;
	            format.align = "center";
	            format.bold = true;
	            format.font = "Verdana"; 
	            label.defaultTextFormat = format;
	            label.multiline = true;
	            label.selectable = false;
	            label.wordWrap = true; 
		        label.text = text;
		    //    if(text == "GoogleWebSearch")
		   //     	label.text = "GoogleSearch";
	       //     label.width = radius * 2.4;
	       //     label.height = radius * 1.5 ;
	       		if(size == 12){
	            	label.width = radius * 2.5;
	            	label.height = radius * 1.5 ;
	         	}
	         	else{
	         		label.width = 20 * 2.5;
	         		label.height = 20 * 1.5;
	         	}
	            child.addChild(label);
	            this.addChild(child);        
 
        	}
        	else{
        		child.graphics.clear();
        	}
            child.graphics.beginFill(fillColor);
            child.graphics.lineStyle(2,lineColor);
            child.graphics.drawCircle(x, y, radius);
	       	label.x = x - radius - 6;
	       	if(size == 12)
	        	label.y = y - radius / 2 + radius / 8;
	        else
	        	label.y = y - radius / 2;            
            child.graphics.endFill();
        }
         
        public function setChosen():void
        {
        	if(!this.isChosen){
        		var event:MouseEvent = new MouseEvent(MouseEvent.ROLL_OVER);
        		this.zoomCircle(event);
        		this.isChosen = true;
        	}
        }
        
        public function resetChosen():void
        {
        	if(this.isChosen){
        		var event:MouseEvent = new MouseEvent(MouseEvent.ROLL_OUT);
        		this.isChosen = false;
        		this.zoomCircle(event);
        	}
        }
        
		public function zoomCircle(event:MouseEvent):void
		{
				if(event.type == MouseEvent.ROLL_OVER){
					var toolTip:String = "";
					toolTip += this.tile.text;
					var length:int = this.tile.services.length;
					for(var i:int = 0; i < length; i++){
						var service:Service = this.tile.services.getItemAt(i) as Service;  
						toolTip += "\n" + service.name + ":  " + service.desc;
					}
					this.toolTip = toolTip;
				}
				if(!this.isChosen){
			/*	if(zoom.isPlaying)
					zoom.reverse();
				else
					zoom.play([this], event.type == MouseEvent.ROLL_OUT ? true : false);
			*/
					if(event.type == MouseEvent.ROLL_OUT)
						scaleTP(2/3, this.tileX, this.tileY);
					else
						scaleTP(3/2, this.tileX, this.tileY); 
				} 
		}
		
		public function getColorIndex(type:String):uint
		{
			var hashCode:Number = 0;
			var length:int = type.length;
			
			for(var i:int = 0; i < length; i++)
				hashCode += type.charCodeAt(i) * i;
		//	hashCode = hashCode + type.charCodeAt(length - 1); 
				
			return hashCode % 10;
		}
		// Transformations
		public function scaleTP( scale : Number, originX : Number, originY : Number ) : void
		{
			// get the transformation matrix of this object
			var affineTransform:Matrix = this.child.transform.matrix;
			
			// move the object to (0/0) relative to the origin
			affineTransform.translate( -originX, -originY );
			
			// scale
			affineTransform.scale( scale, scale );
			
			// move the object back to its original position
			affineTransform.translate( originX, originY );
			
			// apply the new transformation to the object
			this.child.transform.matrix = affineTransform;
		}		
				
		public function TilePacket(tile:Tile = null, x:Number = 0, y:Number = 0, radius:Number = 20, flag:Boolean = true)
		{
			super();
			/* initialize zoom */
			
		/*	zoom = new Zoom();
			zoom.zoomWidthTo = 1.2;
			zoom.zoomWidthFrom = 1;
			zoom.zoomHeightFrom = 1;
			zoom.zoomHeightTo = 1.2;
			zoom.originX = x;
			zoom.originY = y; */
			/* get color index */
			var i:int = getColorIndex(tile.category);
			fillColor = fillColorArr[i];
			lineColor = lineColorArr[i];
			this.radius = radius;
			this.tile = tile;
			this.tileX = x;
			this.tileY = y;
			this.relationArr = new ArrayCollection();
			if(flag){
				drawCircle(tile.name, 0, 0);
				this.visible = false;
			}
			else{
				drawCircle(tile.name, x, y, 10);
			}
			
			
		}
		
		public function addRelation(tp:TilePacket, relation:Relation):void
		{	
			var item:TilePacketRelationItem = new TilePacketRelationItem(tp, relation);
			this.relationArr.addItem(item);
		}
		
		public function getTile():Tile
		{
			return this.tile;
		}
		
		public function getTilePacketX():Number
		{
			return this.tileX;
		}
		
		public function getTilePacketY():Number
		{
			return this.tileY;
		}
		
		public function getX():Number
		{
			return this.x;
		}
		
		public function getY():Number
		{
			return this.y;
		}
		
		public function getRelationArr():ArrayCollection
		{
			return this.relationArr;
		}
		public function setTileX(x:Number):void
		{
			this.tileX = x;
		
		}	
		public function setTileY(y:Number):void
		{
			this.tileY = y;
		}
		
		private var serviceDicArr:ArrayCollection = new ArrayCollection();
		/* sericeDicArrItem: [serviceDic] */
		public function buildDic():void
		{
			var length:int = this.relationArr.length;
			
			for(var i:int = 0; i < length; i++){
				var tpi:TilePacketRelationItem = this.relationArr.getItemAt(i) as TilePacketRelationItem;
				var acService:ArrayCollection = new ArrayCollection();
				var j:int = 0; 
				var ris:ArrayCollection = tpi.getRelation().getRelationItems();
				var flag:Boolean = (tpi.getRelation().getTile1().name == this.tile.name) ? true : false;
				var length2:int = ris.length;
				for(j = 0; j < length2; j++){
					var ri:RelationItem = ris.getItemAt(j) as RelationItem;
					var s:Service = flag ? ri.getOper1() : ri.getOper2();
					addToServiceDic(s, tpi.getTilePacket(), ri);
				}
			}
		}
		
		private function addToServiceDic(s:Service, tp:TilePacket, ri:RelationItem):void
		{
			var length:int = serviceDicArr.length;
			var i:int = 0;
			for(i = 0; i < length; i++){
				var sd:ServiceDic = serviceDicArr.getItemAt(i) as ServiceDic;
				if(s.name == sd.getService().name){
					sd.addServiceRelationItem(tp, ri);
					break;
				}
			}
			if(i == length){
				var sdTmp:ServiceDic = new ServiceDic(s, this);
				sdTmp.addServiceRelationItem(tp, ri);
				serviceDicArr.addItem(sdTmp);
			}	
		}
		
		public function getServiceDicArr():ArrayCollection
		{
			return this.serviceDicArr;
		}
		
		public function playEndHandler(event:EffectEvent):void
		{
			this.x = this.y = 0;
			drawCircle(tile.name, this.tileX, this.tileY);
			dispatchEvent(new MyCursorEvent(MyCursorEvent.NORMAL));
	   //     this.addEventListener(MouseEvent.ROLL_OVER, zoomCircle);
	   //     this.addEventListener(MouseEvent.ROLL_OUT, zoomCircle);  			
		}
		public function play(initialX:Number, initialY:Number):Effect
		{
			var m1:Move = new Move(this);
			if(this.tileX <= initialX){
				if(this.tileY < initialY)
					m1.xFrom = m1.yFrom = 0;
				else{
					m1.xFrom = 0;
					m1.yFrom = initialY * 2;
				}
			}
			else{
				if(this.tileY < initialY){
					m1.xFrom = initialX * 2;
					m1.yFrom = 0;
				}
				else{
					m1.xFrom = initialX * 2;
					m1.yFrom = initialY * 2;
				}
			} 
			m1.xTo = this.tileX; 
			m1.yTo = this.tileY;
			m1.duration = 4000;
			m1.play();
			m1.addEventListener(EffectEvent.EFFECT_END, playEndHandler);
			
			return m1;
		}
		
		public function play2(tx:Number, ty:Number):void
		{
		//	var m:Move = new Move(this);
		//	m.xBy = tx - this.tileX;
		//	m.yBy = ty - this.tileY;
			if(this.tile.name == "Flickr")
				trace("hree");	
			this.tileX = tx;
			this.tileY = ty;
			this.x = this.y = 0;
			drawCircle(tile.name, this.tileX, this.tileY);
		//	m.duration = 4000;
		//	m.play();
		//	m.addEventListener(EffectEvent.EFFECT_END, play2Handler);

		}
		public function play2Handler(e:EffectEvent):void
		{
			if(this.tile.name == "Flickr")
				trace("hree");			
			
		
		drawCircle(tile.name, this.tileX, this.tileY);		
		this.x = this.y = 0;	
		}
		public function reDraw():void
		{
			drawCircle(tile.name, this.tileX, this.tileY);
		}
		
		public function addVisibleTP(tp:TilePacket):void
		{
			var length:int = this.visibleTPArr.length;
			var i:int;
			
			for(i = 0; i < length; i++){
				var tmpTp:TilePacket = this.visibleTPArr.getItemAt(i) as TilePacket;
				if(tmpTp.tile.name == tp.tile.name)
					return;
			}
			this.visibleTPArr.addItem(tp);
		}
		
		public function removeVisibleTP(tp:TilePacket):Boolean
		{
			var length:int = this.visibleTPArr.length;
			var i:int;
			
			for(i = 0; i < length; i++){
				var tmpTp:TilePacket = this.visibleTPArr.getItemAt(i) as TilePacket;
				if(tmpTp.tile.name == tp.tile.name && this.isChosen == false){
					visibleTPArr.removeItemAt(i);
					length--;
					i--;
					if(length == 0){
					//	this.visible = false;
						showAndHideEffect(0.0);
					}
					return true;
				}
			}
			
			return false;
			
		}
		
		/* show and hide effects */
        public function showAndHideEffect(a:Number = 0.0):void
        {        	
        	var fade:Fade = new Fade(this);
        	fade.alphaFrom = 1.0;
        	fade.alphaTo = a;
        	fade.play();
        	this.visible = false;
        }			
		
	}
}