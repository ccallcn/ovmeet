//hong QQ:1410919373
package com.zlchat.ui {
    import fl.controls.*;
    import flash.display.*;
    import flash.events.*;
    import com.zlchat.events.*;
    import com.zlchat.mainapp.*;
    import flash.text.*;
    import flash.media.*;
    import flash.system.*;
    import flash.external.*;

    public class UserWin extends ResizeWin {

        private var soundBar:Slider;
        public var txtTitle:TextField;
        private var chk_a_da:CheckBox;
        public var _rootMC:MainApp;
        private var btnTestMic:SimpleButton;
        private var manHead:MovieClip;
        private var cmbVideo:ComboBox;
        private var txtNoVideo:TextField;
        private var btnCancel:SimpleButton;
        private var btnOK:SimpleButton;
        public var video:Video;
        private var cmbAudio:ComboBox;

        public function UserWin(){
            super(325, 220);
            txtTitle = new TextField();
            txtTitle.text = "音视频设置";
            txtTitle.autoSize = TextFieldAutoSize.LEFT;
            var _local1:TextFormat = new TextFormat();
            _local1.size = 12;
            _local1.color = 0xFFFFFF;
            txtTitle.setTextFormat(_local1);
            addChild(txtTitle);
	    /**
            manHead = new ManHead();
            addChild(manHead);
            manHead.height = 240;
            manHead.x = super.LEFT;
            manHead.y = 85;
            ***/
	    txtNoVideo = new TextField();
            txtNoVideo.text = "没有视频数据";
            addChild(txtNoVideo);
            var _local2:TextFormat = new TextFormat();
            _local2.color = 0xCC0000;
            txtNoVideo.setTextFormat(_local2);
            txtNoVideo.width = 80;
            txtNoVideo.x = 50;
            txtNoVideo.y = 100;

            video = new Video();
            addChild(video);
            video.x = super.LEFT;
            video.y = 85;
            video.height = 120;
	    video.width = 160;
            video.smoothing = true;

            btnOK = new BtnOK();
            addChild(btnOK);
            btnCancel = new BtnCancel();
            addChild(btnCancel);


            BtnMin.visible = false;
            BtnMax.visible = false;
            BtnRestore.visible = false;
            btnOK.addEventListener(MouseEvent.CLICK, onOK);
            btnCancel.addEventListener(MouseEvent.CLICK, onCancel);
            var _local3:TextField = new TextField();
            _local3.text = "当前视频设备:";
            addChild(_local3);
            cmbVideo = new ComboBox();
            getCameraList();
            addChild(cmbVideo);
            _local3.x = 3;
            _local3.width = 130;
            _local3.height = 30;
            cmbVideo.width = 220;
            cmbVideo.x = 90;
            cmbVideo.y = 30;
            _local3.y = 33;
            var _local4:TextField = new TextField();
            _local4.text = "当前音频设备:";
            addChild(_local4);
            cmbAudio = new ComboBox();
            getMicphoneList();
            addChild(cmbAudio);
            _local4.x = 3;
            _local4.width = 130;
            _local4.height = 30;
            cmbAudio.width = 220;
            cmbAudio.x = 90;
            cmbAudio.y = 60;
            _local4.y = 63;
            cmbVideo.addEventListener(Event.CHANGE, changeVideoDV);
            cmbAudio.addEventListener(Event.CHANGE, changeAudioDV);

            btnTestMic = new BtnTestMic();
            addChild(btnTestMic);
            btnTestMic.addEventListener(MouseEvent.CLICK, onTestMic);
            btnTestMic.x = 200;
            btnTestMic.y = 115;

            var _local5:TextFormat = new TextFormat();
            _local5.size = 12;

            chk_a_da = new CheckBox();
            chk_a_da.label = "话筒声音回放";
            chk_a_da.setStyle("textFormat", _local5);
            chk_a_da.width = 120;
            addChild(chk_a_da);
            chk_a_da.selected = false;
            chk_a_da.x = 200;
            chk_a_da.y = 85;
            chk_a_da.addEventListener(Event.CHANGE, soundHandler);
            Resize(325, 220);
        }
        override public function Resize(_arg1:Number, _arg2:Number):void{
            super.Resize(_arg1, _arg2);
            drawBg(_arg1, _arg2);
	    /**
            btnOK.y = (btnCancel.y = ((_arg2 - btnOK.height) - 10));
            btnOK.x = (((_arg1 - (2 * btnOK.width)) - 10) / 2);
            btnCancel.x = ((btnOK.x + btnCancel.width) + 5);
            **/

            btnOK.y = 145;
            btnOK.x = 200;
            btnCancel.x = 200;
            btnCancel.y = 175;


	    txtTitle.x = 6;
            txtTitle.y = 2;
        }
        protected function soundHandler(_arg1:Event):void{
            if (nc.mic != null){
                nc.mic.setLoopBack(_arg1.currentTarget.selected);
            };
        }
        private function onTestMic(_arg1:MouseEvent):void{
            Security.showSettings(SecurityPanel.MICROPHONE);
        }
        override protected function onWinClose(_arg1:MouseEvent):void{
            this.visible = false;
            video.attachCamera(null);
            dispatchEvent(new AlertEvent(AlertEvent.CANCEL, null));
        }
        protected function changeVideoDV(_arg1:Event):void{
            var _local2:Object;
            nc.cam = Camera.getCamera(ComboBox(_arg1.target).selectedItem.data);
            if (nc.cam.name != "VHScrCap"){
                txtNoVideo.text = "没有视频数据";
                video.visible = true;
                video.attachCamera(nc.cam);
                _local2 = nc.roomInfoSo.data["v_mode"];
                nc.cam.setMode(_local2.w, _local2.h, _local2.f);
                nc.cam.setQuality(0, nc.roomInfoSo.data["v_q"]);
            } else {
                txtNoVideo.text = "共享桌面";
                video.visible = false;
                nc.cam.setMode(0x0400, 0x0300, 5);
                nc.cam.setQuality(0, 80);
                ExternalInterface.call("alert", "为了获得最好的显示效果，请把你的显示器分辨率调为1024*768", null);
            };
            nc.dispatchEvent(new VideoEvent1("ChangeVideoDV", null));
        }
        protected function onOK(_arg1:Event):void{
            this.visible = false;
            video.attachCamera(null);
            dispatchEvent(new AlertEvent(AlertEvent.OK, null));
        }
        protected function changeAudioDV(_arg1:Event):void{
            nc.mic = Microphone.getMicrophone(ComboBox(_arg1.target).selectedItem.data);
            nc.mic.rate = nc.roomInfoSo.data["a_r"];
            nc.mic.setSilenceLevel(nc.roomInfoSo.data["a_s"]);
            nc.dispatchEvent(new VideoEvent1("ChangeAudioDV", null));
        }
        protected function getMicphoneList():void{
            var _local1:Object;
            cmbAudio.removeAll();
            for (_local1 in Microphone.names) {
                cmbAudio.addItem({
                    label:Microphone.names[_local1],
                    data:_local1
                });
            };
            cmbAudio.selectedIndex = 0;
        }
        protected function getCameraList():void{
            var _local1:Object;
            cmbVideo.removeAll();
            for (_local1 in Camera.names) {
                if (Camera.names[_local1] == "VHScrCap"){
                    cmbVideo.addItem({
                        label:"共享桌面",
                        data:_local1
                    });
                } else {
                    cmbVideo.addItem({
                        label:Camera.names[_local1],
                        data:_local1
                    });
                };
            };
            cmbVideo.selectedIndex = 0;
        }
        protected function onCancel(_arg1:Event):void{
            this.visible = false;
            video.attachCamera(null);
            dispatchEvent(new AlertEvent(AlertEvent.CANCEL, null));
        }

    }
}//package com.zlchat.ui 
