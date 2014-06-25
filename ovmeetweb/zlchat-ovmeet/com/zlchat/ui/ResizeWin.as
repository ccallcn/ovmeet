//hong QQ:1410919373
package com.zlchat.ui {
    import flash.display.*;
    import flash.events.*;
    import com.zlchat.utils.*;
    import flash.ui.*;

    public class ResizeWin extends Sprite {

        protected const LEFT:int = 2;
        protected const TOP:int = 28;

        public var BtnMax:SimpleButton;//instance name
        public var BtnResize:MovieClip;//instance name
        protected var isMax:Boolean = true;
        public var titleBar:MovieClip;//instance name
        public var BtnClose:SimpleButton;//instance name
        protected var _h:Number;
        public var BtnRestore:SimpleButton;//instance name
        public var border:Sprite;
        protected var nc:ChatConnection;
        public var BtnMin:SimpleButton;//instance name
        protected var resizeCursor:MovieClip;
        protected var isResize:Boolean = false;
        protected var _w:Number;

        public function ResizeWin(_arg1:Number, _arg2:Number){
            border = new Sprite();
            addChild(border);
            resizeCursor = new ResizeCursor();
            addChild(resizeCursor);
            resizeCursor.visible = false;
            BtnResize.visible = false;

           titleBar.addEventListener(MouseEvent.MOUSE_DOWN, onMsDown);
           titleBar.addEventListener(MouseEvent.MOUSE_UP, onMsUp);

            BtnClose.addEventListener(MouseEvent.CLICK, onWinClose);
            BtnMin.addEventListener(MouseEvent.CLICK, onMin);
            BtnMax.addEventListener(MouseEvent.CLICK, onMax);
            BtnRestore.addEventListener(MouseEvent.CLICK, onRestore);
            BtnResize.addEventListener(MouseEvent.MOUSE_DOWN, resizePress);
            BtnResize.addEventListener(MouseEvent.MOUSE_UP, resizeUp);
            BtnResize.addEventListener(MouseEvent.MOUSE_MOVE, resizeMove);
            BtnResize.addEventListener(MouseEvent.MOUSE_OVER, resizeOver);
            BtnResize.addEventListener(MouseEvent.MOUSE_OUT, resizeOut);
            BtnMin.visible = false;
            BtnMax.visible = false;
            BtnRestore.visible = false;
        }
        protected function drawBg(_arg1:Number, _arg2:Number){
            graphics.clear();
            graphics.beginFill(0xFFFFFF);
            graphics.drawRect(1, 27, (_arg1 - 2), (_arg2 - 28));
            graphics.endFill();
        }
        protected function onMsUp(_arg1:MouseEvent):void{
            stopDrag();
        }
        protected function onMax(_arg1:MouseEvent):void{
            BtnMax.visible = false;
            BtnRestore.visible = true;
            parent.addChild(this);
        }
        protected function resizeOut(_arg1:MouseEvent):void{
            resizeCursor.visible = false;
            Mouse.show();
        }
        protected function onMin(_arg1:MouseEvent):void{
            BtnMax.visible = false;
            BtnRestore.visible = true;
        }
        protected function resizeUp(_arg1:MouseEvent):void{
            BtnResize.stopDrag();
            isResize = false;
        }
        public function set conn(_arg1:ChatConnection){
            nc = _arg1;
        }
        protected function onRestore(_arg1:MouseEvent):void{
            BtnRestore.visible = false;
            BtnMax.visible = true;
            BtnResize.visible = true;
        }
        public function Resize(_arg1:Number, _arg2:Number):void{
            _w = (_arg1 - LEFT);
            _h = (_arg2 - TOP);
            titleBar.width = _arg1;
            BtnResize.x = (_arg1 - 13);
            BtnResize.y = (_arg2 - 13);
            resizeCursor.x = _arg1;
            resizeCursor.y = _arg2;
            BtnClose.x = (_arg1 - 28);
            BtnMax.x = (_arg1 - 30);
            BtnRestore.x = (_arg1 - 30);
            BtnMin.x = (_arg1 - 71);
            border.graphics.clear();
            border.graphics.lineStyle(1, 161143);
            border.graphics.beginFill(0xFFFFFF, 0);
            border.graphics.drawRect(0, (titleBar.height - 2), (_arg1 - 1), ((_arg2 - titleBar.height) + 1));
            border.graphics.endFill();
        }
        protected function resizeMove(_arg1:MouseEvent):void{
            if (isResize){
                Resize((BtnResize.x + BtnResize.width), (BtnResize.y + BtnResize.height));
            };
        }
        protected function onMsDown(_arg1:MouseEvent):void{
            parent.addChild(this);
            startDrag();
        }
        protected function resizeOver(_arg1:MouseEvent):void{
            Mouse.hide();
            addChild(resizeCursor);
            resizeCursor.visible = true;
        }
        protected function resizePress(_arg1:MouseEvent):void{
            parent.addChild(this);
            BtnResize.startDrag();
            isResize = true;
        }
        protected function onWinClose(_arg1:MouseEvent):void{
            this.visible = false;
        }

    }
}//package com.zlchat.ui 
