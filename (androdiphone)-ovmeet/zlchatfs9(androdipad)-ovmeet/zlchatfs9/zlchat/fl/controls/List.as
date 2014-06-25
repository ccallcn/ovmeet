//hong QQ:1410919373
package fl.controls {
    import fl.controls.listClasses.*;
    import fl.core.*;
    import flash.display.*;
    import flash.geom.*;
    import flash.events.*;
    import fl.managers.*;
    import flash.utils.*;
    import flash.ui.*;

    public class List extends SelectableList implements IFocusManagerComponent {

        private static var defaultStyles:Object = {
            focusRectSkin:null,
            focusRectPadding:null
        };
        public static var createAccessibilityImplementation:Function;

        protected var _labelField:String = "label";
        protected var _rowHeight:Number = 20;
        protected var _cellRenderer:Object;
        protected var _iconField:String = "icon";
        protected var _labelFunction:Function;
        protected var _iconFunction:Function;

        public function List(){
            _rowHeight = 20;
            _labelField = "label";
            _iconField = "icon";
            super();
        }
        public static function getStyleDefinition():Object{
            return (mergeStyles(defaultStyles, SelectableList.getStyleDefinition()));
        }

        public function get iconField():String{
            return (_iconField);
        }
        protected function doKeySelection(_arg1:int, _arg2:Boolean, _arg3:Boolean):void{
            var _local4:Boolean;
            var _local5:int;
            var _local6:Array;
            var _local7:int;
            var _local8:int;
            _local4 = false;
            if (_arg2){
                _local6 = [];
                _local7 = lastCaretIndex;
                _local8 = _arg1;
                if (_local7 == -1){
                    _local7 = ((caretIndex)!=-1) ? caretIndex : _arg1;
                };
                if (_local7 > _local8){
                    _local8 = _local7;
                    _local7 = _arg1;
                };
                _local5 = _local7;
                while (_local5 <= _local8) {
                    _local6.push(_local5);
                    _local5++;
                };
                selectedIndices = _local6;
                caretIndex = _arg1;
                _local4 = true;
            } else {
                selectedIndex = _arg1;
                caretIndex = (lastCaretIndex = _arg1);
                _local4 = true;
            };
            if (_local4){
                dispatchEvent(new Event(Event.CHANGE));
            };
            invalidate(InvalidationType.DATA);
        }
        override protected function drawList():void{
            var _local1:Rectangle;
            var _local2:uint;
            var _local3:uint;
            var _local4:uint;
            var _local5:Object;
            var _local6:ICellRenderer;
            var _local7:Dictionary;
            var _local8:Dictionary;
            var _local9:Boolean;
            var _local10:String;
            var _local11:Object;
            var _local12:Sprite;
            var _local13:String;
            listHolder.x = (listHolder.y = contentPadding);
            _local1 = listHolder.scrollRect;
            _local1.x = _horizontalScrollPosition;
            _local1.y = (Math.floor(_verticalScrollPosition) % rowHeight);
            listHolder.scrollRect = _local1;
            listHolder.cacheAsBitmap = useBitmapScrolling;
            _local2 = Math.floor((_verticalScrollPosition / rowHeight));
            _local3 = Math.min(length, ((_local2 + rowCount) + 1));
            _local7 = (renderedItems = new Dictionary(true));
            _local4 = _local2;
            while (_local4 < _local3) {
                _local7[_dataProvider.getItemAt(_local4)] = true;
                _local4++;
            };
            _local8 = new Dictionary(true);
            while (activeCellRenderers.length > 0) {
                _local6 = (activeCellRenderers.pop() as ICellRenderer);
                _local5 = _local6.data;
                if ((((_local7[_local5] == null)) || ((invalidItems[_local5] == true)))){
                    availableCellRenderers.push(_local6);
                } else {
                    _local8[_local5] = _local6;
                    invalidItems[_local5] = true;
                };
                list.removeChild((_local6 as DisplayObject));
            };
            invalidItems = new Dictionary(true);
            _local4 = _local2;
            while (_local4 < _local3) {
                _local9 = false;
                _local5 = _dataProvider.getItemAt(_local4);
                if (_local8[_local5] != null){
                    _local9 = true;
                    _local6 = _local8[_local5];
                    É¾  ³ý _local8[_local5];
                } else {
                    if (availableCellRenderers.length > 0){
                        _local6 = (availableCellRenderers.pop() as ICellRenderer);
                    } else {
                        _local6 = (getDisplayObjectInstance(getStyleValue("cellRenderer")) as ICellRenderer);
                        _local12 = (_local6 as Sprite);
                        if (_local12 != null){
                            _local12.addEventListener(MouseEvent.CLICK, handleCellRendererClick, false, 0, true);
                            _local12.addEventListener(MouseEvent.ROLL_OVER, handleCellRendererMouseEvent, false, 0, true);
                            _local12.addEventListener(MouseEvent.ROLL_OUT, handleCellRendererMouseEvent, false, 0, true);
                            _local12.addEventListener(Event.CHANGE, handleCellRendererChange, false, 0, true);
                            _local12.doubleClickEnabled = true;
                            _local12.addEventListener(MouseEvent.DOUBLE_CLICK, handleCellRendererDoubleClick, false, 0, true);
                            if (_local12["setStyle"] != null){
                                for (_local13 in rendererStyles) {
                                    var _local16 = _local12;
                                    _local16["setStyle"](_local13, rendererStyles[_local13]);
                                };
                            };
                        };
                    };
                };
                list.addChild((_local6 as Sprite));
                activeCellRenderers.push(_local6);
                _local6.y = (rowHeight * (_local4 - _local2));
                _local6.setSize((availableWidth + _maxHorizontalScrollPosition), rowHeight);
                _local10 = itemToLabel(_local5);
                _local11 = null;
                if (_iconFunction != null){
                    _local11 = _iconFunction(_local5);
                } else {
                    if (_iconField != null){
                        _local11 = _local5[_iconField];
                    };
                };
                if (!_local9){
                    _local6.data = _local5;
                };
                _local6.listData = new ListData(_local10, _local11, this, _local4, _local4, 0);
                _local6.selected = !((_selectedIndices.indexOf(_local4) == -1));
                if ((_local6 is UIComponent)){
                    (_local6 as UIComponent).drawNow();
                };
                _local4++;
            };
        }
        public function get iconFunction():Function{
            return (_iconFunction);
        }
        public function set iconField(_arg1:String):void{
            if (_arg1 == _iconField){
                return;
            };
            _iconField = _arg1;
            invalidate(InvalidationType.DATA);
        }
        override protected function keyDownHandler(_arg1:KeyboardEvent):void{
            var _local2:int;
            if (!selectable){
                return;
            };
            switch (_arg1.keyCode){
                case Keyboard.UP:
                case Keyboard.DOWN:
                case Keyboard.END:
                case Keyboard.HOME:
                case Keyboard.PAGE_UP:
                case Keyboard.PAGE_DOWN:
                    moveSelectionVertically(_arg1.keyCode, ((_arg1.shiftKey) && (_allowMultipleSelection)), ((_arg1.ctrlKey) && (_allowMultipleSelection)));
                    break;
                case Keyboard.LEFT:
                case Keyboard.RIGHT:
                    moveSelectionHorizontally(_arg1.keyCode, ((_arg1.shiftKey) && (_allowMultipleSelection)), ((_arg1.ctrlKey) && (_allowMultipleSelection)));
                    break;
                case Keyboard.SPACE:
                    if (caretIndex == -1){
                        caretIndex = 0;
                    };
                    doKeySelection(caretIndex, _arg1.shiftKey, _arg1.ctrlKey);
                    scrollToSelected();
                    break;
                default:
                    _local2 = getNextIndexAtLetter(String.fromCharCode(_arg1.keyCode), selectedIndex);
                    if (_local2 > -1){
                        selectedIndex = _local2;
                        scrollToSelected();
                    };
            };
            _arg1.stopPropagation();
        }
        override public function itemToLabel(_arg1:Object):String{
            if (_labelFunction != null){
                return (String(_labelFunction(_arg1)));
            };
            return (((_arg1[_labelField])!=null) ? String(_arg1[_labelField]) : "");
        }
        public function get labelField():String{
            return (_labelField);
        }
        override protected function moveSelectionVertically(_arg1:uint, _arg2:Boolean, _arg3:Boolean):void{
            var _local4:int;
            var _local5:int;
            var _local6:int;
            _local4 = Math.max(Math.floor((calculateAvailableHeight() / rowHeight)), 1);
            _local5 = -1;
            _local6 = 0;
            switch (_arg1){
                case Keyboard.UP:
                    if (caretIndex > 0){
                        _local5 = (caretIndex - 1);
                    };
                    break;
                case Keyboard.DOWN:
                    if (caretIndex < (length - 1)){
                        _local5 = (caretIndex + 1);
                    };
                    break;
                case Keyboard.PAGE_UP:
                    if (caretIndex > 0){
                        _local5 = Math.max((caretIndex - _local4), 0);
                    };
                    break;
                case Keyboard.PAGE_DOWN:
                    if (caretIndex < (length - 1)){
                        _local5 = Math.min((caretIndex + _local4), (length - 1));
                    };
                    break;
                case Keyboard.HOME:
                    if (caretIndex > 0){
                        _local5 = 0;
                    };
                    break;
                case Keyboard.END:
                    if (caretIndex < (length - 1)){
                        _local5 = (length - 1);
                    };
                    break;
            };
            if (_local5 >= 0){
                doKeySelection(_local5, _arg2, _arg3);
                scrollToSelected();
            };
        }
        public function set labelField(_arg1:String):void{
            if (_arg1 == _labelField){
                return;
            };
            _labelField = _arg1;
            invalidate(InvalidationType.DATA);
        }
        public function set rowCount(_arg1:uint):void{
            var _local2:Number;
            var _local3:Number;
            _local2 = Number(getStyleValue("contentPadding"));
            _local3 = ((((_horizontalScrollPolicy == ScrollPolicy.ON)) || ((((_horizontalScrollPolicy == ScrollPolicy.AUTO)) && ((_maxHorizontalScrollPosition > 0)))))) ? 15 : 0;
            height = (((rowHeight * _arg1) + (2 * _local2)) + _local3);
        }
        override protected function setHorizontalScrollPosition(_arg1:Number, _arg2:Boolean=false):void{
            list.x = -(_arg1);
            super.setHorizontalScrollPosition(_arg1, true);
        }
        public function set iconFunction(_arg1:Function):void{
            if (_iconFunction == _arg1){
                return;
            };
            _iconFunction = _arg1;
            invalidate(InvalidationType.DATA);
        }
        public function get labelFunction():Function{
            return (_labelFunction);
        }
        override protected function moveSelectionHorizontally(_arg1:uint, _arg2:Boolean, _arg3:Boolean):void{
        }
        override protected function setVerticalScrollPosition(_arg1:Number, _arg2:Boolean=false):void{
            invalidate(InvalidationType.SCROLL);
            super.setVerticalScrollPosition(_arg1, true);
        }
        protected function calculateAvailableHeight():Number{
            var _local1:Number;
            _local1 = Number(getStyleValue("contentPadding"));
            return (((height - (_local1 * 2)) - ((((_horizontalScrollPolicy == ScrollPolicy.ON)) || ((((_horizontalScrollPolicy == ScrollPolicy.AUTO)) && ((_maxHorizontalScrollPosition > 0)))))) ? 15 : 0));
        }
        override protected function draw():void{
            var _local1:Boolean;
            _local1 = !((contentHeight == (rowHeight * length)));
            contentHeight = (rowHeight * length);
            if (isInvalid(InvalidationType.STYLES)){
                setStyles();
                drawBackground();
                if (contentPadding != getStyleValue("contentPadding")){
                    invalidate(InvalidationType.SIZE, false);
                };
                if (_cellRenderer != getStyleValue("cellRenderer")){
                    _invalidateList();
                    _cellRenderer = getStyleValue("cellRenderer");
                };
            };
            if (((isInvalid(InvalidationType.SIZE, InvalidationType.STATE)) || (_local1))){
                drawLayout();
            };
            if (isInvalid(InvalidationType.RENDERER_STYLES)){
                updateRendererStyles();
            };
            if (isInvalid(InvalidationType.STYLES, InvalidationType.SIZE, InvalidationType.DATA, InvalidationType.SCROLL, InvalidationType.SELECTED)){
                drawList();
            };
            updateChildren();
            validate();
        }
        override protected function configUI():void{
            useFixedHorizontalScrolling = true;
            _horizontalScrollPolicy = ScrollPolicy.AUTO;
            _verticalScrollPolicy = ScrollPolicy.AUTO;
            super.configUI();
        }
        override public function get rowCount():uint{
            return (Math.ceil((calculateAvailableHeight() / rowHeight)));
        }
        override protected function initializeAccessibility():void{
            if (List.createAccessibilityImplementation != null){
                List.createAccessibilityImplementation(this);
            };
        }
        override public function scrollToIndex(_arg1:int):void{
            var _local2:uint;
            var _local3:uint;
            drawNow();
            _local2 = (Math.floor(((_verticalScrollPosition + availableHeight) / rowHeight)) - 1);
            _local3 = Math.ceil((_verticalScrollPosition / rowHeight));
            if (_arg1 < _local3){
                verticalScrollPosition = (_arg1 * rowHeight);
            } else {
                if (_arg1 > _local2){
                    verticalScrollPosition = (((_arg1 + 1) * rowHeight) - availableHeight);
                };
            };
        }
        public function get rowHeight():Number{
            return (_rowHeight);
        }
        public function set labelFunction(_arg1:Function):void{
            if (_labelFunction == _arg1){
                return;
            };
            _labelFunction = _arg1;
            invalidate(InvalidationType.DATA);
        }
        public function set rowHeight(_arg1:Number):void{
            _rowHeight = _arg1;
            invalidate(InvalidationType.SIZE);
        }

    }
}//package fl.controls 
