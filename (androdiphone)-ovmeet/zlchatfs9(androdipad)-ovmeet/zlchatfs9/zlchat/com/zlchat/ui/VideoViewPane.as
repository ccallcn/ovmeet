//hong QQ:1410919373
package com.zlchat.ui {
    import fl.controls.*;
    import flash.display.*;
    import flash.events.*;
    import fl.data.*;
    import flash.net.*;
    import com.zlchat.events.*;
    import com.zlchat.utils.*;
    import fl.events.*;
    import flash.text.*;

    public class VideoViewPane extends BasePane {

        public var txtStatus:TextField;
        private var pageIndex:Number = 1;
        private var userList:DataProvider;
        private var NumPerPage:Number = 4;
        private var w1:Number = 320;
        private var cmbVideo:ComboBox;
        private var btnPre:SimpleButton;
        private var btnStartJK:SimpleButton;
        public var x1:Number = 0;
        private var videoMode:int = 2;
        private var btnStopJK:SimpleButton;
        private var videoList:Array;
        private var h1:Number = 240;
        private var toolBar:Sprite;
        public var y1:Number = 0;
        private var hasStart:Boolean = false;
        public var _h:Number = 240;
        private var btnNext:SimpleButton;
        private var totalPage:Number = 1;
        private var btnSelect:SimpleButton;
        public var _w:Number = 320;

        public function VideoViewPane(){
            var _local3:*;
            videoList = new Array();
            super();
            toolBar = new Sprite();
            addChild(toolBar);
            btnPre = new BtnPreCam();
            toolBar.addChild(btnPre);
            btnPre.y = 8;
            btnPre.x = 4;
            btnNext = new BtnNextCam();
            toolBar.addChild(btnNext);
            btnNext.y = 8;
            btnNext.x = 85;
            btnStartJK = new BtnStartJK();
            toolBar.addChild(btnStartJK);
            btnStartJK.y = 8;
            btnStartJK.x = 165;
            btnStopJK = new BtnStopJK();
            toolBar.addChild(btnStopJK);
            btnStopJK.y = 8;
            btnStopJK.x = 245;
            btnStartJK.addEventListener(MouseEvent.CLICK, startJK);
            btnStopJK.addEventListener(MouseEvent.CLICK, stopJK);
            btnPre.addEventListener(MouseEvent.CLICK, onPre);
            btnNext.addEventListener(MouseEvent.CLICK, onNext);
            btnStopJK.enabled = false;
            txtStatus = new TextField();
            toolBar.addChild(txtStatus);
            txtStatus.width = 60;
            txtStatus.x = 325;
            txtStatus.y = 8;
            var _local1:TextField = new TextField();
            _local1.text = "每页显示视频数:";
            toolBar.addChild(_local1);
            cmbVideo = new ComboBox();
            cmbVideo.addItem({
                label:4,
                data:4
            });
            cmbVideo.addItem({
                label:1,
                data:1
            });
            cmbVideo.addItem({
                label:9,
                data:9
            });
            cmbVideo.addItem({
                label:16,
                data:16
            });
            toolBar.addChild(cmbVideo);
            _local1.x = 365;
            _local1.width = 130;
            _local1.height = 30;
            cmbVideo.width = 50;
            cmbVideo.x = 460;
            cmbVideo.y = 8;
            _local1.y = 8;
            cmbVideo.addEventListener(Event.CHANGE, changeVideo);
            var _local2:* = 0;
            _local2 = 0;
            while (_local2 < 16) {
                _local3 = new VideoItem2();
                videoList.push(_local3);
                _local2++;
            };
        }
        private function onNext(_arg1:MouseEvent):void{
            pageIndex++;
            if (pageIndex > totalPage){
                pageIndex = totalPage;
            } else {
                startViewCam();
            };
        }
        private function onjkSync(_arg1:ConnListEvent):void{
            userList = _arg1.userListDP.clone();
            totalPage = Math.ceil((userList.length / NumPerPage));
            txtStatus.text = ((pageIndex + "/") + totalPage);
        }
        private function startViewCam():void{
            var _local3:int;
            var _local4:*;
            var _local1:int = userList.length;
            var _local2:int = ((pageIndex - 1) * NumPerPage);
            _local3 = 0;
            while (_local3 < NumPerPage) {
                videoList[_local3].stopVideo();
                _local3++;
            };
            _local3 = 0;
            while ((((_local3 < NumPerPage)) && ((_local2 < _local1)))) {
                _local4 = videoList[_local3];
                _local4.visible = true;
                _local4.conn = nc;
                _local4.speaker = userList.getItemAt(_local2).data;
                _local3++;
                _local2++;
            };
            txtStatus.text = ((pageIndex + "/") + totalPage);
        }
        private function startJK(_arg1:MouseEvent):void{
            btnStopJK.enabled = true;
            btnStartJK.enabled = false;
            startViewCam();
            hasStart = true;
        }
        protected function changeVideo(_arg1:Event):void{
            var _local2:* = ComboBox(_arg1.target).selectedItem.data;
            NumPerPage = _local2;
            videoMode = Math.sqrt(NumPerPage);
            totalPage = Math.ceil((userList.length / NumPerPage));
            pageIndex = 1;
            txtStatus.text = ((pageIndex + "/") + totalPage);
            var _local3:* = 0;
            _local3 = 0;
            while (_local3 < NumPerPage) {
                if (videoList[_local3] != null){
                    addChild(videoList[_local3]);
                    videoList[_local3].Resize((_w / videoMode), (_h / videoMode));
                    videoList[_local3].x = (x1 + ((_local3 % videoMode) * videoList[_local3].width));
                    videoList[_local3].y = (y1 + (Math.floor((_local3 / videoMode)) * (_h / videoMode)));
                };
                _local3++;
            };
            if (hasStart){
                startViewCam();
            };
        }
        public function stopAllJK():void{
            btnStopJK.enabled = false;
            btnStartJK.enabled = true;
            pageIndex = 1;
            txtStatus.text = ((pageIndex + "/") + totalPage);
            var _local1:* = 0;
            _local1 = 0;
            while (_local1 < NumPerPage) {
                videoList[_local1].stopVideo();
                videoList[_local1].visible = true;
                _local1++;
            };
            hasStart = false;
        }
        private function stopJK(_arg1:MouseEvent):void{
            stopAllJK();
        }
        private function onPre(_arg1:MouseEvent):void{
            pageIndex--;
            if (pageIndex < 1){
                pageIndex = 1;
            } else {
                startViewCam();
            };
        }
        override public function Resize(_arg1:Number, _arg2:Number):void{
            super.Resize(_arg1, _arg2);
            toolBar.graphics.clear();
            toolBar.graphics.lineStyle(2, 2578295);
            toolBar.graphics.beginFill(15268088, 0.8);
            toolBar.graphics.drawRect(2, 2, (_arg1 - 10), 35);
            toolBar.graphics.endFill();
            w1 = _arg1;
            h1 = _arg2;
            if ((_arg1 * 0.75) > (_arg2 - 40)){
                _h = (_arg2 - 40);
                _w = ((_h * 4) / 3);
            } else {
                _w = _arg1;
                _h = (_w * 0.75);
            };
            x1 = (((_arg1 - _w) / 2) + 2);
            y1 = (((_arg2 - _h) / 2) + 20);
            var _local3:* = 0;
            _local3 = 0;
            while (_local3 < NumPerPage) {
                addChild(videoList[_local3]);
                videoList[_local3].Resize((_w / videoMode), (_h / videoMode));
                videoList[_local3].x = (x1 + ((_local3 % videoMode) * videoList[_local3].width));
                videoList[_local3].y = (y1 + (Math.floor((_local3 / videoMode)) * (_h / videoMode)));
                _local3++;
            };
        }
        override public function set conn(_arg1:ChatConnection){
            nc = _arg1;
            nc.addEventListener("jksync", onjkSync);
        }

    }
}//package com.zlchat.ui 
