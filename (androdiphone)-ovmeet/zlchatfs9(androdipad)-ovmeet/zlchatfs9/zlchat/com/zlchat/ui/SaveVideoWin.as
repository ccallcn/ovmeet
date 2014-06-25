//hong QQ:1410919373
package com.zlchat.ui {
    import fl.controls.*;
    import flash.display.*;
    import flash.events.*;
    import com.zlchat.events.*;
    import flash.text.*;
    import flash.external.*;

    public class SaveVideoWin extends ResizeWin {

        private var txt1:TextField;
        public var curFileName:String = "";
        public var txtTitle:TextField;
        private var btnCancel:SimpleButton;
        private var btnOK:SimpleButton;
        public var txtVideoName:TextInput;

        public function SaveVideoWin(){
            super(320, 180);
            txtTitle = new TextField();
            txtTitle.text = "保存录制视频";
            txtTitle.autoSize = TextFieldAutoSize.LEFT;
            var _local1:TextFormat = new TextFormat();
            _local1.size = 12;
            _local1.color = 0xFFFFFF;
            txtTitle.setTextFormat(_local1);
            addChild(txtTitle);
            btnOK = new BtnSaveVideo();
            addChild(btnOK);
            btnCancel = new BtnAbortVideo();
            addChild(btnCancel);
            BtnMin.visible = false;
            BtnMax.visible = false;
            BtnRestore.visible = false;
            btnOK.addEventListener(MouseEvent.CLICK, onOK);
            btnCancel.addEventListener(MouseEvent.CLICK, onCancel);
            txt1 = new TextField();
            txt1.text = "请输入一个容易记的文件名:";
            addChild(txt1);
            txt1.height = 25;
            txtVideoName = new TextInput();
            addChild(txtVideoName);
            txtVideoName.height = 30;
            Resize(300, 150);
        }
        protected function onOK(_arg1:Event):void{
            if (txtVideoName.text == ""){
                ExternalInterface.call("alert", "文件名不能为空，请重新输入！", null);
            } else {
                nc.call("vodService.reName", null, (curFileName + ".flv"), (txtVideoName.text + ".flv"));
                nc.speakListSo.send("getVodList");
                this.visible = false;
                dispatchEvent(new AlertEvent(AlertEvent.OK, null));
            };
        }
        override public function Resize(_arg1:Number, _arg2:Number):void{
            super.Resize(_arg1, _arg2);
            drawBg(_arg1, _arg2);
            btnOK.y = (btnCancel.y = ((_arg2 - btnOK.height) - 10));
            btnOK.x = (((_arg1 - (2 * btnOK.width)) - 10) / 2);
            btnCancel.x = ((btnOK.x + btnCancel.width) + 5);
            txtTitle.x = 6;
            txtTitle.y = 2;
            txt1.width = (_arg1 - 30);
            txt1.x = 10;
            txt1.y = 35;
            txtVideoName.x = 10;
            txtVideoName.y = 65;
            txtVideoName.width = (_arg1 - 25);
        }
        protected function onCancel(_arg1:Event):void{
            if (curFileName != ""){
                nc.call("vodService.delVod", null, (curFileName + ".flv"));
            };
            this.visible = false;
            dispatchEvent(new AlertEvent(AlertEvent.CANCEL, null));
        }
        override protected function onWinClose(_arg1:MouseEvent):void{
            if (curFileName != ""){
                nc.call("vodService.delVod", null, (curFileName + ".flv"));
            };
            this.visible = false;
            dispatchEvent(new AlertEvent(AlertEvent.CANCEL, null));
        }

    }
}//package com.zlchat.ui 
