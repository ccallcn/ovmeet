//hong QQ:1410919373
package fl.controls {
    import fl.core.*;
    import flash.display.*;
    import flash.events.*;
    import fl.controls.progressBarClasses.*;

    public class ProgressBar extends UIComponent {

        private static var defaultStyles:Object = {
            trackSkin:"ProgressBar_trackSkin",
            barSkin:"ProgressBar_barSkin",
            indeterminateSkin:"ProgressBar_indeterminateSkin",
            indeterminateBar:IndeterminateBar,
            barPadding:0
        };

        protected var _direction:String = "right";
        protected var _mode:String = "event";
        protected var _value:Number = 0;
        protected var _indeterminate:Boolean = true;
        protected var _minimum:Number = 0;
        protected var _maximum:Number = 0;
        protected var determinateBar:DisplayObject;
        protected var _loaded:Number;
        protected var _source:Object;
        protected var track:DisplayObject;
        protected var indeterminateBar:UIComponent;

        public function ProgressBar(){
            _direction = ProgressBarDirection.RIGHT;
            _indeterminate = true;
            _mode = ProgressBarMode.EVENT;
            _minimum = 0;
            _maximum = 0;
            _value = 0;
            super();
        }
        public static function getStyleDefinition():Object{
            return (defaultStyles);
        }

        public function get minimum():Number{
            return (_minimum);
        }
        public function get source():Object{
            return (_source);
        }
        public function set minimum(_arg1:Number):void{
            if (_mode != ProgressBarMode.MANUAL){
                return;
            };
            _minimum = _arg1;
            invalidate(InvalidationType.DATA);
        }
        public function get maximum():Number{
            return (_maximum);
        }
        protected function drawBars():void{
            var _local1:DisplayObject;
            var _local2:DisplayObject;
            _local1 = determinateBar;
            _local2 = indeterminateBar;
            determinateBar = getDisplayObjectInstance(getStyleValue("barSkin"));
            addChild(determinateBar);
            indeterminateBar = (getDisplayObjectInstance(getStyleValue("indeterminateBar")) as UIComponent);
            indeterminateBar.setStyle("indeterminateSkin", getStyleValue("indeterminateSkin"));
            addChild(indeterminateBar);
            if (((!((_local1 == null))) && (!((_local1 == determinateBar))))){
                removeChild(_local1);
            };
            if (((!((_local2 == null))) && (!((_local2 == determinateBar))))){
                removeChild(_local2);
            };
        }
        protected function setupSourceEvents():void{
            _source.addEventListener(ProgressEvent.PROGRESS, handleProgress, false, 0, true);
            _source.addEventListener(Event.COMPLETE, handleComplete, false, 0, true);
        }
        public function set maximum(_arg1:Number):void{
            setProgress(_value, _arg1);
        }
        public function set source(_arg1:Object):void{
            if (_source == _arg1){
                return;
            };
            if (_mode != ProgressBarMode.MANUAL){
                resetProgress();
            };
            _source = _arg1;
            if (_source == null){
                return;
            };
            if (_mode == ProgressBarMode.EVENT){
                setupSourceEvents();
            } else {
                if (_mode == ProgressBarMode.POLLED){
                    addEventListener(Event.ENTER_FRAME, pollSource, false, 0, true);
                };
            };
        }
        protected function drawTrack():void{
            var _local1:DisplayObject;
            _local1 = track;
            track = getDisplayObjectInstance(getStyleValue("trackSkin"));
            addChildAt(track, 0);
            if (((!((_local1 == null))) && (!((_local1 == track))))){
                removeChild(_local1);
            };
        }
        protected function handleProgress(_arg1:ProgressEvent):void{
            _setProgress(_arg1.bytesLoaded, _arg1.bytesTotal, true);
        }
        public function set sourceName(_arg1:String):void{
            var _local2:DisplayObject;
            if (!componentInspectorSetting){
                return;
            };
            if (_arg1 == ""){
                return;
            };
            _local2 = (parent.getChildByName(_arg1) as DisplayObject);
            if (_local2 == null){
                throw (new Error((("Source clip '" + _arg1) + "' not found on parent.")));
            };
            source = _local2;
        }
        protected function resetProgress():void{
            if ((((_mode == ProgressBarMode.EVENT)) && (!((_source == null))))){
                cleanupSourceEvents();
            } else {
                if (_mode == ProgressBarMode.POLLED){
                    removeEventListener(Event.ENTER_FRAME, pollSource);
                } else {
                    if (_source != null){
                        _source = null;
                    };
                };
            };
            _minimum = (_maximum = (_value = 0));
        }
        public function get percentComplete():Number{
            return (((((_maximum <= _minimum)) || ((_value <= _minimum)))) ? 0 : Math.max(0, Math.min(100, (((_value - _minimum) / (_maximum - _minimum)) * 100))));
        }
        public function setProgress(_arg1:Number, _arg2:Number):void{
            if (_mode != ProgressBarMode.MANUAL){
                return;
            };
            _setProgress(_arg1, _arg2);
        }
        protected function pollSource(_arg1:Event):void{
            if (_source == null){
                return;
            };
            _setProgress(_source.bytesLoaded, _source.bytesTotal, true);
            if ((((_maximum > 0)) && ((_maximum == _value)))){
                removeEventListener(Event.ENTER_FRAME, pollSource);
                dispatchEvent(new Event(Event.COMPLETE));
            };
        }
        public function get indeterminate():Boolean{
            return (_indeterminate);
        }
        public function set value(_arg1:Number):void{
            setProgress(_arg1, _maximum);
        }
        public function set direction(_arg1:String):void{
            _direction = _arg1;
            invalidate(InvalidationType.DATA);
        }
        protected function _setProgress(_arg1:Number, _arg2:Number, _arg3:Boolean=false):void{
            if ((((_arg1 == _value)) && ((_arg2 == _maximum)))){
                return;
            };
            _value = _arg1;
            _maximum = _arg2;
            if (((!((_value == _loaded))) && (_arg3))){
                dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, false, false, _value, _maximum));
                _loaded = _value;
            };
            if (_mode != ProgressBarMode.MANUAL){
                setIndeterminate((_arg2 == 0));
            };
            invalidate(InvalidationType.DATA);
        }
        public function set mode(_arg1:String):void{
            if (_mode == _arg1){
                return;
            };
            resetProgress();
            _mode = _arg1;
            if ((((_arg1 == ProgressBarMode.EVENT)) && (!((_source == null))))){
                setupSourceEvents();
            } else {
                if (_arg1 == ProgressBarMode.POLLED){
                    addEventListener(Event.ENTER_FRAME, pollSource, false, 0, true);
                };
            };
            setIndeterminate(!((_mode == ProgressBarMode.MANUAL)));
        }
        public function reset():void{
            var _local1:Object;
            _setProgress(0, 0);
            _local1 = _source;
            _source = null;
            source = _local1;
        }
        override protected function draw():void{
            if (isInvalid(InvalidationType.STYLES)){
                drawTrack();
                drawBars();
                invalidate(InvalidationType.STATE, false);
                invalidate(InvalidationType.SIZE, false);
            };
            if (isInvalid(InvalidationType.STATE)){
                indeterminateBar.visible = _indeterminate;
                determinateBar.visible = !(_indeterminate);
                invalidate(InvalidationType.DATA, false);
            };
            if (isInvalid(InvalidationType.SIZE)){
                drawLayout();
                invalidate(InvalidationType.DATA, false);
            };
            if (((isInvalid(InvalidationType.DATA)) && (!(_indeterminate)))){
                drawDeterminateBar();
            };
            super.draw();
        }
        override protected function configUI():void{
            super.configUI();
        }
        protected function drawDeterminateBar():void{
            var _local1:Number;
            var _local2:Number;
            _local1 = (percentComplete / 100);
            _local2 = Number(getStyleValue("barPadding"));
            determinateBar.width = Math.round(((width - (_local2 * 2)) * _local1));
            determinateBar.x = ((_direction)==ProgressBarDirection.LEFT) ? ((width - _local2) - determinateBar.width) : _local2;
        }
        public function get value():Number{
            return (_value);
        }
        public function set indeterminate(_arg1:Boolean):void{
            if (((!((_mode == ProgressBarMode.MANUAL))) || ((_indeterminate == _arg1)))){
                return;
            };
            setIndeterminate(_arg1);
        }
        protected function setIndeterminate(_arg1:Boolean):void{
            if (_indeterminate == _arg1){
                return;
            };
            _indeterminate = _arg1;
            invalidate(InvalidationType.STATE);
        }
        protected function handleComplete(_arg1:Event):void{
            _setProgress(_maximum, _maximum, true);
            dispatchEvent(_arg1);
        }
        protected function drawLayout():void{
            var _local1:Number;
            _local1 = Number(getStyleValue("barPadding"));
            track.width = width;
            track.height = height;
            indeterminateBar.setSize((width - (_local1 * 2)), (height - (_local1 * 2)));
            indeterminateBar.move(_local1, _local1);
            indeterminateBar.drawNow();
            determinateBar.height = (height - (_local1 * 2));
            determinateBar.y = _local1;
        }
        public function get direction():String{
            return (_direction);
        }
        public function get mode():String{
            return (_mode);
        }
        protected function cleanupSourceEvents():void{
            _source.removeEventListener(ProgressEvent.PROGRESS, handleProgress);
            _source.removeEventListener(Event.COMPLETE, handleComplete);
        }

    }
}//package fl.controls 
