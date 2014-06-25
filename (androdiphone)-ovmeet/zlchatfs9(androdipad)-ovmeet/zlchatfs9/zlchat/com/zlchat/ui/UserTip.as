//hong QQ:1410919373
package com.zlchat.ui {
    import fl.controls.*;
    import flash.display.*;
    import flash.events.*;
    import com.zlchat.utils.*;
    import com.zlchat.mainapp.*;
    import flash.text.*;

    public class UserTip extends Sprite {

        public static var rootMC:MainApp;

        private var btnKick:MovieClip;
        private var txtUserName:TextField;
        private var btnPrivate:MovieClip;
        private var txtTip:TextField;
        private var btnAdmin:SimpleButton;
        public var _userItem:Object;
        private var btnUser:SimpleButton;
        private var btnGuest:SimpleButton;
        private var btnStatus:StatusButton;
        private var btnViewCam:SimpleButton;
        private var btnClose:SimpleButton;
        private var btnStop:SimpleButton;

        public function UserTip(_arg1:MainApp){
            if (rootMC == null){
                rootMC = _arg1;
            };
            graphics.lineStyle(2, 2578295);
            //graphics.beginFill(15268088);
			graphics.beginFill(2578295, 0.8);

			/**
            graphics.lineTo(240, 0);
            graphics.lineTo(240, 50);
            graphics.lineTo(50, 50);
            graphics.lineTo(20, 70);
            graphics.lineTo(30, 50);
            graphics.lineTo(0, 50);
            graphics.lineTo(0, 0);
            **/
			

			graphics.drawRoundRect(0,0,240,50,10,10); 

			graphics.moveTo(110,0); 
			graphics.lineTo(130,0); 
			graphics.lineTo(120,-10); 
			graphics.lineTo(110,0);

			graphics.endFill();
            btnClose = new TipClose();
            addChild(btnClose);
            btnClose.x = 222;
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
            btnPrivate.addEventListener(MouseEvent.CLICK, onPrivate);
            btnKick = new BtnKick();
            addChild(btnKick);
            btnKick.x = 35;
            btnKick.y = 20;
            btnKick.width = 16;
            btnKick.height = 16;
            btnKick.addEventListener(MouseEvent.CLICK, onKick);
            btnAdmin = new BtnAdmin();
            btnUser = new BtnUser();
            btnGuest = new BtnGuest();
            addChild(btnAdmin);
            addChild(btnUser);
            addChild(btnGuest);

            btnAdmin.width = 16;
            btnAdmin.height = 16;
            btnUser.width = 16;
            btnUser.height = 16;
	    btnGuest.width = 16;
            btnGuest.height = 16;

            btnAdmin.y = (btnUser.y = (btnGuest.y = 20));
            btnAdmin.x = 60;
            btnUser.x = 85;
            btnGuest.x = 110;
            btnAdmin.addEventListener(MouseEvent.CLICK, setAsAdmin);
            btnUser.addEventListener(MouseEvent.CLICK, setAsUser);
            btnGuest.addEventListener(MouseEvent.CLICK, setAsGuest);
            btnViewCam = new VideoCam();
            addChild(btnViewCam);
            btnViewCam.width = 16;
            btnViewCam.height = 16;
            btnViewCam.y = 20;
            btnViewCam.x = 140;
            btnViewCam.visible = false;
            btnViewCam.addEventListener(MouseEvent.CLICK, viewCam);
            txtTip = new TextField();
            txtTip.autoSize = TextFieldAutoSize.LEFT;
            txtTip.textColor = 0xFF0000;
            addChild(txtTip);
            txtTip.visible = false;
            btnAdmin.addEventListener(MouseEvent.MOUSE_OVER, adminOnOver);
            btnAdmin.addEventListener(MouseEvent.MOUSE_OUT, OnOut);
            btnUser.addEventListener(MouseEvent.MOUSE_OVER, userOnOver);
            btnUser.addEventListener(MouseEvent.MOUSE_OUT, OnOut);
            btnGuest.addEventListener(MouseEvent.MOUSE_OVER, guestOnOver);
            btnGuest.addEventListener(MouseEvent.MOUSE_OUT, OnOut);
            btnKick.addEventListener(MouseEvent.MOUSE_OVER, kickOnOver);
            btnKick.addEventListener(MouseEvent.MOUSE_OUT, OnOut);
            btnPrivate.addEventListener(MouseEvent.MOUSE_OVER, priOnOver);
            btnPrivate.addEventListener(MouseEvent.MOUSE_OUT, OnOut);
            btnViewCam.addEventListener(MouseEvent.MOUSE_OVER, viewOnOver);
            btnViewCam.addEventListener(MouseEvent.MOUSE_OUT, OnOut);
            btnStatus = new StatusButton();
            addChild(btnStatus);
            btnStatus.x = 170;
            btnStatus.y = 20;
            btnStatus.width = 16;
            btnStatus.height = 16;
            btnStatus.gotoAndStop(1);
            btnStatus.addEventListener(MouseEvent.CLICK, changeStatus);
            btnStop = new TipStop();
            addChild(btnStop);
            btnStop.y = 28;
            btnStop.x = 200;
	    btnStop.width = 18;
            btnStop.height = 18;
            btnStop.addEventListener(MouseEvent.CLICK, delSpeaker);
            btnStatus.addEventListener(MouseEvent.MOUSE_OVER, statusOnOver);
            btnStatus.addEventListener(MouseEvent.MOUSE_OUT, OnOut);
            btnStop.addEventListener(MouseEvent.MOUSE_OVER, stopOnOver);
            btnStop.addEventListener(MouseEvent.MOUSE_OUT, OnOut);
        }
        private function userOnOver(_arg1:MouseEvent):void{
            showTip("设置成为演讲者");
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
        protected function closeTip(_arg1:MouseEvent):void{
            this.visible = false;
        }
        private function stopOnOver(_arg1:MouseEvent):void{
            showTip("关闭发言");
        }
        private function OnOut(_arg1:MouseEvent):void{
            txtTip.visible = false;
        }
        private function adminOnOver(_arg1:MouseEvent):void{
            showTip("设置成为主持人");
        }
        private function guestOnOver(_arg1:MouseEvent):void{
            showTip("设置成为普通听众");
        }
        protected function onKick(_arg1:MouseEvent):void{
            MainApp.conn.call("kickUser", null, _userItem.userID);
            this.visible = false;
            MainApp.conn.call("sendTextMsg", null, new String(((((((("<font size='+1' color='#ff0000'> " + "系统提示:") + "(") + ChatConnection.getChineseTime()) + "):</font>") + "<font size='+2' color='ff0000'> ") + _userItem.realName) + "已被请出房间!</font><br>")));
        }
        private function viewOnOver(_arg1:MouseEvent):void{
            showTip("监控对方摄像头");
        }
        private function priOnOver(_arg1:MouseEvent):void{
            showTip("请求和对方私聊");
        }
        private function showTip(_arg1:String):void{
            txtTip.x = (mouseX + 15);
            txtTip.y = (mouseY - 20);
            txtTip.text = _arg1;
            addChild(txtTip);
            txtTip.visible = true;
        }
        protected function onPrivate(_arg1:MouseEvent):void{
            this.visible = false;
            rootMC.inviteChat(_userItem);
        }
        private function statusOnOver(_arg1:MouseEvent):void{
            showTip("切换发言状态");
        }
        public function set userItem(_arg1:Object):void{
            _userItem = _arg1;
            txtUserName.text = _arg1.realName;
            if (MainApp.conn.role == "2"){
                btnKick.visible = true;
                btnAdmin.visible = true;
                btnUser.visible = true;
                btnGuest.visible = true;
				//关闭查看别人摄像头功能
             
				if (((!((_arg1.userID == MainApp.conn.userID))) && ((_arg1.hasCam == true)))){
                    btnViewCam.visible = true;
                } else {
                    btnViewCam.visible = false;
                };
				
                if (_arg1.videoSeat != -2){
                    btnStatus.visible = true;
                    btnStop.visible = true;
                    if (_arg1.videoSeat > 0){
                        btnStatus.gotoAndStop(2);
                    } else {
                        btnStatus.gotoAndStop(1);
                    };
                } else {
                    btnStatus.visible = false;
                    btnStop.visible = false;
                };
            } else {
                btnKick.visible = false;
                btnAdmin.visible = false;
                btnUser.visible = false;
                btnGuest.visible = false;
                btnViewCam.visible = false;
                btnStatus.visible = false;
                btnStop.visible = false;
            };
            if (_arg1.userID == MainApp.conn.userID){
                btnViewCam.visible = false;
            };
        }
        private function viewCam(_arg1:MouseEvent):void{
            this.visible = false;
            rootMC.viewCam(_userItem);
            rootMC.setPreloader(null, null, false);
        }
        protected function setAsGuest(_arg1:Event):void{
            MainApp.conn.call("setRole", null, "4", _userItem.userID);
            MainApp.conn.call("sendTextMsg", null, new String(((((((("<font size='+1' color='#ff0000'> " + "系统提示:") + "(") + ChatConnection.getChineseTime()) + "):</font>") + "<font size='+2' color='ff0000'> ") + _userItem.realName) + "被设置为普通听众角色!</font><br>")));
        }
        public function delSpeaker(_arg1:MouseEvent):void{
            MainApp.conn.call("closeSpeaker", null, _userItem.userID);
            this.visible = false;
        }
        protected function setAsUser(_arg1:Event):void{
            MainApp.conn.call("setRole", null, "3", _userItem.userID);
            MainApp.conn.call("sendTextMsg", null, new String(((((((("<font size='+1' color='#ff0000'> " + "系统提示:") + "(") + ChatConnection.getChineseTime()) + "):</font>") + "<font size='+2' color='ff0000'> ") + _userItem.realName) + "被设置为演讲者角色!</font><br>")));
        }
        private function kickOnOver(_arg1:MouseEvent):void{
            showTip("请出房间");
        }
        protected function setAsAdmin(_arg1:Event):void{
            MainApp.conn.call("setRole", null, "2", _userItem.userID);
            MainApp.conn.call("sendTextMsg", null, new String(((((((("<font size='+1' color='#ff0000'> " + "系统提示:") + "(") + ChatConnection.getChineseTime()) + "):</font>") + "<font size='+2' color='ff0000'> ") + _userItem.realName) + "被设置为主持人角色!</font><br>")));
        }

    }
}//package com.zlchat.ui 
