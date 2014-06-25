//hong QQ:1410919373
package com.zlchat.wb {
    import flash.display.*;
    import flash.events.*;
    import com.zlchat.events.*;
    import flash.utils.*;

    public class RectBorder extends Sprite {

        private var resizeTimer:Timer;
        private var bg:Sprite;
        private var resizeRect:ResizeRect;

        public function RectBorder(_arg1:Number, _arg2:Number){
            bg = new Sprite();
            addChild(bg);
            bg.x = 0;
            bg.y = 0;
            resizeRect = new ResizeRect();
            addChild(resizeRect);
            resizeTimer = new Timer(40);
            resizeTimer.addEventListener("timer", timerHandler);
            resizeRect.addEventListener(MouseEvent.MOUSE_DOWN, rrDown);
            addEventListener(MouseEvent.MOUSE_UP, rrUp);
            Resize(_arg1, _arg2);
        }
        public function Resize(_arg1:Number, _arg2:Number):void{
            bg.graphics.clear();
            bg.graphics.lineStyle(1, 26367);
            bg.graphics.beginFill(0xFFFFFF, 0);
            bg.graphics.drawRect(0, 0, _arg1, _arg2);
            resizeRect.x = (_arg1 - 3);
            resizeRect.y = (_arg2 - 3);
        }
        protected function rrDown(_arg1:MouseEvent):void{
            resizeRect.startDrag();
            resizeTimer.start();
            _arg1.stopPropagation();
        }
        protected function rrUp(_arg1:MouseEvent):void{
            resizeRect.stopDrag();
            resizeTimer.stop();
        }
        protected function timerHandler(_arg1:Event):void{
            Resize(mouseX, mouseY);
            dispatchEvent(new BorderEvent(BorderEvent.RESIZE, {
                w:mouseX,
                h:mouseY
            }));
        }

    }
}//package com.zlchat.wb 
