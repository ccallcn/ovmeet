//hong QQ:1410919373
package com.zlchat.ui {
    import fl.controls.*;
    import flash.display.*;
    import flash.geom.*;
    import flash.events.*;
    import flash.net.*;
    import com.zlchat.events.*;
    import com.zlchat.utils.*;
    import fl.events.*;
    import flash.text.*;
    import flash.utils.*;
    import com.zlchat.wb.*;

    public class WhiteBoardPane extends BasePane {

        private var txtPoint:Point;
        public var pptFolder:String = "";
        private var uploadWin:PPTUploadWin2;
        public var pptName:String = "";
        public var fileName:String;
        public var rectBorder:RectBorder;
        private var shapeMCList:Dictionary;
        private var rh:Number = 0;
        private var toolBar2:WbToolBar2;
        private var rw:Number = 0;
        private var preSprite:Sprite;
        private var toolBar:ToolBar;
        private var so:SharedObject;
        public var txtTemp:TextField;
        private var vSb:ScrollBar;
        private var maxH:Number = 2000;
        private var maxW:Number = 2000;
        private var fileRef:FileReference;
        private var maskSprite2:Sprite;
        private var indexPage:Number;
        public var totalFrame:int = 5;
        private var progressBar:ProgressBar;
        private var maskList:Array;
        private var txtPercent:TextField;
        private var p1:Point;
        private var p2:Point;
        private var p3:Point;
        private var selectedShape:String = "";
        public var isUpload:Boolean = true;
        private var pageList:Dictionary;
        private var maskSprite:Sprite;
        private var hSb:ScrollBar;
        public var drawMC:DrawMC;
        private var shapeList:Object;
        public var index:int = 0;
        public var realFileName:String;
        private var _h:Number = 0;
        private var totalPage:Number;
        private var _w:Number = 0;

        public function WhiteBoardPane(){
            txtPoint = new Point();
            super();
            shapeList = new Object();
            drawMC = new DrawMC();
            addChild(drawMC);
            drawMC.addEventListener(MouseEvent.MOUSE_DOWN, drawDown);
            drawMC.addEventListener(MouseEvent.MOUSE_UP, drawUp);
            shapeMCList = new Dictionary();
            maskList = new Array();
            maskSprite2 = new Sprite();
            addChild(maskSprite2);
            drawMC.mask = maskSprite2;
            hSb = new ScrollBar();
            hSb.direction = ScrollBarDirection.HORIZONTAL;
            addChild(hSb);
            hSb.visible = false;
            hSb.addEventListener(ScrollEvent.SCROLL, hScroll);
            vSb = new ScrollBar();
            vSb.direction = ScrollBarDirection.VERTICAL;
            addChild(vSb);
            vSb.visible = false;
            vSb.addEventListener(ScrollEvent.SCROLL, vScroll);
            toolBar = new ToolBar();
            addChild(toolBar);
            toolBar.wb = this;
            rectBorder = new RectBorder(100, 30);
            addChild(rectBorder);
            txtTemp = new TextField();
            addChild(txtTemp);
            txtTemp.x = 100;
            txtTemp.y = 100;
            rectBorder.x = 100;
            rectBorder.y = 100;
            txtTemp.type = TextFieldType.INPUT;
            txtTemp.wordWrap = true;
            txtTemp.autoSize = TextFieldAutoSize.LEFT;
            txtTemp.width = 97;
            txtTemp.height = 28;
            txtTemp.addEventListener(MouseEvent.MOUSE_UP, txtUp);
            txtTemp.addEventListener(MouseEvent.MOUSE_DOWN, txtDown);
            txtTemp.addEventListener(Event.CHANGE, txtChange);
            rectBorder.addEventListener(BorderEvent.RESIZE, bdResize);
            txtTemp.visible = false;
            rectBorder.visible = false;
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
            toolBar2 = new WbToolBar2();
            addChild(toolBar2);
            pageList = new Dictionary();
            toolBar2.la.addEventListener(MouseEvent.CLICK, onLA);
            toolBar2.ra.addEventListener(MouseEvent.CLICK, onRA);
            uploadWin = new PPTUploadWin2();
        }
        protected function drawDown(_arg1:MouseEvent):void{
            if (toolBar.selectedTool != ""){
                if (toolBar.selectedTool == "text"){
                    addChild(txtTemp);
                    txtTemp.x = mouseX;
                    txtTemp.y = mouseY;
                    rectBorder.x = mouseX;
                    rectBorder.y = mouseY;
                    txtTemp.width = 97;
                    txtTemp.height = 28;
                    rectBorder.Resize(100, 30);
                    txtTemp.visible = true;
                    rectBorder.visible = true;
                } else {
                    drawMC.selectedColor = toolBar.selectedColor;
                    drawMC.startDraw(toolBar.selectedTool);
                };
            };
        }
        public function loadImage(_arg1:String, _arg2:int):void{
            var _local3:*;
            var _local4:*;
            var _local5:Object;
            if (pptName != ""){
                _local3 = 1;
                while (_local3 <= totalPage) {
                    nc.call("clearWB", null, ("page" + _local3));
                    _local3++;
                };
                _local4 = 1;
                while (_local4 <= totalFrame) {
                    progressBar.visible = false;
                    txtPercent.visible = false;
                    progressBar.setProgress(0, 1);
                    txtPercent.text = "0%";
                    _local5 = new Object();
                    _local5.type = "img";
                    _local5.p1 = new Point(100, 100);
                    _local5.pos = new Point(0, 0);
                    _local5.img = (((("pptUpload/" + _arg1) + "/") + _local4) + ".JPG");
                    nc.call("newShape", null, _local5, ("page" + _local4));
                    isUpload = true;
                    _local4++;
                };
                nc.call("updatePages", null, 1, totalFrame);
            };
        }
        protected function onSetRole(_arg1:Event):void{
            if (nc.role == "4"){
                toolBar.visible = false;
                toolBar2.visible = false;
            } else {
                toolBar.visible = true;
                toolBar2.visible = true;
            };
        }
        public function onSendFile():void{
            var _local1:FileFilter;
            var _local2:Array;
            if (isUpload){
                _local1 = new FileFilter("Images (*.jpg, *.jpeg, *.gif, *.png)", "*.jpg; *.jpeg; *.gif; *.png");
                _local2 = new Array(_local1);
                fileRef.browse(_local2);
            };
        }
        protected function txtUp(_arg1:MouseEvent):void{
            drawMC.addEventListener(MouseEvent.MOUSE_DOWN, stageDown);
            txtPoint.x = txtTemp.x;
            txtPoint.y = txtTemp.y;
        }
        protected function txtDown(_arg1:MouseEvent):void{
            rectBorder.visible = true;
            var _local2:TextFormat = new TextFormat();
            _local2.color = toolBar.selectedColor;
            txtTemp.setTextFormat(_local2);
        }
        protected function txtChange(_arg1:Event):void{
            if (txtTemp.height > rectBorder.height){
                rectBorder.Resize((txtTemp.width + 5), (txtTemp.height + 5));
            };
        }
        protected function hScroll(_arg1:ScrollEvent):void{
            shapeMCList[indexPage].x = (0 - _arg1.position);
            drawMC.x = (0 - _arg1.position);
        }
        public function delShape():void{
            if (selectedShape != ""){
                pageList[indexPage].setProperty(selectedShape, null);
                selectedShape = "";
            };
        }
        protected function checkSB():void{
            if (_w < maxW){
                hSb.visible = true;
                hSb.maxScrollPosition = (maxW - _w);
            } else {
                hSb.visible = false;
            };
            if (_h < maxH){
                vSb.visible = true;
                vSb.maxScrollPosition = (maxH - _h);
            } else {
                vSb.visible = false;
            };
        }
        override public function set conn(_arg1:ChatConnection){
            nc = _arg1;
            drawMC.nc = nc;
            so = SharedObject.getRemote("whiteboard", nc.uri, false);
            so.addEventListener(SyncEvent.SYNC, onWbSync);
            so.connect(nc);
            uploadWin.conn = nc;
            uploadWin.pptPane = this;
            nc.addEventListener("setRole", onSetRole);
            if (nc.role == "4"){
                toolBar.visible = false;
                toolBar2.visible = false;
            };
        }
        protected function onUploadCancel(_arg1:Event):void{
        }
        private function onRA(_arg1:MouseEvent):void{
            indexPage++;
            if (indexPage > totalPage){
                totalPage = indexPage;
            };
            drawMC.indexPage = indexPage;
            toolBar2.txtPage.text = ((indexPage + "/") + totalPage);
            nc.call("updatePages", null, indexPage, totalPage);
        }
        protected function resizeUp(_arg1:MouseEvent):void{
            _arg1.currentTarget.stopDrag();
            p2 = new Point(_arg1.currentTarget.x, _arg1.currentTarget.y);
            var _local2:String = _arg1.currentTarget.name;
            var _local3:Object = pageList[indexPage].data[_local2];
            if (_local3 != null){
                _local3.pos = p2;
                nc.call("editShape", null, _local2, _local3, ("page" + indexPage));
            };
        }
        protected function progressHandler(_arg1:ProgressEvent):void{
            progressBar.setProgress(_arg1.bytesLoaded, _arg1.bytesTotal);
            txtPercent.text = (Math.floor(progressBar.percentComplete) + "%");
        }
        protected function removeShape(_arg1:String):void{
            var shape:* = null;
            var shapeName:* = _arg1;
            try {
                shape = shapeList[shapeName];
                shapeMCList[indexPage].removeChild(shape);
                shapeList[shapeName] = null;
            } catch(e:Error) {
            };
        }
        protected function uploadError(_arg1:Event):void{
            isUpload = true;
            progressBar.visible = false;
            txtPercent.visible = false;
        }
        private function onLA(_arg1:MouseEvent):void{
            indexPage--;
            if (indexPage < 1){
                indexPage = 1;
            };
            drawMC.indexPage = indexPage;
            toolBar2.txtPage.text = ((indexPage + "/") + totalPage);
            nc.call("updatePages", null, indexPage, totalPage);
        }
        protected function bdResize(_arg1:BorderEvent):void{
            txtTemp.width = _arg1.rect.w;
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
        protected function onWbSharpSync(_arg1:SyncEvent):void{
            var _local2:*;
            var _local3:*;
            var _local4:Object;
            for (_local2 in _arg1.changeList) {
                _local3 = _arg1.changeList[_local2];
                switch (_local3.code){
                    case "change":
                        if (((!((_local3.name == "lastID"))) && (!((_local3.name == "indexPage"))))){
                            _local4 = _arg1.target.data[_local3.name];
                            if (_local4 != null){
                                drawShape(_local3.name, _local4, _arg1.target.data["indexPage"]);
                            };
                        };
                        break;
                    case "delete":
                        if (((!((_local3.name == "lastID"))) && (!((_local3.name == "indexPage"))))){
                            removeShape(_local3.name);
                        };
                        break;
                };
            };
        }
        protected function drawShape(_arg1:String, _arg2:Object, _arg3:Number):void{
            var _local5:Sprite;
            var _local6:Point;
            var _local7:Point;
            var _local8:Array;
            var _local9:TextField;
            var _local10:TextFormat;
            var _local11:Loader;
            var _local12:*;
            var _local13:*;
            var _local4:Boolean;
            _local5 = shapeList[_arg1];
            if (_local5 != null){
                _local4 = false;
            } else {
                _local5 = new Sprite();
                shapeMCList[_arg3].addChild(_local5);
                shapeList[_arg1] = _local5;
                _local5.name = _arg1;
                _local5.addEventListener(MouseEvent.CLICK, shapeSelect);
                _local5.addEventListener(MouseEvent.MOUSE_DOWN, resizePress);
                _local5.addEventListener(MouseEvent.MOUSE_UP, resizeUp);
            };
            switch (_arg2.type){
                case "line":
                    _local6 = new Point(_arg2.p1.x, _arg2.p1.y);
                    _local7 = new Point(_arg2.p2.x, _arg2.p2.y);
                    line(_local5, _local6, _local7, _arg2.color);
                    break;
                case "rect":
                    _local6 = new Point(_arg2.p1.x, _arg2.p1.y);
                    _local7 = new Point(_arg2.p2.x, _arg2.p2.y);
                    rect(_local5, _local6, _local7, _arg2.color);
                    break;
                case "circle":
                    _local6 = new Point(_arg2.p1.x, _arg2.p1.y);
                    circle(_local5, _local6, _arg2.r, _arg2.color);
                    break;
                case "pen":
                    _local8 = _arg2.ptArray;
                    _local5.graphics.lineStyle(2, _arg2.color);
                    _local12 = 0;
                    while (_local12 < _local8.length) {
                        _local13 = _local8[_local12];
                        if (_local12 == 0){
                            _local5.graphics.moveTo(_local13.x, _local13.y);
                        } else {
                            _local5.graphics.lineTo(_local13.x, _local13.y);
                        };
                        _local12++;
                    };
                    break;
                case "text":
                    _local9 = new TextField();
                    _local9.text = _arg2.text;
                    _local9.wordWrap = true;
                    _local9.autoSize = TextFieldAutoSize.LEFT;
                    _local9.width = _arg2.w;
                    _local9.x = _arg2.p1.x;
                    _local9.y = _arg2.p1.y;
                    _local5.addChild(_local9);
                    _local10 = new TextFormat();
                    _local10.color = _arg2.color;
                    _local9.setTextFormat(_local10);
                    break;
                case "img":
                    _local11 = new Loader();
                    isUpload = true;
                    _local11.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
                    _local11.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, progressHandler);
                    _local11.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, uploadError);
                    _local11.contentLoaderInfo.addEventListener(Event.OPEN, onOpen);
                    _local11.load(new URLRequest(_arg2.img));
                    _local5.addChild(_local11);
                    shapeMCList[_arg3].addChildAt(_local5, 0);
                    break;
            };
            _local5.x = _arg2.pos.x;
            _local5.y = _arg2.pos.y;
        }
        protected function stageDown(_arg1:MouseEvent):void{
            var _local2:Object;
            rectBorder.visible = false;
            txtTemp.visible = false;
            if (txtTemp.text != ""){
                _local2 = new Object();
                _local2.type = "text";
                _local2.color = toolBar.selectedColor;
                _local2.text = txtTemp.text;
                _local2.p1 = txtPoint;
                _local2.w = txtTemp.width;
                _local2.pos = new Point(0, 0);
                nc.call("newShape", null, _local2, ("page" + indexPage));
            };
            txtTemp.text = "";
            drawMC.removeEventListener(MouseEvent.MOUSE_DOWN, stageDown);
        }
        protected function onWbSync(_arg1:SyncEvent):void{
            var _local2:*;
            var _local3:*;
            var _local4:*;
            var _local5:*;
            var _local6:Sprite;
            var _local7:Sprite;
            for (_local2 in _arg1.changeList) {
                _local4 = _arg1.changeList[_local2];
                switch (_local4.code){
                    case "change":
                        if (_local4.name == "totalPage"){
                            totalPage = so.data[_local4.name];
                        } else {
                            if (_local4.name == "indexPage"){
                                indexPage = so.data[_local4.name];
                                drawMC.indexPage = indexPage;
                            };
                        };
                        break;
                };
            };
            _local3 = 1;
            while (_local3 <= totalPage) {
                if (_local3 != indexPage){
                    if (shapeMCList[_local3] != null){
                        shapeMCList[_local3].visible = false;
                    };
                } else {
                    if (pageList[_local3] == null){
                        _local5 = SharedObject.getRemote(("page" + _local3), nc.uri, false);
                        _local5.addEventListener(SyncEvent.SYNC, onWbSharpSync);
                        _local5.connect(nc);
                        pageList[_local3] = _local5;
                        _local6 = new Sprite();
                        addChild(_local6);
                        shapeMCList[_local3] = _local6;
                        _local7 = new Sprite();
                        addChild(_local7);
                        shapeMCList[_local3].mask = _local7;
                        maskList.push(_local7);
                    };
                    shapeMCList[_local3].visible = true;
                    addChild(shapeMCList[_local3]);
                };
                _local3++;
            };
            Resize(_w, _h);
            toolBar2.txtPage.text = ((indexPage + "/") + totalPage);
            addChild(drawMC);
            addChild(toolBar);
            addChild(toolBar2);
        }
        protected function onOpen(_arg1:Event):void{
            progressBar.visible = true;
            txtPercent.visible = true;
        }
        public function circle(_arg1:Sprite, _arg2:Point, _arg3:Number, _arg4:int){
            _arg1.graphics.clear();
            _arg1.graphics.lineStyle(2, _arg4);
            _arg1.graphics.moveTo((_arg2.x + _arg3), _arg2.y);
            _arg1.graphics.curveTo((_arg3 + _arg2.x), ((Math.tan((Math.PI / 8)) * _arg3) + _arg2.y), ((Math.cos((Math.PI / 4)) * _arg3) + _arg2.x), ((Math.sin((Math.PI / 4)) * _arg3) + _arg2.y));
            _arg1.graphics.curveTo(((Math.tan((Math.PI / 8)) * _arg3) + _arg2.x), (_arg3 + _arg2.y), _arg2.x, (_arg3 + _arg2.y));
            _arg1.graphics.curveTo(((-(Math.tan((Math.PI / 8))) * _arg3) + _arg2.x), (_arg3 + _arg2.y), ((-(Math.cos((Math.PI / 4))) * _arg3) + _arg2.x), ((Math.sin((Math.PI / 4)) * _arg3) + _arg2.y));
            _arg1.graphics.curveTo((-(_arg3) + _arg2.x), ((Math.tan((Math.PI / 8)) * _arg3) + _arg2.y), (-(_arg3) + _arg2.x), _arg2.y);
            _arg1.graphics.curveTo((-(_arg3) + _arg2.x), ((-(Math.tan((Math.PI / 8))) * _arg3) + _arg2.y), ((-(Math.cos((Math.PI / 4))) * _arg3) + _arg2.x), ((-(Math.sin((Math.PI / 4))) * _arg3) + _arg2.y));
            _arg1.graphics.curveTo(((-(Math.tan((Math.PI / 8))) * _arg3) + _arg2.x), (-(_arg3) + _arg2.y), _arg2.x, (-(_arg3) + _arg2.y));
            _arg1.graphics.curveTo(((Math.tan((Math.PI / 8)) * _arg3) + _arg2.x), (-(_arg3) + _arg2.y), ((Math.cos((Math.PI / 4)) * _arg3) + _arg2.x), ((-(Math.sin((Math.PI / 4))) * _arg3) + _arg2.y));
            _arg1.graphics.curveTo((_arg3 + _arg2.x), ((-(Math.tan((Math.PI / 8))) * _arg3) + _arg2.y), (_arg3 + _arg2.x), _arg2.y);
        }
        override public function Resize(_arg1:Number, _arg2:Number):void{
            var _local3:Object;
            super.Resize(_arg1, _arg2);
            _w = _arg1;
            _h = _arg2;
            drawMC.Resize(maxW, maxH);
            for (_local3 in maskList) {
                maskList[_local3].graphics.clear();
                maskList[_local3].graphics.beginFill(0xFFFFFF, 0);
                maskList[_local3].graphics.drawRect(0, 0, (_arg1 - 16), (_arg2 - 16));
            };
            maskSprite2.graphics.clear();
            maskSprite2.graphics.beginFill(0xFFFFFF, 0);
            maskSprite2.graphics.drawRect(0, 0, (_arg1 - 16), (_arg2 - 16));
            hSb.width = _arg1;
            hSb.y = (_arg2 - hSb.height);
            vSb.height = _arg2;
            vSb.x = (_arg1 - vSb.width);
            checkSB();
            toolBar2.x = ((_arg1 - toolBar2.width) - 20);
            toolBar2.y = ((_arg2 - toolBar2.height) - 20);
        }
        protected function completeHandler(_arg1:Event):void{
            var _local2:Object;
            progressBar.visible = false;
            txtPercent.visible = false;
            progressBar.setProgress(0, 1);
            txtPercent.text = "0%";
            if (isUpload){
            } else {
                _local2 = new Object();
                _local2.type = "img";
                _local2.p1 = new Point(100, 100);
                _local2.pos = new Point(0, 0);
                _local2.img = ("wbUpload/" + realFileName);
                nc.call("newShape", null, _local2, ("page" + indexPage));
                isUpload = true;
            };
        }
        protected function selectHandler(_arg1:Event):void{
            var request:* = null;
            var event:* = _arg1;
            if (isUpload){
                fileName = fileRef.name;
                realFileName = getFileName(fileRef.name);
                isUpload = false;
                request = new URLRequest(((("wbUpload." + nc.scriptType) + "?fileName=") + realFileName));
                try {
                    fileRef.upload(request);
                    progressBar.maximum = fileRef.size;
                    progressBar.minimum = 100;
                    progressBar.visible = true;
                    txtPercent.visible = true;
                } catch(error:Error) {
                    trace("Unable to upload file.");
                };
            };
        }
        public function openPPT():void{
            AlertManager.showWin(uploadWin, 200, 100);
            uploadWin.getFileList();
        }
        protected function vScroll(_arg1:ScrollEvent):void{
            shapeMCList[indexPage].y = (0 - _arg1.position);
            drawMC.y = (0 - _arg1.position);
        }
        public function rect(_arg1:Sprite, _arg2:Point, _arg3:Point, _arg4:int):void{
            _arg1.graphics.clear();
            _arg1.graphics.lineStyle(2, _arg4);
            _arg1.graphics.drawRect(_arg2.x, _arg2.y, (_arg3.x - _arg2.x), (_arg3.y - _arg2.y));
        }
        public function clearWB():void{
            nc.call("clearWB", null, ("page" + indexPage));
        }
        protected function resizePress(_arg1:MouseEvent):void{
            shapeMCList[indexPage].addChild(Sprite(_arg1.currentTarget));
            p1 = new Point(_arg1.currentTarget.x, _arg1.currentTarget.y);
            _arg1.currentTarget.startDrag();
        }
        public function line(_arg1:Sprite, _arg2:Point, _arg3:Point, _arg4:int):void{
            _arg1.graphics.clear();
            _arg1.graphics.lineStyle(2, _arg4);
            _arg1.graphics.moveTo(_arg2.x, _arg2.y);
            _arg1.graphics.lineTo(_arg3.x, _arg3.y);
        }
        protected function shapeSelect(_arg1:MouseEvent):void{
            if ((((toolBar.selectedTool == "array")) || ((toolBar.selectedTool == "del")))){
                selectedShape = _arg1.currentTarget.name;
                _arg1.currentTarget.alpha = 0.5;
                if (preSprite != null){
                    preSprite.alpha = 1;
                };
                preSprite = (_arg1.currentTarget as Sprite);
                if (toolBar.selectedTool == "del"){
                    delShape();
                };
            };
        }
        protected function drawUp(_arg1:MouseEvent):void{
            if (toolBar.selectedTool != ""){
                drawMC.stopDraw(toolBar.selectedTool);
            };
        }

    }
}//package com.zlchat.ui 
