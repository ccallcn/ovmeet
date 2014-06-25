//hong QQ:1410919373
package fl.controls {
    import fl.core.*;
    import flash.display.*;
    import flash.events.*;
    import fl.managers.*;
    import fl.events.*;
    import flash.text.*;
    import flash.ui.*;

    public class TextInput extends UIComponent implements IFocusManagerComponent {

        private static var defaultStyles:Object = {
            upSkin:"TextInput_upSkin",
            disabledSkin:"TextInput_disabledSkin",
            focusRectSkin:null,
            focusRectPadding:null,
            textFormat:null,
            disabledTextFormat:null,
            textPadding:0,
            embedFonts:false
        };
        public static var createAccessibilityImplementation:Function;

        protected var _html:Boolean = false;
        protected var _savedHTML:String;
        protected var background:DisplayObject;
        protected var _editable:Boolean = true;
        public var textField:TextField;

        public function TextInput(){
            _editable = true;
            _html = false;
            super();
        }
        public static function getStyleDefinition():Object{
            return (defaultStyles);
        }

        override public function drawFocus(_arg1:Boolean):void{
            if (focusTarget != null){
                focusTarget.drawFocus(_arg1);
                return;
            };
            super.drawFocus(_arg1);
        }
        public function set imeMode(_arg1:String):void{
            _imeMode = _arg1;
        }
        override protected function isOurFocus(_arg1:DisplayObject):Boolean{
            return ((((_arg1 == textField)) || (super.isOurFocus(_arg1))));
        }
        protected function handleKeyDown(_arg1:KeyboardEvent):void{
            if (_arg1.keyCode == Keyboard.ENTER){
                dispatchEvent(new ComponentEvent(ComponentEvent.ENTER, true));
            };
        }
        public function set text(_arg1:String):void{
            textField.text = _arg1;
            _html = false;
            invalidate(InvalidationType.DATA);
            invalidate(InvalidationType.STYLES);
        }
        protected function updateTextFieldType():void{
            textField.type = (((enabled) && (editable))) ? TextFieldType.INPUT : TextFieldType.DYNAMIC;
            textField.selectable = enabled;
        }
        public function get selectionEndIndex():int{
            return (textField.selectionEndIndex);
        }
        public function get editable():Boolean{
            return (_editable);
        }
        override protected function focusInHandler(_arg1:FocusEvent):void{
            var _local2:IFocusManager;
            if (_arg1.target == this){
                stage.focus = textField;
            };
            _local2 = focusManager;
            if (((editable) && (_local2))){
                _local2.showFocusIndicator = true;
                if (((textField.selectable) && ((textField.selectionBeginIndex == textField.selectionBeginIndex)))){
                    setSelection(0, textField.length);
                };
            };
            super.focusInHandler(_arg1);
            if (editable){
                setIMEMode(true);
            };
        }
        public function get selectionBeginIndex():int{
            return (textField.selectionBeginIndex);
        }
        public function set alwaysShowSelection(_arg1:Boolean):void{
            textField.alwaysShowSelection = _arg1;
        }
        override public function set enabled(_arg1:Boolean):void{
            super.enabled = _arg1;
            updateTextFieldType();
        }
        protected function setEmbedFont(){
            var _local1:Object;
            _local1 = getStyleValue("embedFonts");
            if (_local1 != null){
                textField.embedFonts = _local1;
            };
        }
        public function get horizontalScrollPosition():int{
            return (textField.scrollH);
        }
        public function set condenseWhite(_arg1:Boolean):void{
            textField.condenseWhite = _arg1;
        }
        public function set displayAsPassword(_arg1:Boolean):void{
            textField.displayAsPassword = _arg1;
        }
        public function set horizontalScrollPosition(_arg1:int):void{
            textField.scrollH = _arg1;
        }
        public function get restrict():String{
            return (textField.restrict);
        }
        public function get textWidth():Number{
            return (textField.textWidth);
        }
        public function get textHeight():Number{
            return (textField.textHeight);
        }
        public function set editable(_arg1:Boolean):void{
            _editable = _arg1;
            updateTextFieldType();
        }
        public function get maxChars():int{
            return (textField.maxChars);
        }
        public function get length():int{
            return (textField.length);
        }
        public function getLineMetrics(_arg1:int):TextLineMetrics{
            return (textField.getLineMetrics(_arg1));
        }
        public function get imeMode():String{
            return (_imeMode);
        }
        override protected function focusOutHandler(_arg1:FocusEvent):void{
            super.focusOutHandler(_arg1);
            if (editable){
                setIMEMode(false);
            };
        }
        public function set htmlText(_arg1:String):void{
            if (_arg1 == ""){
                text = "";
                return;
            };
            _html = true;
            _savedHTML = _arg1;
            textField.htmlText = _arg1;
            invalidate(InvalidationType.DATA);
            invalidate(InvalidationType.STYLES);
        }
        public function get text():String{
            return (textField.text);
        }
        override public function get enabled():Boolean{
            return (super.enabled);
        }
        public function get condenseWhite():Boolean{
            return (textField.condenseWhite);
        }
        public function get alwaysShowSelection():Boolean{
            return (textField.alwaysShowSelection);
        }
        override protected function draw():void{
            var _local1:Object;
            if (isInvalid(InvalidationType.STYLES, InvalidationType.STATE)){
                drawTextFormat();
                drawBackground();
                _local1 = getStyleValue("embedFonts");
                if (_local1 != null){
                    textField.embedFonts = _local1;
                };
                invalidate(InvalidationType.SIZE, false);
            };
            if (isInvalid(InvalidationType.SIZE)){
                drawLayout();
            };
            super.draw();
        }
        protected function handleTextInput(_arg1:TextEvent):void{
            _arg1.stopPropagation();
            dispatchEvent(new TextEvent(TextEvent.TEXT_INPUT, true, false, _arg1.text));
        }
        override protected function configUI():void{
            super.configUI();
            tabChildren = true;
            textField = new TextField();
            addChild(textField);
            updateTextFieldType();
            textField.addEventListener(TextEvent.TEXT_INPUT, handleTextInput, false, 0, true);
            textField.addEventListener(Event.CHANGE, handleChange, false, 0, true);
            textField.addEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown, false, 0, true);
        }
        public function setSelection(_arg1:int, _arg2:int):void{
            textField.setSelection(_arg1, _arg2);
        }
        public function get displayAsPassword():Boolean{
            return (textField.displayAsPassword);
        }
        public function appendText(_arg1:String):void{
            textField.appendText(_arg1);
        }
        public function set restrict(_arg1:String):void{
            if (((componentInspectorSetting) && ((_arg1 == "")))){
                _arg1 = null;
            };
            textField.restrict = _arg1;
        }
        public function get htmlText():String{
            return (textField.htmlText);
        }
        protected function drawBackground():void{
            var _local1:DisplayObject;
            var _local2:String;
            _local1 = background;
            _local2 = (enabled) ? "upSkin" : "disabledSkin";
            background = getDisplayObjectInstance(getStyleValue(_local2));
            if (background == null){
                return;
            };
            addChildAt(background, 0);
            if (((((!((_local1 == null))) && (!((_local1 == background))))) && (contains(_local1)))){
                removeChild(_local1);
            };
        }
        override public function setFocus():void{
            stage.focus = textField;
        }
        protected function drawLayout():void{
            var _local1:Number;
            _local1 = Number(getStyleValue("textPadding"));
            if (background != null){
                background.width = width;
                background.height = height;
            };
            textField.width = (width - (2 * _local1));
            textField.height = (height - (2 * _local1));
            textField.x = (textField.y = _local1);
        }
        public function set maxChars(_arg1:int):void{
            textField.maxChars = _arg1;
        }
        public function get maxHorizontalScrollPosition():int{
            return (textField.maxScrollH);
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
            if (_html){
                textField.htmlText = _savedHTML;
            };
        }
        protected function handleChange(_arg1:Event):void{
            _arg1.stopPropagation();
            dispatchEvent(new Event(Event.CHANGE, true));
        }

    }
}//package fl.controls 
