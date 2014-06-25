//hong QQ:1410919373
package fl.controls {
    import fl.core.*;
    import flash.display.*;
    import flash.events.*;
    import fl.managers.*;
    import fl.events.*;
    import flash.ui.*;

    public class Slider extends UIComponent implements IFocusManagerComponent {

        protected static const TICK_STYLES:Object = {upSkin:"tickSkin"};
        protected static const TRACK_STYLES:Object = {
            upSkin:"sliderTrackSkin",
            overSkin:"sliderTrackSkin",
            downSkin:"sliderTrackSkin",
            disabledSkin:"sliderTrackDisabledSkin"
        };
        protected static const THUMB_STYLES:Object = {
            upSkin:"thumbUpSkin",
            overSkin:"thumbOverSkin",
            downSkin:"thumbDownSkin",
            disabledSkin:"thumbDisabledSkin"
        };

        protected static var defaultStyles:Object = {
            thumbUpSkin:"SliderThumb_upSkin",
            thumbOverSkin:"SliderThumb_overSkin",
            thumbDownSkin:"SliderThumb_downSkin",
            thumbDisabledSkin:"SliderThumb_disabledSkin",
            sliderTrackSkin:"SliderTrack_skin",
            sliderTrackDisabledSkin:"SliderTrack_disabledSkin",
            tickSkin:"SliderTick_skin",
            focusRectSkin:null,
            focusRectPadding:null
        };

        protected var _direction:String;
        protected var _liveDragging:Boolean = false;
        protected var _value:Number = 0;
        protected var _snapInterval:Number = 0;
        protected var _minimum:Number = 0;
        protected var _maximum:Number = 10;
        protected var track:BaseButton;
        protected var _tickInterval:Number = 0;
        protected var tickContainer:Sprite;
        protected var thumb:BaseButton;

        public function Slider(){
            _direction = SliderDirection.HORIZONTAL;
            _minimum = 0;
            _maximum = 10;
            _value = 0;
            _tickInterval = 0;
            _snapInterval = 0;
            _liveDragging = false;
            super();
            setStyles();
        }
        public static function getStyleDefinition():Object{
            return (defaultStyles);
        }

        public function get minimum():Number{
            return (_minimum);
        }
        public function set minimum(_arg1:Number):void{
            _minimum = _arg1;
            this.value = Math.max(_arg1, this.value);
            invalidate(InvalidationType.DATA);
        }
        public function get maximum():Number{
            return (_maximum);
        }
        protected function positionThumb():void{
            thumb.x = ((((_direction)==SliderDirection.VERTICAL) ? ((maximum - minimum) - value) : (value - minimum) / (maximum - minimum)) * _width);
        }
        protected function clearTicks():void{
            if (((!(tickContainer)) || (!(tickContainer.parent)))){
                return;
            };
            removeChild(tickContainer);
        }
        protected function onTrackClick(_arg1:MouseEvent):void{
            calculateValue(track.mouseX, InteractionInputType.MOUSE, SliderEventClickTarget.TRACK);
            if (!liveDragging){
                dispatchEvent(new SliderEvent(SliderEvent.CHANGE, value, SliderEventClickTarget.TRACK, InteractionInputType.MOUSE));
            };
        }
        public function set maximum(_arg1:Number):void{
            _maximum = _arg1;
            this.value = Math.min(_arg1, this.value);
            invalidate(InvalidationType.DATA);
        }
        public function get liveDragging():Boolean{
            return (_liveDragging);
        }
        protected function doDrag(_arg1:MouseEvent):void{
            var _local2:Number;
            var _local3:Number;
            _local2 = (_width / snapInterval);
            _local3 = track.mouseX;
            calculateValue(_local3, InteractionInputType.MOUSE, SliderEventClickTarget.THUMB);
            dispatchEvent(new SliderEvent(SliderEvent.THUMB_DRAG, value, SliderEventClickTarget.THUMB, InteractionInputType.MOUSE));
        }
        override protected function keyDownHandler(_arg1:KeyboardEvent):void{
            var _local2:uint;
            var _local3:Number;
            var _local4:Boolean;
            if (!enabled){
                return;
            };
            _local2 = ((snapInterval)>0) ? snapInterval : 1;
            _local4 = (direction == SliderDirection.HORIZONTAL);
            if ((((((_arg1.keyCode == Keyboard.DOWN)) && (!(_local4)))) || ((((_arg1.keyCode == Keyboard.LEFT)) && (_local4))))){
                _local3 = (value - _local2);
            } else {
                if ((((((_arg1.keyCode == Keyboard.UP)) && (!(_local4)))) || ((((_arg1.keyCode == Keyboard.RIGHT)) && (_local4))))){
                    _local3 = (value + _local2);
                } else {
                    if ((((((_arg1.keyCode == Keyboard.PAGE_DOWN)) && (!(_local4)))) || ((((_arg1.keyCode == Keyboard.HOME)) && (_local4))))){
                        _local3 = minimum;
                    } else {
                        if ((((((_arg1.keyCode == Keyboard.PAGE_UP)) && (!(_local4)))) || ((((_arg1.keyCode == Keyboard.END)) && (_local4))))){
                            _local3 = maximum;
                        };
                    };
                };
            };
            if (!isNaN(_local3)){
                _arg1.stopPropagation();
                doSetValue(_local3, InteractionInputType.KEYBOARD, null, _arg1.keyCode);
            };
        }
        override public function set enabled(_arg1:Boolean):void{
            if (enabled == _arg1){
                return;
            };
            super.enabled = _arg1;
            track.enabled = (thumb.enabled = _arg1);
        }
        protected function thumbPressHandler(_arg1:MouseEvent):void{
            stage.addEventListener(MouseEvent.MOUSE_MOVE, doDrag, false, 0, true);
            stage.addEventListener(MouseEvent.MOUSE_UP, thumbReleaseHandler, false, 0, true);
            dispatchEvent(new SliderEvent(SliderEvent.THUMB_PRESS, value, InteractionInputType.MOUSE, SliderEventClickTarget.THUMB));
        }
        public function get snapInterval():Number{
            return (_snapInterval);
        }
        protected function thumbReleaseHandler(_arg1:MouseEvent):void{
            stage.removeEventListener(MouseEvent.MOUSE_MOVE, doDrag);
            stage.removeEventListener(MouseEvent.MOUSE_UP, thumbReleaseHandler);
            dispatchEvent(new SliderEvent(SliderEvent.THUMB_RELEASE, value, InteractionInputType.MOUSE, SliderEventClickTarget.THUMB));
            dispatchEvent(new SliderEvent(SliderEvent.CHANGE, value, SliderEventClickTarget.THUMB, InteractionInputType.MOUSE));
        }
        public function set liveDragging(_arg1:Boolean):void{
            _liveDragging = _arg1;
        }
        public function set value(_arg1:Number):void{
            doSetValue(_arg1);
        }
        public function set direction(_arg1:String):void{
            var _local2:Boolean;
            _direction = _arg1;
            _local2 = (_direction == SliderDirection.VERTICAL);
            if (isLivePreview){
                if (_local2){
                    setScaleY(-1);
                    y = track.height;
                } else {
                    setScaleY(1);
                    y = 0;
                };
                positionThumb();
                return;
            };
            if (((_local2) && (componentInspectorSetting))){
                if ((rotation % 90) == 0){
                    setScaleY(-1);
                };
            };
            if (!componentInspectorSetting){
                rotation = (_local2) ? 90 : 0;
            };
        }
        public function set tickInterval(_arg1:Number):void{
            _tickInterval = _arg1;
            invalidate(InvalidationType.SIZE);
        }
        override public function get enabled():Boolean{
            return (super.enabled);
        }
        override protected function draw():void{
            if (isInvalid(InvalidationType.STYLES)){
                setStyles();
                invalidate(InvalidationType.SIZE, false);
            };
            if (isInvalid(InvalidationType.SIZE)){
                track.setSize(_width, track.height);
                track.drawNow();
                thumb.drawNow();
            };
            if (tickInterval > 0){
                drawTicks();
            } else {
                clearTicks();
            };
            positionThumb();
            super.draw();
        }
        override protected function configUI():void{
            super.configUI();
            thumb = new BaseButton();
            thumb.setSize(13, 13);
            thumb.autoRepeat = false;
            addChild(thumb);
            thumb.addEventListener(MouseEvent.MOUSE_DOWN, thumbPressHandler, false, 0, true);
            track = new BaseButton();
            track.move(0, 0);
            track.setSize(80, 4);
            track.autoRepeat = false;
            track.useHandCursor = false;
            track.addEventListener(MouseEvent.CLICK, onTrackClick, false, 0, true);
            addChildAt(track, 0);
        }
        public function set snapInterval(_arg1:Number):void{
            _snapInterval = _arg1;
        }
        public function get value():Number{
            return (_value);
        }
        public function get direction():String{
            return (_direction);
        }
        public function get tickInterval():Number{
            return (_tickInterval);
        }
        override public function setSize(_arg1:Number, _arg2:Number):void{
            if ((((_direction == SliderDirection.VERTICAL)) && (!(isLivePreview)))){
                super.setSize(_arg2, _arg1);
            } else {
                super.setSize(_arg1, _arg2);
            };
            invalidate(InvalidationType.SIZE);
        }
        protected function drawTicks():void{
            var _local1:Number;
            var _local2:Number;
            var _local3:Number;
            var _local4:uint;
            var _local5:DisplayObject;
            clearTicks();
            tickContainer = new Sprite();
            _local1 = ((maximum)<1) ? (tickInterval / 100) : tickInterval;
            _local2 = ((maximum - minimum) / _local1);
            _local3 = (_width / _local2);
            _local4 = 0;
            while (_local4 <= _local2) {
                _local5 = getDisplayObjectInstance(getStyleValue("tickSkin"));
                _local5.x = (_local3 * _local4);
                _local5.y = ((track.y - _local5.height) - 2);
                tickContainer.addChild(_local5);
                _local4++;
            };
            addChild(tickContainer);
        }
        protected function calculateValue(_arg1:Number, _arg2:String, _arg3:String, _arg4:int=undefined):void{
            var _local5:Number;
            _local5 = ((_arg1 / _width) * (maximum - minimum));
            if (_direction == SliderDirection.VERTICAL){
                _local5 = (maximum - _local5);
            } else {
                _local5 = (minimum + _local5);
            };
            doSetValue(_local5, _arg2, _arg3, _arg4);
        }
        protected function getPrecision(_arg1:Number):Number{
            var _local2:String;
            _local2 = _arg1.toString();
            if (_local2.indexOf(".") == -1){
                return (0);
            };
            return (_local2.split(".").pop().length);
        }
        protected function doSetValue(_arg1:Number, _arg2:String=null, _arg3:String=null, _arg4:int=undefined):void{
            var _local5:Number;
            var _local6:Number;
            var _local7:Number;
            var _local8:Number;
            var _local9:Number;
            _local5 = _value;
            if (((!((_snapInterval == 0))) && (!((_snapInterval == 1))))){
                _local6 = Math.pow(10, getPrecision(snapInterval));
                _local7 = (_snapInterval * _local6);
                _local8 = Math.round((_arg1 * _local6));
                _local9 = (Math.round((_local8 / _local7)) * _local7);
                _arg1 = (_local9 / _local6);
                _value = Math.max(minimum, Math.min(maximum, _arg1));
            } else {
                _value = Math.max(minimum, Math.min(maximum, Math.round(_arg1)));
            };
            if (((!((_local5 == _value))) && (((((liveDragging) && (!((_arg3 == null))))) || ((_arg2 == InteractionInputType.KEYBOARD)))))){
                dispatchEvent(new SliderEvent(SliderEvent.CHANGE, value, _arg3, _arg2, _arg4));
            };
            positionThumb();
        }
        protected function setStyles():void{
            copyStylesToChild(thumb, THUMB_STYLES);
            copyStylesToChild(track, TRACK_STYLES);
        }

    }
}//package fl.controls 
