//hong QQ:1410919373
package com.zlchat.ui {
    import fl.controls.*;
    import flash.display.*;
    import flash.events.*;
    import com.zlchat.mainapp.*;
    import flash.text.*;

    public class SpeakerTip extends Sprite {

        public static var rootMC:MainApp;

        private var txtUserName:TextField;
        private var btnPrivate:MovieClip;
        private var txtTip:TextField;
        private var btnStatus:StatusButton;
        private var btnClose:SimpleButton;
        public var _userItem:Object;
        private var btnStop:SimpleButton;

        public function SpeakerTip(_arg1:MainApp){
            if (rootMC == null){
                rootMC = _arg1;
            };
            graphics.lineStyle(2, 2578295);
            graphics.beginFill(15268088);
            graphics.lineTo(200, 0);
            graphics.lineTo(200, 50);
            graphics.lineTo(50, 50);
            graphics.lineTo(20, 70);
            graphics.lineTo(30, 50);
            graphics.lineTo(0, 50);
            graphics.lineTo(0, 0);
            graphics.endFill();
            btnClose = new TipClose();
            addChild(btnClose);
            btnClose.x = 182;
            btnClose.y = 2;
            btnClose.addEventListener(MouseEvent.CLICK, closeTip);
            txtUserName = new TextField();
            addChild(txtUserName);
            txtUserName.text = "lhh";
            var _local2:TextFormat = new TextFormat();
            _local2.color = 0xFFFFFF;
            txtUserName.setTextFormat(_local2);
            txtUserName.y = 2;
            txtUserName.x = 10;
            btnPrivate = new BtnPrivate();
            addChild(btnPrivate);
            btnPrivate.y = 20;
            btnPrivate.x = 10;
            btnPrivate.width = 16;
            btnPrivate.height = 16;
            btnStatus = new StatusButton();
            addChild(btnStatus);
            btnStatus.x = 35;
            btnStatus.y = 20;
            btnStatus.width = 16;
            btnStatus.height = 16;
            btnStatus.gotoAndStop(1);
            btnStatus.addEventListener(MouseEvent.CLICK, changeStatus);
            btnPrivate.addEventListener(MouseEvent.CLICK, onPrivate);
            btnStop = new TipStop();
            addChild(btnStop);
            btnStop.y = 28;
            btnStop.x = 68;
            btnStop.addEventListener(MouseEvent.CLICK, delSpeaker);
            txtTip = new TextField();
            txtTip.autoSize = TextFieldAutoSize.LEFT;
            txtTip.textColor = 0xFF0000;
            addChild(txtTip);
            txtTip.visible = false;
            btnPrivate.addEventListener(MouseEvent.MOUSE_OVER, priOnOver);
            btnPrivate.addEventListener(MouseEvent.MOUSE_OUT, OnOut);
            btnStatus.addEventListener(MouseEvent.MOUSE_OVER, statusOnOver);
            btnStatus.addEventListener(MouseEvent.MOUSE_OUT, OnOut);
            btnStop.addEventListener(MouseEvent.MOUSE_OVER, stopOnOver);
            btnStop.addEventListener(MouseEvent.MOUSE_OUT, OnOut);
        }
        private function priOnOver(_arg1:MouseEvent):void{
            showTip("请求和对方私聊");
        }
        protected function changeStatus(_arg1:MouseEvent):void{
            if (_userItem.videoSeat > 0){
                MainApp.conn.call("stopVideo", null, _userItem.userID);
                _userItem.videoSeat = -1;
                btnStatus.gotoAndStop(1);
            } else {
                MainApp.conn.call("publishVideo", null, _userItem.userID);
                _userItem.videoSeat = 1;
                btnStatus.gotoAndStop(2);
            };
        }
        private function stopOnOver(_arg1:MouseEvent):void{
            showTip("关闭发言");
        }
        private function statusOnOver(_arg1:MouseEvent):void{
            showTip("切换发言状态");
        }
        protected function closeTip(_arg1:MouseEvent):void{
            this.visible = false;
        }
        private function showTip(_arg1:String):void{
            txtTip.x = (mouseX + 15);
            txtTip.y = (mouseY - 20);
            txtTip.text = _arg1;
            addChild(txtTip);
            txtTip.visible = true;
        }
        private function OnOut(_arg1:MouseEvent):void{
            txtTip.visible = false;
        }
        protected function onPrivate(_arg1:MouseEvent):void{
            this.visible = false;
            rootMC.inviteChat(_userItem);
        }
        public function set userItem(_arg1:Object):void{
            _userItem = _arg1;
            txtUserName.text = _arg1.realName;
            if (_arg1.videoSeat > 0){
                btnStatus.gotoAndStop(2);
            } else {
                btnStatus.gotoAndStop(1);
            };
        }
        public function delSpeaker(_arg1:MouseEvent):void{
            MainApp.conn.call("closeSpeaker", null, _userItem.userID);
            this.visible = false;
        }

    }
}//package com.zlchat.ui 
