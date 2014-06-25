//hong QQ:1410919373
package com.zlchat.ui {
    import fl.controls.*;
    import flash.display.*;
    import flash.geom.*;
    import flash.events.*;
    import fl.data.*;
    import flash.net.*;
    import com.zlchat.events.*;
    import com.zlchat.utils.*;
    import fl.events.*;
    import flash.text.*;
    import flash.media.*;
    import flash.external.*;

    public class UserListPane extends BasePane {

        private var btnSpeaker:SimpleButton;
        private var isPublish:Boolean = false;
        private var userList:List;
        private var chk_a_da:CheckBox;
        private var chk_a_dv:CheckBox;
        private var btnSpeakerClose:SimpleButton;
        private var showSpeakBtn:Boolean = true;
        private var volumeAdjust:VolumeAdjust;
        private var isAudio:Boolean = true;
        private var userListDP:DataProvider;
        private var rePublish:Boolean = false;
        private var toolTip:Sprite;
        private var isVideo:Boolean = true;
        private var outStream:NetStream;

        public function UserListPane(){
            userList = new List();
            userList.x = 0;
            userList.y = 0;
            userList.rowHeight = 30;
            userList.setStyle("cellRenderer", UserItem);
            addChild(userList);
            userList.addEventListener(ListEvent.ITEM_CLICK, showTip);
            btnSpeaker = new BtnSpeaker();
            addChild(btnSpeaker);
            btnSpeaker.addEventListener(MouseEvent.CLICK, applySpeaker);
            btnSpeakerClose = new BtnSpeakerClose();
            addChild(btnSpeakerClose);
            btnSpeakerClose.visible = false;
            btnSpeakerClose.addEventListener(MouseEvent.CLICK, closeSpeaker);
            var _local1:TextFormat = new TextFormat();
            _local1.size = 12;
            chk_a_dv = new CheckBox();
            chk_a_dv.label = "摄像头";
            chk_a_dv.setStyle("textFormat", _local1);
            chk_a_dv.width = 70;
            addChild(chk_a_dv);
            chk_a_dv.selected = isVideo;
            chk_a_da = new CheckBox();
            chk_a_da.label = "话筒";
            chk_a_da.setStyle("textFormat", _local1);
            chk_a_da.width = 60;
            addChild(chk_a_da);
            chk_a_da.selected = isAudio;
            chk_a_dv.addEventListener(Event.CHANGE, videoHandler);
            chk_a_da.addEventListener(Event.CHANGE, audioHandler);
            volumeAdjust = new VolumeAdjust();
            addChild(volumeAdjust);
            volumeAdjust.mc.x = 30;
            volumeAdjust.mc.y = -4;
            volumeAdjust.mc.addEventListener(MouseEvent.MOUSE_DOWN, mcDown);
            volumeAdjust.mc.addEventListener(MouseEvent.MOUSE_UP, mcUp);
        }
        private function mcMove(_arg1:MouseEvent):void{
        }
        protected function roll_out(_arg1:ListEvent):void{
            toolTip.visible = false;
        }
        protected function stopVideo(_arg1:Event):void{
            if (outStream != null){
                outStream.close();
            };
            nc.call("sendTextMsg", null, new String(((((((("<font size='+1' color='#ff0000'> " + "系统提示:") + "(") + ChatConnection.getChineseTime()) + "):</font>") + "<font size='+2' color='ff0000'> ") + nc.realName) + "已经停止发言!</font><br>")));
            isPublish = false;
            btnSpeaker.visible = ((showSpeakBtn) && (!(isPublish)));
            btnSpeakerClose.visible = ((showSpeakBtn) && (isPublish));
        }
        protected function audioHandler(_arg1:Event):void{
            isAudio = _arg1.currentTarget.selected;
            nc.dispatchEvent(new RoomInfoEvent("a_da", !(isAudio)));
        }
        protected function changeAudioDV(_arg1:VideoEvent1):void{
            if (outStream != null){
                outStream.attachAudio(nc.mic);
            };
        }
        protected function onSetRole(_arg1:Event):void{
            if (nc.role == "4"){
                showSpeakBtn = !(nc.roomInfoSo.data["g_ds"]);
                btnSpeaker.visible = ((showSpeakBtn) && (!(isPublish)));
                chk_a_dv.visible = isPublish;
                chk_a_da.visible = isPublish;
                volumeAdjust.visible = isPublish;
                btnSpeakerClose.visible = isPublish;
            } else {
                btnSpeaker.visible = true;
                chk_a_dv.visible = true;
                chk_a_da.visible = true;
                volumeAdjust.visible = true;
                showSpeakBtn = true;
            };
        }
        protected function a_da(_arg1:RoomInfoEvent):void{
            if (outStream != null){
                if (!_arg1.key){
                    outStream.attachAudio(nc.mic);
                } else {
                    outStream.attachAudio(null);
                };
            };
        }
        protected function stopPubVideo(_arg1:VideoEvent1):void{
            if (_arg1.speaker){
                if (!nc.roomInfoSo.data["a_dv"]){
                    outStream.attachCamera(nc.cam);
                };
            } else {
                outStream.attachCamera(null);
            };
        }
        protected function publishVideo(_arg1:Event):void{
            var e:* = _arg1;
            //outStream = new NetStream(nc);
		outStream = new NetStream(nc.ncvideo);
	    			//创建netStream与用户组的链接，我们用他来发送视频和音频流
			//outStream = new NetStream(nc.ncvideo, nc.groupSpecifier.groupspecWithAuthorizations());
			//outStream.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			//outStream.bufferTime = 0; 
		 
			 
			var vh264Settings:H264VideoStreamSettings = new H264VideoStreamSettings();
			vh264Settings.setProfileLevel(H264Profile.BASELINE,H264Level.LEVEL_5_1); 
		
			outStream.videoStreamSettings = vh264Settings; 
			 
            try {
                if (((!((nc.cam == null))) && ((nc.cam.name == "VHScrCap")))){
                    nc.cam.setMode(0x0400, 0x0300, 5);
                    nc.cam.setQuality(0, 70);
                };
                if (nc.roomInfoSo.data["a_da"] == true){
                    outStream.attachAudio(null);
                    ExternalInterface.call("alert", " 禁止语音", null);
                } else {
                    if (isAudio){
                        if (nc.mic == null){
                            nc.mic = Microphone.getMicrophone();
                        };
                        outStream.attachAudio(nc.mic);
                    } else {
                        outStream.attachAudio(null);
                    };
                };
                if (nc.roomInfoSo.data["a_dv"] == true){
                    outStream.attachCamera(null);
                } else {
                    if (isVideo){
                        outStream.attachCamera(nc.cam);
                    } else {
                        outStream.attachCamera(null);
                    };
                };
            } catch(e:Error) {
                outStream.attachCamera(nc.cam);
                outStream.attachAudio(nc.mic);
            };
            outStream.publish(nc.userID);
            nc.call("sendTextMsg", null, new String(((((((("<font size='+1' color='#ff0000'> " + "系统提示:") + "(") + ChatConnection.getChineseTime()) + "):</font>") + "<font size='+2' color='ff0000'> ") + nc.realName) + "已经开始发言!</font><br>")));
        }
        protected function a_dv(_arg1:RoomInfoEvent):void{
            if (outStream != null){
                if (!_arg1.key){
                    outStream.attachCamera(nc.cam);
                } else {
                    outStream.attachCamera(null);
                };
            };
        }
        protected function applySpeaker(_arg1:MouseEvent):void{
            isPublish = true;
            nc.call("applySpeaker", null, nc.userID);
            btnSpeakerClose.visible = true;
            btnSpeaker.visible = false;
            if (nc.roomInfoSo.data["applyVideo"] == true){
                nc.call("sendTextMsg", null, new String(((((((("<font size='+1' color='#ff0000'> " + "系统提示:") + "(") + ChatConnection.getChineseTime()) + "):</font>") + "<font size='+2' color='ff0000'> ") + nc.realName) + "提出发言请求!</font><br>")));
            };
        }
        protected function updateUser(_arg1:ConnListEvent):void{
            userListDP = _arg1.userListDP.clone();
            userList.dataProvider = userListDP;
            var _local2:TabPane = (parent as TabPane);
            _local2.changeLabel((("在线用户(" + userList.length) + ")"), 0);
        }
        protected function videoHandler(_arg1:Event):void{
            isVideo = _arg1.currentTarget.selected;
            nc.dispatchEvent(new RoomInfoEvent("a_dv", !(isVideo)));
        }
        private function mcUp(_arg1:MouseEvent):void{
            volumeAdjust.mc.stopDrag();
            if (nc.mic != null){
                nc.mic.gain = (volumeAdjust.mc.x * 2);
            };
        }
        override public function Resize(_arg1:Number, _arg2:Number):void{
            super.Resize(_arg1, _arg2);
            userList.width = _arg1;
            userList.height = ((_arg2 - btnSpeaker.height) - 4);
            btnSpeaker.x = 2;
            btnSpeaker.y = ((_arg2 - btnSpeaker.height) - 2);
            chk_a_dv.y = (chk_a_da.y = ((_arg2 - chk_a_dv.height) - 2));
            chk_a_dv.x = (btnSpeaker.width + 10);
            chk_a_da.x = ((chk_a_dv.x + chk_a_dv.width) + 5);
            btnSpeakerClose.x = 2;
            btnSpeakerClose.y = ((_arg2 - btnSpeaker.height) - 2);
            volumeAdjust.y = ((_arg2 - volumeAdjust.height) - 2);
            volumeAdjust.x = ((chk_a_da.x + chk_a_da.width) + 2);
        }
        protected function roll_over(_arg1:ListEvent):void{
            toolTip.x = this.mouseX;
            toolTip.y = this.mouseY;
            toolTip.visible = true;
        }
        private function mcDown(_arg1:MouseEvent):void{
            volumeAdjust.mc.startDrag(false, new Rectangle(0, -4, 50, 0));
        }
        protected function showTip(_arg1:ListEvent):void{
            TipManager.showUserTip(localToGlobal(new Point(mouseX, mouseY)), _arg1.item.data);
        }
        override public function set conn(_arg1:ChatConnection){
            nc = _arg1;
            nc.addEventListener(ConnListEvent.UserListSync, updateUser);
            nc.addEventListener(ConnListEvent.SpeakerListSync, updateSpeaker);
            nc.addEventListener(VideoEvent1.START, publishVideo);
            nc.addEventListener(VideoEvent1.STOP, stopVideo);
            nc.addEventListener(VideoEvent1.STOPV, stopPubVideo);
            nc.addEventListener(VideoEvent1.STOPA, stopPubAudio);
            nc.addEventListener("ChangeVideoDV", changeVideoDV);
            nc.addEventListener("ChangeAudioDV", changeAudioDV);
            nc.addEventListener("g_ds", g_ds);
            nc.addEventListener("a_dv", a_dv);
            nc.addEventListener("a_da", a_da);
            nc.addEventListener("reConnect", reConn);
            nc.addEventListener(ConnEvent.USERID, onConnectSucc);
            nc.addEventListener("setRole", onSetRole);
        }
        protected function g_ds(_arg1:RoomInfoEvent):void{
            if (nc.role == "4"){
                btnSpeaker.visible = !(_arg1.key);
                chk_a_dv.visible = !(_arg1.key);
                chk_a_da.visible = !(_arg1.key);
                volumeAdjust.visible = !(_arg1.key);
                showSpeakBtn = !(_arg1.key);
            };
        }
        protected function onConnectSucc(_arg1:Event):void{
            if (((rePublish) && (isPublish))){
                nc.call("applySpeaker", null, nc.userID);
            };
        }
        protected function closeSpeaker(_arg1:MouseEvent):void{
            nc.call("closeSpeaker", null, nc.userID);
            btnSpeakerClose.visible = false;
            btnSpeaker.visible = true;
            isPublish = false;
        }
        protected function updateSpeaker(_arg1:ConnListEvent):void{
            var _local5:*;
            var _local6:Object;
            var _local7:*;
            var _local8:Object;
		//	trace("update1");
            var _local2:* = _arg1.userListDP.clone();
		//	trace("update10");
            var _local3:* = _local2.length;
		//	trace("update12");
            var _local4:* = userListDP.length;
         //   trace("update2");
			if ((((_local3 > 0)) && ((_local4 >= _local3)))){
                _local5 = 0;
		//	trace("update3");
				while (_local5 < _local3) {
                    _local6 = _local2.getItemAt(_local5).data;
                    _local7 = 0;
//trace("update4");
                    while (_local7 < _local4) {
                        _local8 = userListDP.getItemAt(_local7).data;
  //            trace("update5");
						if (_local8.userName == _local6.userName){
                            _local8.videoSeat = _local6.videoSeat;
                        };
                        _local7++;
                    };
                    _local5++;
                };
//trace("update6");
                userList.dataProvider = userListDP;
            };
        }
        protected function stopPubAudio(_arg1:VideoEvent1):void{
            if (_arg1.speaker){
                if (!nc.roomInfoSo.data["a_da"]){
                    outStream.attachAudio(nc.mic);
                };
            } else {
                outStream.attachAudio(null);
            };
        }
        protected function changeVideoDV(_arg1:VideoEvent1):void{
            if (outStream != null){
                outStream.attachCamera(nc.cam);
            };
        }
        protected function reConn(_arg1:Event):void{
            rePublish = true;
        }

    }
}//package com.zlchat.ui 
