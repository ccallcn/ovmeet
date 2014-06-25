//hong QQ:1410919373
package com.zlchat.ui {
    import fl.controls.*;
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import com.zlchat.events.*;
    import flash.text.*;
    import flash.utils.*;
    import flash.media.*;
    import flash.errors.*;

    public class PlayerWin extends ResizeWin {

        private var prgMC:Sprite;
        private var inStream:NetStream;
        private var hasStop:Boolean = false;
        private var metaData:MetaDataHandler;
        private var video:Video;
        private var percentPlay:Number = 0;
        private var totalMC:Sprite;
        private var txtTime:TextField;
        private var manHead:MovieClip;
        private var txtNoVideo:TextField;
        private var streamName:String;
        private var btnPlay:SimpleButton;
        private var playTimer:Timer;
        private var btnPause:SimpleButton;
        private var btnStop:SimpleButton;

        public function PlayerWin(_arg1:Number, _arg2:Number){
            super(_arg1, _arg2);
            manHead = new ManHead();
            addChild(manHead);
            manHead.width = (_arg1 - 3);
            manHead.height = 240;
            manHead.x = super.LEFT;
            manHead.y = super.TOP;
            txtNoVideo = new TextField();
            txtNoVideo.text = "没有视频数据";
            addChild(txtNoVideo);
            var _local3:TextFormat = new TextFormat();
            _local3.color = 0xCC0000;
            txtNoVideo.setTextFormat(_local3);
            txtNoVideo.width = 80;
            txtNoVideo.x = 100;
            txtNoVideo.y = 120;
            video = new Video();
            addChild(video);
            video.x = super.LEFT;
            video.y = super.TOP;
            video.width = (_arg1 - 3);
            video.height = 240;
            video.smoothing = true;
            BtnMin.visible = false;
            BtnMax.visible = false;
            BtnRestore.visible = false;
            BtnResize.visible = true;
            addChild(BtnResize);
            btnPlay = new flatblueplay();
            btnPause = new flatbluepause();
            btnStop = new flatbluestop();
            addChild(btnPause);
            addChild(btnPlay);
            addChild(btnStop);
            btnPlay.x = (btnPause.x = 20);
            btnStop.x = 50;
            btnPlay.addEventListener(MouseEvent.CLICK, onBtnPlay);
            btnPause.addEventListener(MouseEvent.CLICK, onBtnPause);
            btnStop.addEventListener(MouseEvent.CLICK, onBtnStop);
            btnStop.enabled = false;
            txtTime = new TextField();
            addChild(txtTime);
            txtTime.text = "00:00/00:00";
            txtTime.width = 80;
            txtTime.x = 65;
            playTimer = new Timer(1000);
            playTimer.addEventListener("timer", playTimerHandler);
            totalMC = new Sprite();
            addChild(totalMC);
            prgMC = new Sprite();
            addChild(prgMC);
            prgMC.addEventListener(MouseEvent.CLICK, onSeek);
            totalMC.addEventListener(MouseEvent.CLICK, onSeek);
            metaData = new MetaDataHandler();
            Resize(_arg1, _arg2);
        }
        public function playVod(_arg1:String):void{
            if (inStream != null){
                inStream.close();
            };
            streamName = _arg1;
            btnPlay.visible = false;
            inStream = new NetStream(nc);
            inStream.client = metaData;
            inStream.addEventListener(NetStatusEvent.NET_STATUS, statusHandler);
            metaData.onMetaData(null);
            metaData.onPlayStatus(null);
            video.attachNetStream(inStream);
            inStream.play(_arg1);
            playTimer.start();
        }
        protected function onBtnPlay(_arg1:Event):void{
            btnPlay.visible = false;
            if (((!((inStream == null))) && (!(hasStop)))){
                inStream.resume();
            } else {
                playVod(streamName);
            };
        }
        override public function Resize(_arg1:Number, _arg2:Number):void{
            super.Resize(_arg1, _arg2);
            video.width = (_arg1 - 3);
            video.height = (_arg2 - 65);
            manHead.width = video.width;
            manHead.height = video.height;
            btnPlay.y = (btnPause.y = (btnStop.y = (_arg2 - 15)));
            txtTime.y = (_arg2 - 25);
            prgMC.y = (totalMC.y = (_arg2 - 35));
            prgMC.x = (totalMC.x = 2);
            totalMC.graphics.clear();
            totalMC.graphics.beginFill(0x333333);
            totalMC.graphics.drawRect(0, 0, (_arg1 - 4), 6);
            totalMC.graphics.endFill();
            prgMC.graphics.clear();
            prgMC.graphics.beginFill(3381759);
            prgMC.graphics.drawRect(0, 1, (totalMC.width * percentPlay), 5);
            prgMC.graphics.endFill();
            drawBg(_arg1, _arg2);
        }
        protected function onBtnStop(_arg1:Event):void{
            btnPlay.visible = true;
            if (inStream != null){
                hasStop = true;
                inStream.close();
            };
        }
        protected function formatTime(_arg1:int):String{
            var _local3:int;
            var _local4:int;
            var _local2 = "";
            _local4 = Math.floor((_arg1 / 60));
            _local3 = (_arg1 - (_local4 * 60));
            if (_local4 < 10){
                _local2 = (("0" + _local4) + ":");
            } else {
                _local2 = (_local4 + ":");
            };
            if (_local3 < 10){
                _local2 = ((_local2 + "0") + _local3);
            } else {
                _local2 = (_local2 + _local3);
            };
            return (_local2);
        }
        protected function playTimerHandler(_arg1:Event):void{
            var e:* = _arg1;
            if (inStream != null){
                try {
                    txtTime.text = ((formatTime(inStream.time) + "/") + formatTime(metaData.duration));
                    percentPlay = (inStream.time / metaData.duration);
                    if (percentPlay > 1){
                        percentPlay = 1;
                    };
                } catch(error:EOFError) {
                };
                prgMC.graphics.clear();
                prgMC.graphics.beginFill(3381759);
                prgMC.graphics.drawRect(0, 1, (totalMC.width * percentPlay), 5);
                prgMC.graphics.endFill();
            };
        }
        override protected function onWinClose(_arg1:MouseEvent):void{
            if (inStream != null){
                inStream.close();
            };
            playTimer.stop();
            this.visible = false;
        }
        private function onSeek(_arg1:MouseEvent):void{
            if (inStream != null){
                inStream.seek(Math.floor(((mouseX / totalMC.width) * metaData.duration)));
            };
        }
        protected function onBtnPause(_arg1:Event):void{
            btnPlay.visible = true;
            if (inStream != null){
                inStream.pause();
            };
        }
        private function statusHandler(_arg1:NetStatusEvent):void{
            switch (_arg1.info.code){
                case "NetStream.Play.Start":
                    btnStop.enabled = true;
                    hasStop = false;
                    break;
                case "NetStream.Play.Stop":
                    btnStop.enabled = false;
                    hasStop = true;
                    break;
            };
        }

    }
}//package com.zlchat.ui 
