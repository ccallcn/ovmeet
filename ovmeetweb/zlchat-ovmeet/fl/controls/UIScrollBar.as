//hong QQ:1410919373
package fl.controls {
    import fl.core.*;
    import flash.events.*;
    import fl.events.*;
    import flash.text.*;

    public class UIScrollBar extends ScrollBar {

        private static var defaultStyles:Object = {};

        protected var inScroll:Boolean = false;
        protected var _scrollTarget:TextField;
        protected var inEdit:Boolean = false;

        public function UIScrollBar(){
            inEdit = false;
            inScroll = false;
            super();
        }
        public static function getStyleDefinition():Object{
            return (UIComponent.mergeStyles(defaultStyles, ScrollBar.getStyleDefinition()));
        }

        protected function handleTargetScroll(_arg1:Event):void{
            if (inDrag){
                return;
            };
            if (!enabled){
                return;
            };
            inEdit = true;
            updateScrollTargetProperties();
            scrollPosition = ((direction)==ScrollBarDirection.HORIZONTAL) ? _scrollTarget.scrollH : _scrollTarget.scrollV;
            inEdit = false;
        }
        override public function set minScrollPosition(_arg1:Number):void{
            super.minScrollPosition = ((_arg1)<0) ? 0 : _arg1;
        }
        override public function setScrollPosition(_arg1:Number, _arg2:Boolean=true):void{
            super.setScrollPosition(_arg1, _arg2);
            if (!_scrollTarget){
                inScroll = false;
                return;
            };
            updateTargetScroll();
        }
        override public function setScrollProperties(_arg1:Number, _arg2:Number, _arg3:Number, _arg4:Number=0):void{
            var _local5:Number;
            var _local6:Number;
            _local5 = _arg3;
            _local6 = ((_arg2)<0) ? 0 : _arg2;
            if (_scrollTarget != null){
                if (direction == ScrollBarDirection.HORIZONTAL){
                    _local5 = ((_arg3)>_scrollTarget.maxScrollH) ? _scrollTarget.maxScrollH : _local5;
                } else {
                    _local5 = ((_arg3)>_scrollTarget.maxScrollV) ? _scrollTarget.maxScrollV : _local5;
                };
            };
            super.setScrollProperties(_arg1, _local6, _local5, _arg4);
        }
        public function get scrollTargetName():String{
            return (_scrollTarget.name);
        }
        public function get scrollTarget():TextField{
            return (_scrollTarget);
        }
        protected function updateScrollTargetProperties():void{
            var _local1:Boolean;
            var _local2:Number;
            if (_scrollTarget == null){
                setScrollProperties(pageSize, minScrollPosition, maxScrollPosition, pageScrollSize);
                scrollPosition = 0;
            } else {
                _local1 = (direction == ScrollBarDirection.HORIZONTAL);
                _local2 = (_local1) ? _scrollTarget.width : 10;
                setScrollProperties(_local2, (_local1) ? 0 : 1, (_local1) ? _scrollTarget.maxScrollH : _scrollTarget.maxScrollV, pageScrollSize);
                scrollPosition = (_local1) ? _scrollTarget.scrollH : _scrollTarget.scrollV;
            };
        }
        public function update():void{
            inEdit = true;
            updateScrollTargetProperties();
            inEdit = false;
        }
        public function set scrollTargetName(_arg1:String):void{
            var target:* = _arg1;
            try {
                scrollTarget = (parent.getChildByName(target) as TextField);
            } catch(error:Error) {
                throw (new Error("ScrollTarget not found, or is not a TextField"));
            };
        }
        override public function set direction(_arg1:String):void{
            if (isLivePreview){
                return;
            };
            super.direction = _arg1;
            updateScrollTargetProperties();
        }
        protected function handleTargetChange(_arg1:Event):void{
            inEdit = true;
            setScrollPosition(((direction)==ScrollBarDirection.HORIZONTAL) ? _scrollTarget.scrollH : _scrollTarget.scrollV, true);
            updateScrollTargetProperties();
            inEdit = false;
        }
        override public function set maxScrollPosition(_arg1:Number):void{
            var _local2:Number;
            _local2 = _arg1;
            if (_scrollTarget != null){
                if (direction == ScrollBarDirection.HORIZONTAL){
                    _local2 = ((_local2)>_scrollTarget.maxScrollH) ? _scrollTarget.maxScrollH : _local2;
                } else {
                    _local2 = ((_local2)>_scrollTarget.maxScrollV) ? _scrollTarget.maxScrollV : _local2;
                };
            };
            super.maxScrollPosition = _local2;
        }
        protected function updateTargetScroll(_arg1:ScrollEvent=null):void{
            if (inEdit){
                return;
            };
            if (direction == ScrollBarDirection.HORIZONTAL){
                _scrollTarget.scrollH = scrollPosition;
            } else {
                _scrollTarget.scrollV = scrollPosition;
            };
        }
        override protected function draw():void{
            if (isInvalid(InvalidationType.DATA)){
                updateScrollTargetProperties();
            };
            super.draw();
        }
        public function set scrollTarget(_arg1:TextField):void{
            if (_scrollTarget != null){
                _scrollTarget.removeEventListener(Event.CHANGE, handleTargetChange, false);
                _scrollTarget.removeEventListener(TextEvent.TEXT_INPUT, handleTargetChange, false);
                _scrollTarget.removeEventListener(Event.SCROLL, handleTargetScroll, false);
                removeEventListener(ScrollEvent.SCROLL, updateTargetScroll, false);
            };
            _scrollTarget = _arg1;
            if (_scrollTarget != null){
                _scrollTarget.addEventListener(Event.CHANGE, handleTargetChange, false, 0, true);
                _scrollTarget.addEventListener(TextEvent.TEXT_INPUT, handleTargetChange, false, 0, true);
                _scrollTarget.addEventListener(Event.SCROLL, handleTargetScroll, false, 0, true);
                addEventListener(ScrollEvent.SCROLL, updateTargetScroll, false, 0, true);
            };
            invalidate(InvalidationType.DATA);
        }
        override public function get direction():String{
            return (super.direction);
        }

    }
}//package fl.controls 
