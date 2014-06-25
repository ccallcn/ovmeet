//hong QQ:1410919373
package com.zlchat.ui {
    import flash.display.*;
    import flash.text.*;

    public class ConnBar extends Sprite {

        public function ConnBar(){
            graphics.lineStyle(2, 2578295);
            graphics.beginFill(2578295, 0.6);
            graphics.drawRoundRect(0, 0, 300, 80,10,10);
            var _local1:MovieClip = new LoadingCircle();
            addChild(_local1);
            _local1.width = 45;
            _local1.height = 45;
            _local1.x = 50;
            _local1.y = 15;
            var _local2:TextField = new TextField();
            _local2.text = "正在连接服务器...";
            addChild(_local2);
            var _local3:TextFormat = new TextFormat();
            _local3.size = 14;
            _local2.setTextFormat(_local3);
            _local2.width = 120;
            _local2.height = 30;
            _local2.x = 120;
            _local2.y = 30;
        }
    }
}//package com.zlchat.ui 
