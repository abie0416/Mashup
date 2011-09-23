package dart.mashup.mashup
{
	import flash.display.Sprite;
	
	import mx.core.UIComponent;
	import mx.effects.Move;
	import mx.events.EffectEvent;

	public class MashupFlowCursor extends UIComponent
	{
        private var radius:Number         = 4;
        private var fillColor:uint = 0x33CC00;
        private var child:Sprite = null;
        private var mfcX:Number;
        private var mfcY:Number;
        private var toX:Number;
        private var toY:Number;
        private var m:Move;
        private var stopFlag:Boolean = false;
        private var pauseTime:Number;
        private var maxPauseTime:Number;
        
		public function MashupFlowCursor(x:Number, y:Number, toX:Number, toY:Number, pauseTime:Number, maxPauseTime:Number, scaleNumber:Number = 0)
		{
			super();
			this.radius = radius;
			this.mfcX = x;
			this.mfcY = y;
			this.toX = toX;
			this.toY = toY;	
			this.x = x;
			this.y = y;
		//	this.scaleX = scaleNumber;
		//	this.scaleY = scaleNumber;
			m = new Move(this);
			this.pauseTime = pauseTime * 1500;
			m.startDelay = this.pauseTime;
			this.maxPauseTime = (maxPauseTime - 1) * 1500;
			drawCircle();	
		}
		
        private function drawCircle():void { 
        	if(child == null){
        		child = new Sprite();
	            this.addChild(child);          
        	}
        	else{
        		child.graphics.clear();
        	}
            child.graphics.beginFill(fillColor);
            child.graphics.lineStyle(1,fillColor);
            child.graphics.drawCircle(0, 0, radius);     
            child.graphics.endFill();
        }
        
        public function playEndHandler(event:EffectEvent):void
        {
        	if(!stopFlag){
        		m.startDelay = this.maxPauseTime; 
        		this.play();
        	}
        }
        
        public function play():void
        {
        	m.xFrom = this.mfcX;
        	m.yFrom = this.mfcY;
        	m.xTo = this.toX;
        	m.yTo = this.toY;
        	m.duration = 1500;
        	m.play();
        	m.addEventListener(EffectEvent.EFFECT_END, playEndHandler);
        }
        
        public function setStopOrder():void
        {
        	this.stopFlag = true;
        }
        
        public function setPlayOrder():void
        {
        	this.stopFlag = false;
        	this.play();
        }	
		
	}
}