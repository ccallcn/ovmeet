//hong QQ:1410919373
package com.zlchat.ui {
    import fl.controls.*;
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import com.zlchat.events.*;
    import com.zlchat.utils.*;
    import com.zlchat.mainapp.*;
    import flash.text.*;
    import flash.media.*;

    public class VideoListWin extends ResizeWin {

        public static var videoListPane:VideoListPane;

        private var txtTip:TextField;
        public var _rootMC:MainApp;
        public var toolBar:Sprite;
        public var btnShiYing:SimpleButton;
        public var btnFullScreen:SimpleButton;
        public var btnDisplay1:SimpleButton;
        public var btnDisplay2:SimpleButton;
        public var btnYuanShi:SimpleButton;
        public var btnFullQuit:SimpleButton;

        public function VideoListWin(_arg1:Number, _arg2:Number){
            super(_arg1, _arg2);
            //videoListPane = new VideoListPane(((_arg1 - 10) + 1), (_arg2 - 30));
	    videoListPane = new VideoListPane(((_arg1 - 10) + 2), (_arg2 - 30));
            addChild(videoListPane);
            videoListPane.x = 1;
            videoListPane.y = 27;
            BtnResize.visible = true;
            BtnClose.visible = false;
            BtnMax.visible = true;
            BtnRestore.visible = true;
            addChild(BtnResize);
            btnFullScreen = new BtnFullScreen2_2();
            btnFullScreen.width = 24;
            btnFullScreen.height = 24;
            btnFullQuit = new BtnCloseFull2_2();
            btnFullQuit.width = 24;
            btnFullQuit.height = 24;
            btnYuanShi = new BtnYuanShi();
            btnYuanShi.width = 24;
            btnYuanShi.height = 24;
            btnShiYing = new BtnShiYing();
            btnShiYing.width = 24;
            btnShiYing.height = 24;
            btnDisplay1 = new BtnDisplay1();
            btnDisplay1.width = 20;
            btnDisplay1.height = 20;
            btnDisplay2 = new BtnDisplay2();
            btnDisplay2.width = 24;
            btnDisplay2.height = 24;
            toolBar = new Sprite();
            addChild(toolBar);
            toolBar.x = 0;
            toolBar.y = 27;
			//toolBar.y = 127;
            //toolBar.addChild(btnFullQuit);
            toolBar.addChild(btnYuanShi);
            toolBar.addChild(btnShiYing);
            //toolBar.addChild(btnFullScreen);
            toolBar.addChild(btnDisplay1);
            toolBar.addChild(btnDisplay2);
            btnFullScreen.y = (btnFullQuit.y = (btnYuanShi.y = (btnShiYing.y = (btnDisplay1.y = (btnDisplay2.y = 5)))));
            btnFullScreen.addEventListener(MouseEvent.CLICK, onFullScr);
            btnFullQuit.addEventListener(MouseEvent.CLICK, onFullQuit);
            btnShiYing.addEventListener(MouseEvent.CLICK, onShiYing);
            btnYuanShi.addEventListener(MouseEvent.CLICK, onYuanShi);
            btnDisplay1.addEventListener(MouseEvent.CLICK, onDisplay1);
            btnDisplay2.addEventListener(MouseEvent.CLICK, onDisplay2);
            toolBar.alpha = 60;
            toolBar.addEventListener(MouseEvent.MOUSE_OVER, onToolBarOver);
            toolBar.addEventListener(MouseEvent.MOUSE_OUT, onToolBarOut);
            btnFullScreen.addEventListener(MouseEvent.MOUSE_OVER, FullScreenOnOver);
            btnFullScreen.addEventListener(MouseEvent.MOUSE_OUT, OnOut);
            btnFullQuit.addEventListener(MouseEvent.MOUSE_OVER, FullQuitOnOver);
            btnFullQuit.addEventListener(MouseEvent.MOUSE_OUT, OnOut);
            btnYuanShi.addEventListener(MouseEvent.MOUSE_OVER, YuanShiOnOver);
            btnYuanShi.addEventListener(MouseEvent.MOUSE_OUT, OnOut);
            btnShiYing.addEventListener(MouseEvent.MOUSE_OVER, ShiYingOnOver);
            btnShiYing.addEventListener(MouseEvent.MOUSE_OUT, OnOut);
            btnDisplay1.addEventListener(MouseEvent.MOUSE_OVER, DisplayOnOver);
            btnDisplay1.addEventListener(MouseEvent.MOUSE_OUT, OnOut);
            btnDisplay2.addEventListener(MouseEvent.MOUSE_OVER, DisplayOnOver);
            btnDisplay2.addEventListener(MouseEvent.MOUSE_OUT, OnOut);
            txtTip = new TextField();
            txtTip.autoSize = TextFieldAutoSize.LEFT;
            txtTip.textColor = 0xFF0000;
            addChild(txtTip);
            txtTip.visible = false;
        }
        protected function addStream(_arg1:VideoEvent1):void{
            var _local2:VideoItem;
            var _local3:Boolean;
            var _local4:int = videoListPane.videoList.length;
            var _local5:int;
            while (_local5 < _local4) {
                if (videoListPane.videoList[_local5].speaker.userID == _arg1.speaker.userID){
                    _local3 = true;
                    videoListPane.videoList[_local5].isRecord = _arg1.speaker.isRecord;
                    break;
                };
                _local5++;
            };
            if (!_local3){
                _local2 = new VideoItem();
                _local2.conn = nc;
                _local2.speaker = _arg1.speaker;
                videoListPane.addVideo(_local2);
                videoListPane.layoutVideo();
            };
        }
        protected function delStream(_arg1:VideoEvent1):void{
            videoListPane.delVideo(_arg1.speaker);
        }
        private function onFullQuit(_arg1:MouseEvent):void{
            stage.displayState = "normal";
            this.x = 0;
            this.y = 33;
            Resize(322, 268);
            btnFullScreen.visible = true;
            btnFullQuit.visible = false;
        }
        private function onShiYing(_arg1:MouseEvent):void{
            if (videoListPane != null){
                videoListPane.scMode = 1;
                videoListPane.Resize2();
            };
            btnShiYing.visible = false;
            btnYuanShi.visible = true;
        }
        private function onDisplay1(_arg1:MouseEvent):void{
            if (videoListPane != null){
                videoListPane.displayMode = 0;
                videoListPane.Resize2();
            };
            btnDisplay1.visible = false;
            btnDisplay2.visible = true;
        }
        private function onDisplay2(_arg1:MouseEvent):void{
            if (videoListPane != null){
                videoListPane.displayMode = 1;
                videoListPane.Resize2();
            };
            btnDisplay1.visible = true;
            btnDisplay2.visible = false;
        }
        override protected function onWinClose(_arg1:MouseEvent):void{
            this.visible = false;
        }
        private function onYuanShi(_arg1:MouseEvent):void{
            if (videoListPane != null){
                videoListPane.scMode = 0;
                videoListPane.Resize2();
            };
            btnShiYing.visible = true;
            btnYuanShi.visible = false;
        }
        private function OnOut(_arg1:MouseEvent):void{
            txtTip.visible = false;
        }
        private function FullQuitOnOver(_arg1:MouseEvent):void{
            showTip("退出全屏");
        }
        override public function Resize(_arg1:Number, _arg2:Number):void{
            super.Resize(_arg1, _arg2);
            btnFullScreen.x = (btnFullQuit.x = ((_arg1 / 2) + 25));
            btnYuanShi.x = (btnShiYing.x = (_arg1 / 2));
            btnDisplay1.x = (btnDisplay2.x = ((_arg1 / 2) - 25));
            //toolBar.y = 227;
            toolBar.y =_arg2 - 32;//底部上面32像素划工具栏
	    toolBar.graphics.clear();
            toolBar.graphics.lineStyle(2, 2578295);
            //toolBar.graphics.beginFill(15268088, 0.8);
	    toolBar.graphics.beginFill(2578295, 0.8);
            //toolBar.graphics.drawRect(30, 0, (_arg1 - 60), 30);
	    toolBar.graphics.drawRoundRect(30, 0, (_arg1 - 60), 30,10,10);
            toolBar.graphics.endFill();
	    toolBar.alpha = 0;
            if (videoListPane != null){
                //videoListPane.Resize((_arg1 - 3), (_arg2 - 28));
		videoListPane.Resize((_arg1 - 2), (_arg2 - 28));
            };
        }
        private function DisplayOnOver(_arg1:MouseEvent):void{
            showTip("切换视频布局");
        }
        override protected function onRestore(_arg1:MouseEvent):void{
            super.onRestore(_arg1);
            videoListPane.visible = true;
            this.x = 0;
            this.y = 33;
            Resize(322, 268);
        }
        private function showTip(_arg1:String):void{
            txtTip.x = (mouseX + 15);
            txtTip.y = (mouseY - 20);
            txtTip.text = _arg1;
            addChild(txtTip);
            txtTip.visible = true;
        }
        override public function set conn(_arg1:ChatConnection){
            nc = _arg1;
            nc.addEventListener(VideoEvent1.ADD, addStream);
            nc.addEventListener(VideoEvent1.DEL, delStream);
            nc.addEventListener("reConnect", delAll);
        }
        override protected function onMin(_arg1:MouseEvent):void{
            super.onMin(_arg1);
            videoListPane.visible = false;
        }
        override protected function onMax(_arg1:MouseEvent):void{
            super.onMax(_arg1);
            this.x = 0;
            this.y = 33;
            Resize((stage.stageWidth), (stage.stageHeight - 60));
        }
        private function FullScreenOnOver(_arg1:MouseEvent):void{
            showTip("全屏");
        }
        private function ShiYingOnOver(_arg1:MouseEvent):void{
            showTip("适应屏幕大小");
        }
        private function onToolBarOut(_arg1:MouseEvent):void{
            toolBar.alpha = 0;
        }
        private function onToolBarOver(_arg1:MouseEvent):void{
            toolBar.alpha = 100;
        }
        protected function delAll(_arg1:Event):void{
            videoListPane.delAll();
        }
        private function onFullScr(_arg1:MouseEvent):void{
            btnFullScreen.visible = false;
            btnFullQuit.visible = true;
            stage.displayState = "fullScreen";
            parent.addChild(this);
            this.x = 0;
            this.y = -25;
            Resize(stage.stageWidth, (stage.stageHeight + 25));
        }
        private function YuanShiOnOver(_arg1:MouseEvent):void{
            showTip("原始比例");
        }

    }
}//package com.zlchat.ui 
