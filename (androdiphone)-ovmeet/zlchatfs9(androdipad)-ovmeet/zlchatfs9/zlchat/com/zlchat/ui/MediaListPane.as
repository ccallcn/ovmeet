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

    public class MediaListPane extends BasePane {

        private var fileList:List;
        private var recordWin:RecordWin;
        private var btnRecord:SimpleButton;
        private var btnDel:SimpleButton;
        private var loader:URLLoader;
        private var progressBar:ProgressBar;
        private var btnPlay:SimpleButton;
        private var txtPercent:TextField;
        private var fileRef:FileReference;
        private var playerWin:PlayerWin;
        private var btnUpload:Button;

        public function MediaListPane(){
            btnUpload = new Button();
            btnUpload.x = 2;
            btnUpload.y = 2;
            btnUpload.width = 70;
            btnRecord = new BtnRecordVideo();
            btnRecord.y = 2;
            btnRecord.width = 70;
            btnRecord.x = 2;
            addChild(btnRecord);
            btnRecord.addEventListener(MouseEvent.CLICK, showRecordWin);
            btnPlay = new BtnPlayVideo();
            btnPlay.y = 2;
            btnPlay.width = 70;
            btnPlay.x = (btnUpload.width + 6);
            addChild(btnPlay);
            btnPlay.addEventListener(MouseEvent.CLICK, playFile);
            btnDel = new BtnDelVideo();
            btnDel.y = 2;
            btnDel.width = 70;
            btnDel.x = ((btnDel.width * 2) + 10);
            addChild(btnDel);
            btnDel.addEventListener(MouseEvent.CLICK, delFile);
            btnDel.enabled = false;
            btnRecord.enabled = true;
            btnPlay.enabled = false;
            fileList = new List();
            addChild(fileList);
            fileList.x = 2;
            fileList.y = (btnUpload.height + 4);
            fileList.rowHeight = 30;
            fileList.setStyle("cellRenderer", FileItem);
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
            recordWin = new RecordWin(247, 240);
            addChild(recordWin);
            recordWin.x = 100;
            recordWin.y = 100;
            recordWin.visible = false;
            playerWin = new PlayerWin(327, 270);
            addChild(playerWin);
            playerWin.x = 100;
            playerWin.y = 100;
            playerWin.visible = false;
        }
        protected function selectHandler(_arg1:Event):void{
            var event:* = _arg1;
            var request:* = new URLRequest(((("uploadDoc." + nc.scriptType) + "?roomID=") + nc.roomID));
            try {
                fileRef.upload(request);
                progressBar.maximum = fileRef.size;
                progressBar.minimum = 100;
                progressBar.visible = true;
                txtPercent.visible = true;
            } catch(error:Error) {
                trace("Unable to upload file.");
            };
        }
        protected function uploadError(_arg1:Event):void{
            progressBar.visible = false;
            txtPercent.visible = false;
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
        protected function onOpen(_arg1:Event):void{
            progressBar.visible = true;
            txtPercent.visible = true;
        }
        protected function showRecordWin(_arg1:MouseEvent):void{
            recordWin.visible = true;
        }
        protected function playFile(_arg1:MouseEvent):void{
            playerWin.visible = true;
            playerWin.playVod(fileList.selectedItem.data);
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
            recordWin.conn = _arg1;
            playerWin.conn = _arg1;
            getVodList();
            nc.addEventListener("getVodList", getVodList2);
            nc.addEventListener("setRole", onSetRole);
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
        protected function uploadFile(_arg1:MouseEvent):void{
            fileRef.browse();
        }
        protected function onCheckError(_arg1:Event):void{
            trace("读取文件列表发生错误");
        }
        protected function getVodList():void{
            nc.call("vodService.getListOfAvailableFLVs", new Responder(onVodList));
        }
        protected function downloadFile(_arg1:MouseEvent):void{
            fileRef.download(new URLRequest(("./upload/" + fileList.selectedItem.data.fileName)), fileList.selectedItem.data.fName);
        }
        protected function delFile(_arg1:MouseEvent):void{
            nc.call("vodService.delVod", null, (fileList.selectedItem.data + ".flv"));
            nc.speakListSo.send("getVodList");
        }
        protected function onGetFileList(_arg1:Event):void{
            var _local4:XML;
            var _local5:Object;
            var _local2:XML = XML(loader.data);
            var _local3:DataProvider = new DataProvider();
            for each (_local4 in _local2..File) {
                _local5 = new Object();
                _local5.fName = _local4.@name;
                _local5.fileName = _local4.@fileName;
                _local5.id = _local4.@id;
                _local3.addItem({
                    label:_local5.fName,
                    data:_local5
                });
            };
            fileList.dataProvider = _local3;
        }
        protected function progressHandler(_arg1:ProgressEvent):void{
            progressBar.setProgress(_arg1.bytesLoaded, _arg1.bytesTotal);
            txtPercent.text = (Math.floor(progressBar.percentComplete) + "%");
        }
        protected function onVodList(_arg1:Array):void{
            var _local2:String;
            var _local3:Object;
            fileList.removeAll();
            for (_local2 in _arg1) {
                _local3 = _arg1[_local2];
                fileList.addItem({
                    label:(((((_local3.flvName + "   (大小: ") + _local3.size) + "k  创建日期: ") + _local3.lastModified) + ")"),
                    data:_local3.flvName
                });
            };
        }
        protected function enableButtons(_arg1:ListEvent):void{
            btnRecord.enabled = true;
            btnPlay.enabled = true;
            btnDel.enabled = true;
        }
        protected function getVodList2(_arg1:Event):void{
            getVodList();
        }

    }
}//package com.zlchat.ui 
