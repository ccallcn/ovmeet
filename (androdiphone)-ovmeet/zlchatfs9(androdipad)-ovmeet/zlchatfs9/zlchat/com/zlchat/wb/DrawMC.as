//hong QQ:1410919373
package com.zlchat.wb {
    import flash.display.*;
    import flash.geom.*;
    import flash.events.*;
    import flash.net.*;
    import com.zlchat.events.*;
    import flash.text.*;
    import flash.utils.*;

    public class DrawMC extends Sprite {

        public var indexPage:Number = 1;
        public var endPoint:Point;
        public var selectedColor:int = 0;
        public var startPoint:Point;
        private var _type:String;
        private var drawTimer:Timer;
        public var tempPoint:Point;
        private var tempMC:TempDrawMC;
        public var thickness:int = 2;
        private var ptArray:Array;
        public var nc:NetConnection;

        public function DrawMC(){
            drawTimer = new Timer(30);
            drawTimer.addEventListener("timer", timerHandler);
            startPoint = new Point(0, 0);
            endPoint = new Point(0, 0);
            tempPoint = new Point(0, 0);
            ptArray = new Array();
            tempMC = new TempDrawMC();
            addChild(tempMC);
        }
        public function line(_arg1:Sprite, _arg2:Point, _arg3:Point):void{
            _arg1.graphics.clear();
            _arg1.graphics.lineStyle(2, selectedColor);
            _arg1.graphics.moveTo(_arg2.x, _arg2.y);
            _arg1.graphics.lineTo(_arg3.x, _arg3.y);
        }
        protected function timerHandler(_arg1:TimerEvent):void{
            switch (_type){
                case "line":
                    drawLine();
                    break;
                case "rect":
                    drawRect();
                    break;
                case "circle":
                    drawCircle();
                    break;
                case "pen":
                    drawPen();
                    break;
            };
        }
        public function startDraw(_arg1:String):void{
            drawTimer.start();
            startPoint.x = mouseX;
            startPoint.y = mouseY;
            _type = _arg1;
            if (_arg1 == "pen"){
                tempPoint.x = mouseX;
                tempPoint.y = mouseY;
                ptArray = new Array();
                ptArray.push(new Point(mouseX, mouseY));
            };
        }
        protected function drawPen():void{
            tempMC.graphics.lineStyle(2, selectedColor);
            if (!(((tempPoint.x == mouseX)) && ((tempPoint.y == mouseY)))){
                tempMC.graphics.moveTo(tempPoint.x, tempPoint.y);
                tempMC.graphics.lineTo(mouseX, mouseY);
                tempPoint.x = mouseX;
                tempPoint.y = mouseY;
                ptArray.push(new Point(mouseX, mouseY));
            };
        }
        protected function drawRect():void{
            rect(tempMC, startPoint, new Point(mouseX, mouseY));
        }
        public function circle(_arg1:Sprite, _arg2:Point, _arg3:Number){
            _arg1.graphics.clear();
            _arg1.graphics.lineStyle(2, selectedColor);
            _arg1.graphics.moveTo((_arg2.x + _arg3), _arg2.y);
            _arg1.graphics.curveTo((_arg3 + _arg2.x), ((Math.tan((Math.PI / 8)) * _arg3) + _arg2.y), ((Math.cos((Math.PI / 4)) * _arg3) + _arg2.x), ((Math.sin((Math.PI / 4)) * _arg3) + _arg2.y));
            _arg1.graphics.curveTo(((Math.tan((Math.PI / 8)) * _arg3) + _arg2.x), (_arg3 + _arg2.y), _arg2.x, (_arg3 + _arg2.y));
            _arg1.graphics.curveTo(((-(Math.tan((Math.PI / 8))) * _arg3) + _arg2.x), (_arg3 + _arg2.y), ((-(Math.cos((Math.PI / 4))) * _arg3) + _arg2.x), ((Math.sin((Math.PI / 4)) * _arg3) + _arg2.y));
            _arg1.graphics.curveTo((-(_arg3) + _arg2.x), ((Math.tan((Math.PI / 8)) * _arg3) + _arg2.y), (-(_arg3) + _arg2.x), _arg2.y);
            _arg1.graphics.curveTo((-(_arg3) + _arg2.x), ((-(Math.tan((Math.PI / 8))) * _arg3) + _arg2.y), ((-(Math.cos((Math.PI / 4))) * _arg3) + _arg2.x), ((-(Math.sin((Math.PI / 4))) * _arg3) + _arg2.y));
            _arg1.graphics.curveTo(((-(Math.tan((Math.PI / 8))) * _arg3) + _arg2.x), (-(_arg3) + _arg2.y), _arg2.x, (-(_arg3) + _arg2.y));
            _arg1.graphics.curveTo(((Math.tan((Math.PI / 8)) * _arg3) + _arg2.x), (-(_arg3) + _arg2.y), ((Math.cos((Math.PI / 4)) * _arg3) + _arg2.x), ((-(Math.sin((Math.PI / 4))) * _arg3) + _arg2.y));
            _arg1.graphics.curveTo((_arg3 + _arg2.x), ((-(Math.tan((Math.PI / 8))) * _arg3) + _arg2.y), (_arg3 + _arg2.x), _arg2.y);
        }
        protected function drawLine():void{
            line(tempMC, startPoint, new Point(mouseX, mouseY));
        }
        public function Resize(_arg1:Number, _arg2:Number):void{
            drawBg(_arg1, _arg2);
        }
        public function rect(_arg1:Sprite, _arg2:Point, _arg3:Point):void{
            _arg1.graphics.clear();
            _arg1.graphics.lineStyle(2, selectedColor);
            _arg1.graphics.drawRect(_arg2.x, _arg2.y, (_arg3.x - _arg2.x), (_arg3.y - _arg2.y));
        }
        public function stopDraw(_arg1:String):void{
            var _local3:Number;
            var _local4:Point;
            drawTimer.stop();
            endPoint.x = mouseX;
            endPoint.y = mouseY;
            tempMC.graphics.clear();
            var _local2:Object = new Object();
            switch (_arg1){
                case "line":
                    _local2.type = "line";
                    _local2.color = selectedColor;
                    _local2.thickness = thickness;
                    _local2.p1 = startPoint;
                    _local2.p2 = endPoint;
                    _local2.pos = new Point(0, 0);
                    nc.call("newShape", null, _local2, ("page" + indexPage));
                    break;
                case "rect":
                    _local2.type = "rect";
                    _local2.color = selectedColor;
                    _local2.thickness = thickness;
                    _local2.p1 = startPoint;
                    _local2.p2 = endPoint;
                    _local2.pos = new Point(0, 0);
                    nc.call("newShape", null, _local2, ("page" + indexPage));
                    break;
                case "circle":
                    _local3 = (Point.distance(startPoint, endPoint) / 2);
                    _local2.type = "circle";
                    _local2.color = selectedColor;
                    _local2.thickness = thickness;
                    _local4 = new Point();
                    _local4.x = ((endPoint.x + startPoint.x) / 2);
                    _local4.y = ((endPoint.y + startPoint.y) / 2);
                    _local2.p1 = _local4;
                    _local2.r = _local3;
                    _local2.pos = new Point(0, 0);
                    nc.call("newShape", null, _local2, ("page" + indexPage));
                    break;
                case "pen":
                    _local2.type = "pen";
                    _local2.color = selectedColor;
                    _local2.thickness = thickness;
                    ptArray.push(endPoint);
                    _local2.ptArray = ptArray;
                    _local2.pos = new Point(0, 0);
                    nc.call("newShape", null, _local2, ("page" + indexPage));
                    break;
                case "text":
                    break;
            };
            _type = "";
        }
        protected function drawBg(_arg1:Number, _arg2:Number){
            graphics.clear();
            graphics.beginFill(0xFFFFFF, 0);
            graphics.drawRect(0, 0, _arg1, _arg2);
            graphics.endFill();
        }
        protected function drawCircle():void{
            tempPoint.x = mouseX;
            tempPoint.y = mouseY;
            var _local1:Number = Point.distance(startPoint, tempPoint);
            var _local2:Point = new Point();
            _local2.x = ((mouseX + startPoint.x) / 2);
            _local2.y = ((mouseY + startPoint.y) / 2);
            circle(tempMC, _local2, (_local1 / 2));
        }

    }
}//package com.zlchat.wb 
