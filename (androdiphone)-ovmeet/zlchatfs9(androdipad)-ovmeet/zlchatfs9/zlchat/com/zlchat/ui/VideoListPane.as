//hong QQ:1410919373
package com.zlchat.ui {
    import flash.display.*;
    import flash.geom.*;
    import flash.events.*;
    import flash.utils.*;

    public class VideoListPane extends Sprite {

        private const scanVideo2:Number = 0.75;
        private const scanVideo:Number = 1.3333;

        public var displayMode:Number = 0;
        public var videoMask:Sprite;
        public var scMode:Number = 0;
        public var btnUp:MovieClip;
        private var w1:Number = 320;
        public var btnDown:MovieClip;
        public var videoList:Array;
        private var video2Bg:MovieClip;
        private var videoMode:int = 2;
        public var x1:Number = 0;
        private var bg:MovieClip;
        private var h1:Number = 240;
        private var downTimer:Timer;
        public var videoMC:Sprite;
        public var y1:Number = 0;
        public var largeShow:Number = 0;
        public var _h:Number = 240;
        private var upTimer:Timer;
        public var _w:Number = 320;

        public function VideoListPane(_arg1:Number, _arg2:Number){
            videoList = new Array();
            super();
            bg = new VideoBg();
            addChild(bg);
            bg.x = 0;
            bg.y = 0;
            video2Bg = new VideoBg4();
            addChild(video2Bg);
            video2Bg.visible = false;
            video2Bg.x = 0;
            video2Bg.y = 0;
            videoMC = new Sprite();
            addChild(videoMC);
            videoMask = new Sprite();
            addChild(videoMask);
            videoMC.mask = videoMask;
            btnUp = new BtnUp2();
            btnDown = new BtnDown2();
            btnUp.width = (btnDown.width = 25);
            btnUp.height = (btnDown.height = 25);
            btnUp.addEventListener(MouseEvent.MOUSE_OVER, onVideoUpOver);
            btnUp.addEventListener(MouseEvent.MOUSE_OUT, onVideoUpOut);
            btnDown.addEventListener(MouseEvent.MOUSE_OVER, onVideoDownOver);
            btnDown.addEventListener(MouseEvent.MOUSE_OUT, onVideoDownOut);
            upTimer = new Timer(200);
            upTimer.addEventListener(TimerEvent.TIMER, onUp);
            downTimer = new Timer(200);
            downTimer.addEventListener(TimerEvent.TIMER, onDown);
            videoList = new Array();
            layoutVideo();
            Resize(_arg1, _arg2);
        }
        private function onVideoUpOver(_arg1:MouseEvent):void{
            upTimer.start();
        }
        public function delAll():void{
            var i:* = null;
            for (i in videoList) {
                try {
                    removeChild(videoList[i]);
                } catch(e:Error) {
                };
                try {
                    videoMC.removeChild(videoList[i]);
                } catch(e:Error) {
                };
                videoList.splice(i, 1);
            };
            videoList = new Array();
            layoutVideo();
        }
        private function onVideoDownOver(_arg1:MouseEvent):void{
            downTimer.start();
        }
        private function onDown(_arg1:TimerEvent):void{
            videoMC.y = (videoMC.y + 10);
        }
        protected function drawBg(_arg1:Number, _arg2:Number){
            graphics.clear();
            graphics.beginFill(0x666666);
            graphics.drawRect(0, 0, _arg1, _arg2);
            graphics.endFill();
        }
        private function onVideoUpOut(_arg1:MouseEvent):void{
            upTimer.stop();
        }
        protected function showVideoTip(_arg1:MouseEvent):void{
            TipManager.showVideoTip(localToGlobal(new Point(mouseX, mouseY)), (_arg1.currentTarget as VideoItem));
        }
        public function delVideo(_arg1:Object):void{
            var i:* = null;
            var s:* = _arg1;
            for (i in videoList) {
                if (videoList[i]._user.userID == s.userID){
                    try {
                        removeChild(videoList[i]);
                    } catch(e:Error) {
                    };
                    try {
                        videoMC.removeChild(videoList[i]);
                    } catch(e:Error) {
                    };
                    videoList.splice(i, 1);
                    break;
                };
            };
            layoutVideo();
        }
        private function onVideoDownOut(_arg1:MouseEvent):void{
            downTimer.stop();
        }
        private function onUp(_arg1:TimerEvent):void{
            videoMC.y = (videoMC.y - 10);
        }
        public function Resize(_arg1:Number, _arg2:Number):void{
            var _local4:int;
            var _local5:int;
            w1 = _arg1;
            h1 = _arg2;
            bg.width = _arg1;
            bg.height = _arg2;
            videoMC.x = 0;
            videoMC.y = 0;
            btnUp.y = 2;
            btnDown.y = (_arg2 - 27);
            videoMask.graphics.clear();
            videoMask.graphics.beginFill(0);
            videoMask.graphics.drawRect(0, 0, 120, _arg2);
            videoMask.graphics.endFill();
            if (scMode == 0){
                if ((_arg1 * 0.75) > _arg2){
                    _h = _arg2;
                    _w = ((_h * 4) / 3);
                } else {
                    _w = _arg1;
                    _h = (_w * 0.75);
                };
                x1 = ((_arg1 - _w) / 2);
                y1 = ((_arg2 - _h) / 2);
            } else {
                _w = _arg1;
                _h = _arg2;
                x1 = 0;
                y1 = 0;
            };
            var _local3:int = videoList.length;
            if (_local3 > 0){
                video2Bg.x = x1;
                video2Bg.y = y1;
                video2Bg.width = _w;
                video2Bg.height = _h;
                if (videoMode > 1){
                    video2Bg.visible = true;
                };
            } else {
                return;
            };
            if (displayMode == 0){
                btnUp.visible = false;
                btnDown.visible = false;
                _local4 = 0;
                while (_local4 < _local3) {
                    addChild(videoList[_local4]);
                    videoList[_local4].index = _local4;
                    videoList[_local4].Resize((_w / videoMode), (_h / videoMode));
                    videoList[_local4].x = (x1 + ((_local4 % videoMode) * (_w / videoMode)));
                    videoList[_local4].y = (y1 + (Math.floor((_local4 / videoMode)) * (_h / videoMode)));
                    _local4++;
                };
            } else {
                addChild(videoList[largeShow]);
                addChild(videoMC);
                _local5 = 0;
                while (_local5 < _local3) {
                    videoList[_local5].index = _local5;
                    if (_local5 == largeShow){
                        videoList[_local5].Resize(_w, _h);
                        videoList[_local5].x = x1;
                        videoList[_local5].y = y1;
                    } else {
                        videoMC.addChild(videoList[_local5]);
                        videoList[_local5].Resize(120, 90);
                        videoList[_local5].x = 0;
                        if (_local5 < largeShow){
                            videoList[_local5].y = (_local5 * 90);
                        } else {
                            videoList[_local5].y = ((_local5 - 1) * 90);
                        };
                    };
                    _local5++;
                };
                btnUp.visible = true;
                btnDown.visible = true;
                addChild(btnUp);
                addChild(btnDown);
            };
            drawBg(_arg1, _arg2);
        }
        public function Resize2():void{
            Resize(w1, h1);
        }
        public function addVideo(_arg1:VideoItem):void{
            videoList.push(_arg1);
        }
        public function layoutVideo():void{
            var _local1:Object;
            for (_local1 in videoList) {
				//视频图像工具菜单
                //videoList[_local1].addEventListener(MouseEvent.CLICK, showVideoTip);
            };
            videoMode = Math.ceil(Math.sqrt(videoList.length));
            switch (videoMode){
                case 1:
                    video2Bg.visible = false;
                    break;
                case 2:
                    removeChild(video2Bg);
                    video2Bg = new VideoBg4();
                    addChild(video2Bg);
                    video2Bg.visible = true;
                    break;
                case 3:
                    removeChild(video2Bg);
                    video2Bg = new VideoBg9();
                    addChild(video2Bg);
                    video2Bg.visible = true;
                    break;
                case 4:
                    removeChild(video2Bg);
                    video2Bg = new VideoBg16();
                    addChild(video2Bg);
                    video2Bg.visible = true;
                    break;
                default:
                    video2Bg.visible = false;
            };
            Resize(_w, _h);
        }

    }
}//package com.zlchat.ui 
