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
    import flash.media.*;
    import flash.external.*;

    public class PPTUploadWin2 extends ResizeWin {

        public var txtTitle:TextField;
        private var btnDel:SimpleButton;
        private var loader:URLLoader;
        public var realFileName:String;
        public var fileName:String;
        private var progressBar:ProgressBar;
        private var txtPercent:TextField;
        private var btnCancel:SimpleButton;
        private var fileRef:FileReference;
        private var btnOK:SimpleButton;
        private var fileList:List;
        public var pptPane:WhiteBoardPane;
        private var btnUpload:SimpleButton;

        public function PPTUploadWin2(){
            super(400, 300);
            txtTitle = new TextField();
            txtTitle.text = "打开PPT";
            txtTitle.autoSize = TextFieldAutoSize.LEFT;
            var _local1:TextFormat = new TextFormat();
            _local1.size = 12;
            _local1.color = 0xFFFFFF;
            txtTitle.setTextFormat(_local1);
            addChild(txtTitle);
            btnOK = new BtnOK();
            addChild(btnOK);
            btnOK.enabled = false;
            btnCancel = new BtnCancel();
            addChild(btnCancel);
            btnUpload = new BtnUploadPPT();
            addChild(btnUpload);
            btnDel = new BtnDelPPT();
            addChild(btnDel);
            btnDel.enabled = false;
            btnDel.addEventListener(MouseEvent.CLICK, delFile);
            btnOK.width = (btnCancel.width = (btnUpload.width = (btnDel.width = 80)));
            btnUpload.addEventListener(MouseEvent.CLICK, onSendPPT);
            BtnMin.visible = false;
            BtnMax.visible = false;
            BtnRestore.visible = false;
            btnOK.addEventListener(MouseEvent.CLICK, onOK);
            btnCancel.addEventListener(MouseEvent.CLICK, onCancel);
            fileList = new List();
            fileList.setStyle("cellRenderer", FileItem);
            addChild(fileList);
            fileList.x = 2;
            fileList.y = 28;
            fileList.rowHeight = 30;
            fileList.addEventListener(ListEvent.ITEM_CLICK, enableButtons);
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
            txtPercent.width = 200;
            Resize(450, 260);
            fileRef = new FileReference();
            fileRef.addEventListener(Event.SELECT, selectHandler);
            fileRef.addEventListener(Event.COMPLETE, completeHandler);
            fileRef.addEventListener(HTTPStatusEvent.HTTP_STATUS, uploadError);
            fileRef.addEventListener(IOErrorEvent.IO_ERROR, uploadError);
            fileRef.addEventListener(SecurityErrorEvent.SECURITY_ERROR, uploadError);
            fileRef.addEventListener(Event.OPEN, onOpen);
            fileRef.addEventListener(Event.CANCEL, uploadError);
            fileRef.addEventListener(ProgressEvent.PROGRESS, progressHandler);
        }
        protected function onOK(_arg1:Event):void{
            btnOK.enabled = false;
            btnDel.enabled = false;
            pptPane.pptName = fileList.selectedItem.data.fName;
            pptPane.pptFolder = fileList.selectedItem.data.folder;
            pptPane.totalFrame = fileList.selectedItem.data.totalFrame;
            pptPane.index = 1;
            this.visible = false;
            dispatchEvent(new AlertEvent(AlertEvent.OK, null));
            pptPane.loadImage(fileList.selectedItem.data.folder, 1);
            nc.call("sendTextMsg", null, new String(((((((((("<font size='+1' color='#ff0000'> " + "系统提示:") + "(") + ChatConnection.getChineseTime()) + "):</font>") + "<font size='+2' color='ff0000'> ") + nc.realName) + "已经打开PPT:") + pptPane.pptName) + "!</font><br>")));
        }
        public function onSendPPT(_arg1:Event):void{
            var _local2:FileFilter = new FileFilter("ppt (*.ppt,*.pptx)", "*.ppt;*.pptx");
            var _local3:Array = new Array(_local2);
            fileRef.browse(_local3);
        }
        protected function selectHandler(_arg1:Event):void{
            var request:* = null;
            var event:* = _arg1;
            if (fileRef.size < ((200 * 0x0400) * 0x0400)){
                fileName = fileRef.name;
                realFileName = getFileName(fileRef.name);
                request = new URLRequest(((((("uploadPPT." + nc.scriptType) + "?fileName=") + realFileName) + "&roomID=") + nc.roomID));
                try {
                    fileRef.upload(request);
                    progressBar.maximum = fileRef.size;
                    progressBar.minimum = 100;
                    progressBar.visible = true;
                    txtPercent.visible = true;
                } catch(error:Error) {
                    trace("Unable to upload file.");
                };
            } else {
                ExternalInterface.call("alert", "传送的文件不能大于200M", null);
            };
        }
        protected function uploadError(_arg1:Event):void{
            progressBar.visible = false;
            txtPercent.visible = false;
            btnUpload.enabled = true;
        }
        protected function onOpen(_arg1:Event):void{
            progressBar.visible = true;
            txtPercent.visible = true;
            btnUpload.enabled = false;
        }
        protected function completeHandler(_arg1:Event):void{
            progressBar.visible = false;
            txtPercent.visible = false;
            progressBar.setProgress(0, 1);
            txtPercent.text = "0%";
            btnUpload.enabled = true;
            getFileList();
        }
        public function getFileList():void{
            loader = new URLLoader();
            var userRequest:* = new URLRequest(((("getPPTList." + nc.scriptType) + "?roomID=") + nc.roomID));
            loader.addEventListener(Event.COMPLETE, onGetFileList);
            loader.addEventListener(IOErrorEvent.IO_ERROR, onCheckError);
            loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onCheckError);
            try {
                loader.load(userRequest);
            } catch(error:ArgumentError) {
                trace("An ArgumentError has occurred.");
            } catch(error:SecurityError) {
                trace("A SecurityError has occurred.");
            };
        }
        protected function delFile(_arg1:Event):void{
            var _local2:* = new URLLoader();
            var _local3:URLRequest = new URLRequest(((("delPPT." + nc.scriptType) + "?folder=") + fileList.selectedItem.data.folder));
            _local2.addEventListener(Event.COMPLETE, delHandler);
            _local2.load(_local3);
        }
        protected function delHandler(_arg1:Event):void{
            getFileList();
        }
        override public function set conn(_arg1:ChatConnection){
            nc = _arg1;
            nc.addEventListener("setRole", onSetRole);
            if (nc.role == "3"){
                btnDel.visible = false;
            } else {
                btnDel.visible = true;
            };
        }
        protected function onSetRole(_arg1:Event):void{
            if (nc.role == "3"){
                btnDel.visible = false;
            } else {
                btnDel.visible = true;
            };
        }
        override public function Resize(_arg1:Number, _arg2:Number):void{
            super.Resize(_arg1, _arg2);
            drawBg(_arg1, _arg2);
            btnOK.y = (btnCancel.y = (btnUpload.y = (btnDel.y = ((_arg2 - btnOK.height) - 10))));
            btnOK.x = (((_arg1 - (4 * btnOK.width)) - 10) / 2);
            btnCancel.x = ((btnOK.x + btnCancel.width) + 5);
            btnUpload.x = ((btnCancel.x + btnUpload.width) + 5);
            btnDel.x = ((btnUpload.x + btnUpload.width) + 5);
            txtTitle.x = 6;
            txtTitle.y = 2;
            fileList.setSize((_arg1 - 3), (_arg2 - 70));
            progressBar.y = (btnUpload.y - 10);
            progressBar.x = 20;
            txtPercent.y = ((progressBar.y - txtPercent.textHeight) - 4);
            txtPercent.x = ((progressBar.x + (txtPercent.width / 2)) + 4);
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
        protected function onCheckError(_arg1:Event):void{
            trace("读取文件列表发生错误");
        }
        protected function onGetFileList(_arg1:Event):void{
            var _local4:XML;
            var _local5:Object;
            var _local2:XML = XML(loader.data);
            var _local3:DataProvider = new DataProvider();
            for each (_local4 in _local2..File) {
                _local5 = new Object();
                _local5.fName = _local4.@name;
                _local5.folder = _local4.@folder;
                _local5.id = _local4.@id;
                _local5.totalFrame = _local4.@totalFrame;
                _local5.date = _local4.@date;
                _local3.addItem({
                    label:(((_local5.fName + "( 上传时间: ") + _local5.date) + ")"),
                    data:_local5
                });
            };
            fileList.dataProvider = _local3;
        }
        protected function progressHandler(_arg1:ProgressEvent):void{
            progressBar.setProgress(_arg1.bytesLoaded, _arg1.bytesTotal);
            if (_arg1.bytesLoaded == _arg1.bytesTotal){
                txtPercent.text = "上传完毕，现在正在转换PPT!";
            } else {
                txtPercent.text = (Math.floor(progressBar.percentComplete) + "%");
            };
        }
        protected function onCancel(_arg1:Event):void{
            btnOK.enabled = false;
            btnDel.enabled = false;
            this.visible = false;
            dispatchEvent(new AlertEvent(AlertEvent.CANCEL, null));
        }
        override protected function onWinClose(_arg1:MouseEvent):void{
            btnOK.enabled = false;
            btnDel.enabled = false;
            this.visible = false;
            dispatchEvent(new AlertEvent(AlertEvent.CANCEL, null));
        }
        protected function enableButtons(_arg1:Event):void{
            btnOK.enabled = true;
            btnDel.enabled = true;
        }

    }
}//package com.zlchat.ui 
