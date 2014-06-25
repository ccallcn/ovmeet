//hong QQ:1410919373
package fl.controls {
    import fl.core.*;
    import flash.display.*;
    import flash.events.*;
    import fl.managers.*;
    import fl.events.*;
    import flash.text.*;
    import flash.ui.*;
    import flash.system.*;

    public class TextArea extends UIComponent implements IFocusManagerComponent {

        protected static const SCROLL_BAR_STYLES:Object = {
            downArrowDisabledSkin:"downArrowDisabledSkin",
            downArrowDownSkin:"downArrowDownSkin",
            downArrowOverSkin:"downArrowOverSkin",
            downArrowUpSkin:"downArrowUpSkin",
            upArrowDisabledSkin:"upArrowDisabledSkin",
            upArrowDownSkin:"upArrowDownSkin",
            upArrowOverSkin:"upArrowOverSkin",
            upArrowUpSkin:"upArrowUpSkin",
            thumbDisabledSkin:"thumbDisabledSkin",
            thumbDownSkin:"thumbDownSkin",
            thumbOverSkin:"thumbOverSkin",
            thumbUpSkin:"thumbUpSkin",
            thumbIcon:"thumbIcon",
            trackDisabledSkin:"trackDisabledSkin",
            trackDownSkin:"trackDownSkin",
            trackOverSkin:"trackOverSkin",
            trackUpSkin:"trackUpSkin",
            repeatDelay:"repeatDelay",
            repeatInterval:"repeatInterval"
        };

        private static var defaultStyles:Object = {
            upSkin:"TextArea_upSkin",
            disabledSkin:"TextArea_disabledSkin",
            focusRectSkin:null,
            focusRectPadding:null,
            textFormat:null,
            disabledTextFormat:null,
            textPadding:3,
            embedFonts:false
        };
        public static var createAccessibilityImplementation:Function;

        protected var _html:Boolean = false;
        protected var _verticalScrollBar:UIScrollBar;
        protected var _savedHTML:String;
        protected var background:DisplayObject;
        protected var _horizontalScrollBar:UIScrollBar;
        protected var _horizontalScrollPolicy:String = "auto";
        protected var _editable:Boolean = true;
        protected var textHasChanged:Boolean = false;
        public var textField:TextField;
        protected var _wordWrap:Boolean = true;
        protected var _verticalScrollPolicy:String = "auto";

        public function TextArea(){
            _editable = true;
            _wordWrap = true;
            _horizontalScrollPolicy = ScrollPolicy.AUTO;
            _verticalScrollPolicy = ScrollPolicy.AUTO;
            _html = false;
            textHasChanged = false;
            super();
        }
        public static function getStyleDefinition():Object{
            return (UIComponent.mergeStyles(defaultStyles, ScrollBar.getStyleDefinition()));
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
        protected function handleWheel(_arg1:MouseEvent):void{
            if (((!(enabled)) || (!(_verticalScrollBar.visible)))){
                return;
            };
            _verticalScrollBar.scrollPosition = (_verticalScrollBar.scrollPosition - (_arg1.delta * _verticalScrollBar.lineScrollSize));
            dispatchEvent(new ScrollEvent(ScrollBarDirection.VERTICAL, (_arg1.delta * _verticalScrollBar.lineScrollSize), _verticalScrollBar.scrollPosition));
        }
        public function get verticalScrollPosition():Number{
            return (textField.scrollV);
        }
        override protected function isOurFocus(_arg1:DisplayObject):Boolean{
            return ((((_arg1 == textField)) || (super.isOurFocus(_arg1))));
        }
        public function set verticalScrollPosition(_arg1:Number):void{
            drawNow();
            textField.scrollV = _arg1;
        }
        protected function handleKeyDown(_arg1:KeyboardEvent):void{
            if (_arg1.keyCode == Keyboard.ENTER){
                dispatchEvent(new ComponentEvent(ComponentEvent.ENTER, true));
            };
        }
        public function set text(_arg1:String):void{
            if (((componentInspectorSetting) && ((_arg1 == "")))){
                return;
            };
            textField.text = _arg1;
            _html = false;
            invalidate(InvalidationType.DATA);
            invalidate(InvalidationType.STYLES);
            textHasChanged = true;
        }
        protected function updateTextFieldType():void{
            textField.type = (((enabled) && (_editable))) ? TextFieldType.INPUT : TextFieldType.DYNAMIC;
            textField.selectable = enabled;
            textField.wordWrap = _wordWrap;
            textField.multiline = true;
        }
        public function get selectionEndIndex():int{
            return (textField.selectionEndIndex);
        }
        public function get editable():Boolean{
            return (_editable);
        }
        override protected function focusInHandler(_arg1:FocusEvent):void{
            var _local2:IFocusManager;
            setIMEMode(true);
            if (_arg1.target == this){
                stage.focus = textField;
            };
            _local2 = focusManager;
            if (_local2){
                if (editable){
                    _local2.showFocusIndicator = true;
                };
                _local2.defaultButtonEnabled = false;
            };
            super.focusInHandler(_arg1);
            if (editable){
                setIMEMode(true);
            };
        }
        public function get wordWrap():Boolean{
            return (_wordWrap);
        }
        public function get selectionBeginIndex():int{
            return (textField.selectionBeginIndex);
        }
        public function get horizontalScrollBar():UIScrollBar{
            return (_horizontalScrollBar);
        }
        public function set alwaysShowSelection(_arg1:Boolean):void{
            textField.alwaysShowSelection = _arg1;
        }
        override public function set enabled(_arg1:Boolean):void{
            super.enabled = _arg1;
            mouseChildren = enabled;
            invalidate(InvalidationType.STATE);
        }
        protected function setEmbedFont(){
            var _local1:Object;
            _local1 = getStyleValue("embedFonts");
            if (_local1 != null){
                textField.embedFonts = _local1;
            };
        }
        public function get horizontalScrollPosition():Number{
            return (textField.scrollH);
        }
        public function set condenseWhite(_arg1:Boolean):void{
            textField.condenseWhite = _arg1;
            invalidate(InvalidationType.DATA);
        }
        public function get horizontalScrollPolicy():String{
            return (_horizontalScrollPolicy);
        }
        public function set displayAsPassword(_arg1:Boolean):void{
            textField.displayAsPassword = _arg1;
        }
        public function get maxVerticalScrollPosition():int{
            return (textField.maxScrollV);
        }
        public function set horizontalScrollPosition(_arg1:Number):void{
            drawNow();
            textField.scrollH = _arg1;
        }
        public function get textHeight():Number{
            drawNow();
            return (textField.textHeight);
        }
        public function get textWidth():Number{
            drawNow();
            return (textField.textWidth);
        }
        public function get restrict():String{
            return (textField.restrict);
        }
        public function set editable(_arg1:Boolean):void{
            _editable = _arg1;
            invalidate(InvalidationType.STATE);
        }
        protected function updateScrollBars(){
            _horizontalScrollBar.update();
            _verticalScrollBar.update();
            _verticalScrollBar.enabled = enabled;
            _horizontalScrollBar.enabled = enabled;
            _horizontalScrollBar.drawNow();
            _verticalScrollBar.drawNow();
        }
        public function get maxChars():int{
            return (textField.maxChars);
        }
        public function get length():Number{
            return (textField.text.length);
        }
        public function set wordWrap(_arg1:Boolean):void{
            _wordWrap = _arg1;
            invalidate(InvalidationType.STATE);
        }
        public function get verticalScrollPolicy():String{
            return (_verticalScrollPolicy);
        }
        public function getLineMetrics(_arg1:int):TextLineMetrics{
            return (textField.getLineMetrics(_arg1));
        }
        public function get imeMode():String{
            return (IME.conversionMode);
        }
        protected function handleScroll(_arg1:ScrollEvent):void{
            dispatchEvent(_arg1);
        }
        override protected function focusOutHandler(_arg1:FocusEvent):void{
            var _local2:IFocusManager;
            _local2 = focusManager;
            if (_local2){
                _local2.defaultButtonEnabled = true;
            };
            setSelection(0, 0);
            super.focusOutHandler(_arg1);
            if (editable){
                setIMEMode(false);
            };
        }
        protected function delayedLayoutUpdate(_arg1:Event):void{
            if (textHasChanged){
                textHasChanged = false;
                drawLayout();
                return;
            };
            removeEventListener(Event.ENTER_FRAME, delayedLayoutUpdate);
        }
        public function set htmlText(_arg1:String):void{
            if (((componentInspectorSetting) && ((_arg1 == "")))){
                return;
            };
            if (_arg1 == ""){
                text = "";
                return;
            };
            _html = true;
            _savedHTML = _arg1;
            textField.htmlText = _arg1;
            invalidate(InvalidationType.DATA);
            invalidate(InvalidationType.STYLES);
            textHasChanged = true;
        }
        public function get text():String{
            return (textField.text);
        }
        public function get verticalScrollBar():UIScrollBar{
            return (_verticalScrollBar);
        }
        override public function get enabled():Boolean{
            return (super.enabled);
        }
        public function get condenseWhite():Boolean{
            return (textField.condenseWhite);
        }
        public function set horizontalScrollPolicy(_arg1:String):void{
            _horizontalScrollPolicy = _arg1;
            invalidate(InvalidationType.SIZE);
        }
        public function get displayAsPassword():Boolean{
            return (textField.displayAsPassword);
        }
        override protected function draw():void{
            if (isInvalid(InvalidationType.STATE)){
                updateTextFieldType();
            };
            if (isInvalid(InvalidationType.STYLES)){
                setStyles();
                setEmbedFont();
            };
            if (isInvalid(InvalidationType.STYLES, InvalidationType.STATE)){
                drawTextFormat();
                drawBackground();
                invalidate(InvalidationType.SIZE, false);
            };
            if (isInvalid(InvalidationType.SIZE, InvalidationType.DATA)){
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
            _verticalScrollBar = new UIScrollBar();
            _verticalScrollBar.name = "V";
            _verticalScrollBar.visible = false;
            _verticalScrollBar.focusEnabled = false;
            copyStylesToChild(_verticalScrollBar, SCROLL_BAR_STYLES);
            _verticalScrollBar.addEventListener(ScrollEvent.SCROLL, handleScroll, false, 0, true);
            addChild(_verticalScrollBar);
            _horizontalScrollBar = new UIScrollBar();
            _horizontalScrollBar.name = "H";
            _horizontalScrollBar.visible = false;
            _horizontalScrollBar.focusEnabled = false;
            _horizontalScrollBar.direction = ScrollBarDirection.HORIZONTAL;
            copyStylesToChild(_horizontalScrollBar, SCROLL_BAR_STYLES);
            _horizontalScrollBar.addEventListener(ScrollEvent.SCROLL, handleScroll, false, 0, true);
            addChild(_horizontalScrollBar);
            textField.addEventListener(TextEvent.TEXT_INPUT, handleTextInput, false, 0, true);
            textField.addEventListener(Event.CHANGE, handleChange, false, 0, true);
            textField.addEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown, false, 0, true);
            _horizontalScrollBar.scrollTarget = textField;
            _verticalScrollBar.scrollTarget = textField;
            addEventListener(MouseEvent.MOUSE_WHEEL, handleWheel, false, 0, true);
        }
        protected function setTextSize(_arg1:Number, _arg2:Number, _arg3:Number):void{
            var _local4:Number;
            var _local5:Number;
            _local4 = (_arg1 - (_arg3 * 2));
            _local5 = (_arg2 - (_arg3 * 2));
            if (_local4 != textField.width){
                textField.width = _local4;
            };
            if (_local5 != textField.height){
                textField.height = _local5;
            };
        }
        public function appendText(_arg1:String):void{
            textField.appendText(_arg1);
            invalidate(InvalidationType.DATA);
        }
        protected function needVScroll():Boolean{
            if (_verticalScrollPolicy == ScrollPolicy.OFF){
                return (false);
            };
            if (_verticalScrollPolicy == ScrollPolicy.ON){
                return (true);
            };
            return ((textField.maxScrollV > 1));
        }
        public function setSelection(_arg1:int, _arg2:int):void{
            textField.setSelection(_arg1, _arg2);
        }
        public function get alwaysShowSelection():Boolean{
            return (textField.alwaysShowSelection);
        }
        public function get htmlText():String{
            return (textField.htmlText);
        }
        public function set restrict(_arg1:String):void{
            if (((componentInspectorSetting) && ((_arg1 == "")))){
                _arg1 = null;
            };
            textField.restrict = _arg1;
        }
        protected function drawBackground():void{
            var _local1:DisplayObject;
            var _local2:String;
            _local1 = background;
            _local2 = (enabled) ? "upSkin" : "disabledSkin";
            background = getDisplayObjectInstance(getStyleValue(_local2));
            if (background != null){
                addChildAt(background, 0);
            };
            if (((((!((_local1 == null))) && (!((_local1 == background))))) && (contains(_local1)))){
                removeChild(_local1);
            };
        }
        public function set maxChars(_arg1:int):void{
            textField.maxChars = _arg1;
        }
        public function get maxHorizontalScrollPosition():int{
            return (textField.maxScrollH);
        }
        protected function drawLayout():void{
            var _local1:Number;
            var _local2:Number;
            var _local3:Boolean;
            var _local4:Number;
            var _local5:Boolean;
            _local1 = Number(getStyleValue("textPadding"));
            textField.x = (textField.y = _local1);
            background.width = width;
            background.height = height;
            _local2 = height;
            _local3 = needVScroll();
            _local4 = (width - (_local3) ? _verticalScrollBar.width : 0);
            _local5 = needHScroll();
            if (_local5){
                _local2 = (_local2 - _horizontalScrollBar.height);
            };
            setTextSize(_local4, _local2, _local1);
            if (((((_local5) && (!(_local3)))) && (needVScroll()))){
                _local3 = true;
                _local4 = (_local4 - _verticalScrollBar.width);
                setTextSize(_local4, _local2, _local1);
            };
            if (_local3){
                _verticalScrollBar.visible = true;
                _verticalScrollBar.x = (width - _verticalScrollBar.width);
                _verticalScrollBar.height = _local2;
                _verticalScrollBar.visible = true;
                _verticalScrollBar.enabled = enabled;
            } else {
                _verticalScrollBar.visible = false;
            };
            if (_local5){
                _horizontalScrollBar.visible = true;
                _horizontalScrollBar.y = (height - _horizontalScrollBar.height);
                _horizontalScrollBar.width = _local4;
                _horizontalScrollBar.visible = true;
                _horizontalScrollBar.enabled = enabled;
            } else {
                _horizontalScrollBar.visible = false;
            };
            updateScrollBars();
            addEventListener(Event.ENTER_FRAME, delayedLayoutUpdate, false, 0, true);
        }
        protected function setStyles():void{
            copyStylesToChild(_verticalScrollBar, SCROLL_BAR_STYLES);
            copyStylesToChild(_horizontalScrollBar, SCROLL_BAR_STYLES);
        }
        protected function needHScroll():Boolean{
            if (_horizontalScrollPolicy == ScrollPolicy.OFF){
                return (false);
            };
            if (_horizontalScrollPolicy == ScrollPolicy.ON){
                return (true);
            };
            return ((textField.maxScrollH > 0));
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
        public function set verticalScrollPolicy(_arg1:String):void{
            _verticalScrollPolicy = _arg1;
            invalidate(InvalidationType.SIZE);
        }
        protected function handleChange(_arg1:Event):void{
            _arg1.stopPropagation();
            dispatchEvent(new Event(Event.CHANGE, true));
            invalidate(InvalidationType.DATA);
        }

    }
}//package fl.controls 
