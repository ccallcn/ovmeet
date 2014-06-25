//hong QQ:1410919373
package com.zlchat.ui {
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import com.zlchat.utils.*;
    import flash.text.*;
    import flash.utils.*;
    import flash.media.*;
    import flash.external.*;

    public class RecordWin extends ResizeWin {

        private var btnSave:SimpleButton;
        private var txtStatus:TextField;
        private var inStream:NetStream;
        private var curFileName:String = "";
        private var saveEnabled:Boolean = false;
        private var saveVideoWin:SaveVideoWin;
        private var videoTimer:Timer;
        private var txtNoVideo:TextField;
        private var btnPlay:SimpleButton;
        private var saveTimer:Timer;
        private var btnRecord:MovieClip;
        private var outVideo:Video;
        private var inVideo:Video;
        private var manHead:MovieClip;
        private var txtTime:TextField;
        private var rTime:int = 0;
        private var pTime:int = 0;
        private var outStream:NetStream;
        private var playTimer:Timer;
        private var rTotal = 1800;
        private var btnStop:SimpleButton;

        public function RecordWin(_arg1:Number, _arg2:Number){
            super(_arg1, _arg2);
            manHead = new ManHead();
            addChild(manHead);
            manHead.width = (_arg1 - 3);
            manHead.height = 180;
            manHead.x = super.LEFT;
            manHead.y = super.TOP;
            txtNoVideo = new TextField();
            txtNoVideo.text = "没有视频数据";
            addChild(txtNoVideo);
            var _local3:TextFormat = new TextFormat();
            _local3.color = 0xCC0000;
            txtNoVideo.setTextFormat(_local3);
            txtNoVideo.width = 80;
            txtNoVideo.x = 70;
            txtNoVideo.y = 90;
            outVideo = new Video();
            outVideo.width = (_arg1 - 3);
            outVideo.height = 180;
            inVideo = new Video();
            inVideo.width = (_arg1 - 3);
            inVideo.height = 180;
            addChild(outVideo);
            addChild(inVideo);
            outVideo.x = super.LEFT;
            outVideo.y = super.TOP;
            inVideo.x = super.LEFT;
            inVideo.y = super.TOP;
            btnStop = new flatbluestop();
            addChild(btnStop);
            btnStop.x = ((super.LEFT + 2) + 12.5);
            btnStop.addEventListener(MouseEvent.CLICK, stopRecord);
            btnStop.visible = false;
            btnPlay = new flatblueplay();
            addChild(btnPlay);
            btnPlay.x = (((super.LEFT + 2) + 12.5) + 27);
            btnPlay.visible = false;
            btnPlay.addEventListener(MouseEvent.CLICK, playStream);
            btnRecord = new BtnRecord();
            addChild(btnRecord);
            btnRecord.x = (super.LEFT + 2);
            btnRecord.addEventListener(MouseEvent.CLICK, startRecord);
            BtnMin.visible = false;
            BtnMax.visible = false;
            BtnRestore.visible = false;
            btnSave = new BtnSave();
            addChild(btnSave);
            btnSave.visible = false;
            btnSave.addEventListener(MouseEvent.CLICK, saveVideo);
            txtStatus = new TextField();
            txtStatus.text = "状态:停止";
            addChild(txtStatus);
            txtStatus.width = 60;
            txtTime = new TextField();
            addChild(txtTime);
            txtTime.text = "00:00/30:00";
            txtTime.width = 80;
            saveVideoWin = new SaveVideoWin();
            saveTimer = new Timer(5000);
            saveTimer.addEventListener("timer", saveTimerHandler);
            videoTimer = new Timer(1000);
            videoTimer.addEventListener("timer", videoTimerHandler);
            playTimer = new Timer(1000);
            playTimer.addEventListener("timer", playTimerHandler);
            Resize(_arg1, _arg2);
        }
        protected function saveVideo(_arg1:MouseEvent):void{
            saveTimer.stop();
            videoTimer.stop();
            playTimer.stop();
            rTime = 0;
            pTime = 0;
            this.visible = false;
            stopRecord2();
            saveVideoWin.curFileName = curFileName;
            saveVideoWin.txtVideoName.text = curFileName;
            AlertManager.showWin(saveVideoWin, ((stage.stageWidth / 2) - 100), 200);
        }
        protected function playTimerHandler(_arg1:Event):void{
            if (inStream != null){
                if (inStream.time <= rTime){
                    txtTime.text = ((formatTime(inStream.time) + "/") + formatTime(rTime));
                } else {
                    playTimer.stop();
                    txtTime.text = ((formatTime(rTime) + "/") + formatTime(rTime));
                };
            };
        }
        private function getFileName(_arg1:String):String{
            var _local2:String;
            var _local3:Date = new Date();
            _local2 = ((((("_" + _local3.getFullYear()) + _local3.getDate()) + _local3.getHours()) + _local3.getMinutes()) + _local3.getSeconds());
            return ((_arg1 + _local2));
        }
        protected function stopRecord2():void{
            btnStop.visible = false;
            btnRecord.visible = true;
            outVideo.attachCamera(null);
            inVideo.attachNetStream(null);
            txtStatus.text = "状态:停止";
            outVideo.clear();
            inVideo.clear();
            if (outStream != null){
                outStream.close();
            };
            if (inStream != null){
                inStream.close();
            };
        }
        protected function startRecord(_arg1:MouseEvent):void{
            btnRecord.visible = false;
            btnPlay.visible = false;
            txtStatus.text = "状态:录制";
            btnSave.visible = false;
            saveTimer.start();
            rTime = 0;
            videoTimer.start();
            outStream = new NetStream(nc);
            if (outStream != null){
                if (inStream != null){
                    playTimer.stop();
                    pTime = 0;
                    inVideo.attachNetStream(null);
                    inStream.close();
                };
                outStream.attachCamera(nc.cam);
                outStream.attachAudio(nc.mic);
                outVideo.attachCamera(nc.cam);
                addChild(outVideo);
                curFileName = getFileName(nc.realName);
                outStream.publish(curFileName, "record");
            };
        }
        override public function set conn(_arg1:ChatConnection){
            nc = _arg1;
            saveVideoWin.conn = nc;
        }
        override public function Resize(_arg1:Number, _arg2:Number):void{
            super.Resize(_arg1, _arg2);
            btnRecord.y = ((_arg2 - btnRecord.height) - super.LEFT);
            btnStop.y = (((_arg2 - btnStop.height) - super.LEFT) + 12.5);
            btnPlay.y = (((_arg2 - btnPlay.height) - super.LEFT) + 12.5);
            btnSave.x = ((_arg1 - btnSave.width) - 7);
            btnSave.y = ((_arg2 - btnSave.height) - 7);
            txtStatus.x = ((btnPlay.x + btnPlay.width) + 2);
            txtTime.x = ((txtStatus.x + txtStatus.width) - 5);
            txtTime.y = (txtStatus.y = (btnPlay.y - 10));
            drawBg(_arg1, _arg2);
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
        protected function videoTimerHandler(_arg1:Event):void{
            if (rTime <= rTotal){
                txtTime.text = (formatTime(rTime) + "/30:00");
                rTime++;
            } else {
                ExternalInterface.call("alert", "录制时间已满!", null);
                btnSave.visible = true;
                btnPlay.visible = true;
                stopRecord2();
                videoTimer.stop();
            };
        }
        protected function saveTimerHandler(_arg1:Event):void{
            saveEnabled = true;
            btnStop.visible = true;
            saveTimer.stop();
        }
        protected function stopRecord(_arg1:MouseEvent):void{
            btnSave.visible = saveEnabled;
            btnPlay.visible = true;
            videoTimer.stop();
            playTimer.stop();
            saveEnabled = false;
            stopRecord2();
        }
        protected function playStream(_arg1:MouseEvent):void{
            if (curFileName != ""){
                txtStatus.text = "状态:播放";
                rTime = (rTime - 2);
                playTimer.start();
                addChild(inVideo);
                inStream = new NetStream(nc);
                inStream.client = this;
                inVideo.attachNetStream(inStream);

		inStream.bufferTime = 0.5;
                inStream.play(curFileName);
            };
        }
        override protected function onWinClose(_arg1:MouseEvent):void{
            this.visible = false;
            saveTimer.stop();
            videoTimer.stop();
            playTimer.stop();
            rTime = 0;
            pTime = 0;
            stopRecord2();
            if (curFileName != ""){
                nc.call("vodService.delVod", null, (curFileName + ".flv"));
            };
        }

    }
}//package com.zlchat.ui 
