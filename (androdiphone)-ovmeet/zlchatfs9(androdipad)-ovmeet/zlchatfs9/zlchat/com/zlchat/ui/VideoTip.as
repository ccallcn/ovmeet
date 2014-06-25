//hong QQ:1410919373
package com.zlchat.ui {
    import fl.controls.*;
    import flash.display.*;
    import flash.events.*;
    import com.zlchat.events.*;
    import com.zlchat.mainapp.*;
    import flash.text.*;
    import flash.media.*;

    public class VideoTip extends Sprite {

        private var micOn:SimpleButton;
        private var txtTip:TextField;
        private var txtUserName:TextField;
        private var camOn:SimpleButton;
        private var camOff:SimpleButton;
        private var micOff:SimpleButton;
        private var _videoItem:VideoItem;
        private var speakOff:SimpleButton;
        private var btn1x:SimpleButton;
        private var btnRecord:SimpleButton;
        private var speakOn:SimpleButton;
        private var btnFullScreen:SimpleButton;
        private var btnRecordStop:SimpleButton;
        private var btnClose:SimpleButton;
        private var btnStop:SimpleButton;

        public function VideoTip(){
            graphics.lineStyle(2, 2578295);
            graphics.beginFill(2578295, 0.8);
	    /**
            graphics.lineTo(200, 0);
            graphics.lineTo(200, 50);
            graphics.lineTo(50, 50);
            graphics.lineTo(20, 70);
            graphics.lineTo(30, 50);
            graphics.lineTo(0, 50);
            graphics.lineTo(0, 0);
            **/
	    	        graphics.drawRoundRect(0,0,200,50,10,10); 

			graphics.moveTo(90,0); 
			graphics.lineTo(110,0); 
			graphics.lineTo(100,-10); 
			graphics.lineTo(90,0);
	    graphics.endFill();
            btnClose = new TipClose();
            addChild(btnClose);
            btnClose.x = 182;
            btnClose.y = 2;
            btnClose.addEventListener(MouseEvent.CLICK, closeTip);
            txtUserName = new TextField();
            addChild(txtUserName);
            txtUserName.text = "zjb";
            var _local1:TextFormat = new TextFormat();
            _local1.color = 0xFFFFFF;
            txtUserName.setTextFormat(_local1);
            txtUserName.y = 2;
            txtUserName.x = 10;
            camOff = new CamOff();
            camOff.x = 2;
            camOff.y = 20;
            addChild(camOff);
            camOn = new CamOn();
            camOn.x = 2;
            camOn.y = 20;
            addChild(camOn);

            speakOff = new SpeakOff();
            speakOff.x = 30;
            speakOff.y = 20;
            addChild(speakOff);
            micOff = new MicOff();
            micOff.x = 30;
            micOff.y = 20;
            addChild(micOff);
            speakOn = new SpeakOn();
            speakOn.x = 30;
            speakOn.y = 20;
            addChild(speakOn);
            micOn = new MicOn();
            micOn.x = 30;
            micOn.y = 20;
            addChild(micOn);
            camOn.addEventListener(MouseEvent.CLICK, closeVideo);
            camOff.addEventListener(MouseEvent.CLICK, openVideo);
            speakOff.addEventListener(MouseEvent.CLICK, openAudio);
            speakOn.addEventListener(MouseEvent.CLICK, closeAudio);
            micOff.addEventListener(MouseEvent.CLICK, openAudio);
            micOn.addEventListener(MouseEvent.CLICK, closeAudio);


            btnFullScreen = new BtnFullScreen();
            addChild(btnFullScreen);
            btnFullScreen.y = 21;
            btnFullScreen.x = 59;
            btnFullScreen.addEventListener(MouseEvent.CLICK, onFullScr);
            btn1x = new Btn1X();
            addChild(btn1x);
            btn1x.y = 21;
            btn1x.x = 59;
            btn1x.addEventListener(MouseEvent.CLICK, onCloseFull);
            btn1x.visible = false;

            btnFullScreen.width = 26;
            btnFullScreen.height = 26;
	    btn1x.width = 26;
            btn1x.height = 26;

            btnRecord = new BtnRecord2();
            addChild(btnRecord);
            btnRecord.width = 26;
            btnRecord.height = 26;
            btnRecord.y = 20;
            btnRecord.x = 87;
            btnRecord.addEventListener(MouseEvent.CLICK, startRecord);
            btnRecordStop = new BtnRecordStop();
            addChild(btnRecordStop);
            btnRecordStop.width = 26;
            btnRecordStop.height = 26;
            btnRecordStop.y = 20;
            btnRecordStop.x = 87;
            btnRecordStop.addEventListener(MouseEvent.CLICK, stopRecord);
            btnRecordStop.visible = false;

            btnStop = new TipStop();
            addChild(btnStop);
            btnStop.width = 28;
            btnStop.height = 28;
            btnStop.y = 33;
            btnStop.x = 130;
            btnStop.visible = false;
            btnStop.addEventListener(MouseEvent.CLICK, delSpeaker);
            txtTip = new TextField();
            txtTip.autoSize = TextFieldAutoSize.LEFT;
            txtTip.textColor = 0xFF0000;
            addChild(txtTip);
            txtTip.visible = false;
            btnStop.addEventListener(MouseEvent.MOUSE_OVER, stopOnOver);
            btnStop.addEventListener(MouseEvent.MOUSE_OUT, OnOut);
            btnRecord.addEventListener(MouseEvent.MOUSE_OVER, recordOnOver);
            btnRecord.addEventListener(MouseEvent.MOUSE_OUT, OnOut);
            btnRecordStop.addEventListener(MouseEvent.MOUSE_OVER, recordStopOnOver);
            btnRecordStop.addEventListener(MouseEvent.MOUSE_OUT, OnOut);
            btn1x.addEventListener(MouseEvent.MOUSE_OVER, btn1xOnOver);
            btn1x.addEventListener(MouseEvent.MOUSE_OUT, OnOut);
            btnFullScreen.addEventListener(MouseEvent.MOUSE_OVER, fullOnOver);
            btnFullScreen.addEventListener(MouseEvent.MOUSE_OUT, OnOut);
            camOn.addEventListener(MouseEvent.MOUSE_OVER, camOnOver);
            camOn.addEventListener(MouseEvent.MOUSE_OUT, OnOut);
            camOff.addEventListener(MouseEvent.MOUSE_OVER, camOffOver);
            camOff.addEventListener(MouseEvent.MOUSE_OUT, OnOut);
            micOn.addEventListener(MouseEvent.MOUSE_OVER, micOnOver);
            micOn.addEventListener(MouseEvent.MOUSE_OUT, OnOut);
            micOff.addEventListener(MouseEvent.MOUSE_OVER, micOffOnOver);
            micOff.addEventListener(MouseEvent.MOUSE_OUT, OnOut);
            speakOn.addEventListener(MouseEvent.MOUSE_OVER, speakOnOver);
            speakOn.addEventListener(MouseEvent.MOUSE_OUT, OnOut);
            speakOff.addEventListener(MouseEvent.MOUSE_OVER, speakOffOnOver);
            speakOff.addEventListener(MouseEvent.MOUSE_OUT, OnOut);
        }
        private function camOnOver(_arg1:MouseEvent):void{
            showTip("关闭视频");
        }
        private function recordOnOver(_arg1:MouseEvent):void{
            showTip("录制");
        }
        protected function onCloseFull(_arg1:Event):void{
            btn1x.visible = false;
            btnFullScreen.visible = true;
            _videoItem.isFull = false;
            VideoListWin.videoListPane.largeShow = 0;
            VideoListWin.videoListPane.Resize2();
        }
        protected function closeTip(_arg1:MouseEvent):void{
            this.visible = false;
        }
        private function camOffOver(_arg1:MouseEvent):void{
            showTip("打开视频");
        }
        private function micOffOnOver(_arg1:MouseEvent):void{
            showTip("打开音频");
        }
        private function getFileName():String{
            var _local1:String;
            var _local2:Date = new Date();
            _local1 = (("_" + _local2.getFullYear()) + _local2.getDate());
            return (_local1);
        }
        private function recordStopOnOver(_arg1:MouseEvent):void{
            showTip("停止录制");
        }
        protected function openAudio(_arg1:MouseEvent):void{
            if (_videoItem._user.userID != MainApp.conn.userID){
                _videoItem.stopAudio(true);
                speakOn.visible = true;
                speakOff.visible = false;
            } else {
                MainApp.conn.dispatchEvent(new VideoEvent1(VideoEvent1.STOPA, true));
                micOn.visible = true;
                micOff.visible = false;
            };
            _videoItem.isAudio = true;
        }
        protected function onFullScr(_arg1:Event):void{
            VideoListWin.videoListPane.largeShow = _videoItem.index;
            VideoListWin.videoListPane.Resize2();
            VideoListWin.videoListPane.addChild(_videoItem);
            _videoItem.Resize(VideoListWin.videoListPane._w, VideoListWin.videoListPane._h);
            _videoItem.x = VideoListWin.videoListPane.x1;
            _videoItem.y = VideoListWin.videoListPane.y1;
            _videoItem.isFull = true;
            btn1x.visible = true;
            btnFullScreen.visible = false;
        }
        public function get videoItem():VideoItem{
            return (this._videoItem);
        }
        protected function closeAudio(_arg1:MouseEvent):void{
            if (_videoItem._user.userID != MainApp.conn.userID){
                _videoItem.stopAudio(false);
                speakOn.visible = false;
                speakOff.visible = true;
            } else {
                MainApp.conn.dispatchEvent(new VideoEvent1(VideoEvent1.STOPA, false));
                micOn.visible = false;
                micOff.visible = true;
            };
            _videoItem.isAudio = false;
        }
        private function fullOnOver(_arg1:MouseEvent):void{
            showTip("全屏");
        }
        private function speakOnOver(_arg1:MouseEvent):void{
            showTip("关闭话筒");
        }
        private function OnOut(_arg1:MouseEvent):void{
            txtTip.visible = false;
        }
        protected function startRecord(_arg1:MouseEvent):void{
            MainApp.conn.call("startRecord", null, _videoItem._user.userID, ((_videoItem._user.realName + getFileName()) + _videoItem._user.userID));
            btnRecord.visible = false;
            btnRecordStop.visible = true;
            _videoItem.isRecord = true;
        }
        protected function openVideo(_arg1:MouseEvent):void{
            if (_videoItem._user.userID != MainApp.conn.userID){
                _videoItem.stopVideo(true);
            } else {
                MainApp.conn.dispatchEvent(new VideoEvent1(VideoEvent1.STOPV, true));
                _videoItem.video.attachCamera(Camera.getCamera());
            };
            camOff.visible = false;
            camOn.visible = true;
            _videoItem.isVideo = true;
        }
        public function set videoItem(_arg1:VideoItem):void{
            _videoItem = _arg1;
            camOn.visible = _arg1.isVideo;
            camOff.visible = !(_arg1.isVideo);
            btnFullScreen.visible = !(_arg1.isFull);
            btn1x.visible = _arg1.isFull;
            btnRecord.visible = !(_arg1.isRecord);
            btnRecordStop.visible = _arg1.isRecord;
            txtUserName.text = _arg1._user.realName;
            if (MainApp.conn.role == "2"){
                btnStop.visible = true;
            } else {
                btnStop.visible = false;
                btnRecord.visible = false;
                btnRecordStop.visible = false;
            };
            if (_arg1._user.userID != MainApp.conn.userID){
                speakOn.visible = _arg1.isAudio;
                speakOff.visible = !(_arg1.isAudio);
                micOn.visible = false;
                micOff.visible = false;
            } else {
                speakOn.visible = false;
                speakOff.visible = false;
                micOn.visible = _arg1.isAudio;
                micOff.visible = !(_arg1.isAudio);
            };
        }
        protected function closeVideo(_arg1:MouseEvent):void{
            if (_videoItem._user.userID != MainApp.conn.userID){
                _videoItem.stopVideo(false);
            } else {
                MainApp.conn.dispatchEvent(new VideoEvent1(VideoEvent1.STOPV, false));
                _videoItem.video.attachCamera(null);
            };
            camOff.visible = true;
            camOn.visible = false;
            _videoItem.isVideo = false;
        }
        private function showTip(_arg1:String):void{
            txtTip.x = (mouseX + 15);
            txtTip.y = (mouseY - 20);
            txtTip.text = _arg1;
            addChild(txtTip);
            txtTip.visible = true;
        }
        private function speakOffOnOver(_arg1:MouseEvent):void{
            showTip("打开话筒");
        }
        protected function stopRecord(_arg1:MouseEvent):void{
            MainApp.conn.call("stopRecord", null, _videoItem._user.userID);
            btnRecord.visible = true;
            btnRecordStop.visible = false;
            _videoItem.isRecord = false;
        }
        public function delSpeaker(_arg1:MouseEvent):void{
            MainApp.conn.call("closeSpeaker", null, _videoItem._user.userID);
            this.visible = false;
        }
        private function stopOnOver(_arg1:MouseEvent):void{
            showTip("关闭发言");
        }
        private function btn1xOnOver(_arg1:MouseEvent):void{
            showTip("原始大小");
        }
        private function micOnOver(_arg1:MouseEvent):void{
            showTip("关闭音频");
        }

    }
}//package com.zlchat.ui 
