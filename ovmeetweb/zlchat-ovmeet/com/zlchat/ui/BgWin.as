//hong QQ:1410919373
package com.zlchat.ui {
    import flash.display.*;

    public class BgWin extends Sprite {

        public var mc_right:MovieClip;//instance name
        public var mc_bottom:MovieClip;//instance name
        public var mc_left:MovieClip;//instance name
        public var mc_top:MovieClip;//instance name

        public function Resize(_arg1:Number, _arg2:Number):void{
            mc_top.width = _arg1;
            mc_bottom.width = _arg1;
            mc_left.height = (_arg2 - 60);
            mc_right.height = (_arg2 - 60);
            mc_right.x = (_arg1 - 5);
            mc_bottom.y = (_arg2 - 27);
        }

    }
}//package com.zlchat.ui 
