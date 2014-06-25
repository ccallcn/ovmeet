//hong QQ:1410919373
package com.zlchat.ui {
    import flash.events.*;
    import com.zlchat.utils.*;
    import com.zlchat.mainapp.*;

    public class UserListWin extends ResizeWin {

        public var _rootMC:MainApp;
        private var tabPane:TabPane;

        public function UserListWin(_arg1:Number, _arg2:Number){
            super(_arg1, _arg2);
            tabPane = new TabPane((_arg1 - 4), (_arg2 - 28));
            var _local3:Array = new Array();
            _local3.push({
                label:"在线用户(0)",
                pane:new UserListPane()
            });
            _local3.push({
                label:"会议信息",
                pane:new RoomInfoPane()
            });
            tabPane.dataProvider = _local3;
            addChild(tabPane);
            tabPane.x = 3;
            tabPane.y = 30;
            BtnResize.visible = true;
            BtnClose.visible = false;
            addChild(BtnResize);
        }
        override protected function onMin(_arg1:MouseEvent):void{
            super.onMin(_arg1);
            tabPane.visible = false;
        }
        override public function Resize(_arg1:Number, _arg2:Number):void{
            super.Resize(_arg1, _arg2);
            tabPane.Resize((_arg1 - 4), (_arg2 - 32));
        }
        override protected function onMax(_arg1:MouseEvent):void{
            super.onMax(_arg1);
            this.x = 5;
            this.y = 33;
            Resize(this.width, (stage.stageHeight - 60));
        }
        override public function set conn(_arg1:ChatConnection){
            nc = _arg1;
            tabPane.conn = nc;
        }
        override protected function onWinClose(_arg1:MouseEvent):void{
            this.visible = false;
        }
        override protected function onRestore(_arg1:MouseEvent):void{
            super.onRestore(_arg1);
            tabPane.visible = true;
            this.x = 5;
            this.y = 303;
            Resize(330, (stage.stageHeight - 330));
        }

    }
}//package com.zlchat.ui 
