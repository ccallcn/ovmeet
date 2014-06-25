//hong QQ:1410919373
package fl.controls {
    import fl.core.*;
    import flash.display.*;
    import flash.events.*;
    import fl.managers.*;
    import fl.events.*;
    import flash.text.*;
    import flash.ui.*;

    public class LabelButton extends BaseButton implements IFocusManagerComponent {

        private static var defaultStyles:Object = {
            icon:null,
            upIcon:null,
            downIcon:null,
            overIcon:null,
            disabledIcon:null,
            selectedDisabledIcon:null,
            selectedUpIcon:null,
            selectedDownIcon:null,
            selectedOverIcon:null,
            textFormat:null,
            disabledTextFormat:null,
            textPadding:5,
            embedFonts:false
        };
        public static var createAccessibilityImplementation:Function;

        protected var _labelPlacement:String = "right";
        protected var _toggle:Boolean = false;
        protected var icon:DisplayObject;
        protected var oldMouseState:String;
        protected var mode:String = "center";
        public var textField:TextField;
        protected var _label:String = "Label";

        public function LabelButton(){
            _labelPlacement = ButtonLabelPlacement.RIGHT;
            _toggle = false;
            _label = "Label";
            mode = "center";
            super();
        }
        public static function getStyleDefinition():Object{
            return (mergeStyles(defaultStyles, BaseButton.getStyleDefinition()));
        }

        protected function toggleSelected(_arg1:MouseEvent):void{
            selected = !(selected);
            dispatchEvent(new Event(Event.CHANGE, true));
        }
        public function get labelPlacement():String{
            return (_labelPlacement);
        }
        override protected function keyDownHandler(_arg1:KeyboardEvent):void{
            if (!enabled){
                return;
            };
            if (_arg1.keyCode == Keyboard.SPACE){
                if (oldMouseState == null){
                    oldMouseState = mouseState;
                };
                setMouseState("down");
                startPress();
            };
        }
        protected function setEmbedFont(){
            var _local1:Object;
            _local1 = getStyleValue("embedFonts");
            if (_local1 != null){
                textField.embedFonts = _local1;
            };
        }
        override protected function keyUpHandler(_arg1:KeyboardEvent):void{
            if (!enabled){
                return;
            };
            if (_arg1.keyCode == Keyboard.SPACE){
                setMouseState(oldMouseState);
                oldMouseState = null;
                endPress();
                dispatchEvent(new MouseEvent(MouseEvent.CLICK));
            };
        }
        override public function get selected():Boolean{
            return ((_toggle) ? _selected : false);
        }
        public function set labelPlacement(_arg1:String):void{
            _labelPlacement = _arg1;
            invalidate(InvalidationType.SIZE);
        }
        public function set toggle(_arg1:Boolean):void{
            if (((!(_arg1)) && (super.selected))){
                selected = false;
            };
            _toggle = _arg1;
            if (_toggle){
                addEventListener(MouseEvent.CLICK, toggleSelected, false, 0, true);
            } else {
                removeEventListener(MouseEvent.CLICK, toggleSelected);
            };
            invalidate(InvalidationType.STATE);
        }
        public function get label():String{
            return (_label);
        }
        override public function set selected(_arg1:Boolean):void{
            _selected = _arg1;
            if (_toggle){
                invalidate(InvalidationType.STATE);
            };
        }
        override protected function draw():void{
            if (textField.text != _label){
                label = _label;
            };
            if (isInvalid(InvalidationType.STYLES, InvalidationType.STATE)){
                drawBackground();
                drawIcon();
                drawTextFormat();
                invalidate(InvalidationType.SIZE, false);
            };
            if (isInvalid(InvalidationType.SIZE)){
                drawLayout();
            };
            if (isInvalid(InvalidationType.SIZE, InvalidationType.STYLES)){
                if (((isFocused) && (focusManager.showFocusIndicator))){
                    drawFocus(true);
                };
            };
            validate();
        }
        public function get toggle():Boolean{
            return (_toggle);
        }
        override protected function configUI():void{
            super.configUI();
            textField = new TextField();
            textField.type = TextFieldType.DYNAMIC;
            textField.selectable = false;
            addChild(textField);
        }
        override protected function drawLayout():void{
            var _local1:Number;
            var _local2:String;
            var _local3:Number;
            var _local4:Number;
            var _local5:Number;
            var _local6:Number;
            var _local7:Number;
            var _local8:Number;
            _local1 = Number(getStyleValue("textPadding"));
            _local2 = ((((icon == null)) && ((mode == "center")))) ? ButtonLabelPlacement.TOP : _labelPlacement;
            textField.height = (textField.textHeight + 4);
            _local3 = (textField.textWidth + 4);
            _local4 = (textField.textHeight + 4);
            _local5 = ((icon)==null) ? 0 : (icon.width + _local1);
            _local6 = ((icon)==null) ? 0 : (icon.height + _local1);
            textField.visible = (label.length > 0);
            if (icon != null){
                icon.x = Math.round(((width - icon.width) / 2));
                icon.y = Math.round(((height - icon.height) / 2));
            };
            if (textField.visible == false){
                textField.width = 0;
                textField.height = 0;
            } else {
                if ((((_local2 == ButtonLabelPlacement.BOTTOM)) || ((_local2 == ButtonLabelPlacement.TOP)))){
                    _local7 = Math.max(0, Math.min(_local3, (width - (2 * _local1))));
                    if ((height - 2) > _local4){
                        _local8 = _local4;
                    } else {
                        _local8 = (height - 2);
                    };
                    _local3 = _local7;
                    textField.width = _local3;
                    _local4 = _local8;
                    textField.height = _local4;
                    textField.x = Math.round(((width - _local3) / 2));
                    textField.y = Math.round(((((height - textField.height) - _local6) / 2) + ((_local2)==ButtonLabelPlacement.BOTTOM) ? _local6 : 0));
                    if (icon != null){
                        icon.y = Math.round(((_local2)==ButtonLabelPlacement.BOTTOM) ? (textField.y - _local6) : ((textField.y + textField.height) + _local1));
                    };
                } else {
                    _local7 = Math.max(0, Math.min(_local3, ((width - _local5) - (2 * _local1))));
                    _local3 = _local7;
                    textField.width = _local3;
                    textField.x = Math.round(((((width - _local3) - _local5) / 2) + ((_local2)!=ButtonLabelPlacement.LEFT) ? _local5 : 0));
                    textField.y = Math.round(((height - textField.height) / 2));
                    if (icon != null){
                        icon.x = Math.round(((_local2)!=ButtonLabelPlacement.LEFT) ? (textField.x - _local5) : ((textField.x + _local3) + _local1));
                    };
                };
            };
            super.drawLayout();
        }
        override protected function initializeAccessibility():void{
            if (LabelButton.createAccessibilityImplementation != null){
                LabelButton.createAccessibilityImplementation(this);
            };
        }
        protected function drawIcon():void{
            var _local1:DisplayObject;
            var _local2:String;
            var _local3:Object;
            _local1 = icon;
            _local2 = (enabled) ? mouseState : "disabled";
            if (selected){
                _local2 = (("selected" + _local2.substr(0, 1).toUpperCase()) + _local2.substr(1));
            };
            _local2 = (_local2 + "Icon");
            _local3 = getStyleValue(_local2);
            if (_local3 == null){
                _local3 = getStyleValue("icon");
            };
            if (_local3 != null){
                icon = getDisplayObjectInstance(_local3);
            };
            if (icon != null){
                addChildAt(icon, 1);
            };
            if (((!((_local1 == null))) && (!((_local1 == icon))))){
                removeChild(_local1);
            };
        }
        public function set label(_arg1:String):void{
            _label = _arg1;
            if (textField.text != _label){
                textField.text = _label;
                dispatchEvent(new ComponentEvent(ComponentEvent.LABEL_CHANGE));
            };
            invalidate(InvalidationType.SIZE);
            invalidate(InvalidationType.STYLES);
        }
        protected function drawTextFormat():void{
            var _local1:Object;
            var _local2:TextFormat;
            var _local3:TextFormat;
            _local1 = UIComponent.getStyleDefinition();
            _local2 = (enabled) ? (_local1.defaultTextFormat as TextFormat) : (_local1.defaultDisabledTextFormat as TextFormat);
            textField.setTextFormat(_local2);
            _local3 = (getStyleValue((enabled) ? "textFormat" : "disabledTextFormat") as TextFormat);
            if (_local3 != null){
                textField.setTextFormat(_local3);
            } else {
                _local3 = _local2;
            };
            textField.defaultTextFormat = _local3;
            setEmbedFont();
        }

    }
}//package fl.controls 
