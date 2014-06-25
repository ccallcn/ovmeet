//hong QQ:1410919373
package com.zlchat.ui {
    import flash.display.*;
    import flash.events.*;
    import com.zlchat.events.*;
    import com.zlchat.utils.*;
    import com.zlchat.mainapp.*;
    import flash.text.*;

    public class ClientWin extends ResizeWin {

        private var btnFullQuit:SimpleButton;
        private var jkPane:VideoViewPane;
        private var txtTip:TextField;
        private var dp:Array;
        private var btnFullScreen:SimpleButton;
        private var tabPane:TabPane;
        public var _rootMC:MainApp;

        public function ClientWin(_arg1:Number, _arg2:Number){
            super(_arg1, _arg2);
            tabPane = new TabPane((_arg1 - 2), (_arg2 - 28));
            tabPane.addEventListener("switch", onSwitchPane);
			
            dp = new Array();
            dp.push({
                label:"文本交流",
                pane:new TextChatPane()
            });
   
	    dp.push({
                label:"电子白板",
                pane:new WhiteBoardPane()
            });
            dp.push({
                label:"共享文档",
                pane:new FileListPane()
            });
	    
            dp.push({
                label:"影音中心",
                pane:new MediaListPane()
            });
 		 
            jkPane = new VideoViewPane();
            tabPane.dataProvider = dp;
            addChild(tabPane);
            tabPane.x = 2;
            tabPane.y = 30;
            BtnResize.visible = true;
            BtnMax.visible = true;
            BtnRestore.visible = true;
            BtnClose.visible = false;
            addChild(BtnResize);
            btnFullScreen = new BtnFullScreen2_2();
            btnFullScreen.width = 16;
            btnFullScreen.height = 16;
            btnFullQuit = new BtnCloseFull2_2();
            btnFullQuit.width = 16;
            btnFullQuit.height = 16;
            //addChild(btnFullQuit);
            //addChild(btnFullScreen);
            btnFullScreen.addEventListener(MouseEvent.CLICK, onFullScr);
            btnFullQuit.addEventListener(MouseEvent.CLICK, onFullQuit);
            btnFullScreen.addEventListener(MouseEvent.MOUSE_OVER, FullScreenOnOver);
            btnFullScreen.addEventListener(MouseEvent.MOUSE_OUT, OnOut);
            btnFullQuit.addEventListener(MouseEvent.MOUSE_OVER, FullQuitOnOver);
            btnFullQuit.addEventListener(MouseEvent.MOUSE_OUT, OnOut);
            txtTip = new TextField();
            txtTip.autoSize = TextFieldAutoSize.LEFT;
            txtTip.textColor = 0xFF0000;
            addChild(txtTip);
            txtTip.visible = false;
        }
        override protected function onMin(_arg1:MouseEvent):void{
            super.onMin(_arg1);
            tabPane.visible = false;
        }
	//全屏
        private function onFullScr(_arg1:MouseEvent):void{
            btnFullScreen.visible = false;
            btnFullQuit.visible = true;
            stage.displayState = "fullScreen";
            parent.addChild(this);
            this.x = 0;
            this.y = 0;
            Resize(stage.stageWidth, stage.stageHeight);
        }
	//最大
        override protected function onMax(_arg1:MouseEvent):void{
            super.onMax(_arg1);
            //this.x = 5;
            this.x = 0;
	    this.y = 33;
            Resize((stage.stageWidth), (stage.stageHeight - 60));
        }
        override protected function onWinClose(_arg1:MouseEvent):void{
            this.visible = false;
        }
        private function OnOut(_arg1:MouseEvent):void{
            txtTip.visible = false;
        }
        private function FullQuitOnOver(_arg1:MouseEvent):void{
            showTip("退出全屏");
        }
        override public function Resize(_arg1:Number, _arg2:Number):void{
            super.Resize(_arg1, _arg2);
            graphics.clear();
            drawBg(_arg1, _arg2);
            btnFullScreen.y = (btnFullQuit.y = 6);
            btnFullScreen.x = (btnFullQuit.x = (_arg1 - 50));
            tabPane.Resize((_arg1 - 4), (_arg2 - 32));
        }
        protected function onSetRole(_arg1:Event):void{
            if (nc.role == "2"){
                if (tabPane.panes.length < 5){
                   // tabPane.addPane("视频监控", jkPane);
                };
            } else {
                if (jkPane != null){
                    jkPane.stopAllJK();
                };
                tabPane.delPane(4);
            };
        }
        private function showTip(_arg1:String):void{
            txtTip.x = (mouseX + 15);
            txtTip.y = (mouseY - 20);
            txtTip.text = _arg1;
            addChild(txtTip);
            txtTip.visible = true;
        }
        override public function set conn(_arg1:ChatConnection){
            nc = _arg1;
            tabPane.conn = nc;
            nc.addEventListener("syncUI", syncUI);
            nc.addEventListener("setRole", onSetRole);
            if (nc.role == "2"){
                if (tabPane.panes.length < 5){
                    // tabPane.addPane("视频监控", jkPane);
                };
            };
        }
        private function FullScreenOnOver(_arg1:MouseEvent):void{
            showTip("全屏");
        }
        protected function syncUI(_arg1:RoomInfoEvent):void{
            if (nc.roomInfoSo.data["sync_ui"] == true){
                tabPane.selectPane(int(_arg1.key));
            };
        }
	//最大还原
        override protected function onRestore(_arg1:MouseEvent):void{
            super.onRestore(_arg1);
            tabPane.visible = true;
            //this.x = 328;
            this.x =(stage.stageWidth-2)*0.25+1;
	    this.y = (stage.stageHeight - 60)*0.6+33;
            Resize((stage.stageWidth-2)*0.5, (stage.stageHeight - 60)*0.4);
        }
        protected function onSwitchPane(_arg1:TabEvent):void{
            if (nc.role == "2"){
                if (nc.roomInfoSo.data["sync_ui"] == true){
                    nc.roomInfoSo.setProperty("uiIndex", _arg1.key);
                };
            };
        }
	//退出最大
        private function onFullQuit(_arg1:MouseEvent):void{
            stage.displayState = "normal";
            this.x =(stage.stageWidth-2)*0.25+1;
	    this.y = (stage.stageHeight - 60)*0.6+33;
            Resize((stage.stageWidth-2)*0.5, (stage.stageHeight - 60)*0.4);
            btnFullScreen.visible = true;
            btnFullQuit.visible = false;
        }

    }
}//package com.zlchat.ui 
