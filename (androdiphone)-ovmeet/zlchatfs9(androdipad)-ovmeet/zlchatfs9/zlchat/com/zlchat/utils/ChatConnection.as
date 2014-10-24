//hong QQ:1410919373
package com.zlchat.utils {
    import com.zlchat.ui.*;
    import flash.events.*;
    import fl.data.*;
    import flash.net.*;
    import com.zlchat.events.*;
    import flash.utils.*;
    import flash.media.*;
    import flash.system.*;
    import flash.external.*;

    public class ChatConnection extends NetConnection {

        public var speakListSo:SharedObject;
        public var userID:String;
        private var viewNS:NetStream;
        private var bandWidthTimer:Timer;
        public var pwd:String;
        public var userListSo:SharedObject;
        public var mediaServer:String;
        public var realName:String;
        public var mic:Microphone;
        public var roomID:String;
        public var roomInfoSo:SharedObject;
        private var tipTimer:Timer;
        public var role:String;
        private var tryStr:String = null;
        private var reConnTimer:Timer;
        public var hasConnected:Boolean = false;
        public var myDomain:String;
        private var isKick:Boolean = false;
        private var up:Number = 0;
        private var reCount:int = 0;
        private var down:Number = 0;
        public var scriptType:String;
        public var user:Object;
        public var cam:Camera;
        public var hasCam:Boolean = false;
        private var upLatency:Number;
        private var serverClient:ServerClientBandwidth;
        public var pptSo:SharedObject;
        public var userName:String;
        private var downLatency:Number;

		public var ncvideo:NetConnection = null;
		public var groupSpecifier:GroupSpecifier;
		public var netGroup:NetGroup = null; 

        public function ChatConnection(){
            addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
            addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
            addEventListener(AsyncErrorEvent.ASYNC_ERROR, onNetError);
            addEventListener(IOErrorEvent.IO_ERROR, onNetError);
            mic = Microphone.getMicrophone();
            if (mic != null){
                mic.gain = 60;
            };
            cam = Camera.getCamera();
            if (cam != null){
                hasCam = true;
            };
            reConnTimer = new Timer(2000);
            reConnTimer.addEventListener(TimerEvent.TIMER, reConnHandler);
            this.objectEncoding = ObjectEncoding.AMF0;
            bandWidthTimer = new Timer(20000);
            bandWidthTimer.addEventListener(TimerEvent.TIMER, bandWidthHandler);
            tipTimer = new Timer(60000);
            tipTimer.addEventListener(TimerEvent.TIMER, tipHandler);
 
			ncvideo = new NetConnection();
			ncvideo.client = this;
			ncvideo.addEventListener(NetStatusEvent.NET_STATUS, VnetStatusHandler);

        }
        public static function getChineseTime(){
            var _local1:String;
            var _local2:Date = new Date();
            _local1 = ((((((((((_local2.getFullYear() + "-") + (_local2.getMonth() + 1)) + "-") + _local2.getDate()) + " ") + _local2.getHours()) + ":") + _local2.getMinutes()) + ":") + _local2.getSeconds());
            return (_local1);
        }

        public function inviteChat(_arg1:String, _arg2:String, _arg3:String):void{
            var _local4:Object;
            if (userID == _arg1){
                _local4 = new Object();
                dispatchEvent(new PrivateEvent(PrivateEvent.INVITE, {
                    userID:_arg3,
                    realName:_arg2
                }, null));
            };
        }
        public function ClientServer():void{
            var _local1:ClientServerBandwidth = new ClientServerBandwidth();
            _local1.connection = this;
            _local1.service = "bwCheckService.onClientBWCheck";
            _local1.addEventListener(BandwidthDetectEvent.DETECT_COMPLETE, onClientServerComplete);
            _local1.addEventListener(BandwidthDetectEvent.DETECT_STATUS, onClientServerStatus);
            _local1.addEventListener(BandwidthDetectEvent.DETECT_FAILED, onDetectFailed);
            _local1.start();
        }
        public function updateRoomInfo(_arg1:Number, _arg2:Boolean, _arg3:String):void{
            var _local4:Object = {
                maxRoomUser:_arg1,
                hasBuy:_arg2,
                companyName:_arg3
            };
            dispatchEvent(new RoomInfoEvent("updateLicenseInfo", _local4));
        }
        public function ServerClient():void{
            serverClient = new ServerClientBandwidth();
            try {
                serverClient.connection = this;
                serverClient.service = "bwCheckService.onServerClientBWCheck";
                serverClient.addEventListener(BandwidthDetectEvent.DETECT_COMPLETE, onServerClientComplete);
                serverClient.addEventListener(BandwidthDetectEvent.DETECT_STATUS, onServerClientStatus);
                serverClient.addEventListener(BandwidthDetectEvent.DETECT_FAILED, onDetectFailed);
                serverClient.start();
            } catch(e:Error) {
            };
        }
        public function onBWDone(_arg1:Object):void{
            var obj:* = _arg1;
            try {
                if (obj != null){
                    if (serverClient != null){
                        serverClient.dispatchComplete(obj);
                    };
                };
            } catch(e:Error) {
            };
        }
        public function onSetRole(_arg1:String):void{
            if (_arg1 != null){
                this.role = _arg1;
                dispatchEvent(new ConnEvent("setRole"));
            };
        }
        public function rejectVideo(_arg1:String, _arg2:String):void{
            if (userID == _arg1){
                dispatchEvent(new PrivateEvent("rejectVideo", {userID:_arg2}, null));
            };
        }
        public function cancelVideo(_arg1:String, _arg2:String):void{
            if (userID == _arg1){
                dispatchEvent(new PrivateEvent("cancelVideo", {userID:_arg2}, null));
            };
        }
        protected function onRoomInfo(_arg1:SyncEvent):void{
            var _local2:*;
            var _local3:*;
            var _local4:Object;
            for (_local2 in _arg1.changeList) {
                _local3 = _arg1.changeList[_local2];
                switch (_local3.code){
                    case "change":
                        switch (_local3.name){
                            case "txtRoomInfo":
                                dispatchEvent(new RoomInfoEvent(RoomInfoEvent.TXTROOMINFO, roomInfoSo.data["txtRoomInfo"]));
                                break;
                            case "uiIndex":
                                if (roomInfoSo.data["uiIndex"] != null){
                                    dispatchEvent(new RoomInfoEvent("syncUI", roomInfoSo.data["uiIndex"]));
                                };
                                break;
                            case "v_mode":
                                if (cam != null){
                                    _local4 = roomInfoSo.data["v_mode"];
                                    cam.setMode(_local4.w, _local4.h, _local4.f,false);
	
                                };
                                dispatchEvent(new RoomInfoEvent("v_mode", roomInfoSo.data["v_mode"]));
                                break;
                            case "v_q":
                                if (cam != null){
                                    cam.setQuality(0, roomInfoSo.data["v_q"]);

                                    dispatchEvent(new RoomInfoEvent("v_q", roomInfoSo.data["v_q"]));
                                };
                                break;
                            case "a_rate":
                                if (mic != null){
                                    mic.rate = roomInfoSo.data["a_rate"];
					//				mic.rate = 8;
                                    mic.setUseEchoSuppression(true);
                                };
                                dispatchEvent(new RoomInfoEvent("a_rate", roomInfoSo.data["a_rate"]));
                                break;
                            case "a_s":
                                if (mic != null){
                                    mic.setSilenceLevel(roomInfoSo.data["a_s"]);

                                    dispatchEvent(new RoomInfoEvent("a_s", roomInfoSo.data["a_s"]));
                                };
                                break;
                            case "g_ds":
                                dispatchEvent(new RoomInfoEvent("g_ds", roomInfoSo.data["g_ds"]));
                                break;
                            case "g_dp":
                                dispatchEvent(new RoomInfoEvent("g_dp", roomInfoSo.data["g_dp"]));
                                break;
                            case "g_dt":
                                dispatchEvent(new RoomInfoEvent("g_dt", roomInfoSo.data["g_dt"]));
                                break;
                            case "a_dv":
                                dispatchEvent(new RoomInfoEvent("a_dv", roomInfoSo.data["a_dv"]));
                                break;
                            case "a_da":
                                dispatchEvent(new RoomInfoEvent("a_da", roomInfoSo.data["a_da"]));
                                break;
                            case "sync_ui":
                                dispatchEvent(new RoomInfoEvent("sync_ui", roomInfoSo.data["sync_ui"]));
                                break;
                            case "applyVideo":
                                dispatchEvent(new RoomInfoEvent("apply_sp", roomInfoSo.data["applyVideo"]));
                                break;
                            case "lock":
                                dispatchEvent(new RoomInfoEvent("lock", roomInfoSo.data["lock"]));
                                break;
                            case "maxVideoSeat":
                                dispatchEvent(new RoomInfoEvent("maxVideoSeat", roomInfoSo.data["maxVideoSeat"]));
                                break;
                        };
                        break;
                    case "delete":
                        break;
                };
            };
        }
        public function acceptUpload(_arg1:String, _arg2:String):void{
            if (userID == _arg1){
                dispatchEvent(new PrivateEvent("acceptUpload", {userID:_arg2}, null));
            };
        }
        protected function tipHandler(_arg1:Event):void{
            if (this.connected){
                AlertManager.showMessageBox(tryStr);
            };
        }
        public function setUserID(_arg1:String):void{
            if (_arg1 != null){
                this.userID = _arg1;
            };
        }

        private function initSharedObject():void{
            userListSo = SharedObject.getRemote("userList", this.uri, false);
            userListSo.addEventListener(SyncEvent.SYNC, onUserListSync);
            userListSo.addEventListener(AsyncErrorEvent.ASYNC_ERROR, securityErrorHandler);
            userListSo.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
            userListSo.connect(this);
            speakListSo = SharedObject.getRemote("speakList", this.uri, false);
            speakListSo.addEventListener(SyncEvent.SYNC, onSpeakListSync);
            speakListSo.addEventListener(AsyncErrorEvent.ASYNC_ERROR, securityErrorHandler);
            speakListSo.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
            speakListSo.connect(this);
            speakListSo.client = this;
            roomInfoSo = SharedObject.getRemote("roomInfo", this.uri, false);
            roomInfoSo.addEventListener(AsyncErrorEvent.ASYNC_ERROR, securityErrorHandler);
            roomInfoSo.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
            roomInfoSo.addEventListener(SyncEvent.SYNC, onRoomInfo);
            roomInfoSo.connect(this);
            roomInfoSo.client = this;
            pptSo = SharedObject.getRemote("ppt", this.uri, false);
            pptSo.addEventListener(AsyncErrorEvent.ASYNC_ERROR, securityErrorHandler);
            pptSo.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
            pptSo.addEventListener(SyncEvent.SYNC, onPPTSync);
            pptSo.connect(this);
            pptSo.client = this;

			dispatchEvent(new ConnEvent(ConnEvent.USERID));
			
  
        }

        private function VnetStatusHandler(evt:NetStatusEvent) : void
        {

			trace("ccccc1"+evt.info.code);
			switch(evt.info.code) 
			{
				case "NetGroup.Connect.Success": 

					break;
				case "NetConnection.Connect.Failed":
				case "NetConnection.Connect.Rejected": 
					ncvideo.close();
					ExternalInterface.call("alert", "视频服务器连接出错!", null);
					break;
				case "NetConnection.Connect.Success":
					initSharedObject();

					break;

				default:
			}		

	}
	private function ncvideoConnect():void{
	

		ncvideo.connect("rtmp://119.161.219.252:1966/live");
	}

        public function onDetectFailed(_arg1:BandwidthDetectEvent):void{
        }
        protected function reConnHandler(_arg1:Event):void{
            if (!hasConnected){
                connect((("rtmp://"+mediaServer + ":1936/vimeet/") + roomID), userName, role, hasCam, myDomain, realName);
            } else {
                reConnTimer.stop();
            };
        }
        protected function onPPTSync(_arg1:SyncEvent):void{
            var _local2:*;
            var _local3:*;
            for (_local2 in _arg1.changeList) {
                _local3 = _arg1.changeList[_local2];
                switch (_local3.code){
                    case "change":
                        dispatchEvent(new RoomInfoEvent("changePPT", pptSo.data["ppt"]));
                        break;
                };
            };
        }
        public function acceptVideo(_arg1:String, _arg2:String):void{
            if (userID == _arg1){
                dispatchEvent(new PrivateEvent("acceptVideo", {userID:_arg2}, null));
            };
        }
        private function netStatusHandler(_arg1:NetStatusEvent):void{
            switch (_arg1.info.code){
                case "NetConnection.Connect.Success":
                    AlertManager.hideAll();
                    if (expireDate(2018, 5)){
                        AlertManager.showMessageBox("发现新版本，请到www.cecall.cc更新!");
                    };
                    if (tryStr != null){
                        tipTimer.start();
                    };
                    Security.showSettings(SecurityPanel.PRIVACY);
					//BT服务器连接
		    ncvideoConnect();
		    //ncvideo.connect("rtmfp://m.cecall.cc:1966/"); 
                    //initSharedObject();
                    hasConnected = true;
                    reConnTimer.stop();
                    ServerClient();
                    bandWidthTimer.start();
                    break;
                case "NetConnection.Connect.Closed":
                    if (((hasConnected) && (!(isKick)))){
                        this.close();
                        hasConnected = false;
                        reConnTimer.start();
                        dispatchEvent(new ConnEvent("reConnect"));
                    };
                    break;
                case "NetConnection.Connect.Failed":
                    hasConnected = false;
                    break;
                case "NetConnection.Connect.Rejected":
                    ExternalInterface.call("alert", "房间被锁定", null);
                    break;
                case "NetConnection.Connect.AppShutdown":
                    break;
                case "NetConnection.Connect.InvalidApp":
                    break;
            };
        }
        public function sendMessage(_arg1:String, _arg2:String, _arg3:String):void{
            if (userID == _arg2){
                dispatchEvent(new PrivateEvent("SendMessage", {userID:_arg3}, _arg1));
            };
        }
        public function noSeat(_arg1:Boolean):void{
            if (_arg1){
                AlertManager.showMessageBox("视频位置已经占满了，请稍后再试");
            };
        }
        public function inviteUpload(_arg1:String, _arg2:String, _arg3:String, _arg4:String):void{
            if (userID == _arg1){
                dispatchEvent(new PrivateEvent("inviteUpload", {userID:_arg4}, {
                    fileName:_arg2,
                    realFileName:_arg3
                }));
            };
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
        public function syncUI(_arg1:int):void{
            dispatchEvent(new RoomInfoEvent("syncUI", _arg1));
        }
        public function closeChat(_arg1:String, _arg2:String):void{
            if (userID == _arg1){
                dispatchEvent(new PrivateEvent("CloseChat", {userID:_arg2}, null));
            };
        }
        public function delSpeaker(_arg1:Object):void{
            dispatchEvent(new VideoEvent1(VideoEvent1.DEL, _arg1));
        }
        public function onNetError(_arg1:Event):void{
        }
        public function showTryWin(_arg1:String){
            if (_arg1 != null){
                tryStr = _arg1;
            };
        }
        public function acceptChat(_arg1:String, _arg2:String):void{
            if (userID == _arg1){
                dispatchEvent(new PrivateEvent("acceptChat", {userID:_arg2}, null));
            };
        }
        private function securityErrorHandler(_arg1:Event):void{
            trace(("securityErrorHandler: " + _arg1));
        }
        public function rejectUpload(_arg1:String, _arg2:String):void{
            if (userID == _arg1){
                dispatchEvent(new PrivateEvent("rejectUpload", {userID:_arg2}, null));
            };
        }
        public function stopViewCam(_arg1:String){
            if (viewNS != null){
                viewNS.attachCamera(null);
            };
        }
        protected function bandWidthHandler(_arg1:Event):void{
            if (this.connected){
                ServerClient();
            };
        }
        public function stopVideo(_arg1:Boolean){
            if (_arg1){
                dispatchEvent(new VideoEvent1(VideoEvent1.STOP, null));
            };
        }
        public function completeUpload(_arg1:String, _arg2:String):void{
            if (userID == _arg1){
                dispatchEvent(new PrivateEvent("completeUpload", {userID:_arg2}, null));
            };
        }
        public function rejectChat(_arg1:String, _arg2:String):void{
            if (userID == _arg1){
                dispatchEvent(new PrivateEvent("rejectChat", {userID:_arg2}, null));
            };
        }
        public function publishVideo(_arg1:Boolean){
            if (_arg1){
                dispatchEvent(new VideoEvent1(VideoEvent1.START, null));
            };
        }
        public function getFileList():void{
            dispatchEvent(new ConnEvent(ConnEvent.FILELIST));
        }
        protected function onSpeakListSync(_arg1:SyncEvent):void{
            var _local2:*;
            var _local3:DataProvider;
            var _local4:Object;
            var _local5:*;
            var _local6:Object; 
            for (_local2 in _arg1.changeList) { 
                _local5 = _arg1.changeList[_local2]; 
                switch (_local5.code){
                    case "change":
                        _local6 = speakListSo.data[_local5.name];
                        if (_local6.videoSeat > 0){
                            dispatchEvent(new VideoEvent1(VideoEvent1.ADD, _local6));
                        };
                        break;
                    case "delete":
                        break;
                };
            };
 
        }
        public function onClientServerStatus(_arg1:BandwidthDetectEvent):void{
        }
        public function completeVideo(_arg1:String, _arg2:String):void{
            if (userID == _arg1){
                dispatchEvent(new PrivateEvent("completeVideo", {userID:_arg2}, null));
            };
        }
        protected function onUserListSync(_arg1:SyncEvent):void{
            var _local4:Object;
            var _local2:DataProvider = new DataProvider();
            var _local3:DataProvider = new DataProvider(); 
            for each (_local4 in userListSo.data) { 
				if (_local4.userID == this.userID){ 
                    this.user = _local4;
                    _local2.addItem({ 
                        data:_local4
                    });
                } else { 
                    _local2.addItem({
                        label:_local4.realName,
                        data:_local4
                    });
                }; 
            };
 
        }
        public function onKick(_arg1:Boolean):void{
            if (_arg1){
                isKick = true;
                ExternalInterface.call("alert", "你已经被踢出房间!", null);
            };
        }
        public function onClientServerComplete(_arg1:BandwidthDetectEvent):void{
            up = (up + _arg1.info.kbitUp);
            up = Math.floor((up / 2));
            upLatency = _arg1.info.latency;
            var _local2:Number = (upLatency + downLatency);
            if (up > 150){
                up = (up - 100);
            };
            var _local3:Object = {
                up:up,
                down:down,
                latency:_local2
            };
            dispatchEvent(new RoomInfoEvent("updateBandWidth", _local3));
        }
        public function onServerClientStatus(_arg1:BandwidthDetectEvent):void{
        }
        public function getVodList():void{
            dispatchEvent(new ConnEvent("getVodList"));
        }
        public function onServerClientComplete(_arg1:BandwidthDetectEvent):void{
            var event:* = _arg1;
            down = (down + event.info.kbitDown);
            down = Math.floor((down / 2));
            downLatency = event.info.latency;
            try {
                ClientServer();
            } catch(e:Error) {
            };
        }
        public function viewCam(_arg1:String):void{
            if (userID == _arg1){
                if (viewNS != null){
                    viewNS.attachCamera(this.cam);
                } else {

			viewNS = new NetStream(this.ncvideo, this.groupSpecifier.groupspecWithAuthorizations());

			var vh264Settings:H264VideoStreamSettings = new H264VideoStreamSettings();
			vh264Settings.setProfileLevel(H264Profile.BASELINE,H264Level.LEVEL_5_1); 
			
			viewNS.videoStreamSettings = vh264Settings;
                    viewNS.attachCamera(this.cam);
                    viewNS.publish(("zlchat_view" + userID));
                };
            };
        }
        public function inviteVideo(_arg1:String, _arg2:String):void{
            if (userID == _arg1){
                dispatchEvent(new PrivateEvent("inviteVideo", {userID:_arg2}, null));
            };
        }
        public function closeRoom(_arg1:String){
            if (this.userID != _arg1){
                ExternalInterface.call("alert", "房间已经关闭,谢谢你的使用!", null);
                isKick = true;
                this.close();
            };
        }
        public function onBWCheck(_arg1:Object):void{
            if (_arg1 != null){
                if (serverClient != null){
                    serverClient.dispatchStatus(_arg1);
                };
            };
        }

    }
}//package com.zlchat.utils 
