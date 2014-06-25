//hong QQ:1410919373
package com.zlchat.ui {
    import fl.controls.*;
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import com.zlchat.events.*;
    import com.zlchat.mainapp.*;
    import flash.text.*;
    import flash.media.*;

    public class ViewCamWin extends ResizeWin {

        private var stream:NetStream;
        public var txtTitle:TextField;
        private var txtNoVideo:TextField;
        private var u:Object;
        public var _rootMC:MainApp;
        private var manHead:MovieClip;
        public var video:Video;

        public function ViewCamWin(_arg1:Object){
            super(325, 300);
            u = _arg1;
            txtTitle = new TextField();
            txtTitle.text = _arg1.realName;
            txtTitle.autoSize = TextFieldAutoSize.LEFT;
            var _local2:TextFormat = new TextFormat();
            _local2.size = 12;
            _local2.color = 0xFFFFFF;
            txtTitle.setTextFormat(_local2);
            addChild(txtTitle);
            manHead = new ManHead();
            addChild(manHead);
            manHead.height = 240;
            manHead.x = super.LEFT;
            manHead.y = super.TOP;
            txtNoVideo = new TextField();
            txtNoVideo.text = "正在连接对方视频";
            addChild(txtNoVideo);
            var _local3:TextFormat = new TextFormat();
            _local3.color = 0xCC0000;
            txtNoVideo.setTextFormat(_local3);
            txtNoVideo.width = 150;
            txtNoVideo.x = 100;
            txtNoVideo.y = (super.TOP + 60);
            video = new Video();
            addChild(video);
            video.x = super.LEFT;
            video.y = super.TOP;
            video.height = 240;
            video.smoothing = true;
            BtnMin.visible = false;
            BtnMax.visible = false;
            BtnRestore.visible = false;
            Resize(325, (242 + super.TOP));
        }
        override protected function onWinClose(_arg1:MouseEvent):void{
            this.visible = false;
            stopView();
        }
        public function stopView():void{
            if (stream != null){
                stream.close();
            };
            if (MainApp.conn != null){
                MainApp.conn.speakListSo.send("stopViewCam", u.userID);
            };
        }
        override public function Resize(_arg1:Number, _arg2:Number):void{
            super.Resize(_arg1, _arg2);
            drawBg(_arg1, _arg2);
            txtTitle.x = 6;
            txtTitle.y = 2;
        }
        public function startView():void{
            if (MainApp.conn != null){
                stream = new NetStream(MainApp.conn);
		//stream = new NetStream(MainApp.conn.ncvideo, MainApp.conn.groupSpecifier.groupspecWithAuthorizations());
		stream.bufferTime = 0.5;
                video.attachNetStream(stream); 
                stream.play(("zlchat_view" + u.userID));
            };
        }

    }
}//package com.zlchat.ui 
