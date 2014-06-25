//hong QQ:1410919373
package com.zlchat.ui {
    import flash.display.*;
    import com.zlchat.utils.*;

    public class BasePane extends Sprite {

        protected var nc:ChatConnection;

        public function Resize(_arg1:Number, _arg2:Number):void{
            graphics.clear();
            drawBg(_arg1, _arg2);
        }
        public function set conn(_arg1:ChatConnection){
            nc = _arg1;
        }
        protected function drawBg(_arg1:Number, _arg2:Number){
            graphics.beginFill(0xFFFFFF);
            graphics.drawRect(0, 0, _arg1, _arg2);
            graphics.endFill();
        }

    }
}//package com.zlchat.ui 
