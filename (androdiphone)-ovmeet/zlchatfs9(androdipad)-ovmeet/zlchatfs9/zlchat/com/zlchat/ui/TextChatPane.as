//hong QQ:1410919373
package com.zlchat.ui {
    import fl.controls.*;
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import com.zlchat.events.*;
    import com.zlchat.utils.*;
    import fl.events.*;
    import flash.text.*;
    import flash.media.*;

    public class TextChatPane extends BasePane {

        private var btnSend:SimpleButton;
        private var isSound:Boolean = true;
        private var chkSound:CheckBox;
        private var txtMsgShow:TextArea;
        private var btnClear:SimpleButton;
        private var chkScroll:CheckBox;
        private var isScroll:Boolean = true;
        private var colorPicker:ColorPicker;
        private var txtMsgSend:TextInput;
        private var txtColor:String = "#000000";
        private var btnHistory:SimpleButton;
        private var textChatSo:SharedObject;

        public function TextChatPane(){
            txtMsgShow = new TextArea();
            addChild(txtMsgShow);
            txtMsgShow.x = 2;
            txtMsgShow.y = 2;
            txtMsgShow.editable = false;
            txtMsgSend = new TextInput();
            txtMsgSend.x = 2;
            txtMsgSend.height = 30;
            var _local1:TextFormat = new TextFormat();
            _local1.size = 14;
            txtMsgSend.setStyle("textFormat", _local1);
            txtMsgSend.maxChars = 250;
            addChild(txtMsgSend);
            txtMsgSend.addEventListener(ComponentEvent.ENTER, sendMsg);
            btnSend = new BtnSend();
            addChild(btnSend);
            btnSend.width = 80;
            btnSend.height = 30;
            btnSend.addEventListener(MouseEvent.CLICK, sendMsg);
            colorPicker = new ColorPicker();
            colorPicker.addEventListener(ColorPickerEvent.CHANGE, changeColor);
            addChild(colorPicker);
            var _local2:TextFormat = new TextFormat();
            _local2.size = 12;
            chkSound = new CheckBox();
            chkSound.label = "提示音";
            chkSound.setStyle("textFormat", _local2);
            chkSound.width = 70;
            chkScroll = new CheckBox();
            chkScroll.label = "向上滚屏";
            chkScroll.setStyle("textFormat", _local2);
            chkScroll.width = 80;
            chkSound.addEventListener(Event.CHANGE, soundHandler);
            chkScroll.addEventListener(Event.CHANGE, scrollHandler);
            chkSound.selected = isSound;
            chkScroll.selected = isScroll;
            addChild(chkSound);
            addChild(chkScroll);
            btnHistory = new BtnHistory();
            btnHistory.width = 70;
            addChild(btnHistory);
            btnClear = new BtnClear();
            btnClear.width = 70;
            addChild(btnClear);
            btnClear.addEventListener(MouseEvent.CLICK, onClear);
            btnHistory.addEventListener(MouseEvent.CLICK, onHistory);
        }
        override public function Resize(_arg1:Number, _arg2:Number):void{
            super.Resize(_arg1, _arg2);
            txtMsgShow.width = (_arg1 - 4);
            txtMsgShow.height = (_arg2 - 70);
            txtMsgSend.width = (_arg1 - 90);
            txtMsgSend.y = ((_arg2 - txtMsgSend.height) - 2);
            btnSend.x = (_arg1 - 82);
            btnSend.y = ((_arg2 - btnSend.height) - 2);
            chkSound.x = 2;
            chkSound.y = (_arg2 - 62);
            chkScroll.x = 84;
            chkScroll.y = (_arg2 - 62);
            colorPicker.x = 170;
            colorPicker.y = (_arg2 - 64);
            btnHistory.y = (btnClear.y = (_arg2 - 64));
            btnHistory.x = 200;
            btnClear.x = 275;
        }
        protected function showHistory(_arg1:String):void{
            txtMsgShow.htmlText = _arg1;
        }
        protected function sendMsg(_arg1:Event):void{
            if (txtMsgSend.text != ""){
                nc.call("sendTextMsg", null, new String(((((((((("<font size='+1' color='#ff6633'> " + nc.user.realName) + "(") + ChatConnection.getChineseTime()) + "):</font>") + "<font size='+2' color='") + txtColor) + "'> ") + txtMsgSend.text) + "</font><br>")));
                txtMsgSend.text = "";
                txtMsgSend.setFocus();
            };
        }
        protected function getChineseTime(){
            var _local1:String;
            var _local2:Date = new Date();
            _local1 = ((((((((((_local2.getFullYear() + "-") + (_local2.getMonth() + 1)) + "-") + _local2.getDate()) + " ") + _local2.getHours()) + ":") + _local2.getMinutes()) + ":") + _local2.getSeconds());
            return (_local1);
        }
        override public function set conn(_arg1:ChatConnection){
            nc = _arg1;
            nc.addEventListener("g_dt", g_dt);
            textChatSo = SharedObject.getRemote("textChat", nc.uri, false);
            textChatSo.connect(nc);
            textChatSo.client = this;
        }
        protected function g_dt(_arg1:RoomInfoEvent):void{
            if (nc.role == "4"){
                txtMsgSend.enabled = !(_arg1.key);
                btnSend.enabled = !(_arg1.key);
            };
        }
        protected function changeColor(_arg1:ColorPickerEvent):void{
            txtColor = ("#" + _arg1.target.hexValue);
            var _local2:TextFormat = new TextFormat();
            _local2.size = 14;
            _local2.color = _arg1.color;
            txtMsgSend.setStyle("textFormat", _local2);
        }
        protected function onClear(_arg1:Event):void{
            txtMsgShow.text = "";
        }
        public function sendMessage(_arg1:String):void{
            var _local2:Msg;
            txtMsgShow.htmlText = (txtMsgShow.htmlText + _arg1);
            if (isSound == true){
                _local2 = new Msg();
                _local2.play();
            };
            if (isScroll == true){
                txtMsgShow.verticalScrollPosition = txtMsgShow.maxVerticalScrollPosition;
            };
        }
        protected function soundHandler(_arg1:Event):void{
            isSound = (_arg1.currentTarget.selected as Boolean);
        }
        protected function onHistory(_arg1:Event):void{
            nc.call("getHistory", new Responder(showHistory));
        }
        protected function scrollHandler(_arg1:Event):void{
            isScroll = (_arg1.currentTarget.selected as Boolean);
        }

    }
}//package com.zlchat.ui 
