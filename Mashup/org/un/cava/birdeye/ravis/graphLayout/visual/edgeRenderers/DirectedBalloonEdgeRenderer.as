/* 
 * The MIT License
 *
 * Copyright (c) 2007 The SixDegrees Project Team
 * (Jason Bellone, Juan Rodriguez, Segolene de Basquiat, Daniel Lang).
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */
package org.un.cava.birdeye.ravis.graphLayout.visual.edgeRenderers {
	
	import flash.display.Graphics;
	import flash.geom.Point;
	
	import org.un.cava.birdeye.ravis.graphLayout.visual.IVisualEdge;
	import org.un.cava.birdeye.ravis.graphLayout.visual.IVisualNode;
	import org.un.cava.birdeye.ravis.utils.Geometry;


	/**
	 * This is a directed edge renderer, which draws the edges
	 * with slim ballon like curves that indicate a source.
	 * Please note that for undirected graphs, the actual direction
	 * of the edge might be arbitrary.
	 * */
	public class DirectedBalloonEdgeRenderer extends BaseEdgeRenderer {
		
		
		/**
		 * Specifies the width or thickness of the balloons.
		 * @default 10
		 * */
		public var balloonWidth:Number = 10.0;
		
		/**
		 * Constructor sets the graphics object (required).
		 * @param g The graphics object to be used.
		 * */
		public function DirectedBalloonEdgeRenderer(g:Graphics) {
			super(g);
		}
		
		/**
		 * The draw function, i.e. the main function to be used.
		 * Draws a curved line from one node of the edge to the other.
		 * The colour is determined by the "disting" parameter and
		 * a set of edge parameters, which are stored in an edge object.
		 * 
		 * @inheritDoc
		 * */
		 private function drawCircle(p:Point,Radius:uint=40):Point{
		 		var centerx:int = p.x ;
		 		var centery:int = p.y - Radius;
		 		_g.lineStyle(2, 0x008000);
		 		_g.drawCircle(centerx,centery,Radius);
		 		
		 		return new Point(centerx,centery-Radius);
		 		
		 }
		override public function draw(vedge:IVisualEdge):void {
			
			/* first get the corresponding visual object */
			var fromNode:IVisualNode = vedge.edge.node1.vnode;
			var toNode:IVisualNode = vedge.edge.node2.vnode;
			
			if(fromNode.id == toNode.id){
				var tempP:Point = drawCircle(fromNode.viewCenter);
				if(vedge.vgraph.displayEdgeLabels) {
					vedge.setEdgeLabelCoordinates(tempP);
				}
				
			}else{			
				if(!vedge.isLoopEdge){
					applyLineStyle(vedge);
					/* now we actually draw */
					drawBallonLine(vedge);

				}else{
					//画一条曲线	
				vedge.lineStyle.color = 0x008000;
				vedge.lineStyle.thickness = 2;
				applyLineStyle(vedge);
						/* now we actually draw */
				drawCurveLine(vedge);
				}
			
		
			/* if the vgraph currently displays edgeLabels, then
			 * we need to update their coordinates */
				if(vedge.vgraph.displayEdgeLabels) {
					vedge.setEdgeLabelCoordinates(labelCoordinates(vedge));
				}
			}
		}
		//画直线
		private function drawBallonLine(vedge:IVisualEdge):void{
			var fromNode:IVisualNode = vedge.edge.node1.vnode;
			var toNode:IVisualNode = vedge.edge.node2.vnode;
			

			var fP:Point = fromNode.viewCenter;
			var tP:Point = toNode.viewCenter;
			/* calculate the midpoint used as curveTo anchor point */
			var anchor:Point = Geometry.midPointOfLine(fP,tP);
				
			/* apply the line style */
			_g.beginFill(uint(vedge.lineStyle.color));
			_g.moveTo(fP.x, fP.y);			
					
			/* bezier curve style */
			_g.curveTo(fP.x - balloonWidth, fP.y - balloonWidth, anchor.x, anchor.y);
			_g.endFill();
			_g.beginFill(uint(vedge.lineStyle.color));
			_g.moveTo(fP.x, fP.y);
			_g.curveTo(fP.x + balloonWidth, fP.y + balloonWidth, anchor.x, anchor.y);
			_g.endFill();
			_g.beginFill(uint(vedge.lineStyle.color));
			_g.moveTo(fP.x, fP.y);
			_g.curveTo(fP.x - balloonWidth, fP.y + balloonWidth, anchor.x, anchor.y);
			_g.endFill();
			_g.beginFill(uint(vedge.lineStyle.color));
			_g.moveTo(fP.x, fP.y);
			_g.curveTo(fP.x + balloonWidth, fP.y - balloonWidth, anchor.x, anchor.y);
			_g.endFill();
			_g.beginFill(uint(vedge.lineStyle.color));
			_g.moveTo(anchor.x, anchor.y);
			
			_g.lineTo(toNode.viewCenter.x, toNode.viewCenter.y);
			_g.endFill();
		}
		//画曲线，该曲线一定经过两个点连线的中点
		private function drawCurveLine(vedge:IVisualEdge):void{
			var fP:Point = vedge.edge.node1.vnode.viewCenter;
			var tP:Point = vedge.edge.node2.vnode.viewCenter;
			// 第一点坐标
			var x1:Number =fP.x; //_obj1.x;
			var y1:Number = fP.y;//_obj1.y;
			// 第二点坐标
			/*若A(x1,y1)B(x2,y2)P(x,y)且AP=λPB 
			*x=(x1+λx2)/(1+λ) 
 			*y=(y1+λy2)/(1+λ) 
 			*这里设λ =9
			 */
			 var rate:int =1;
			var x2:Number =tP.x;//(x1+rate*tP.x)/(1+rate);
			var y2:Number =tP.y;//(y1+rate*tP.y)/(1+rate);

			// 曲线方向
			var dir:Boolean = Math.abs(x2 - x1) > Math.abs(y2 - y1);

			// 几何中点坐标
			var anchor:Point = Geometry.midPointOfLine(fP,tP);			
			/* we use t = 0.6 here to a bit more towards the target */
			var center:Point =  Geometry.bezierPoint(fP,anchor,tP,0.6);
			
			
			var xc:Number = center.x;//(x2 - x1) / 2 + x1;
			var yc:Number = center.y;//(y2 - y1) / 2 + y1;

			// 第一条曲线控制点坐标
			var bx1:Number = dir ? (xc - x1) / 2 + x1 : x1;
			var by1:Number = dir ? y1 : (yc - y1) / 2 + y1;

			// 第二条曲线控制点坐标
			var bx2:Number = dir ? (x2 - xc) / 2 + xc : x2;
			var by2:Number = dir ? y2 : (yc - y2) / 2 + y2;

			// 绘制曲线
			//画一下两个曲线的控制点	
			_g.moveTo(x1, y1);
			_g.curveTo(bx1, by1, xc, yc);
			_g.curveTo(bx2, by2, x2, y2);
		
//			drawArrow(vedge);
			drawTriangle(vedge,vedge.edge.node2.vnode.view.width/6);
		}
		
		private function drawTriangle(vedge:IVisualEdge,Radius:int=6):void{
				var fromPoint:Point = vedge.edge.node1.vnode.viewCenter;
				var toPoint:Point = vedge.edge.node2.vnode.viewCenter;
			 	var angle:int =GetAngle(fromPoint,toPoint);
			 	
			 	
                var centerX:int=toPoint.x-Radius * Math.cos(angle *(Math.PI/180)) ;
                var centerY:int=toPoint.y+Radius * Math.sin(angle *(Math.PI/180)) ;
                var topX:int=toPoint.x ;
                var topY:int=toPoint.y  ;
                
                var leftX:int=centerX + Radius * Math.cos((angle +120) *(Math.PI/180))  ;
                var leftY:int=centerY - Radius * Math.sin((angle +120) *(Math.PI/180))  ;
                
                var rightX:int=centerX + Radius * Math.cos((angle +240) *(Math.PI/180))  ;
                var rightY:int=centerY - Radius * Math.sin((angle +240) *(Math.PI/180))  ;
                
              _g.beginFill(uint(vedge.lineStyle.color));
                
              _g.moveTo(topX,topY);
              _g.lineTo(leftX,leftY);
                
              _g.lineTo(centerX,centerY);
                
              _g.lineTo(rightX,rightY);
              _g.lineTo(topX,topY);
                
              _g.endFill();
		}
		
        private function GetAngle(fromPoint:Point,toPoint:Point):int{
            var  tmpx:int=toPoint.x-fromPoint.x ;
            var tmpy:int=fromPoint.y -toPoint.y ;
            var angle:int= Math.atan2(tmpy,tmpx)*(180/Math.PI);
            return angle;
        }
		/**
		 * This method places the label coordinates at the functional midpoint
		 * of the bezier curve using the same anchors as the edge renderer.
		 * 
		 * @inheritDoc
		 * */
		override public function labelCoordinates(vedge:IVisualEdge):Point {
		
			var center:Point ;
			/* first get the corresponding visual object */
				
				var fromPoint:Point = new Point(vedge.edge.node1.vnode.viewCenter.x,
								vedge.edge.node1.vnode.viewCenter.y);
				var toPoint:Point = new Point(vedge.edge.node2.vnode.viewCenter.x,
								vedge.edge.node2.vnode.viewCenter.y);

			
			/* calculate the midpoint used as curveTo anchor point */
//			if(!vedge.isLoopEdge){
				var anchor:Point = Geometry.midPointOfLine(fromPoint,toPoint);			
			/* we use t = 0.6 here to a bit more towards the target */
				center =  Geometry.bezierPoint(fromPoint,anchor,toPoint,0.6);
//			}else {
//				var xc:uint = (fromPoint.x+toPoint.x)/2;
//				var yc:uint = (fromPoint.y +toPoint.y)/2;
//				center = new Point(xc,yc);
//			}
			
			return center;
		}
	}
}