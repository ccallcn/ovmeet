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
    import flash.external.*;

    public class PrivateChatWin extends ResizeWin {

        public var btnSend:SimpleButton;
        private var isSound:Boolean = true;
        private var chkSound:CheckBox;
        private var txtTip:TextField;
        public var _overlay:Sprite;
        private var chkScroll:CheckBox;
        public var txtMsgSend:TextInput;
        public var fileName:String;
        public var btnOK:SimpleButton;
        private var chkCam:CheckBox;
        private var btnVideoAccept:SimpleButton;
        private var fileRef:FileReference;
        private var btnVideoChat:SimpleButton;
        public var userItem:Object;
        private var txtMsgShow:TextArea;
        private var isScroll:Boolean = true;
        private var btnSendFile:SimpleButton;
        private var progressBar:ProgressBar;
        private var bufBar:MovieClip;
        private var txtPercent:TextField;
        private var btnVideoClose:SimpleButton;
        private var chkMic:CheckBox;
        private var videoMode:Boolean = false;
        public var txtTitle:TextField;
        public var isUpload:Boolean = true;
        private var localVideo:PriVideoItem;
        private var colorPicker:ColorPicker;
        private var txtColor:String = "#000000";
        private var remoteVideo:PriVideoItem;
        private var btnVideoCancel:SimpleButton;
        public var dlg:Sprite;
        public var realFileName:String;
        public var btnCancel:SimpleButton;
        private var btnVideoReject:SimpleButton;

        public function PrivateChatWin(_arg1:Object){
            userItem = _arg1;
            super(400, 300);
            txtTitle = new TextField();
            txtTitle.text = userItem.realName;
            txtTitle.autoSize = TextFieldAutoSize.LEFT;
            var _local2:TextFormat = new TextFormat();
            _local2.size = 12;
            _local2.color = 0xFFFFFF;
            txtTitle.setTextFormat(_local2);
            addChild(txtTitle);
            BtnMin.visible = false;
            BtnMax.visible = false;
            BtnRestore.visible = false;
            txtMsgShow = new TextArea();
            addChild(txtMsgShow);
            txtMsgShow.x = 7;
            txtMsgShow.y = 28;
            txtMsgShow.editable = false;
            txtMsgSend = new TextInput();
            txtMsgSend.x = 7;
            txtMsgSend.height = 30;
            _local2 = new TextFormat();
            _local2.size = 14;
            txtMsgSend.setStyle("textFormat", _local2);
            txtMsgSend.maxChars = 250;
            addChild(txtMsgSend);
            txtMsgSend.addEventListener(ComponentEvent.ENTER, sendMsg);
            btnSend = new BtnSend();
            addChild(btnSend);
            btnSend.width = 70;
            btnSend.height = 30;
            btnSend.addEventListener(MouseEvent.CLICK, sendMsg);
            colorPicker = new ColorPicker();
            colorPicker.addEventListener(ColorPickerEvent.CHANGE, changeColor);
            addChild(colorPicker);
            chkSound = new CheckBox();
            chkSound.label = "提示音";
            chkSound.width = 70;
            chkScroll = new CheckBox();
            chkScroll.label = "向上滚屏";
            chkScroll.width = 80;
            chkSound.addEventListener(Event.CHANGE, soundHandler);
            chkScroll.addEventListener(Event.CHANGE, scrollHandler);
            chkSound.selected = true;
            chkScroll.selected = true;
            btnSendFile = new BtnSendFile();
            btnSendFile.width = (btnSendFile.height = 24);
            addChild(btnSendFile);
            addChild(chkSound);
            addChild(chkScroll);
            _overlay = new Sprite();
            addChild(_overlay);
            dlg = new Sprite();
            dlg.graphics.lineStyle(2, 2578295);
            dlg.graphics.beginFill(15268088, 0.8);
            dlg.graphics.drawRect(0, 0, 320, 150);
            dlg.graphics.endFill();
            _overlay.addChild(dlg);
            dlg.x = 40;
            dlg.y = 50;
            bufBar = new LoadingCircle();
            dlg.addChild(bufBar);
            bufBar.width = (bufBar.height = 30);
            bufBar.x = 50;
            bufBar.y = 50;
            txtTip = new TextField();
            dlg.addChild(txtTip);
            txtTip.text = "正在等待对方同意...";
            txtTip.x = 100;
            txtTip.y = 60;
            txtTip.width = 150;
            btnOK = new BtnAccept();
            dlg.addChild(btnOK);
            btnCancel = new BtnReject();
            dlg.addChild(btnCancel);
            btnOK.width = (btnCancel.width = 80);
            btnOK.y = (btnCancel.y = 110);
            btnOK.x = 70;
            btnCancel.x = 170;
            _overlay.visible = false;
            fileRef = new FileReference();
            fileRef.addEventListener(Event.SELECT, selectHandler);
            fileRef.addEventListener(Event.COMPLETE, completeHandler);
            fileRef.addEventListener(HTTPStatusEvent.HTTP_STATUS, uploadError);
            fileRef.addEventListener(IOErrorEvent.IO_ERROR, uploadError);
            fileRef.addEventListener(SecurityErrorEvent.SECURITY_ERROR, uploadError);
            fileRef.addEventListener(Event.OPEN, onOpen);
            fileRef.addEventListener(Event.CANCEL, onUploadCancel);
            fileRef.addEventListener(ProgressEvent.PROGRESS, progressHandler);
            progressBar = new ProgressBar();
            addChild(progressBar);
            progressBar.move(10, 10);
            progressBar.mode = ProgressBarMode.MANUAL;
            progressBar.width = 200;
            progressBar.visible = false;
            progressBar.direction = ProgressBarDirection.RIGHT;
            txtPercent = new TextField();
            txtPercent.text = "0%";
            addChild(txtPercent);
            txtPercent.visible = false;
            btnVideoChat = new BtnVideoChat();
            addChild(btnVideoChat);
            btnVideoChat.height = 30;
            btnVideoChat.width = 24;
            btnVideoChat.addEventListener(MouseEvent.CLICK, startVideoChat);
            remoteVideo = new PriVideoItem();
            localVideo = new PriVideoItem();
            addChild(remoteVideo);
            addChild(localVideo);
            remoteVideo.visible = false;
            localVideo.visible = false;
            btnVideoCancel = new BtnCancel();
            btnVideoAccept = new BtnAccept();
            btnVideoReject = new BtnReject();
            btnVideoClose = new BtnStopChat();
            addChild(btnVideoCancel);
            addChild(btnVideoAccept);
            addChild(btnVideoReject);
            addChild(btnVideoClose);
            btnVideoAccept.addEventListener(MouseEvent.CLICK, acceptVideo);
            btnVideoReject.addEventListener(MouseEvent.CLICK, rejectVideo);
            btnVideoCancel.addEventListener(MouseEvent.CLICK, cancelVideo);
            btnVideoClose.addEventListener(MouseEvent.CLICK, closeVideo);
            btnVideoCancel.visible = false;
            btnVideoAccept.visible = false;
            btnVideoReject.visible = false;
            btnVideoClose.visible = false;
            chkMic = new CheckBox();
            chkMic.label = "声音";
            chkMic.width = 70;
            chkCam = new CheckBox();
            chkCam.label = "图像";
            chkCam.width = 80;
            chkMic.selected = true;
            chkCam.selected = true;
            addChild(chkMic);
            addChild(chkCam);
            chkMic.visible = false;
            chkCam.visible = false;
            chkMic.addEventListener(Event.CHANGE, micHandler);
            chkCam.addEventListener(Event.CHANGE, camHandler);
            addChild(_overlay);
            Resize(400, 300);
        }
        protected function showVideoPane(_arg1:Boolean):void{
            btnVideoReject.visible = _arg1;
            btnVideoAccept.visible = _arg1;
            btnVideoCancel.visible = _arg1;
            btnVideoClose.visible = _arg1;
            chkCam.visible = _arg1;
            chkMic.visible = _arg1;
            remoteVideo.visible = _arg1;
            localVideo.visible = _arg1;
        }
        protected function micHandler(_arg1:Event):void{
            if (localVideo._stream != null){
                if (_arg1.currentTarget.selected){
                    localVideo._stream.attachAudio(nc.mic);
                } else {
                    localVideo._stream.attachAudio(null);
                };
            };
        }
        protected function cancelVideo(_arg1:MouseEvent):void{
            nc.speakListSo.send("cancelVideo", userItem.userID, nc.userID);
            showVideoPane(false);
            videoMode = false;
            Resize(400, 300);
            btnVideoChat.visible = true;
        }
        protected function onSendFile(_arg1:MouseEvent):void{
            fileRef.browse();
        }
        protected function getChineseTime(){
            var _local1:String;
            var _local2:Date = new Date();
            _local1 = ((((((((((_local2.getFullYear() + "-") + (_local2.getMonth() + 1)) + "-") + _local2.getDate()) + " ") + _local2.getHours()) + ":") + _local2.getMinutes()) + ":") + _local2.getSeconds());
            return (_local1);
        }
        protected function acceptUpload(_arg1:MouseEvent):void{
            _overlay.visible = false;
            isUpload = false;
            fileRef.download(new URLRequest(("./upload/temp/" + realFileName)), fileName);
        }
        protected function onCompleteVideo(_arg1:PrivateEvent):void{
            var _local2:String;
            if (_arg1.userItem.userID == userItem.userID){
                _local2 = new String(((((((((("<font size='+1' color='#ff6633'> " + "系统提示") + "(") + getChineseTime()) + "):</font>") + "<font size='+2' color='") + txtColor) + "'> ") + "对方已经关闭视频聊天！") + "</font><br>"));
                txtMsgShow.htmlText = (txtMsgShow.htmlText + _local2);
                if (isScroll == true){
                    txtMsgShow.verticalScrollPosition = txtMsgShow.maxVerticalScrollPosition;
                };
                showVideoPane(false);
                videoMode = false;
                Resize(400, 300);
                btnVideoChat.visible = true;
                localVideo.clearStream();
                remoteVideo.clearStream();
            };
        }
        protected function rejectVideo(_arg1:MouseEvent):void{
            nc.speakListSo.send("rejectVideo", userItem.userID, nc.userID);
            showVideoPane(false);
            videoMode = false;
            Resize(400, 300);
            btnVideoChat.visible = true;
        }
        protected function startVideoChat(_arg1:MouseEvent):void{
            videoMode = true;
            btnVideoChat.visible = false;
            btnVideoAccept.visible = false;
            btnVideoReject.visible = false;
            btnVideoCancel.visible = true;
            btnVideoClose.visible = false;
            Resize(580, 300);
            nc.speakListSo.send("inviteVideo", userItem.userID, nc.userID);
        }
        protected function soundHandler(_arg1:Event):void{
            isSound = _arg1.currentTarget.selected;
        }
        protected function draw(_arg1:Number, _arg2:Number):void{
            _overlay.graphics.clear();
            _overlay.graphics.beginFill(0xEEEEEE, 0.2);
            _overlay.graphics.drawRect(5, 25, _arg1, _arg2);
            _overlay.graphics.endFill();
        }
        public function onCloseChat(_arg1:PrivateEvent):void{
            var _local2:String;
            if (_arg1.userItem.userID == userItem.userID){
                _local2 = new String(((((((((("<font size='+1' color='#ff6633'> " + "系统提示") + "(") + getChineseTime()) + "):</font>") + "<font size='+2' color='") + txtColor) + "'> ") + "对方已经关闭私聊窗口！") + "</font><br>"));
                txtMsgShow.htmlText = (txtMsgShow.htmlText + _local2);
                if (isScroll == true){
                    txtMsgShow.verticalScrollPosition = txtMsgShow.maxVerticalScrollPosition;
                };
                txtMsgSend.enabled = false;
                btnSend.enabled = false;
                if (videoMode == true){
                    showVideoPane(false);
                    videoMode = false;
                    Resize(400, 300);
                    btnVideoChat.visible = true;
                    localVideo.clearStream();
                    remoteVideo.clearStream();
                };
            };
        }
        protected function acceptVideo(_arg1:MouseEvent):void{
            var _local2:Object = new Object();
            _local2.userID = nc.userID;
            _local2.userName = nc.realName;
            localVideo.speaker = _local2;
            nc.speakListSo.send("acceptVideo", userItem.userID, nc.userID);
            btnVideoReject.visible = false;
            btnVideoAccept.visible = false;
            btnVideoCancel.visible = false;
            btnVideoClose.visible = true;
            remoteVideo.speaker = userItem;
        }
        override public function set conn(_arg1:ChatConnection){
            nc = _arg1;
            remoteVideo.conn = _arg1;
            localVideo.conn = _arg1;
            nc.addEventListener("SendMessage", sendMessage);
            nc.addEventListener("CloseChat", onCloseChat);
            nc.addEventListener("acceptChat", onAcceptChat);
            nc.addEventListener("rejectChat", onRejectChat);
            nc.addEventListener("inviteUpload", onInviteUpload);
            nc.addEventListener("acceptUpload", onAcceptUpload);
            nc.addEventListener("rejectUpload", onRejectUpload);
            nc.addEventListener("completeUpload", onCompleteUpload);
            nc.addEventListener("inviteVideo", onInviteVideo);
            nc.addEventListener("acceptVideo", onAcceptVideo);
            nc.addEventListener("cancelVideo", onCancelVideo);
            nc.addEventListener("rejectVideo", onRejectVideo);
            nc.addEventListener("completeVideo", onCompleteVideo);
        }
        protected function onCompleteUpload(_arg1:PrivateEvent):void{
            var _local2:String;
            var _local3:URLRequest;
            var _local4:URLLoader;
            if (_arg1.userItem.userID == userItem.userID){
                _local2 = new String(((((((((("<font size='+1' color='#ff6633'> " + "系统提示") + "(") + getChineseTime()) + "):</font>") + "<font size='+2' color='") + txtColor) + "'> ") + "对方已经接收文件完毕！") + "</font><br>"));
                txtMsgShow.htmlText = (txtMsgShow.htmlText + _local2);
                if (isScroll == true){
                    txtMsgShow.verticalScrollPosition = txtMsgShow.maxVerticalScrollPosition;
                };
                btnSendFile.visible = true;
                isUpload = true;
                _local3 = new URLRequest(((("privateDel." + nc.scriptType) + "?fileName=") + realFileName));
                _local4 = new URLLoader();
                _local4.load(_local3);
            };
        }
        protected function onUploadCancel(_arg1:Event):void{
            if (!isUpload){
                nc.speakListSo.send("rejectUpload", userItem.userID, nc.userID);
            };
        }
        protected function progressHandler(_arg1:ProgressEvent):void{
            progressBar.setProgress(_arg1.bytesLoaded, _arg1.bytesTotal);
            txtPercent.text = (Math.floor(progressBar.percentComplete) + "%");
        }
        public function sendMessage(_arg1:PrivateEvent):void{
            var _local2:Msg;
            if (_arg1.userItem.userID == userItem.userID){
                txtMsgShow.htmlText = (txtMsgShow.htmlText + _arg1.detail);
                if (isSound == true){
                    _local2 = new Msg();
                    _local2.play();
                };
                if (isScroll == true){
                    txtMsgShow.verticalScrollPosition = txtMsgShow.maxVerticalScrollPosition;
                };
            };
        }
        protected function closeVideo(_arg1:MouseEvent):void{
            nc.speakListSo.send("completeVideo", userItem.userID, nc.userID);
            showVideoPane(false);
            videoMode = false;
            Resize(400, 300);
            btnVideoChat.visible = true;
            localVideo.clearStream();
            remoteVideo.clearStream();
        }
        override protected function onWinClose(_arg1:MouseEvent):void{
            this.visible = false;
            nc.speakListSo.send("closeChat", userItem.userID, nc.userID);
            if (videoMode == true){
                showVideoPane(false);
                videoMode = false;
                Resize(400, 300);
                localVideo.clearStream();
                remoteVideo.clearStream();
            };
            btnVideoChat.visible = false;
            btnSendFile.visible = false;
        }
        protected function acceptChat(_arg1:MouseEvent):void{
            _overlay.visible = false;
            txtMsgSend.enabled = true;
            btnSend.enabled = true;
            nc.speakListSo.send("acceptChat", userItem.userID, nc.userID);
        }
        protected function uploadError(_arg1:Event):void{
            if (!isUpload){
                nc.speakListSo.send("completeUpload", userItem.userID, nc.userID);
            };
            isUpload = true;
            btnSendFile.visible = true;
            progressBar.visible = false;
            txtPercent.visible = false;
        }
        protected function camHandler(_arg1:Event):void{
            if (localVideo._stream != null){
                if (_arg1.currentTarget.selected){
                    localVideo._stream.attachCamera(nc.cam);
                } else {
                    localVideo._stream.attachCamera(null);
                };
            };
        }
        protected function rejectUpload(_arg1:MouseEvent):void{
            _overlay.visible = false;
            nc.speakListSo.send("rejectUpload", userItem.userID, nc.userID);
        }
        protected function changeColor(_arg1:ColorPickerEvent):void{
            txtColor = ("#" + _arg1.target.hexValue);
            var _local2:TextFormat = new TextFormat();
            _local2.size = 14;
            _local2.color = _arg1.color;
            txtMsgSend.setStyle("textFormat", _local2);
        }
        public function showInviteDlg(){
            txtTip.text = "正在等待对方同意...";
            btnOK.visible = false;
            btnCancel.visible = false;
            _overlay.visible = true;
            btnVideoChat.visible = true;
            btnSendFile.visible = true;
        }
        protected function onInviteVideo(_arg1:PrivateEvent):void{
            if (_arg1.userItem.userID == userItem.userID){
                videoMode = true;
                btnVideoAccept.visible = true;
                btnVideoReject.visible = true;
                btnVideoCancel.visible = false;
                btnVideoClose.visible = false;
                Resize(580, 300);
                btnVideoChat.visible = false;
            };
        }
        private function getFileName(_arg1:String):String{
            var _local2:String;
            var _local4:String;
            var _local3:* = _arg1.lastIndexOf(".");
            _local2 = _arg1.substr(_local3);
            var _local5:Date = new Date();
            _local4 = ((((("_" + _local5.getFullYear()) + _local5.getDate()) + _local5.getHours()) + _local5.getMinutes()) + _local5.getSeconds());
            return ((_local4 + _local2));
        }
        protected function rejectChat(_arg1:MouseEvent):void{
            this.visible = false;
            nc.speakListSo.send("rejectChat", userItem.userID, nc.userID);
        }
        public function showUploadDlg(){
            btnOK.visible = true;
            btnCancel.visible = true;
            txtTip.wordWrap = true;
            txtTip.text = (("对方发送文件" + fileName) + "给你，同意或者拒绝!");
            txtTip.width = 200;
            _overlay.visible = true;
            btnOK.removeEventListener(MouseEvent.CLICK, acceptChat);
            btnCancel.removeEventListener(MouseEvent.CLICK, rejectChat);
            btnOK.addEventListener(MouseEvent.CLICK, acceptUpload);
            btnCancel.addEventListener(MouseEvent.CLICK, rejectUpload);
        }
        protected function onAcceptUpload(_arg1:PrivateEvent):void{
            var _local2:String;
            if (_arg1.userItem.userID == userItem.userID){
                _local2 = new String(((((((((("<font size='+1' color='#ff6633'> " + "系统提示") + "(") + getChineseTime()) + "):</font>") + "<font size='+2' color='") + txtColor) + "'> ") + "对方已经开始接收文件！") + "</font><br>"));
                txtMsgShow.htmlText = (txtMsgShow.htmlText + _local2);
                if (isScroll == true){
                    txtMsgShow.verticalScrollPosition = txtMsgShow.maxVerticalScrollPosition;
                };
            };
        }
        protected function selectHandler(_arg1:Event):void{
            var request:* = null;
            var event:* = _arg1;
            if (isUpload){
                if (fileRef.size < ((20 * 0x0400) * 0x0400)){
                    fileName = fileRef.name;
                    realFileName = getFileName(fileRef.name);
                    isUpload = true;
                    request = new URLRequest(((("privateUpload." + nc.scriptType) + "?fileName=") + realFileName));
                    try {
                        fileRef.upload(request);
                        progressBar.maximum = fileRef.size;
                        progressBar.minimum = 100;
                        progressBar.visible = true;
                        txtPercent.visible = true;
                        btnSendFile.visible = false;
                    } catch(error:Error) {
                        trace("Unable to upload file.");
                    };
                } else {
                    ExternalInterface.call("alert", "传送的文件不能大于20M", null);
                };
            } else {
                isUpload = false;
                btnSendFile.visible = false;
                nc.speakListSo.send("acceptUpload", userItem.userID, nc.userID);
            };
        }
        protected function scrollHandler(_arg1:Event):void{
            isScroll = _arg1.currentTarget.selected;
        }
        protected function onAcceptChat(_arg1:PrivateEvent):void{
            if (_arg1.userItem.userID == userItem.userID){
                _overlay.visible = false;
                txtMsgSend.enabled = true;
                btnSend.enabled = true;
            };
        }
        public function showInviteDlg2(){
            btnOK.visible = true;
            btnCancel.visible = true;
            txtTip.text = "对方请求和你私聊，同意或者拒绝。";
            txtTip.width = 200;
            _overlay.visible = true;
            btnOK.addEventListener(MouseEvent.CLICK, acceptChat);
            btnCancel.addEventListener(MouseEvent.CLICK, rejectChat);
            btnOK.removeEventListener(MouseEvent.CLICK, acceptUpload);
            btnCancel.removeEventListener(MouseEvent.CLICK, rejectUpload);
            btnVideoChat.visible = true;
            btnSendFile.visible = true;
        }
        protected function onCancelVideo(_arg1:PrivateEvent):void{
            var _local2:String;
            if (_arg1.userItem.userID == userItem.userID){
                _local2 = new String(((((((((("<font size='+1' color='#ff6633'> " + "系统提示") + "(") + getChineseTime()) + "):</font>") + "<font size='+2' color='") + txtColor) + "'> ") + "对方取消视频聊天请求！") + "</font><br>"));
                txtMsgShow.htmlText = (txtMsgShow.htmlText + _local2);
                if (isScroll == true){
                    txtMsgShow.verticalScrollPosition = txtMsgShow.maxVerticalScrollPosition;
                };
                showVideoPane(false);
                videoMode = false;
                Resize(400, 300);
                btnVideoChat.visible = true;
            };
        }
        protected function onRejectVideo(_arg1:PrivateEvent):void{
            var _local2:String;
            if (_arg1.userItem.userID == userItem.userID){
                _local2 = new String(((((((((("<font size='+1' color='#ff6633'> " + "系统提示") + "(") + getChineseTime()) + "):</font>") + "<font size='+2' color='") + txtColor) + "'> ") + "对方拒绝视频聊天请求！") + "</font><br>"));
                txtMsgShow.htmlText = (txtMsgShow.htmlText + _local2);
                if (isScroll == true){
                    txtMsgShow.verticalScrollPosition = txtMsgShow.maxVerticalScrollPosition;
                };
                showVideoPane(false);
                videoMode = false;
                Resize(400, 300);
                btnVideoChat.visible = true;
            };
        }
        protected function onOpen(_arg1:Event):void{
            progressBar.visible = true;
            txtPercent.visible = true;
        }
        override public function Resize(_arg1:Number, _arg2:Number):void{
            super.Resize(_arg1, _arg2);
            drawBg(_arg1, _arg2);
            var _local3:int;
            if (videoMode){
                _local3 = 244;
                remoteVideo.visible = true;
                localVideo.visible = true;
                remoteVideo.Resize(240, 160);
                remoteVideo.x = 3;
                remoteVideo.y = 28;
                localVideo.Resize(120, 90);
                localVideo.x = 124;
                localVideo.y = 190;
                chkCam.visible = true;
                chkMic.visible = true;
                chkCam.x = 10;
                chkMic.x = 60;
                chkCam.y = 190;
                chkMic.y = 190;
                btnVideoCancel.x = 20;
                btnVideoCancel.y = 220;
                btnVideoAccept.x = 20;
                btnVideoAccept.y = 220;
                btnVideoClose.x = 20;
                btnVideoClose.y = 220;
                btnVideoReject.x = 20;
                btnVideoReject.y = 250;
            } else {
                remoteVideo.visible = false;
                localVideo.visible = false;
            };
            txtTitle.x = 6;
            txtTitle.y = 2;
            txtMsgShow.width = ((_arg1 - 10) - _local3);
            txtMsgShow.height = (_arg2 - 98);
            txtMsgSend.width = ((_arg1 - 90) - _local3);
            txtMsgSend.y = ((_arg2 - txtMsgSend.height) - 7);
            txtMsgShow.x = (_local3 + 4);
            txtMsgSend.x = (_local3 + 4);
            btnSend.x = (_arg1 - 78);
            btnSend.y = ((_arg2 - btnSend.height) - 7);
            chkSound.x = (7 + _local3);
            chkSound.y = (_arg2 - 62);
            chkScroll.x = (91 + _local3);
            chkScroll.y = (_arg2 - 62);
            colorPicker.x = (177 + _local3);
            colorPicker.y = (_arg2 - 66);
            btnSendFile.x = (205 + _local3);
            btnSendFile.y = (_arg2 - 64);
            btnSendFile.addEventListener(MouseEvent.CLICK, onSendFile);
            progressBar.y = (btnSendFile.y - 10);
            progressBar.x = (20 + _local3);
            txtPercent.y = ((progressBar.y - txtPercent.textHeight) - 4);
            txtPercent.x = ((progressBar.x + (txtPercent.width / 2)) + 4);
            btnVideoChat.y = (_arg2 - 64);
            btnVideoChat.x = (237 + _local3);
            draw((_arg1 - 10), (_arg2 - 30));
        }
        protected function onRejectChat(_arg1:PrivateEvent):void{
            if (_arg1.userItem.userID == userItem.userID){
                this.visible = false;
                ExternalInterface.call("alert", (userItem.realName + "已经拒绝你的私聊请求"), null);
            };
        }
        protected function completeHandler(_arg1:Event):void{
            progressBar.visible = false;
            txtPercent.visible = false;
            progressBar.setProgress(0, 1);
            txtPercent.text = "0%";
            if (isUpload){
                nc.speakListSo.send("inviteUpload", userItem.userID, fileName, realFileName, nc.userID);
                isUpload = false;
            } else {
                nc.speakListSo.send("completeUpload", userItem.userID, nc.userID);
                btnSendFile.visible = true;
                isUpload = true;
            };
        }
        protected function sendMsg(_arg1:Event):void{
            var _local2:String;
            if (txtMsgSend.text != ""){
                _local2 = new String(((((((((("<font size='+1' color='#ff6633'> " + nc.user.realName) + "(") + getChineseTime()) + "):</font>") + "<font size='+2' color='") + txtColor) + "'> ") + txtMsgSend.text) + "</font><br>"));
                nc.speakListSo.send("sendMessage", _local2, userItem.userID, nc.userID);
                txtMsgSend.text = "";
                txtMsgShow.htmlText = (txtMsgShow.htmlText + _local2);
                if (isScroll == true){
                    txtMsgShow.verticalScrollPosition = txtMsgShow.maxVerticalScrollPosition;
                };
                txtMsgSend.setFocus();
            };
        }
        protected function onInviteUpload(_arg1:PrivateEvent):void{
            if (_arg1.userItem.userID == userItem.userID){
                fileName = _arg1.detail.fileName;
                realFileName = _arg1.detail.realFileName;
                showUploadDlg();
            };
        }
        protected function onAcceptVideo(_arg1:PrivateEvent):void{
            var _local2:String;
            var _local3:Object;
            if (_arg1.userItem.userID == userItem.userID){
                _local2 = new String(((((((((("<font size='+1' color='#ff6633'> " + "系统提示") + "(") + getChineseTime()) + "):</font>") + "<font size='+2' color='") + txtColor) + "'> ") + "对方已经接受视频聊天请求！") + "</font><br>"));
                txtMsgShow.htmlText = (txtMsgShow.htmlText + _local2);
                if (isScroll == true){
                    txtMsgShow.verticalScrollPosition = txtMsgShow.maxVerticalScrollPosition;
                };
                btnVideoReject.visible = false;
                btnVideoAccept.visible = false;
                btnVideoCancel.visible = false;
                btnVideoClose.visible = true;
                remoteVideo.speaker = userItem;
                _local3 = new Object();
                _local3.userID = nc.userID;
                _local3.userName = nc.realName;
                localVideo.speaker = _local3;
            };
        }
        protected function onRejectUpload(_arg1:PrivateEvent):void{
            var _local2:String;
            var _local3:URLRequest;
            var _local4:URLLoader;
            if (_arg1.userItem.userID == userItem.userID){
                _local2 = new String(((((((((("<font size='+1' color='#ff6633'> " + "系统提示") + "(") + getChineseTime()) + "):</font>") + "<font size='+2' color='") + txtColor) + "'> ") + "对方拒绝接收文件！") + "</font><br>"));
                txtMsgShow.htmlText = (txtMsgShow.htmlText + _local2);
                if (isScroll == true){
                    txtMsgShow.verticalScrollPosition = txtMsgShow.maxVerticalScrollPosition;
                };
                btnSendFile.visible = true;
                isUpload = true;
                _local3 = new URLRequest(((("privateDel." + nc.scriptType) + "?fileName=") + realFileName));
                _local4 = new URLLoader();
                _local4.load(_local3);
            };
        }

    }
}//package com.zlchat.ui 
