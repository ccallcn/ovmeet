//hong QQ:1410919373
package fl.controls {
    import fl.core.*;
    import flash.display.*;
    import flash.events.*;
    import fl.managers.*;
    import fl.events.*;
    import flash.ui.*;

    public class NumericStepper extends UIComponent implements IFocusManagerComponent {

        protected static const DOWN_ARROW_STYLES:Object = {
            disabledSkin:"downArrowDisabledSkin",
            downSkin:"downArrowDownSkin",
            overSkin:"downArrowOverSkin",
            upSkin:"downArrowUpSkin",
            repeatDelay:"repeatDelay",
            repeatInterval:"repeatInterval"
        };
        protected static const TEXT_INPUT_STYLES:Object = {
            upSkin:"upSkin",
            disabledSkin:"disabledSkin",
            textPadding:"textPadding",
            textFormat:"textFormat",
            disabledTextFormat:"disabledTextFormat",
            embedFonts:"embedFonts"
        };
        protected static const UP_ARROW_STYLES:Object = {
            disabledSkin:"upArrowDisabledSkin",
            downSkin:"upArrowDownSkin",
            overSkin:"upArrowOverSkin",
            upSkin:"upArrowUpSkin",
            repeatDelay:"repeatDelay",
            repeatInterval:"repeatInterval"
        };

        private static var defaultStyles:Object = {
            downArrowDisabledSkin:"NumericStepperDownArrow_disabledSkin",
            downArrowDownSkin:"NumericStepperDownArrow_downSkin",
            downArrowOverSkin:"NumericStepperDownArrow_overSkin",
            downArrowUpSkin:"NumericStepperDownArrow_upSkin",
            upArrowDisabledSkin:"NumericStepperUpArrow_disabledSkin",
            upArrowDownSkin:"NumericStepperUpArrow_downSkin",
            upArrowOverSkin:"NumericStepperUpArrow_overSkin",
            upArrowUpSkin:"NumericStepperUpArrow_upSkin",
            upSkin:"TextInput_upSkin",
            disabledSkin:"TextInput_disabledSkin",
            focusRect:null,
            focusRectSkin:null,
            focusRectPadding:null,
            repeatDelay:500,
            repeatInterval:35,
            embedFonts:false
        };

        protected var upArrow:BaseButton;
        protected var _stepSize:Number = 1;
        protected var downArrow:BaseButton;
        protected var _value:Number = 1;
        protected var _minimum:Number = 0;
        protected var _maximum:Number = 10;
        protected var _precision:Number;
        protected var inputField:TextInput;

        public function NumericStepper(){
            _maximum = 10;
            _minimum = 0;
            _value = 1;
            _stepSize = 1;
            super();
            setStyles();
            stepSize = _stepSize;
        }
        public static function getStyleDefinition():Object{
            return (defaultStyles);
        }

        override public function drawFocus(_arg1:Boolean):void{
            var _local2:Number;
            super.drawFocus(_arg1);
            if (_arg1){
                _local2 = Number(getStyleValue("focusRectPadding"));
                uiFocusRect.width = (width + (_local2 * 2));
                uiFocusRect.height = (height + (_local2 * 2));
            };
        }
        public function get minimum():Number{
            return (_minimum);
        }
        public function set imeMode(_arg1:String):void{
            inputField.imeMode = _arg1;
        }
        public function set minimum(_arg1:Number):void{
            _minimum = _arg1;
            if (_value < _minimum){
                setValue(_minimum, false);
            };
        }
        public function get maximum():Number{
            return (_maximum);
        }
        override protected function isOurFocus(_arg1:DisplayObject):Boolean{
            return ((((_arg1 == inputField)) || (super.isOurFocus(_arg1))));
        }
        public function get nextValue():Number{
            var _local1:Number;
            _local1 = (_value + _stepSize);
            return ((inRange(_local1)) ? _local1 : _value);
        }
        public function set maximum(_arg1:Number):void{
            _maximum = _arg1;
            if (_value > _maximum){
                setValue(_maximum, false);
            };
        }
        protected function setValue(_arg1:Number, _arg2:Boolean=true):void{
            var _local3:Number;
            if (_arg1 == _value){
                return;
            };
            _local3 = _value;
            _value = getValidValue(_arg1);
            inputField.text = _value.toString();
            if (_arg2){
                dispatchEvent(new Event(Event.CHANGE, true));
            };
        }
        override protected function keyDownHandler(_arg1:KeyboardEvent):void{
            var _local2:Number;
            if (!enabled){
                return;
            };
            _arg1.stopImmediatePropagation();
            _local2 = Number(inputField.text);
            switch (_arg1.keyCode){
                case Keyboard.END:
                    setValue(maximum);
                    break;
                case Keyboard.HOME:
                    setValue(minimum);
                    break;
                case Keyboard.UP:
                    setValue(nextValue);
                    break;
                case Keyboard.DOWN:
                    setValue(previousValue);
                    break;
                case Keyboard.ENTER:
                    setValue(_local2);
                    break;
            };
        }
        override public function set enabled(_arg1:Boolean):void{
            if (_arg1 == enabled){
                return;
            };
            super.enabled = _arg1;
            upArrow.enabled = (downArrow.enabled = (inputField.enabled = _arg1));
        }
        protected function onTextChange(_arg1:Event):void{
            _arg1.stopImmediatePropagation();
        }
        public function get previousValue():Number{
            var _local1:Number;
            _local1 = (_value - _stepSize);
            return ((inRange(_local1)) ? _local1 : _value);
        }
        protected function getValidValue(_arg1:Number):Number{
            var _local2:Number;
            if (isNaN(_arg1)){
                return (_value);
            };
            _local2 = Number((_stepSize * Math.round((_arg1 / _stepSize))).toFixed(_precision));
            if (_local2 > maximum){
                return (maximum);
            };
            if (_local2 < minimum){
                return (minimum);
            };
            return (_local2);
        }
        public function set value(_arg1:Number):void{
            setValue(_arg1, false);
        }
        public function get stepSize():Number{
            return (_stepSize);
        }
        protected function passEvent(_arg1:Event):void{
            dispatchEvent(_arg1);
        }
        public function get imeMode():String{
            return (inputField.imeMode);
        }
        protected function stepperPressHandler(_arg1:ComponentEvent):void{
            setValue(Number(inputField.text), false);
            switch (_arg1.currentTarget){
                case upArrow:
                    setValue(nextValue);
                    break;
                case downArrow:
                    setValue(previousValue);
            };
            inputField.setFocus();
            inputField.textField.setSelection(0, 0);
        }
        override protected function focusOutHandler(_arg1:FocusEvent):void{
            if (_arg1.eventPhase == 3){
                setValue(Number(inputField.text));
            };
            super.focusOutHandler(_arg1);
        }
        protected function inRange(_arg1:Number):Boolean{
            return ((((_arg1 >= _minimum)) && ((_arg1 <= _maximum))));
        }
        override public function get enabled():Boolean{
            return (super.enabled);
        }
        override protected function draw():void{
            if (isInvalid(InvalidationType.STYLES, InvalidationType.STATE)){
                setStyles();
                invalidate(InvalidationType.SIZE, false);
            };
            if (isInvalid(InvalidationType.SIZE)){
                drawLayout();
            };
            if (((isFocused) && (focusManager.showFocusIndicator))){
                drawFocus(true);
            };
            validate();
        }
        override protected function configUI():void{
            super.configUI();
            upArrow = new BaseButton();
            copyStylesToChild(upArrow, UP_ARROW_STYLES);
            upArrow.autoRepeat = true;
            upArrow.setSize(21, 12);
            upArrow.focusEnabled = false;
            addChild(upArrow);
            downArrow = new BaseButton();
            copyStylesToChild(downArrow, DOWN_ARROW_STYLES);
            downArrow.autoRepeat = true;
            downArrow.setSize(21, 12);
            downArrow.focusEnabled = false;
            addChild(downArrow);
            inputField = new TextInput();
            copyStylesToChild(inputField, TEXT_INPUT_STYLES);
            inputField.restrict = "0-9\\-\\.\\,";
            inputField.text = _value.toString();
            inputField.setSize(21, 24);
            inputField.focusTarget = (this as IFocusManagerComponent);
            inputField.focusEnabled = false;
            inputField.addEventListener(FocusEvent.FOCUS_IN, passEvent);
            inputField.addEventListener(FocusEvent.FOCUS_OUT, passEvent);
            addChild(inputField);
            inputField.addEventListener(Event.CHANGE, onTextChange, false, 0, true);
            upArrow.addEventListener(ComponentEvent.BUTTON_DOWN, stepperPressHandler, false, 0, true);
            downArrow.addEventListener(ComponentEvent.BUTTON_DOWN, stepperPressHandler, false, 0, true);
        }
        public function get value():Number{
            return (_value);
        }
        protected function inStep(_arg1:Number):Boolean{
            return ((((_arg1 - _minimum) % _stepSize) == 0));
        }
        protected function drawLayout():void{
            var _local1:Number;
            var _local2:Number;
            _local1 = (width - upArrow.width);
            _local2 = (height / 2);
            inputField.setSize(_local1, height);
            upArrow.height = _local2;
            downArrow.height = Math.floor(_local2);
            downArrow.move(_local1, _local2);
            upArrow.move(_local1, 0);
            downArrow.drawNow();
            upArrow.drawNow();
            inputField.drawNow();
        }
        override public function setFocus():void{
            if (stage){
                stage.focus = inputField.textField;
            };
        }
        protected function getPrecision():Number{
            var _local1:String;
            _local1 = _stepSize.toString();
            if (_local1.indexOf(".") == -1){
                return (0);
            };
            return (_local1.split(".").pop().length);
        }
        public function get textField():TextInput{
            return (inputField);
        }
        public function set stepSize(_arg1:Number):void{
            _stepSize = _arg1;
            _precision = getPrecision();
            setValue(_value);
        }
        protected function setStyles():void{
            copyStylesToChild(downArrow, DOWN_ARROW_STYLES);
            copyStylesToChild(upArrow, UP_ARROW_STYLES);
            copyStylesToChild(inputField, TEXT_INPUT_STYLES);
        }

    }
}//package fl.controls 
