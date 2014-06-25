//hong QQ:1410919373
package fl.controls {
    import fl.core.*;
    import flash.display.*;
    import flash.geom.*;
    import flash.events.*;
    import fl.managers.*;
    import fl.events.*;
    import flash.text.*;
    import flash.ui.*;

    public class ColorPicker extends UIComponent implements IFocusManagerComponent {

        protected static const SWATCH_STYLES:Object = {
            disabledSkin:"swatchSkin",
            downSkin:"swatchSkin",
            overSkin:"swatchSkin",
            upSkin:"swatchSkin"
        };
        protected static const POPUP_BUTTON_STYLES:Object = {
            disabledSkin:"disabledSkin",
            downSkin:"downSkin",
            overSkin:"overSkin",
            upSkin:"upSkin"
        };

        public static var defaultColors:Array;
        private static var defaultStyles:Object = {
            upSkin:"ColorPicker_upSkin",
            disabledSkin:"ColorPicker_disabledSkin",
            overSkin:"ColorPicker_overSkin",
            downSkin:"ColorPicker_downSkin",
            colorWell:"ColorPicker_colorWell",
            swatchSkin:"ColorPicker_swatchSkin",
            swatchSelectedSkin:"ColorPicker_swatchSelectedSkin",
            swatchWidth:10,
            swatchHeight:10,
            columnCount:18,
            swatchPadding:1,
            textFieldSkin:"ColorPicker_textFieldSkin",
            textFieldWidth:null,
            textFieldHeight:null,
            textPadding:3,
            background:"ColorPicker_backgroundSkin",
            backgroundPadding:5,
            textFormat:null,
            focusRectSkin:null,
            focusRectPadding:null,
            embedFonts:false
        };

        protected var paletteBG:DisplayObject;
        protected var customColors:Array;
        protected var palette:Sprite;
        protected var isOpen:Boolean = false;
        protected var swatchButton:BaseButton;
        protected var selectedSwatch:Sprite;
        protected var textFieldBG:DisplayObject;
        protected var colorWell:DisplayObject;
        protected var rollOverColor:int = -1;
        protected var colorHash:Object;
        protected var swatchSelectedSkin:DisplayObject;
        protected var _showTextField:Boolean = true;
        protected var currRowIndex:int;
        protected var doOpen:Boolean = false;
        protected var currColIndex:int;
        protected var swatchMap:Array;
        protected var _selectedColor:uint;
        protected var _editable:Boolean = true;
        public var textField:TextField;
        protected var swatches:Sprite;

        public function ColorPicker(){
            rollOverColor = -1;
            _editable = true;
            _showTextField = true;
            isOpen = false;
            doOpen = false;
            super();
        }
        public static function getStyleDefinition():Object{
            return (defaultStyles);
        }

        public function set imeMode(_arg1:String):void{
            _imeMode = _arg1;
        }
        protected function drawSwatchHighlight():void{
            var _local1:Object;
            var _local2:Number;
            cleanUpSelected();
            _local1 = getStyleValue("swatchSelectedSkin");
            _local2 = (getStyleValue("swatchPadding") as Number);
            if (_local1 != null){
                swatchSelectedSkin = getDisplayObjectInstance(_local1);
                swatchSelectedSkin.x = 0;
                swatchSelectedSkin.y = 0;
                swatchSelectedSkin.width = ((getStyleValue("swatchWidth") as Number) + 2);
                swatchSelectedSkin.height = ((getStyleValue("swatchHeight") as Number) + 2);
            };
        }
        protected function setColorWellColor(_arg1:ColorTransform):void{
            if (!colorWell){
                return;
            };
            colorWell.transform.colorTransform = _arg1;
        }
        override protected function isOurFocus(_arg1:DisplayObject):Boolean{
            return ((((_arg1 == textField)) || (super.isOurFocus(_arg1))));
        }
        public function open():void{
            var _local1:IFocusManager;
            if (!_enabled){
                return;
            };
            doOpen = true;
            _local1 = focusManager;
            if (_local1){
                _local1.defaultButtonEnabled = false;
            };
            invalidate(InvalidationType.STATE);
        }
        protected function setTextEditable():void{
            if (!showTextField){
                return;
            };
            textField.type = (editable) ? TextFieldType.INPUT : TextFieldType.DYNAMIC;
            textField.selectable = editable;
        }
        protected function createSwatch(_arg1:uint):Sprite{
            var _local2:Sprite;
            var _local3:BaseButton;
            var _local4:Number;
            var _local5:Number;
            var _local6:Number;
            var _local7:Graphics;
            _local2 = new Sprite();
            _local3 = new BaseButton();
            _local3.focusEnabled = false;
            _local4 = (getStyleValue("swatchWidth") as Number);
            _local5 = (getStyleValue("swatchHeight") as Number);
            _local3.setSize(_local4, _local5);
            _local3.transform.colorTransform = new ColorTransform(0, 0, 0, 1, (_arg1 >> 16), ((_arg1 >> 8) & 0xFF), (_arg1 & 0xFF), 0);
            copyStylesToChild(_local3, SWATCH_STYLES);
            _local3.mouseEnabled = false;
            _local3.drawNow();
            _local3.name = "color";
            _local2.addChild(_local3);
            _local6 = (getStyleValue("swatchPadding") as Number);
            _local7 = _local2.graphics;
            _local7.beginFill(0);
            _local7.drawRect(-(_local6), -(_local6), (_local4 + (_local6 * 2)), (_local5 + (_local6 * 2)));
            _local7.endFill();
            _local2.addEventListener(MouseEvent.CLICK, onSwatchClick, false, 0, true);
            _local2.addEventListener(MouseEvent.MOUSE_OVER, onSwatchOver, false, 0, true);
            _local2.addEventListener(MouseEvent.MOUSE_OUT, onSwatchOut, false, 0, true);
            return (_local2);
        }
        protected function onSwatchOut(_arg1:MouseEvent):void{
            var _local2:ColorTransform;
            _local2 = _arg1.target.transform.colorTransform;
            dispatchEvent(new ColorPickerEvent(ColorPickerEvent.ITEM_ROLL_OUT, _local2.color));
        }
        override protected function keyDownHandler(_arg1:KeyboardEvent):void{
            var _local2:ColorTransform;
            var _local3:Sprite;
            switch (_arg1.keyCode){
                case Keyboard.SHIFT:
                case Keyboard.CONTROL:
                    return;
            };
            if (_arg1.ctrlKey){
                switch (_arg1.keyCode){
                    case Keyboard.DOWN:
                        open();
                        break;
                    case Keyboard.UP:
                        close();
                        break;
                };
                return;
            };
            if (!isOpen){
                switch (_arg1.keyCode){
                    case Keyboard.UP:
                    case Keyboard.DOWN:
                    case Keyboard.LEFT:
                    case Keyboard.RIGHT:
                    case Keyboard.SPACE:
                        open();
                        return;
                };
            };
            textField.maxChars = ((((_arg1.keyCode == "#".charCodeAt(0))) || ((textField.text.indexOf("#") > -1)))) ? 7 : 6;
            switch (_arg1.keyCode){
                case Keyboard.TAB:
                    _local3 = findSwatch(_selectedColor);
                    setSwatchHighlight(_local3);
                    return;
                case Keyboard.HOME:
                    currColIndex = (currRowIndex = 0);
                    break;
                case Keyboard.END:
                    currColIndex = (swatchMap[(swatchMap.length - 1)].length - 1);
                    currRowIndex = (swatchMap.length - 1);
                    break;
                case Keyboard.PAGE_DOWN:
                    currRowIndex = (swatchMap.length - 1);
                    break;
                case Keyboard.PAGE_UP:
                    currRowIndex = 0;
                    break;
                case Keyboard.ESCAPE:
                    if (isOpen){
                        selectedColor = _selectedColor;
                    };
                    close();
                    return;
                case Keyboard.ENTER:
                    return;
                case Keyboard.UP:
                    currRowIndex = Math.max(-1, (currRowIndex - 1));
                    if (currRowIndex == -1){
                        currRowIndex = (swatchMap.length - 1);
                    };
                    break;
                case Keyboard.DOWN:
                    currRowIndex = Math.min(swatchMap.length, (currRowIndex + 1));
                    if (currRowIndex == swatchMap.length){
                        currRowIndex = 0;
                    };
                    break;
                case Keyboard.RIGHT:
                    currColIndex = Math.min(swatchMap[currRowIndex].length, (currColIndex + 1));
                    if (currColIndex == swatchMap[currRowIndex].length){
                        currColIndex = 0;
                        currRowIndex = Math.min(swatchMap.length, (currRowIndex + 1));
                        if (currRowIndex == swatchMap.length){
                            currRowIndex = 0;
                        };
                    };
                    break;
                case Keyboard.LEFT:
                    currColIndex = Math.max(-1, (currColIndex - 1));
                    if (currColIndex == -1){
                        currColIndex = (swatchMap[currRowIndex].length - 1);
                        currRowIndex = Math.max(-1, (currRowIndex - 1));
                        if (currRowIndex == -1){
                            currRowIndex = (swatchMap.length - 1);
                        };
                    };
                    break;
                default:
                    return;
            };
            _local2 = swatchMap[currRowIndex][currColIndex].getChildByName("color").transform.colorTransform;
            rollOverColor = _local2.color;
            setColorWellColor(_local2);
            setSwatchHighlight(swatchMap[currRowIndex][currColIndex]);
            setColorText(_local2.color);
        }
        public function get editable():Boolean{
            return (_editable);
        }
        override protected function focusInHandler(_arg1:FocusEvent):void{
            super.focusInHandler(_arg1);
            setIMEMode(true);
        }
        protected function onStageClick(_arg1:MouseEvent):void{
            if (((!(contains((_arg1.target as DisplayObject)))) && (!(palette.contains((_arg1.target as DisplayObject)))))){
                selectedColor = _selectedColor;
                close();
            };
        }
        protected function onSwatchOver(_arg1:MouseEvent):void{
            var _local2:BaseButton;
            var _local3:ColorTransform;
            _local2 = (_arg1.target.getChildByName("color") as BaseButton);
            _local3 = _local2.transform.colorTransform;
            setColorWellColor(_local3);
            setSwatchHighlight((_arg1.target as Sprite));
            setColorText(_local3.color);
            dispatchEvent(new ColorPickerEvent(ColorPickerEvent.ITEM_ROLL_OVER, _local3.color));
        }
        override public function set enabled(_arg1:Boolean):void{
            super.enabled = _arg1;
            if (!_arg1){
                close();
            };
            swatchButton.enabled = _arg1;
        }
        override protected function keyUpHandler(_arg1:KeyboardEvent):void{
            var _local2:uint;
            var _local3:ColorTransform;
            var _local4:String;
            var _local5:Sprite;
            if (!isOpen){
                return;
            };
            _local3 = new ColorTransform();
            if (((editable) && (showTextField))){
                _local4 = textField.text;
                if (_local4.indexOf("#") > -1){
                    _local4 = _local4.replace(/^\s+|\s+$/g, "");
                    _local4 = _local4.replace(/#/g, "");
                };
                _local2 = parseInt(_local4, 16);
                _local5 = findSwatch(_local2);
                setSwatchHighlight(_local5);
                _local3.color = _local2;
                setColorWellColor(_local3);
            } else {
                _local2 = rollOverColor;
                _local3.color = _local2;
            };
            if (_arg1.keyCode != Keyboard.ENTER){
                return;
            };
            dispatchEvent(new ColorPickerEvent(ColorPickerEvent.ENTER, _local2));
            _selectedColor = rollOverColor;
            setColorText(_local3.color);
            rollOverColor = _local3.color;
            dispatchEvent(new ColorPickerEvent(ColorPickerEvent.CHANGE, selectedColor));
            close();
        }
        protected function drawBG():void{
            var _local1:Object;
            var _local2:Number;
            _local1 = getStyleValue("background");
            if (_local1 != null){
                paletteBG = (getDisplayObjectInstance(_local1) as Sprite);
            };
            if (paletteBG == null){
                return;
            };
            _local2 = Number(getStyleValue("backgroundPadding"));
            paletteBG.width = (Math.max((showTextField) ? textFieldBG.width : 0, swatches.width) + (_local2 * 2));
            paletteBG.height = ((swatches.y + swatches.height) + _local2);
            palette.addChildAt(paletteBG, 0);
        }
        protected function positionTextField():void{
            var _local1:Number;
            var _local2:Number;
            if (!showTextField){
                return;
            };
            _local1 = (getStyleValue("backgroundPadding") as Number);
            _local2 = (getStyleValue("textPadding") as Number);
            textFieldBG.x = (paletteBG.x + _local1);
            textFieldBG.y = (paletteBG.y + _local1);
            textField.x = (textFieldBG.x + _local2);
            textField.y = (textFieldBG.y + _local2);
        }
        protected function setEmbedFonts():void{
            var _local1:Object;
            _local1 = getStyleValue("embedFonts");
            if (_local1 != null){
                textField.embedFonts = _local1;
            };
        }
        public function set showTextField(_arg1:Boolean):void{
            invalidate(InvalidationType.STYLES);
            _showTextField = _arg1;
        }
        protected function addStageListener(_arg1:Event=null):void{
            stage.addEventListener(MouseEvent.MOUSE_DOWN, onStageClick, false, 0, true);
        }
        protected function drawPalette():void{
            if (isOpen){
                stage.removeChild(palette);
            };
            palette = new Sprite();
            drawTextField();
            drawSwatches();
            drawBG();
        }
        protected function showPalette():void{
            var _local1:Sprite;
            if (isOpen){
                positionPalette();
                return;
            };
            addEventListener(Event.ENTER_FRAME, addCloseListener, false, 0, true);
            stage.addChild(palette);
            isOpen = true;
            positionPalette();
            dispatchEvent(new Event(Event.OPEN));
            stage.focus = textField;
            _local1 = selectedSwatch;
            if (_local1 == null){
                _local1 = findSwatch(_selectedColor);
            };
            setSwatchHighlight(_local1);
        }
        public function set editable(_arg1:Boolean):void{
            _editable = _arg1;
            invalidate(InvalidationType.STATE);
        }
        public function set colors(_arg1:Array):void{
            customColors = _arg1;
            invalidate(InvalidationType.DATA);
        }
        protected function drawTextField():void{
            var _local1:Number;
            var _local2:Number;
            var _local3:Object;
            var _local4:TextFormat;
            var _local5:TextFormat;
            if (!showTextField){
                return;
            };
            _local1 = (getStyleValue("backgroundPadding") as Number);
            _local2 = (getStyleValue("textPadding") as Number);
            textFieldBG = getDisplayObjectInstance(getStyleValue("textFieldSkin"));
            if (textFieldBG != null){
                palette.addChild(textFieldBG);
                textFieldBG.x = (textFieldBG.y = _local1);
            };
            _local3 = UIComponent.getStyleDefinition();
            _local4 = (enabled) ? (_local3.defaultTextFormat as TextFormat) : (_local3.defaultDisabledTextFormat as TextFormat);
            textField.setTextFormat(_local4);
            _local5 = (getStyleValue("textFormat") as TextFormat);
            if (_local5 != null){
                textField.setTextFormat(_local5);
            } else {
                _local5 = _local4;
            };
            textField.defaultTextFormat = _local5;
            setEmbedFonts();
            textField.restrict = "A-Fa-f0-9#";
            textField.maxChars = 6;
            palette.addChild(textField);
            textField.text = " #888888 ";
            textField.height = (textField.textHeight + 3);
            textField.width = (textField.textWidth + 3);
            textField.text = "";
            textField.x = (textField.y = (_local1 + _local2));
            textFieldBG.width = (textField.width + (_local2 * 2));
            textFieldBG.height = (textField.height + (_local2 * 2));
            setTextEditable();
        }
        protected function setColorText(_arg1:uint):void{
            if (textField == null){
                return;
            };
            textField.text = ("#" + colorToString(_arg1));
        }
        protected function colorToString(_arg1:uint):String{
            var _local2:String;
            _local2 = _arg1.toString(16);
            while (_local2.length < 6) {
                _local2 = ("0" + _local2);
            };
            return (_local2);
        }
        public function get imeMode():String{
            return (_imeMode);
        }
        public function set selectedColor(_arg1:uint):void{
            var _local2:ColorTransform;
            if (!_enabled){
                return;
            };
            _selectedColor = _arg1;
            rollOverColor = -1;
            currColIndex = (currRowIndex = 0);
            _local2 = new ColorTransform();
            _local2.color = _arg1;
            setColorWellColor(_local2);
            invalidate(InvalidationType.DATA);
        }
        override protected function focusOutHandler(_arg1:FocusEvent):void{
            if (_arg1.relatedObject == textField){
                setFocus();
                return;
            };
            if (isOpen){
                close();
            };
            super.focusOutHandler(_arg1);
            setIMEMode(false);
        }
        protected function onPopupButtonClick(_arg1:MouseEvent):void{
            if (isOpen){
                close();
            } else {
                open();
            };
        }
        protected function positionPalette():void{
            var _local1:Point;
            var _local2:Number;
            _local1 = swatchButton.localToGlobal(new Point(0, 0));
            _local2 = (getStyleValue("backgroundPadding") as Number);
            if ((_local1.x + palette.width) > stage.stageWidth){
                palette.x = ((_local1.x - palette.width) << 0);
            } else {
                palette.x = (((_local1.x + swatchButton.width) + _local2) << 0);
            };
            palette.y = (Math.max(0, Math.min(_local1.y, (stage.stageHeight - palette.height))) << 0);
        }
        public function get hexValue():String{
            if (colorWell == null){
                return (colorToString(0));
            };
            return (colorToString(colorWell.transform.colorTransform.color));
        }
        override public function get enabled():Boolean{
            return (super.enabled);
        }
        protected function setSwatchHighlight(_arg1:Sprite):void{
            var _local2:Number;
            var _local3:*;
            if (_arg1 == null){
                if (palette.contains(swatchSelectedSkin)){
                    palette.removeChild(swatchSelectedSkin);
                };
                return;
            };
            if (((!(palette.contains(swatchSelectedSkin))) && ((colors.length > 0)))){
                palette.addChild(swatchSelectedSkin);
            } else {
                if (!colors.length){
                    return;
                };
            };
            _local2 = (getStyleValue("swatchPadding") as Number);
            palette.setChildIndex(swatchSelectedSkin, (palette.numChildren - 1));
            swatchSelectedSkin.x = ((swatches.x + _arg1.x) - 1);
            swatchSelectedSkin.y = ((swatches.y + _arg1.y) - 1);
            _local3 = _arg1.getChildByName("color").transform.colorTransform.color;
            currColIndex = colorHash[_local3].col;
            currRowIndex = colorHash[_local3].row;
        }
        protected function onSwatchClick(_arg1:MouseEvent):void{
            var _local2:ColorTransform;
            _local2 = _arg1.target.getChildByName("color").transform.colorTransform;
            _selectedColor = _local2.color;
            dispatchEvent(new ColorPickerEvent(ColorPickerEvent.CHANGE, selectedColor));
            close();
        }
        override protected function draw():void{
            if (isInvalid(InvalidationType.STYLES, InvalidationType.DATA)){
                setStyles();
                drawPalette();
                setEmbedFonts();
                invalidate(InvalidationType.DATA, false);
                invalidate(InvalidationType.STYLES, false);
            };
            if (isInvalid(InvalidationType.DATA)){
                drawSwatchHighlight();
                setColorDisplay();
            };
            if (isInvalid(InvalidationType.STATE)){
                setTextEditable();
                if (doOpen){
                    doOpen = false;
                    showPalette();
                };
                colorWell.visible = enabled;
            };
            if (isInvalid(InvalidationType.SIZE, InvalidationType.STYLES)){
                swatchButton.setSize(width, height);
                swatchButton.drawNow();
                colorWell.width = width;
                colorWell.height = height;
            };
            super.draw();
        }
        protected function drawSwatches():void{
            var _local1:Number;
            var _local2:Number;
            var _local3:uint;
            var _local4:uint;
            var _local5:Number;
            var _local6:Number;
            var _local7:uint;
            var _local8:int;
            var _local9:uint;
            var _local10:Sprite;
            _local1 = (getStyleValue("backgroundPadding") as Number);
            _local2 = (showTextField) ? ((textFieldBG.y + textFieldBG.height) + _local1) : _local1;
            swatches = new Sprite();
            palette.addChild(swatches);
            swatches.x = _local1;
            swatches.y = _local2;
            _local3 = (getStyleValue("columnCount") as uint);
            _local4 = (getStyleValue("swatchPadding") as uint);
            _local5 = (getStyleValue("swatchWidth") as Number);
            _local6 = (getStyleValue("swatchHeight") as Number);
            colorHash = {};
            swatchMap = [];
            _local7 = Math.min(0x0400, colors.length);
            _local8 = -1;
            _local9 = 0;
            while (_local9 < _local7) {
                _local10 = createSwatch(colors[_local9]);
                _local10.x = ((_local5 + _local4) * (_local9 % _local3));
                if (_local10.x == 0){
                    swatchMap.push([_local10]);
                    _local8++;
                } else {
                    swatchMap[_local8].push(_local10);
                };
                colorHash[colors[_local9]] = {
                    swatch:_local10,
                    row:_local8,
                    col:(swatchMap[_local8].length - 1)
                };
                _local10.y = (Math.floor((_local9 / _local3)) * (_local6 + _local4));
                swatches.addChild(_local10);
                _local9++;
            };
        }
        override protected function configUI():void{
            var _local1:uint;
            super.configUI();
            tabChildren = false;
            if (ColorPicker.defaultColors == null){
                ColorPicker.defaultColors = [];
                _local1 = 0;
                while (_local1 < 216) {
                    ColorPicker.defaultColors.push(((((((((_local1 / 6) % 3) << 0) + (((_local1 / 108) << 0) * 3)) * 51) << 16) | (((_local1 % 6) * 51) << 8)) | ((((_local1 / 18) << 0) % 6) * 51)));
                    _local1++;
                };
            };
            colorHash = {};
            swatchMap = [];
            textField = new TextField();
            textField.tabEnabled = false;
            swatchButton = new BaseButton();
            swatchButton.focusEnabled = false;
            swatchButton.useHandCursor = false;
            swatchButton.autoRepeat = false;
            swatchButton.setSize(25, 25);
            swatchButton.addEventListener(MouseEvent.CLICK, onPopupButtonClick, false, 0, true);
            addChild(swatchButton);
            palette = new Sprite();
            palette.tabChildren = false;
            palette.cacheAsBitmap = true;
        }
        public function get showTextField():Boolean{
            return (_showTextField);
        }
        public function get colors():Array{
            return (((customColors)!=null) ? customColors : ColorPicker.defaultColors);
        }
        protected function findSwatch(_arg1:uint):Sprite{
            var _local2:Object;
            if (!swatchMap.length){
                return (null);
            };
            _local2 = colorHash[_arg1];
            if (_local2 != null){
                return (_local2.swatch);
            };
            return (null);
        }
        protected function setColorDisplay():void{
            var _local1:ColorTransform;
            var _local2:Sprite;
            if (!swatchMap.length){
                return;
            };
            _local1 = new ColorTransform(0, 0, 0, 1, (_selectedColor >> 16), ((_selectedColor >> 8) & 0xFF), (_selectedColor & 0xFF), 0);
            setColorWellColor(_local1);
            setColorText(_selectedColor);
            _local2 = findSwatch(_selectedColor);
            setSwatchHighlight(_local2);
            if (((swatchMap.length) && ((colorHash[_selectedColor] == undefined)))){
                cleanUpSelected();
            };
        }
        protected function cleanUpSelected():void{
            if (((swatchSelectedSkin) && (palette.contains(swatchSelectedSkin)))){
                palette.removeChild(swatchSelectedSkin);
            };
        }
        public function get selectedColor():uint{
            if (colorWell == null){
                return (0);
            };
            return (colorWell.transform.colorTransform.color);
        }
        private function addCloseListener(_arg1:Event){
            removeEventListener(Event.ENTER_FRAME, addCloseListener);
            if (!isOpen){
                return;
            };
            addStageListener();
        }
        protected function removeStageListener(_arg1:Event=null):void{
            stage.removeEventListener(MouseEvent.MOUSE_DOWN, onStageClick, false);
        }
        protected function setStyles():void{
            var _local1:DisplayObject;
            var _local2:Object;
            _local1 = colorWell;
            _local2 = getStyleValue("colorWell");
            if (_local2 != null){
                colorWell = (getDisplayObjectInstance(_local2) as DisplayObject);
            };
            addChildAt(colorWell, getChildIndex(swatchButton));
            copyStylesToChild(swatchButton, POPUP_BUTTON_STYLES);
            swatchButton.drawNow();
            if (((((!((_local1 == null))) && (contains(_local1)))) && (!((_local1 == colorWell))))){
                removeChild(_local1);
            };
        }
        public function close():void{
            var _local1:IFocusManager;
            if (isOpen){
                stage.removeChild(palette);
                isOpen = false;
                dispatchEvent(new Event(Event.CLOSE));
            };
            _local1 = focusManager;
            if (_local1){
                _local1.defaultButtonEnabled = true;
            };
            removeStageListener();
            cleanUpSelected();
        }

    }
}//package fl.controls 
