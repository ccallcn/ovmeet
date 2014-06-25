//hong QQ:1410919373
package com.zlchat.ui {
    import flash.display.*;
    import flash.events.*;
    import com.zlchat.events.*;
    import flash.filters.*;

    public class AlertManager extends Sprite {

        public static var dlg:Sprite = null;
        public static var msgBox:MessageBox = null;
        public static var _alertManager:AlertManager = null;
        public static var _overlay:Sprite = null;
        public static var _rootMC:Sprite = null;
        public static var _stage:Stage = null;

        public function AlertManager(){
            _stage = _rootMC.stage;
            _overlay = new Sprite();
            _overlay.visible = true;
            addChild(_overlay);
            _stage.addChild(this);
            _stage.addEventListener(Event.RESIZE, stageResizeHandler, false, 0, true);
            _stage.addEventListener(Event.FULLSCREEN, stageResizeHandler, false, 0, true);
            msgBox = new MessageBox();
            this.addChild(msgBox);
            msgBox.visible = false;
            msgBox.addEventListener(AlertEvent.CANCEL, onCancel);
            msgBox.addEventListener(AlertEvent.OK, onOK);
            draw();
        }
        public static function showMessageBox(_arg1:String):void{
            if (_alertManager == null){
                _alertManager = new (AlertManager)();
            };
            _overlay.visible = true;
            msgBox.label = _arg1;
            msgBox.visible = true;
        }
        public static function showWin(_arg1:Sprite, _arg2:Number, _arg3:Number):void{
            dlg = _arg1;
            if (_alertManager == null){
                _alertManager = new (AlertManager)();
            };
            _alertManager.init();
            _arg1.x = _arg2;
            _arg1.y = _arg3;
            _stage.addChild(_arg1);
            _arg1.visible = true;
            _overlay.visible = true;
        }
        public static function hideAll():void{
            if (_overlay != null){
                _overlay.visible = false;
            };
            if (dlg != null){
                dlg.visible = false;
            };
            if (msgBox != null){
            };
            msgBox.visible = false;
        }

        protected function init():void{
            dlg.addEventListener(AlertEvent.CANCEL, onCancel);
            dlg.addEventListener(AlertEvent.OK, onOK);
        }
        protected function draw():void{
            _overlay.graphics.clear();
            _overlay.graphics.beginFill(0xEEEEEE, 0.2);
            _overlay.graphics.drawRect(0, 0, _stage.stageWidth, _stage.stageHeight);
            _overlay.graphics.endFill();
            msgBox.x = ((_stage.stageWidth - msgBox.width) / 2);
            msgBox.y = ((_stage.stageHeight - msgBox.height) / 2);
        }
        function getBlurFilter():BitmapFilter{
            var _local1:BlurFilter = new BlurFilter();
            _local1.blurX = 2;
            _local1.blurY = 2;
            _local1.quality = BitmapFilterQuality.HIGH;
            return (_local1);
        }
        protected function stageResizeHandler(_arg1:Event):void{
            draw();
        }
        protected function onCancel(_arg1:Event):void{
            _overlay.visible = false;
        }
        protected function onOK(_arg1:Event):void{
            _overlay.visible = false;
        }

    }
}//package com.zlchat.ui 
