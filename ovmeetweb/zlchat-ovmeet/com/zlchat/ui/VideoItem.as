//hong QQ:1410919373
package com.zlchat.ui {
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import com.zlchat.events.*;
    import com.zlchat.utils.*;
    import flash.text.*;
    import flash.media.*;
    import flash.ui.*;

    public class VideoItem extends Sprite {

        private var txtNoVideo:TextField;
        public var isAudio:Boolean = true;
        public var index:Number = 0;
        public var isFull:Boolean = false;
        private var manHead:MovieClip;
        public var isRecord:Boolean = false;
        public var _stream:NetStream;
        protected var bufBar:MovieClip;
        public var isVideo:Boolean = true;
        protected var nc:ChatConnection;
        public var _user:Object;
        public var video:Video;

        public function VideoItem(){
            manHead = new ManHead();
            addChild(manHead);
            txtNoVideo = new TextField();
            txtNoVideo.text = "没有视频";
            addChild(txtNoVideo);
            var _local1:TextFormat = new TextFormat();
            _local1.color = 0xCC0000;
            txtNoVideo.setTextFormat(_local1);
            txtNoVideo.width = 80;
            txtNoVideo.y = 30;
            txtNoVideo.x = 20;
            video = new Video();
            video.smoothing = true;
            addChild(video);
            video.x = 0;
            video.y = 0;
            bufBar = new LoadingCircle();
            addChild(bufBar);
            bufBar.width = 36;
            bufBar.height = 36;
            bufBar.x = 50;
            bufBar.y = 50;
            var _local2:ContextMenu = new ContextMenu();
            _local2.hideBuiltInItems();
            this.contextMenu = _local2;
        }
        public function stopAudio(_arg1:Boolean):void{
            _stream.receiveAudio(_arg1);
        }
        protected function changeVideoDV(_arg1:VideoEvent1):void{
            if (_user.userID == nc.userID){
                if (nc.cam.name != "VHScrCap"){
                    video.attachCamera(nc.cam);
                    video.visible = true;
                    txtNoVideo.text = "没有视频";
                } else {
                    video.visible = false;
                    video.attachCamera(null);
                    txtNoVideo.text = "正在共享桌面";
                };
            };
        }
        public function set speaker(_arg1:Object):void{
            _user = _arg1;
            if (_user.userID != nc.userID){
		_stream = new NetStream(nc);

 
		_stream.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
                video.attachNetStream(_stream);
                _stream.play(_user.userID);
                video.visible = true;
                bufBar.visible = true;
            } else {
                if (!nc.roomInfoSo.data["a_dv"]){
                    if (((!((nc.cam == null))) && ((nc.cam.name == "VHScrCap")))){
                        video.visible = false;
                        video.attachCamera(null);
                        txtNoVideo.text = "正在共享桌面";
                    } else {
                        video.attachCamera(nc.cam);
                        video.visible = true;
                        txtNoVideo.text = "没有视频";
                    };
                };
                bufBar.visible = false;
            };
        }
        protected function netStatusHandler(_arg1:NetStatusEvent):void{
			trace("eeeeee1:"+_arg1.info.code);
            switch (_arg1.info.code){
                case "NetStream.Play.Start": 
                case "NetStream.Buffer.Full":
                case "NetStream.Publish.Start":
                    bufBar.visible = false;
                    break;
                case "NetStream.MulticastStream.Reset":
                    bufBar.visible = false;
                    break;
            };
        }
        public function set conn(_arg1:ChatConnection){
            nc = _arg1; 
        }
        public function stopVideo(_arg1:Boolean):void{
            _stream.receiveVideo(_arg1);
        }
        protected function drawBg(_arg1:Number, _arg2:Number){
            graphics.clear();
            graphics.beginFill(0);
            graphics.drawRect(0, 0, _arg1, _arg2);
            graphics.endFill();
        }
        public function Resize(_arg1:Number, _arg2:Number):void{
            drawBg(_arg1, _arg2);
            manHead.width = _arg1;
            manHead.height = _arg2;
            video.width = _arg1;
            video.height = _arg2; 
        }
        public function clearStream():void{
            if (_user.userID != nc.userID){
                _stream.close();
                video.attachNetStream(null);
                video.visible = false;
            } else {
                video.attachCamera(null);
                video.visible = false;
            };
        }
        protected function changeAudioDV(_arg1:VideoEvent1):void{
        }
        public function get speaker():Object{
            return (_user);
        }

    }
}//package com.zlchat.ui 
