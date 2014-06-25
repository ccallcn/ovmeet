//hong QQ:1410919373
package com.zlchat.ui {
    import flash.display.*;
    import flash.events.*;
    import com.zlchat.events.*;
    import com.zlchat.utils.*;

    public class TabPane extends Sprite {

        private var _h:Number;
        public var panes:Array;
        private var tabButtons:Array;
        private var dp:Array;
        protected var nc:ChatConnection;
        private var _w:Number;

        public function TabPane(_arg1:Number, _arg2:Number){
            tabButtons = new Array();
            panes = new Array();
            super();
            Resize(_arg1, _arg2);
        }
        public function addPane(_arg1:String, _arg2:BasePane):void{
            var _local3:TabButton = new TabButton(_arg1);
            addChild(_local3);
            _local3.visible = true;
            _local3.y = 2;
            _local3.addEventListener(MouseEvent.CLICK, btnClick);
            tabButtons.push(_local3);
            var _local4:BasePane = _arg2;
            panes.push(_local4);
            addChild(_local4);
            _local4.x = 0;
            _local4.y = 28;
            _local4.visible = true;
            _local4.conn = nc;
            Resize(_w, _h);
            selectPane(0);
        }
        public function delPane(_arg1:int):void{
            var _local2:TabButton;
            var _local3:BasePane;
            if (tabButtons.length == (_arg1 + 1)){
                _local2 = tabButtons[_arg1];
                _local2.visible = false;
                _local3 = panes[_arg1];
                _local3.visible = false;
                tabButtons.splice(_arg1, 1);
                panes.splice(_arg1, 1);
                Resize(_w, _h);
                selectPane(0);
            };
        }
        protected function btnClick(_arg1:MouseEvent):void{
            var _local3:MovieClip;
            var _local2:* = 0;
            while (_local2 < tabButtons.length) {
                _local3 = tabButtons[_local2];
                if (_arg1.target != _local3){
                    _local3.changeState(1);
                } else {
                    _local3.changeState(2);
                    addChild(panes[_local2]);
                    dispatchEvent(new TabEvent("switch", _local2));
                };
                _local2++;
            };
        }
        protected function drawLine(_arg1:Number, _arg2:Number){
            graphics.lineStyle(1, 4354701);
            graphics.moveTo(0, 27);
            graphics.lineTo(_arg1, 27);
        }
        public function changeLabel(_arg1:String, _arg2:int):void{
            tabButtons[_arg2].label = _arg1;
        }
        protected function drawBg(_arg1:Number, _arg2:Number){
            graphics.beginFill(0xFFFFFF);
            graphics.drawRect(0, 0, _arg1, _arg2);
            graphics.endFill();
        }
        public function set conn(_arg1:ChatConnection){
            var _local2:*;
            nc = _arg1;
            for (_local2 in panes) {
                panes[_local2].conn = nc;
            };
        }
        public function Resize(_arg1:Number, _arg2:Number):void{
            var _local4:Sprite;
            var _local5:BasePane;
            graphics.clear();
            drawBg(_arg1, _arg2);
            drawLine(_arg1, _arg2);
            _w = _arg1;
            _h = _arg2;
            var _local3:* = 0;
            while (_local3 < tabButtons.length) {
                _local4 = tabButtons[_local3];
                _local4.x = ((_local3 * _local4.width) + ((_local3 + 1) * 2));
                _local3++;
            };
            _local3 = 0;
            while (_local3 < panes.length) {
                _local5 = panes[_local3];
                _local5.Resize(_arg1, (_arg2 - 28));
                _local3++;
            };
        }
        public function get dataProvider():Array{
            return (dp);
        }
        public function selectPane(_arg1:int):void{
            var _local3:MovieClip;
            if ((((_arg1 < 0)) || ((_arg1 > (tabButtons.length - 1))))){
                return;
            };
            var _local2:* = 0;
            while (_local2 < tabButtons.length) {
                _local3 = tabButtons[_local2];
                if (_local2 != _arg1){
                    _local3.changeState(1);
                } else {
                    _local3.changeState(2);
                    addChild(panes[_local2]);
                };
                _local2++;
            };
        }
        public function set dataProvider(_arg1:Array):void{
            var _local2:Object;
            var _local3:TabButton;
            var _local4:Sprite;
            if (_arg1 != null){
                tabButtons = new Array();
                panes = new Array();
                for (_local2 in _arg1) {
                    _local3 = new TabButton(_arg1[_local2].label);
                    addChild(_local3);
                    _local3.y = 2;
                    _local3.addEventListener(MouseEvent.CLICK, btnClick);
                    tabButtons.push(_local3);
                    _local4 = _arg1[_local2].pane;
                    panes.push(_local4);
                    addChild(_local4);
                    _local4.x = 0;
                    _local4.y = 28;
                };
                selectPane(0);
            };
        }

    }
}//package com.zlchat.ui 
