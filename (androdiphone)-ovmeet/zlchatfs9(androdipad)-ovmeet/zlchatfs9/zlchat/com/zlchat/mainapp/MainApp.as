//hong QQ:1410919373
package com.zlchat.mainapp {
    import fl.controls.*;
    import flash.display.*;
    import com.zlchat.ui.*;
    import flash.events.*;
    import flash.net.*;
    import com.zlchat.events.*;
    import com.zlchat.utils.*;
    import flash.text.*;
    import com.zlchat.preloader.*;
    import flash.utils.*;
    import flash.system.*;
    import flash.external.*; 
    import CeCallMeet;
	
    public class MainApp extends Sprite {

        public static var conn:ChatConnection;

        public var txtBandWidth:TextField;
        private var preloader:DisplayObject;
        private var btnUser:SimpleButton;
        private var camWinList:Dictionary;
        public var clientWin:ClientWin;
        public var userListWin:UserListWin;
        private var bgWin:BgWin;
        public var userWin:UserWin;
        public var connBar:ConnBar;
        public var videoListWin:VideoListWin;
        private var conf:Config;
        private var btnSystem:SimpleButton;
        private var systemWin:SystemWin;
        private var chatWinList:Dictionary;
        public var txtLicense:TextField;
        private var txtLogo:TextField;
        private var btnHelp:SimpleButton; 

	//private var btnExit:SimpleButton; 
	public var cecallmeet:CeCallMeet;
		
	public function MainApp(){
            chatWinList = new Dictionary();
            camWinList = new Dictionary();
            super();
            bgWin = new BgWin();
            addChild(bgWin);
            txtLogo = new TextField();
            txtLogo.width = 400;
            txtLogo.text = "OvMeet-视频会议系统";
            addChild(txtLogo);
            txtLogo.x = 8;
            txtLogo.y = 5;
            videoListWin = new VideoListWin(322, 268);
            addChild(videoListWin);
            videoListWin.x = 0;
            videoListWin.y = 33;
            userListWin = new UserListWin(322, 262);
            addChild(userListWin);
            userListWin.x = 0;
            userListWin.y = 301;
            clientWin = new ClientWin(559, 530);
            addChild(clientWin);
            clientWin.x = 323;
            clientWin.y = 33;
            var _local1:TextFormat = new TextFormat();
            _local1.color = "0xFFFFFF";
            _local1.size = 14;
            txtLogo.setTextFormat(_local1);
            btnHelp = new BtnHelp(); 
           // addChild(btnHelp);

	        btnHome = new BtnHome(); 
            addChild(btnHome);
	    	    btnExit = new BtnExit(); 
            addChild(btnExit);

	    btnHome.y=8;
	    btnExit.y=8;


	    btnUser = new BtnUserSet();
            addChild(btnUser);
            btnSystem = new BtnRoomSet();
           // addChild(btnSystem);
            btnHelp.y = (btnUser.y = (btnSystem.y = 8));

	    btnHome.addEventListener(MouseEvent.CLICK, onHome);
            btnHelp.addEventListener(MouseEvent.CLICK, onHelp);
	    btnExit.addEventListener(MouseEvent.CLICK, onExit);

            btnUser.addEventListener(MouseEvent.CLICK, showUserWin);
            btnSystem.addEventListener(MouseEvent.CLICK, showSystemWin);
            userWin = new UserWin();
            userWin._rootMC = this;
            videoListWin._rootMC = this;
            userListWin._rootMC = this;
            clientWin._rootMC = this;
            systemWin = new SystemWin();
            connBar = new ConnBar();
            TipManager.rootMC = this;
            AlertManager._rootMC = this;
            txtBandWidth = new TextField();
            txtBandWidth.width = 400;
            addChild(txtBandWidth);
            txtBandWidth.x = 10;
            txtLicense = new TextField();
            txtLicense.autoSize = TextFieldAutoSize.CENTER;
            addChild(txtLicense);
            txtLicense.x = 300;
            conn = new ChatConnection();  
 
        }
		 
        protected function onHome(_arg1:Event):void{
		 cecallmeet.removeRoom(); //返回主页，并删除本实例
	}
        protected function onHelp(_arg1:Event):void{
              navigateToURL(new URLRequest("./cecallmeet_help.html"), "_blank"); 
	}
	protected function onExit(_arg1:Event):void{
		   cecallmeet.reExit();
        }
	public function setPreloader(_arg1:DisplayObject, _arg2:Object, _arg3:Boolean):void{
            if (_arg3){
                //preloader = _arg1;
                //preloader.addEventListener(Event.RESIZE, Resize);
		 cecallmeet=_arg1;
		 cecallmeet.addEventListener(Event.RESIZE, Resize);


		//stage.scaleMode = StageScaleMode.NO_SCALE; 
		//stage.align = StageAlign.TOP_LEFT;
		//先将缩放模式设置成无缩放模式 
		//stage.addEventListener(Event.RESIZE,Resize);
		//stage.dispatchEvent(new Event(Event.RESIZE)); 
			
		/**
		 bgWin.Resize(stage.stageWidth, stage.stageHeight);
	         videoListWin.Resize(322, 268);
		 userListWin.Resize(322, (stage.stageHeight - 330));
		clientWin.Resize((stage.stageWidth - 330), (stage.stageHeight - 60));
		 btnHelp.x = ((stage.stageWidth - 7) - btnHelp.width);
		 btnUser.x = ((btnHelp.x - 2) - btnUser.width);
		btnSystem.x = ((btnUser.x - 2) - btnSystem.width);
		videoListWin.x = 3;
		 videoListWin.y = 33;
		 txtBandWidth.y = (stage.stageHeight - 25);
		txtLicense.y = (stage.stageHeight - 25);
		txtLicense.x = ((stage.stageWidth - txtLicense.width) / 2);
		**/


                conn.userName = _arg2["userName"];
                conn.realName = _arg2["realName"];
                conn.role = _arg2["role"];
                conn.pwd = _arg2["password"];
                conn.roomID = _arg2["roomID"];
                conn.scriptType = _arg2["scriptType"];
		conn.mediaServer =_arg2["mediaServer"];
                //conn.mediaServer ="rtmp://"+_arg2["mediaServer"]+":1936";
                conn.myDomain = getDomain(_arg2["url"]);
                AlertManager.showWin(connBar, ((stage.stageWidth - connBar.width) / 2), ((stage.stageHeight - connBar.height) / 2));
                conn.connect((("rtmp://"+conn.mediaServer + ":1936/zlchat2/") + conn.roomID), conn.userName, conn.role, conn.hasCam, conn.myDomain, conn.realName);
                conn.addEventListener(PrivateEvent.INVITE, onInvite);
                conn.addEventListener(ConnEvent.USERID, onConnectSucc);
                conn.addEventListener("setRole", onSetRole);
                conn.addEventListener("updateBandWidth", updateBandWdith);
                conn.addEventListener("updateLicenseInfo", updateLicenseInfo);
                conn.setUserID(null);
                conn.noSeat(false);
                conn.showTryWin(null);
                conn.publishVideo(false);
                conn.stopVideo(false);
                conn.onKick(false);
                conn.onSetRole(conn.role);
                conn.onBWCheck(null);
                conn.onBWDone(null);
            };
        }
        private function getDomain(_arg1:String):String{
            var _local3:int;
            var _local4:int;
            var _local2:String = _arg1;
            if (_local2 != null){
                _local3 = _local2.indexOf("/", 0);
                _local4 = _local2.indexOf("/", 10);
                return (_local2.substring((_local3 + 2), _local4));
            };
            return ("");
        }
        private function updateLicenseInfo(_arg1:RoomInfoEvent):void{
            txtLicense.text = "鸿荣科技有限公司　版权所有　联系电话:18650075676 QQ:1410919373";
	    /**
            if (_arg1.key.hasBuy){
                txtLicense.appendText("正式版本，");
            } else {
                txtLicense.appendText("试用版本，");
            };
            txtLicense.appendText(("授权用户数: " + _arg1.key.maxRoomUser));
            **/
	    var _local2:TextFormat = new TextFormat();
            _local2.color = "0xffffff";
            txtLicense.setTextFormat(_local2);
        }
        public function inviteChat(_arg1:Object):void{
            var _local2:PrivateChatWin;
            if ((((conn.role == "4")) && (conn.roomInfoSo.data["g_dp"]))){
                ExternalInterface.call("alert", "禁止私聊", null);
            } else {
                if (_arg1.userID != conn.userID){
                    _local2 = chatWinList[_arg1.userID];
                    if (_local2 == null){
                        _local2 = new PrivateChatWin(_arg1);
                        _local2.conn = conn;
                        addChild(_local2);
                        _local2.x = 100;
                        _local2.y = 100;
                        chatWinList[_arg1.userID] = _local2;
                    } else {
                        _local2.visible = true;
                        addChild(_local2);
                    };
                    _local2.txtMsgSend.enabled = true;
                    _local2.btnSend.enabled = true;
                    _local2.showInviteDlg();
                    conn.speakListSo.send("inviteChat", _arg1.userID, conn.realName, conn.userID);
                } else {
                    ExternalInterface.call("alert", "不能和自己私聊！", null);
                };
            };
        }
        public function Resize(_arg1:Event):void{
            bgWin.Resize(stage.stageWidth, stage.stageHeight);
            videoListWin.Resize(322, 268);
            userListWin.Resize(322, (stage.stageHeight - 328));
            //clientWin.Resize((stage.stageWidth - 330), (stage.stageHeight - 60));
	    clientWin.Resize((stage.stageWidth - 323), (stage.stageHeight - 60));

	    btnExit.x = ((stage.stageWidth - 7) - btnExit.width);
	    //btnHelp.x = ((stage.stageWidth - 7) - btnHelp.width);
            btnUser.x = ((btnExit.x - 2) - btnUser.width); 
           // btnSystem.x = ((btnUser.x - 2) - btnSystem.width);
	    btnHome.x = ((btnUser.x - 2) - btnHome.width);

            videoListWin.x = 0;
            videoListWin.y = 33;
            txtBandWidth.y = (stage.stageHeight - 25);
            txtLicense.y = (stage.stageHeight - 25);
            txtLicense.x = ((stage.stageWidth - txtLicense.width) / 2);
        }
        protected function onSetRole(_arg1:Event):void{
	/*
            if (conn.role == "2"){
                btnSystem.visible = true;
            } else {
               btnSystem.visible = false;
            };
	    */
        }
        protected function showUserWin(_arg1:MouseEvent):void{
            if (userWin == null){
                userWin = new UserWin();
                userWin.conn = conn;
            };
            if (conn.cam != null){
                userWin.video.attachCamera(conn.cam);
            };
            AlertManager.showWin(userWin, (btnUser.x - userWin.width), 100);
        }
        protected function onInvite(_arg1:PrivateEvent):void{
            var _local2:PrivateChatWin = chatWinList[_arg1.userItem.userID];
            if (_local2 == null){
                _local2 = new PrivateChatWin(_arg1.userItem);
                _local2.conn = conn;
                addChild(_local2);
                _local2.x = 100;
                _local2.y = 100;
                chatWinList[_arg1.userItem.userID] = _local2;
            } else {
                _local2.visible = true;
                addChild(_local2);
            };
            _local2.txtMsgSend.enabled = true;
            _local2.btnSend.enabled = true;
            _local2.showInviteDlg2();
        }
        public function viewCam(_arg1:Object):void{
            var _local2:ViewCamWin;
            if (_arg1.userID != conn.userID){
                _local2 = camWinList[_arg1.userID];
                if (_local2 == null){
                    _local2 = new ViewCamWin(_arg1);
                    addChild(_local2);
                    _local2.x = 100;
                    _local2.y = 100;
                    camWinList[_arg1.userID] = _local2;
                } else {
                    _local2.visible = true;
                    addChild(_local2);
                };
                conn.speakListSo.send("viewCam", _arg1.userID);
                _local2.startView();
            } else {
                ExternalInterface.call("alert", "不能查看自己！", null);
            };
        }
        protected function showSystemWin(_arg1:MouseEvent):void{

		    if (systemWin == null){
			systemWin = new SystemWin();
			systemWin.conn = conn;
		    };
		    AlertManager.showWin(systemWin, (btnSystem.x - systemWin.width), 100);
	}
        protected function updateBandWdith(_arg1:RoomInfoEvent):void{
            txtBandWidth.text = (((((("下行:" + _arg1.key.down) + "kbps  上行:") + _arg1.key.up) + "kbps  延时:") + _arg1.key.latency) + "ms");
            var _local2:TextFormat = new TextFormat();
            _local2.color = "0xffffff";
            txtBandWidth.setTextFormat(_local2);
        }
        private function expireDate(_arg1:int, _arg2:int){
            var _local3:Date = new Date();
            var _local4:int = _local3.getFullYear();
            var _local5:int = (_local3.getMonth() + 1);
            if (_local4 > _arg1){
                return (true);
            };
            if (_local4 == _arg1){
                if (_local5 <= _arg2){
                    return (false);
                };
                return (true);
            };
            return (false);
        }
        protected function onConnectSucc(_arg1:Event):void{
            userListWin.conn = conn;
            clientWin.conn = conn;
            videoListWin.conn = conn;
            userWin.conn = conn;
            systemWin.conn = conn;
            if (conn.role != "2"){
                btnSystem.visible = false;
            };
        }

    }
}//package com.zlchat.mainapp 
