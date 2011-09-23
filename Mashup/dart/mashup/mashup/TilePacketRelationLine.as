package dart.mashup.mashup
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import mx.core.UIComponent;
	import mx.effects.Fade;

	public class TilePacketRelationLine extends UIComponent
	{
		private var color:uint = 0x666666; //0x00CC00
		private var colorBri:uint = 0xFFFFFF; //0x00FF00
		private var colorChosen:uint = 0x00FF00;
		private var line:Sprite = new Sprite();
		private var t1:TilePacket;
		private var t2:TilePacket;
		private var relation:Relation;
		private var refCount:int = 0;
		private var lineThick:Number = 0.1;
				
		public function TilePacketRelationLine(t1:TilePacket, t2:TilePacket, relation:Relation, flag:Boolean = true)
		{
			super();
			this.t1 = t1;
			this.t2 = t2;
			this.relation = relation;
			this.buttonMode = true;
			line.graphics.lineStyle(lineThick, color);
		//	drawLine();
			if(flag)
				this.visible = false;
		}
		
		public function drawLine():void
		{
			var xFrom:Number =  this.t1.getTilePacketX();
			var yFrom:Number = this.t1.getTilePacketY();
			var xTo:Number = this.t2.getTilePacketX();
			var yTo:Number = this.t2.getTilePacketY();
			line.graphics.moveTo(xFrom, yFrom);
			line.graphics.lineTo(xTo, yTo);
			this.addChild(line);
			this.addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
			this.addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
		}
		
		private function rollOverHandler(event:MouseEvent):void
		{
			this.useHandCursor = true;
			var tmp:Sprite = event.target.getChildAt(0);
			tmp.graphics.clear();
			tmp.graphics.lineStyle(lineThick,colorBri);
			drawLine();
			this.t1.zoomCircle(new MouseEvent(MouseEvent.ROLL_OVER));
			this.t2.zoomCircle(new MouseEvent(MouseEvent.ROLL_OVER));
		}
		 
		private function rollOutHandler(event:MouseEvent):void
		{
			this.useHandCursor = false;
			var tmp:Sprite = event.target.getChildAt(0);
			tmp.graphics.clear();
			tmp.graphics.lineStyle(lineThick,color);
			drawLine();
			this.t1.zoomCircle(new MouseEvent(MouseEvent.ROLL_OUT));
			this.t2.zoomCircle(new MouseEvent(MouseEvent.ROLL_OUT));
		}
		
		public function find(tp1:TilePacket, tp2:TilePacket):TilePacketRelationLine
		{
			if((this.t1.getTile().name == tp1.getTile().name && this.t2.getTile().name == tp2.getTile().name)
			|| (this.t1.getTile().name == tp2.getTile().name && this.t2.getTile().name == tp1.getTile().name)){
				return this;
			}
			
			return null;
		}
		
		public function setChosen():Boolean
		{
			if(this.color != this.colorChosen){
				this.color = this.colorBri = this.colorChosen;
				this.line.graphics.clear();
				this.line.graphics.lineStyle(lineThick, colorChosen);
				this.play();
				drawLine();
				return true;
			}
			
			return false;
		}
		
		public function resetChosen():Boolean
		{
			if(this.color == this.colorChosen){
				this.color = 0x666666;
				this.colorBri = 0xFFFFFF;
				this.line.graphics.clear();
				this.line.graphics.lineStyle(lineThick, color);
				drawLine();
				this.play();
				return true;
			}
			
			return false;
		}
		
		public function play():void
		{
			/* appear effect ! */
			var fade:Fade = new Fade(this);
			fade.startDelay = 3500;
			fade.alphaFrom = 0.0;
			fade.alphaTo = 0.7;
			//dissovle.duration = 1000;
			fade.play();
			
		}		
		
		public function redrawLine():void
		{
			this.line.graphics.clear();
			this.line.graphics.lineStyle(lineThick, color);
			drawLine();
			this.play();			
		}
		public function clear():void
		{
			this.line.graphics.clear();
		}
		public function increaseRefCount():void
		{
			this.refCount ++;	
		}
		
		public function decreaseRefCount():int
		{
		
			this.refCount --;
			
			return this.refCount;			
		}
		
		public function getRefCount():int
		{
			return this.refCount;
		}
		
		public function getTilePacket1():TilePacket
		{
			return this.t1;
		}
		
		public function getTilePacket2():TilePacket
		{
			return this.t2;
		}
		
	}
}