//hong QQ:1410919373
package fl.controls {
    import fl.controls.listClasses.*;
    import fl.core.*;
    import flash.display.*;
    import flash.geom.*;
    import flash.events.*;
    import fl.data.*;
    import fl.managers.*;
    import fl.events.*;
    import flash.text.*;
    import flash.ui.*;

    public class ComboBox extends UIComponent implements IFocusManagerComponent {

        protected static const BACKGROUND_STYLES:Object = {
            overSkin:"overSkin",
            downSkin:"downSkin",
            upSkin:"upSkin",
            disabledSkin:"disabledSkin",
            repeatInterval:"repeatInterval"
        };
        protected static const LIST_STYLES:Object = {
            upSkin:"comboListUpSkin",
            overSkin:"comboListOverSkin",
            downSkin:"comobListDownSkin",
            disabledSkin:"comboListDisabledSkin",
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
            repeatInterval:"repeatInterval",
            textFormat:"textFormat",
            disabledAlpha:"disabledAlpha",
            skin:"listSkin"
        };

        private static var defaultStyles:Object = {
            upSkin:"ComboBox_upSkin",
            downSkin:"ComboBox_downSkin",
            overSkin:"ComboBox_overSkin",
            disabledSkin:"ComboBox_disabledSkin",
            focusRectSkin:null,
            focusRectPadding:null,
            textFormat:null,
            disabledTextFormat:null,
            textPadding:3,
            buttonWidth:24,
            disabledAlpha:null,
            listSkin:null
        };
        public static var createAccessibilityImplementation:Function;

        protected var _dropdownWidth:Number;
        protected var highlightedCell:int = -1;
        protected var _prompt:String;
        protected var isOpen:Boolean = false;
        protected var list:List;
        protected var _rowCount:uint = 5;
        protected var currentIndex:int;
        protected var isKeyDown:Boolean = false;
        protected var _labels:Array;
        protected var background:BaseButton;
        protected var inputField:TextInput;
        protected var listOverIndex:uint;
        protected var editableValue:String;
        protected var _editable:Boolean = false;
        private var collectionItemImport:SimpleCollectionItem;

        public function ComboBox(){
            _rowCount = 5;
            _editable = false;
            isOpen = false;
            highlightedCell = -1;
            isKeyDown = false;
            super();
        }
        public static function getStyleDefinition():Object{
            return (mergeStyles(defaultStyles, List.getStyleDefinition()));
        }

        protected function drawList():void{
            list.rowCount = Math.max(0, Math.min(_rowCount, list.dataProvider.length));
        }
        public function set imeMode(_arg1:String):void{
            inputField.imeMode = _arg1;
        }
        public function get dropdown():List{
            return (list);
        }
        public function get dropdownWidth():Number{
            return (list.width);
        }
        public function sortItemsOn(_arg1:String, _arg2:Object=null){
            return (list.sortItemsOn(_arg1, _arg2));
        }
        protected function onEnter(_arg1:ComponentEvent):void{
            _arg1.stopPropagation();
        }
        public function removeItemAt(_arg1:uint):void{
            list.removeItemAt(_arg1);
            invalidate(InvalidationType.DATA);
        }
        public function open():void{
            currentIndex = selectedIndex;
            if (((isOpen) || ((length == 0)))){
                return;
            };
            dispatchEvent(new Event(Event.OPEN));
            isOpen = true;
            addEventListener(Event.ENTER_FRAME, addCloseListener, false, 0, true);
            positionList();
            list.scrollToSelected();
            stage.addChild(list);
        }
        public function get selectedItem():Object{
            return (list.selectedItem);
        }
        public function set text(_arg1:String):void{
            if (!editable){
                return;
            };
            inputField.text = _arg1;
        }
        public function get labelField():String{
            return (list.labelField);
        }
        override protected function keyDownHandler(_arg1:KeyboardEvent):void{
            var _local2:int;
            var _local3:uint;
            var _local4:Number;
            var _local5:int;
            isKeyDown = true;
            if (_arg1.ctrlKey){
                switch (_arg1.keyCode){
                    case Keyboard.UP:
                        if (highlightedCell > -1){
                            selectedIndex = highlightedCell;
                            dispatchEvent(new Event(Event.CHANGE));
                        };
                        close();
                        break;
                    case Keyboard.DOWN:
                        open();
                        break;
                };
                return;
            };
            _arg1.stopPropagation();
            _local2 = Math.max(((calculateAvailableHeight() / list.rowHeight) << 0), 1);
            _local3 = selectedIndex;
            _local4 = ((highlightedCell)==-1) ? selectedIndex : highlightedCell;
            _local5 = -1;
            switch (_arg1.keyCode){
                case Keyboard.SPACE:
                    if (isOpen){
                        close();
                    } else {
                        open();
                    };
                    return;
                case Keyboard.ESCAPE:
                    if (isOpen){
                        if (highlightedCell > -1){
                            selectedIndex = selectedIndex;
                        };
                        close();
                    };
                    return;
                case Keyboard.UP:
                    _local5 = Math.max(0, (_local4 - 1));
                    break;
                case Keyboard.DOWN:
                    _local5 = Math.min((length - 1), (_local4 + 1));
                    break;
                case Keyboard.PAGE_UP:
                    _local5 = Math.max((_local4 - _local2), 0);
                    break;
                case Keyboard.PAGE_DOWN:
                    _local5 = Math.min((_local4 + _local2), (length - 1));
                    break;
                case Keyboard.HOME:
                    _local5 = 0;
                    break;
                case Keyboard.END:
                    _local5 = (length - 1);
                    break;
                case Keyboard.ENTER:
                    if (((_editable) && ((highlightedCell == -1)))){
                        editableValue = inputField.text;
                        selectedIndex = -1;
                    } else {
                        if (((isOpen) && ((highlightedCell > -1)))){
                            editableValue = null;
                            selectedIndex = highlightedCell;
                            dispatchEvent(new Event(Event.CHANGE));
                        };
                    };
                    dispatchEvent(new ComponentEvent(ComponentEvent.ENTER));
                    close();
                    return;
                default:
                    if (editable){
                        break;
                    };
                    _local5 = list.getNextIndexAtLetter(String.fromCharCode(_arg1.keyCode), _local4);
            };
            if (_local5 > -1){
                if (isOpen){
                    highlightCell(_local5);
                    inputField.text = list.itemToLabel(getItemAt(_local5));
                } else {
                    highlightCell();
                    selectedIndex = _local5;
                    dispatchEvent(new Event(Event.CHANGE));
                };
            };
        }
        public function set dropdownWidth(_arg1:Number):void{
            _dropdownWidth = _arg1;
            invalidate(InvalidationType.SIZE);
        }
        public function get editable():Boolean{
            return (_editable);
        }
        override protected function focusInHandler(_arg1:FocusEvent):void{
            super.focusInHandler(_arg1);
            if (editable){
                stage.focus = inputField.textField;
            };
        }
        protected function onStageClick(_arg1:MouseEvent):void{
            if (!isOpen){
                return;
            };
            if (((!(contains((_arg1.target as DisplayObject)))) && (!(list.contains((_arg1.target as DisplayObject)))))){
                if (highlightedCell != -1){
                    selectedIndex = highlightedCell;
                    dispatchEvent(new Event(Event.CHANGE));
                };
                close();
            };
        }
        protected function handleDataChange(_arg1:DataChangeEvent):void{
            invalidate(InvalidationType.DATA);
        }
        override protected function keyUpHandler(_arg1:KeyboardEvent):void{
            isKeyDown = false;
        }
        protected function onListItemUp(_arg1:MouseEvent):void{
            var _local2:*;
            stage.removeEventListener(MouseEvent.MOUSE_UP, onListItemUp);
            if (((!((_arg1.target is ICellRenderer))) || (!(list.contains((_arg1.target as DisplayObject)))))){
                return;
            };
            editableValue = null;
            _local2 = selectedIndex;
            selectedIndex = _arg1.target.listData.index;
            if (_local2 != selectedIndex){
                dispatchEvent(new Event(Event.CHANGE));
            };
            close();
        }
        public function removeAll():void{
            list.removeAll();
            inputField.text = "";
            invalidate(InvalidationType.DATA);
        }
        public function set selectedItem(_arg1:Object):void{
            list.selectedItem = _arg1;
            invalidate(InvalidationType.SELECTED);
        }
        protected function highlightCell(_arg1:int=-1):void{
            var _local2:ICellRenderer;
            if (highlightedCell > -1){
                _local2 = list.itemToCellRenderer(getItemAt(highlightedCell));
                if (_local2 != null){
                    _local2.setMouseState("up");
                };
            };
            if (_arg1 == -1){
                return;
            };
            list.scrollToIndex(_arg1);
            list.drawNow();
            _local2 = list.itemToCellRenderer(getItemAt(_arg1));
            if (_local2 != null){
                _local2.setMouseState("over");
                highlightedCell = _arg1;
            };
        }
        public function itemToLabel(_arg1:Object):String{
            if (_arg1 == null){
                return ("");
            };
            return (list.itemToLabel(_arg1));
        }
        public function addItemAt(_arg1:Object, _arg2:uint):void{
            list.addItemAt(_arg1, _arg2);
            invalidate(InvalidationType.DATA);
        }
        public function replaceItemAt(_arg1:Object, _arg2:uint):Object{
            return (list.replaceItemAt(_arg1, _arg2));
        }
        protected function showPrompt():void{
            inputField.text = _prompt;
        }
        public function set rowCount(_arg1:uint):void{
            _rowCount = _arg1;
            invalidate(InvalidationType.SIZE);
        }
        public function get restrict():String{
            return (inputField.restrict);
        }
        protected function setEmbedFonts():void{
            var _local1:Object;
            _local1 = getStyleValue("embedFonts");
            if (_local1 != null){
                inputField.textField.embedFonts = _local1;
            };
        }
        public function sortItems(... _args){
            return (list.sortItems.apply(list, _args));
        }
        public function set labelField(_arg1:String):void{
            list.labelField = _arg1;
            invalidate(InvalidationType.DATA);
        }
        public function set editable(_arg1:Boolean):void{
            _editable = _arg1;
            drawTextField();
        }
        public function set prompt(_arg1:String):void{
            if (_arg1 == ""){
                _prompt = null;
            } else {
                _prompt = _arg1;
            };
            invalidate(InvalidationType.STATE);
        }
        public function get length():int{
            return (list.length);
        }
        protected function drawTextField():void{
            inputField.setStyle("upSkin", "");
            inputField.setStyle("disabledSkin", "");
            inputField.enabled = enabled;
            inputField.editable = _editable;
            inputField.textField.selectable = ((enabled) && (_editable));
            inputField.mouseEnabled = (inputField.mouseChildren = ((enabled) && (_editable)));
            inputField.focusEnabled = false;
            if (_editable){
                inputField.addEventListener(FocusEvent.FOCUS_IN, onInputFieldFocus, false, 0, true);
                inputField.addEventListener(FocusEvent.FOCUS_OUT, onInputFieldFocusOut, false, 0, true);
            } else {
                inputField.removeEventListener(FocusEvent.FOCUS_IN, onInputFieldFocus);
                inputField.removeEventListener(FocusEvent.FOCUS_OUT, onInputFieldFocusOut);
            };
        }
        protected function onInputFieldFocusOut(_arg1:FocusEvent):void{
            inputField.removeEventListener(ComponentEvent.ENTER, onEnter);
            selectedIndex = selectedIndex;
        }
        protected function passEvent(_arg1:Event):void{
            dispatchEvent(_arg1);
        }
        public function get imeMode():String{
            return (inputField.imeMode);
        }
        public function get labelFunction():Function{
            return (list.labelFunction);
        }
        protected function calculateAvailableHeight():Number{
            var _local1:Number;
            _local1 = Number(getStyleValue("contentPadding"));
            return ((list.height - (_local1 * 2)));
        }
        public function get selectedIndex():int{
            return (list.selectedIndex);
        }
        override protected function focusOutHandler(_arg1:FocusEvent):void{
            isKeyDown = false;
            if (isOpen){
                if (((!(_arg1.relatedObject)) || (!(list.contains(_arg1.relatedObject))))){
                    if (((!((highlightedCell == -1))) && (!((highlightedCell == selectedIndex))))){
                        selectedIndex = highlightedCell;
                        dispatchEvent(new Event(Event.CHANGE));
                    };
                    close();
                };
            };
            super.focusOutHandler(_arg1);
        }
        public function get selectedLabel():String{
            if (editableValue != null){
                return (editableValue);
            };
            if (selectedIndex == -1){
                return (null);
            };
            return (itemToLabel(selectedItem));
        }
        public function get text():String{
            return (inputField.text);
        }
        protected function onListChange(_arg1:Event):void{
            editableValue = null;
            dispatchEvent(_arg1);
            invalidate(InvalidationType.SELECTED);
            if (isKeyDown){
                return;
            };
            close();
        }
        protected function onToggleListVisibility(_arg1:MouseEvent):void{
            _arg1.stopPropagation();
            dispatchEvent(_arg1);
            if (isOpen){
                close();
            } else {
                open();
                stage.addEventListener(MouseEvent.MOUSE_UP, onListItemUp, false, 0, true);
            };
        }
        override protected function draw():void{
            var _local1:*;
            _local1 = selectedIndex;
            if ((((_local1 == -1)) && (((((!((prompt == null))) || (editable))) || ((length == 0)))))){
                _local1 = Math.max(-1, Math.min(_local1, (length - 1)));
            } else {
                editableValue = null;
                _local1 = Math.max(0, Math.min(_local1, (length - 1)));
            };
            if (list.selectedIndex != _local1){
                list.selectedIndex = _local1;
                invalidate(InvalidationType.SELECTED, false);
            };
            if (isInvalid(InvalidationType.STYLES)){
                setStyles();
                setEmbedFonts();
                invalidate(InvalidationType.SIZE, false);
            };
            if (isInvalid(InvalidationType.SIZE, InvalidationType.DATA, InvalidationType.STATE)){
                drawTextFormat();
                drawLayout();
                invalidate(InvalidationType.DATA);
            };
            if (isInvalid(InvalidationType.DATA)){
                drawList();
                invalidate(InvalidationType.SELECTED, true);
            };
            if (isInvalid(InvalidationType.SELECTED)){
                if ((((_local1 == -1)) && (!((editableValue == null))))){
                    inputField.text = editableValue;
                } else {
                    if (_local1 > -1){
                        if (length > 0){
                            inputField.horizontalScrollPosition = 0;
                            inputField.text = itemToLabel(list.selectedItem);
                        };
                    } else {
                        if ((((_local1 == -1)) && (!((_prompt == null))))){
                            showPrompt();
                        } else {
                            inputField.text = "";
                        };
                    };
                };
                if (((((editable) && ((selectedIndex > -1)))) && ((stage.focus == inputField.textField)))){
                    inputField.setSelection(0, inputField.length);
                };
            };
            drawTextField();
            super.draw();
        }
        public function addItem(_arg1:Object):void{
            list.addItem(_arg1);
            invalidate(InvalidationType.DATA);
        }
        public function get rowCount():uint{
            return (_rowCount);
        }
        override protected function configUI():void{
            super.configUI();
            background = new BaseButton();
            background.focusEnabled = false;
            copyStylesToChild(background, BACKGROUND_STYLES);
            background.addEventListener(MouseEvent.MOUSE_DOWN, onToggleListVisibility, false, 0, true);
            addChild(background);
            inputField = new TextInput();
            inputField.focusTarget = (this as IFocusManagerComponent);
            inputField.focusEnabled = false;
            inputField.addEventListener(Event.CHANGE, onTextInput, false, 0, true);
            addChild(inputField);
            list = new List();
            list.focusEnabled = false;
            copyStylesToChild(list, LIST_STYLES);
            list.addEventListener(Event.CHANGE, onListChange, false, 0, true);
            list.addEventListener(ListEvent.ITEM_CLICK, onListChange, false, 0, true);
            list.addEventListener(ListEvent.ITEM_ROLL_OUT, passEvent, false, 0, true);
            list.addEventListener(ListEvent.ITEM_ROLL_OVER, passEvent, false, 0, true);
            list.verticalScrollBar.addEventListener(Event.SCROLL, passEvent, false, 0, true);
        }
        protected function positionList():void{
            var _local1:Point;
            _local1 = localToGlobal(new Point(0, 0));
            list.x = _local1.x;
            if (((_local1.y + height) + list.height) > stage.stageHeight){
                list.y = (_local1.y - list.height);
            } else {
                list.y = (_local1.y + height);
            };
        }
        public function get value():String{
            var _local1:Object;
            if (editableValue != null){
                return (editableValue);
            };
            _local1 = selectedItem;
            if (((!(_editable)) && (!((_local1.data == null))))){
                return (_local1.data);
            };
            return (itemToLabel(_local1));
        }
        public function get prompt():String{
            return (_prompt);
        }
        public function set dataProvider(_arg1:DataProvider):void{
            _arg1.addEventListener(DataChangeEvent.DATA_CHANGE, handleDataChange, false, 0, true);
            list.dataProvider = _arg1;
            invalidate(InvalidationType.DATA);
        }
        public function set restrict(_arg1:String):void{
            if (((componentInspectorSetting) && ((_arg1 == "")))){
                _arg1 = null;
            };
            if (!_editable){
                return;
            };
            inputField.restrict = _arg1;
        }
        protected function onTextInput(_arg1:Event):void{
            _arg1.stopPropagation();
            if (!_editable){
                return;
            };
            editableValue = inputField.text;
            selectedIndex = -1;
            dispatchEvent(new Event(Event.CHANGE));
        }
        protected function onInputFieldFocus(_arg1:FocusEvent):void{
            inputField.addEventListener(ComponentEvent.ENTER, onEnter, false, 0, true);
            close();
        }
        public function getItemAt(_arg1:uint):Object{
            return (list.getItemAt(_arg1));
        }
        override protected function initializeAccessibility():void{
            if (ComboBox.createAccessibilityImplementation != null){
                ComboBox.createAccessibilityImplementation(this);
            };
        }
        protected function drawLayout():void{
            var _local1:Number;
            var _local2:Number;
            _local1 = (getStyleValue("buttonWidth") as Number);
            _local2 = (getStyleValue("textPadding") as Number);
            background.setSize(width, height);
            inputField.x = (inputField.y = _local2);
            inputField.setSize(((width - _local1) - _local2), (height - _local2));
            list.width = (isNaN(_dropdownWidth)) ? width : _dropdownWidth;
            background.enabled = enabled;
            background.drawNow();
        }
        public function removeItem(_arg1:Object):Object{
            return (list.removeItem(_arg1));
        }
        private function addCloseListener(_arg1:Event){
            removeEventListener(Event.ENTER_FRAME, addCloseListener);
            if (!isOpen){
                return;
            };
            stage.addEventListener(MouseEvent.MOUSE_DOWN, onStageClick, false, 0, true);
        }
        public function get dataProvider():DataProvider{
            return (list.dataProvider);
        }
        public function get textField():TextInput{
            return (inputField);
        }
        protected function setStyles():void{
            copyStylesToChild(background, BACKGROUND_STYLES);
            copyStylesToChild(list, LIST_STYLES);
        }
        public function set labelFunction(_arg1:Function):void{
            list.labelFunction = _arg1;
            invalidate(InvalidationType.DATA);
        }
        protected function drawTextFormat():void{
            var _local1:TextFormat;
            _local1 = (getStyleValue((_enabled) ? "textFormat" : "disabledTextFormat") as TextFormat);
            if (_local1 == null){
                _local1 = new TextFormat();
            };
            inputField.textField.defaultTextFormat = _local1;
            inputField.textField.setTextFormat(_local1);
            setEmbedFonts();
        }
        public function set selectedIndex(_arg1:int):void{
            list.selectedIndex = _arg1;
            highlightCell();
            invalidate(InvalidationType.SELECTED);
        }
        public function close():void{
            highlightCell();
            highlightedCell = -1;
            if (!isOpen){
                return;
            };
            dispatchEvent(new Event(Event.CLOSE));
            stage.removeEventListener(MouseEvent.MOUSE_DOWN, onStageClick);
            isOpen = false;
            stage.removeChild(list);
        }

    }
}//package fl.controls 
