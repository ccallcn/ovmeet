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

    public class VideoItem2 extends Sprite {

        private var txtNoVideo:TextField;
        public var isAudio:Boolean = true;
        public var isFull:Boolean = false;
        private var manHead:MovieClip;
        public var _stream:NetStream;
        protected var bufBar:MovieClip;
        public var isVideo:Boolean = true;
        protected var nc:ChatConnection;
        public var _user:Object = null;
        public var video:Video;
        public var isRecord:Boolean = false;

        public function VideoItem2(){
            manHead = new ManHead();
            addChild(manHead);
            txtNoVideo = new TextField();
            txtNoVideo.text = "";
            addChild(txtNoVideo);
            var _local1:TextFormat = new TextFormat();
            _local1.color = 0xCC0000;
            txtNoVideo.setTextFormat(_local1);
            txtNoVideo.width = 80;
            txtNoVideo.y = 10;
            txtNoVideo.x = 10;
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
            bufBar.visible = false;
            var _local2:ContextMenu = new ContextMenu();
            _local2.hideBuiltInItems();
            this.contextMenu = _local2;
        }
        protected function netStatusHandler(_arg1:NetStatusEvent):void{
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
        public function set speaker(_arg1:Object):void{
            var _local2:TextFormat;
            if (_arg1 != null){
                _user = _arg1;
                nc.speakListSo.send("viewCam", _arg1.userID);
                //_stream = new NetStream(nc);
		_stream = new NetStream(nc.ncvideo, nc.groupSpecifier.groupspecWithAuthorizations());
                _stream.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
                video.attachNetStream(_stream);

		_stream.bufferTime = 0.5;
                _stream.play(("zlchat_view" + _user.userID));
                video.visible = true;
                bufBar.visible = true;
                txtNoVideo.text = _arg1.realName;
                addChild(txtNoVideo);
                _local2 = new TextFormat();
                _local2.color = 0xCC0000;
                _local2.size = 14;
                _local2.bold = true;
                txtNoVideo.setTextFormat(_local2);
            };
        }
        public function Resize(_arg1:Number, _arg2:Number):void{
            drawBg(_arg1, _arg2);
            manHead.width = _arg1;
            manHead.height = _arg2;
            video.width = _arg1;
            video.height = _arg2;
            bufBar.x = ((_arg1 - bufBar.width) / 2);
            bufBar.y = ((_arg2 - bufBar.height) / 2);
        }
        public function set conn(_arg1:ChatConnection){
            nc = _arg1;
        }
        public function stopVideo():void{
            if (((!((_user == null))) && (!((nc == null))))){
                txtNoVideo.text = "";
                _stream.close();
                video.visible = false;
                nc.speakListSo.send("stopViewCam", _user.userID);
            };
        }
        protected function drawBg(_arg1:Number, _arg2:Number){
            graphics.clear();
            graphics.beginFill(0);
            graphics.drawRect(0, 0, _arg1, _arg2);
            graphics.endFill();
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
        public function get speaker():Object{
            return (_user);
        }

    }
}//package com.zlchat.ui 
