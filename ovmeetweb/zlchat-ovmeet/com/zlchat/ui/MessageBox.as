//hong QQ:1410919373
package com.zlchat.ui {
    import flash.display.*;
    import flash.events.*;
    import com.zlchat.events.*;
    import flash.text.*;

    public class MessageBox extends ResizeWin {

        public var txtDetail:TextField;
        public var btnCancel:SimpleButton;
        public var btnOK:SimpleButton;

        public function MessageBox(){
            super(320, 180);
            txtDetail = new TextField();
            txtDetail.text = "请先设置对话框内容";
            var _local1:TextFormat = new TextFormat();
            _local1.size = 14;
            _local1.bold = true;
            txtDetail.setTextFormat(_local1);
            txtDetail.width = 300;
            txtDetail.height = 100;
            txtDetail.autoSize = TextFieldAutoSize.LEFT;
            addChild(txtDetail);
            btnOK = new BtnOK();
            addChild(btnOK);
            btnCancel = new BtnCancel();
            addChild(btnCancel);
            BtnMin.visible = false;
            BtnMax.visible = false;
            BtnRestore.visible = false;
            btnOK.addEventListener(MouseEvent.CLICK, onOK);
            btnCancel.addEventListener(MouseEvent.CLICK, onCancel);
            Resize(320, 180);
        }
        override public function Resize(_arg1:Number, _arg2:Number):void{
            super.Resize(_arg1, _arg2);
            drawBg(_arg1, _arg2);
            btnOK.y = (btnCancel.y = ((_arg2 - btnOK.height) - 10));
            btnOK.x = (((_arg1 - (2 * btnOK.width)) - 10) / 2);
            btnCancel.x = ((btnOK.x + btnCancel.width) + 5);
            txtDetail.x = 20;
            txtDetail.y = 40;
        }
        protected function onCancel(_arg1:Event):void{
            this.visible = false;
            dispatchEvent(new AlertEvent(AlertEvent.CANCEL, null));
        }
        protected function onOK(_arg1:Event):void{
            this.visible = false;
            dispatchEvent(new AlertEvent(AlertEvent.OK, null));
        }
        override protected function onWinClose(_arg1:MouseEvent):void{
            this.visible = false;
            dispatchEvent(new AlertEvent(AlertEvent.CANCEL, null));
        }
        public function set label(_arg1:String):void{
            txtDetail.text = _arg1;
        }

    }
}//package com.zlchat.ui 
