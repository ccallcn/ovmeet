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
    import flash.external.*;

    public class FileListPane extends BasePane {

        private var fileList:List;
        private var btnDownload:SimpleButton;
        private var btnDel:SimpleButton;
        private var loader:URLLoader;
        private var progressBar:ProgressBar;
        private var fileRef:FileReference;
        private var txtPercent:TextField;
        private var btnUpload:SimpleButton;

        public function FileListPane(){
            btnUpload = new BtnUpload();
            btnUpload.x = 2;
            btnUpload.y = 2;
            addChild(btnUpload);
            btnDownload = new BtnDownload();
            btnDownload.y = 2;
            btnDownload.x = (btnUpload.width + 6);
            addChild(btnDownload);
            btnDel = new BtnDelFile();
            btnDel.y = 2;
            btnDel.x = ((btnUpload.width * 2) + 10);
            addChild(btnDel);
            btnDel.addEventListener(MouseEvent.CLICK, delFile);
            btnDownload.addEventListener(MouseEvent.CLICK, downloadFile);
            btnDel.enabled = false;
            btnDownload.enabled = false;
            fileList = new List();
            fileList.setStyle("cellRenderer", FileItem);
            addChild(fileList);
            fileList.x = 2;
            fileList.y = (btnUpload.height + 4);
            fileList.rowHeight = 30;
            fileList.addEventListener(ListEvent.ITEM_CLICK, enableButtons);
            fileRef = new FileReference();
            fileRef.addEventListener(Event.SELECT, selectHandler);
            fileRef.addEventListener(Event.COMPLETE, completeHandler);
            fileRef.addEventListener(HTTPStatusEvent.HTTP_STATUS, uploadError);
            fileRef.addEventListener(IOErrorEvent.IO_ERROR, uploadError);
            fileRef.addEventListener(SecurityErrorEvent.SECURITY_ERROR, uploadError);
            fileRef.addEventListener(Event.OPEN, onOpen);
            fileRef.addEventListener(Event.CANCEL, uploadError);
            fileRef.addEventListener(ProgressEvent.PROGRESS, progressHandler);
            btnUpload.addEventListener(MouseEvent.CLICK, uploadFile);
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
        }
        protected function getFileList2(_arg1:Event):void{
            getFileList();
        }
        protected function uploadError(_arg1:Event):void{
            progressBar.visible = false;
            txtPercent.visible = false;
        }
        protected function onOpen(_arg1:Event):void{
            progressBar.visible = true;
            txtPercent.visible = true;
        }
        protected function completeHandler(_arg1:Event):void{
            progressBar.visible = false;
            txtPercent.visible = false;
            progressBar.setProgress(0, 1);
            txtPercent.text = "0%";
            nc.speakListSo.send("getFileList");
        }
        override public function Resize(_arg1:Number, _arg2:Number):void{
            super.Resize(_arg1, _arg2);
            fileList.setSize((_arg1 - 4), ((_arg2 - btnUpload.height) - 6));
            progressBar.y = ((btnUpload.height + 8) / 2);
            progressBar.x = ((btnUpload.width * 3) + 8);
            txtPercent.y = ((progressBar.y - txtPercent.textHeight) - 4);
            txtPercent.x = ((progressBar.x + (txtPercent.width / 2)) + 4);
        }
        override public function set conn(_arg1:ChatConnection){
            nc = _arg1;
            nc.addEventListener(ConnEvent.FILELIST, getFileList2);
            nc.addEventListener("setRole", onSetRole);
            getFileList();
            if (nc.role == "2"){
                btnDel.visible = true;
            } else {
                btnDel.visible = false;
            };
        }
        protected function onSetRole(_arg1:Event):void{
            if (nc.role == "2"){
                btnDel.visible = true;
            } else {
                btnDel.visible = false;
            };
        }
        protected function progressHandler(_arg1:ProgressEvent):void{
            progressBar.setProgress(_arg1.bytesLoaded, _arg1.bytesTotal);
            var _local2:Number = (_arg1.bytesLoaded / _arg1.bytesTotal);
            txtPercent.text = (Math.floor((_local2 * 100)) + "%");
        }
        protected function onCheckError(_arg1:Event):void{
            trace("读取文件列表发生错误");
        }
        protected function onGetFileList(_arg1:Event):void{
            var _local4:XML;
            var _local5:Object;
            var _local6:String;
            var _local2:XML = XML(loader.data);
            var _local3:DataProvider = new DataProvider();
            for each (_local4 in _local2..File) {
                _local5 = new Object();
                _local5.fName = _local4.@name;
                _local5.fileName = _local4.@fileName;
                _local5.id = _local4.@id;
                _local5.size = _local4.@size;
                _local5.date = _local4.@date;
                _local6 = new String();
                if (_local5.size > 0x0400){
                    _local6 = ((_local5.size / 0x0400) + " M");
                } else {
                    _local6 = (_local5.size + " k");
                };
                _local3.addItem({
                    label:(((((_local5.fName + "  ( 大小:") + _local6) + " 上传时间:") + _local5.date) + " )"),
                    data:_local5
                });
            };
            fileList.dataProvider = _local3;
        }
        protected function downloadFile(_arg1:MouseEvent):void{
            fileRef.removeEventListener(Event.SELECT, selectHandler);
            fileRef.download(new URLRequest(("./upload/" + fileList.selectedItem.data.fileName)), fileList.selectedItem.data.fName);
        }
        protected function delFile(_arg1:MouseEvent):void{
            loader = new URLLoader();
            var _local2:URLRequest = new URLRequest(((((("delFile." + nc.scriptType) + "?roomID=") + nc.roomID) + "&fileName=") + fileList.selectedItem.data.fileName));
            loader.load(_local2);
            nc.speakListSo.send("getFileList");
        }
        protected function uploadFile(_arg1:MouseEvent):void{
            fileRef.addEventListener(Event.SELECT, selectHandler);
            fileRef.browse();
        }
        protected function getFileList():void{
            loader = new URLLoader();
            var userRequest:* = new URLRequest(((("getFileList." + nc.scriptType) + "?roomID=") + nc.roomID));
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
        protected function selectHandler(_arg1:Event):void{
            var request:* = null;
            var event:* = _arg1;
            if (fileRef.size < ((20 * 0x0400) * 0x0400)){
                request = new URLRequest(((("uploadDoc." + nc.scriptType) + "?roomID=") + nc.roomID));
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
                ExternalInterface.call("alert", "传送的文件不能大于20M", null);
            };
        }
        protected function enableButtons(_arg1:ListEvent):void{
            btnDel.enabled = true;
            btnDownload.enabled = true;
        }

    }
}//package com.zlchat.ui 
