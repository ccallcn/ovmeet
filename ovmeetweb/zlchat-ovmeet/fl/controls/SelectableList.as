//hong QQ:1410919373
package fl.controls {
    import fl.controls.listClasses.*;
    import fl.core.*;
    import flash.display.*;
    import flash.events.*;
    import fl.data.*;
    import fl.managers.*;
    import fl.events.*;
    import flash.utils.*;
    import fl.containers.*;
    import flash.ui.*;

    public class SelectableList extends BaseScrollPane implements IFocusManagerComponent {

        private static var defaultStyles:Object = {
            skin:"List_skin",
            cellRenderer:CellRenderer,
            contentPadding:null,
            disabledAlpha:null
        };
        public static var createAccessibilityImplementation:Function;

        protected var invalidItems:Dictionary;
        protected var renderedItems:Dictionary;
        protected var listHolder:Sprite;
        protected var _allowMultipleSelection:Boolean = false;
        protected var lastCaretIndex:int = -1;
        protected var _selectedIndices:Array;
        protected var availableCellRenderers:Array;
        protected var list:Sprite;
        protected var caretIndex:int = -1;
        protected var updatedRendererStyles:Object;
        protected var preChangeItems:Array;
        protected var activeCellRenderers:Array;
        protected var rendererStyles:Object;
        protected var _verticalScrollPosition:Number;
        protected var _dataProvider:DataProvider;
        protected var _horizontalScrollPosition:Number;
        private var collectionItemImport:SimpleCollectionItem;
        protected var _selectable:Boolean = true;

        public function SelectableList(){
            _allowMultipleSelection = false;
            _selectable = true;
            caretIndex = -1;
            lastCaretIndex = -1;
            super();
            activeCellRenderers = [];
            availableCellRenderers = [];
            invalidItems = new Dictionary(true);
            renderedItems = new Dictionary(true);
            _selectedIndices = [];
            if (dataProvider == null){
                dataProvider = new DataProvider();
            };
            verticalScrollPolicy = ScrollPolicy.AUTO;
            rendererStyles = {};
            updatedRendererStyles = {};
        }
        public static function getStyleDefinition():Object{
            return (mergeStyles(defaultStyles, BaseScrollPane.getStyleDefinition()));
        }

        protected function drawList():void{
        }
        public function set allowMultipleSelection(_arg1:Boolean):void{
            if (_arg1 == _allowMultipleSelection){
                return;
            };
            _allowMultipleSelection = _arg1;
            if (((!(_arg1)) && ((_selectedIndices.length > 1)))){
                _selectedIndices = [_selectedIndices.pop()];
                invalidate(InvalidationType.DATA);
            };
        }
        public function sortItemsOn(_arg1:String, _arg2:Object=null){
            return (_dataProvider.sortOn(_arg1, _arg2));
        }
        public function removeItemAt(_arg1:uint):Object{
            return (_dataProvider.removeItemAt(_arg1));
        }
        public function get selectedItem():Object{
            return (((_selectedIndices.length)==0) ? null : _dataProvider.getItemAt(selectedIndex));
        }
        override protected function keyDownHandler(_arg1:KeyboardEvent):void{
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
                    _arg1.stopPropagation();
                    break;
                case Keyboard.LEFT:
                case Keyboard.RIGHT:
                    moveSelectionHorizontally(_arg1.keyCode, ((_arg1.shiftKey) && (_allowMultipleSelection)), ((_arg1.ctrlKey) && (_allowMultipleSelection)));
                    _arg1.stopPropagation();
                    break;
            };
        }
        public function get selectable():Boolean{
            return (_selectable);
        }
        public function itemToCellRenderer(_arg1:Object):ICellRenderer{
            var _local2:*;
            var _local3:ICellRenderer;
            if (_arg1 != null){
                for (_local2 in activeCellRenderers) {
                    _local3 = (activeCellRenderers[_local2] as ICellRenderer);
                    if (_local3.data == _arg1){
                        return (_local3);
                    };
                };
            };
            return (null);
        }
        public function getNextIndexAtLetter(_arg1:String, _arg2:int=-1):int{
            var _local3:int;
            var _local4:Number;
            var _local5:Number;
            var _local6:Object;
            var _local7:String;
            if (length == 0){
                return (-1);
            };
            _arg1 = _arg1.toUpperCase();
            _local3 = (length - 1);
            _local4 = 0;
            while (_local4 < _local3) {
                _local5 = ((_arg2 + 1) + _local4);
                if (_local5 > (length - 1)){
                    _local5 = (_local5 - length);
                };
                _local6 = getItemAt(_local5);
                if (_local6 == null){
                    break;
                };
                _local7 = itemToLabel(_local6);
                if (_local7 == null){
                } else {
                    if (_local7.charAt(0).toUpperCase() == _arg1){
                        return (_local5);
                    };
                };
                _local4++;
            };
            return (-1);
        }
        public function invalidateList():void{
            _invalidateList();
            invalidate(InvalidationType.DATA);
        }
        override public function set enabled(_arg1:Boolean):void{
            super.enabled = _arg1;
            list.mouseChildren = _enabled;
        }
        public function get selectedIndices():Array{
            return (_selectedIndices.concat());
        }
        public function set selectable(_arg1:Boolean):void{
            if (_arg1 == _selectable){
                return;
            };
            if (!_arg1){
                selectedIndices = [];
            };
            _selectable = _arg1;
        }
        public function itemToLabel(_arg1:Object):String{
            return (_arg1["label"]);
        }
        public function addItemAt(_arg1:Object, _arg2:uint):void{
            _dataProvider.addItemAt(_arg1, _arg2);
            invalidateList();
        }
        public function replaceItemAt(_arg1:Object, _arg2:uint):Object{
            return (_dataProvider.replaceItemAt(_arg1, _arg2));
        }
        protected function handleDataChange(_arg1:DataChangeEvent):void{
            var _local2:int;
            var _local3:int;
            var _local4:String;
            var _local5:uint;
            _local2 = _arg1.startIndex;
            _local3 = _arg1.endIndex;
            _local4 = _arg1.changeType;
            if (_local4 == DataChangeType.INVALIDATE_ALL){
                clearSelection();
                invalidateList();
            } else {
                if (_local4 == DataChangeType.INVALIDATE){
                    _local5 = 0;
                    while (_local5 < _arg1.items.length) {
                        invalidateItem(_arg1.items[_local5]);
                        _local5++;
                    };
                } else {
                    if (_local4 == DataChangeType.ADD){
                        _local5 = 0;
                        while (_local5 < _selectedIndices.length) {
                            if (_selectedIndices[_local5] >= _local2){
                                _selectedIndices[_local5] = (_selectedIndices[_local5] + (_local2 - _local3));
                            };
                            _local5++;
                        };
                    } else {
                        if (_local4 == DataChangeType.REMOVE){
                            _local5 = 0;
                            while (_local5 < _selectedIndices.length) {
                                if (_selectedIndices[_local5] >= _local2){
                                    if (_selectedIndices[_local5] <= _local3){
                                        É¾  ³ý _selectedIndices[_local5];
                                    } else {
                                        _selectedIndices[_local5] = (_selectedIndices[_local5] - ((_local2 - _local3) + 1));
                                    };
                                };
                                _local5++;
                            };
                        } else {
                            if (_local4 == DataChangeType.REMOVE_ALL){
                                clearSelection();
                            } else {
                                if (_local4 == DataChangeType.REPLACE){
                                } else {
                                    selectedItems = preChangeItems;
                                    preChangeItems = null;
                                };
                            };
                        };
                    };
                };
            };
            invalidate(InvalidationType.DATA);
        }
        protected function _invalidateList():void{
            availableCellRenderers = [];
            while (activeCellRenderers.length > 0) {
                list.removeChild((activeCellRenderers.pop() as DisplayObject));
            };
        }
        protected function updateRendererStyles():void{
            var _local1:Array;
            var _local2:uint;
            var _local3:uint;
            var _local4:String;
            _local1 = availableCellRenderers.concat(activeCellRenderers);
            _local2 = _local1.length;
            _local3 = 0;
            while (_local3 < _local2) {
                if (_local1[_local3].setStyle == null){
                } else {
                    for (_local4 in updatedRendererStyles) {
                        _local1[_local3].setStyle(_local4, updatedRendererStyles[_local4]);
                    };
                    _local1[_local3].drawNow();
                };
                _local3++;
            };
            updatedRendererStyles = {};
        }
        public function set selectedItem(_arg1:Object):void{
            var _local2:int;
            _local2 = _dataProvider.getItemIndex(_arg1);
            selectedIndex = _local2;
        }
        public function sortItems(... _args){
            return (_dataProvider.sort.apply(_dataProvider, _args));
        }
        public function removeAll():void{
            _dataProvider.removeAll();
        }
        protected function handleCellRendererChange(_arg1:Event):void{
            var _local2:ICellRenderer;
            var _local3:uint;
            _local2 = (_arg1.currentTarget as ICellRenderer);
            _local3 = _local2.listData.index;
            _dataProvider.invalidateItemAt(_local3);
        }
        protected function moveSelectionVertically(_arg1:uint, _arg2:Boolean, _arg3:Boolean):void{
        }
        override protected function setHorizontalScrollPosition(_arg1:Number, _arg2:Boolean=false):void{
            var _local3:Number;
            if (_arg1 == _horizontalScrollPosition){
                return;
            };
            _local3 = (_arg1 - _horizontalScrollPosition);
            _horizontalScrollPosition = _arg1;
            if (_arg2){
                dispatchEvent(new ScrollEvent(ScrollBarDirection.HORIZONTAL, _local3, _arg1));
            };
        }
        public function scrollToSelected():void{
            scrollToIndex(selectedIndex);
        }
        public function invalidateItem(_arg1:Object):void{
            if (renderedItems[_arg1] == null){
                return;
            };
            invalidItems[_arg1] = true;
            invalidate(InvalidationType.DATA);
        }
        protected function handleCellRendererClick(_arg1:MouseEvent):void{
            var _local2:ICellRenderer;
            var _local3:uint;
            var _local4:int;
            var _local5:int;
            var _local6:uint;
            if (!_enabled){
                return;
            };
            _local2 = (_arg1.currentTarget as ICellRenderer);
            _local3 = _local2.listData.index;
            if (((!(dispatchEvent(new ListEvent(ListEvent.ITEM_CLICK, false, true, _local2.listData.column, _local2.listData.row, _local3, _local2.data)))) || (!(_selectable)))){
                return;
            };
            _local4 = selectedIndices.indexOf(_local3);
            if (!_allowMultipleSelection){
                if (_local4 != -1){
                    return;
                };
                _local2.selected = true;
                _selectedIndices = [_local3];
                lastCaretIndex = (caretIndex = _local3);
            } else {
                if (_arg1.shiftKey){
                    _local6 = ((_selectedIndices.length)>0) ? _selectedIndices[0] : _local3;
                    _selectedIndices = [];
                    if (_local6 > _local3){
                        _local5 = _local6;
                        while (_local5 >= _local3) {
                            _selectedIndices.push(_local5);
                            _local5--;
                        };
                    } else {
                        _local5 = _local6;
                        while (_local5 <= _local3) {
                            _selectedIndices.push(_local5);
                            _local5++;
                        };
                    };
                    caretIndex = _local3;
                } else {
                    if (_arg1.ctrlKey){
                        if (_local4 != -1){
                            _local2.selected = false;
                            _selectedIndices.splice(_local4, 1);
                        } else {
                            _local2.selected = true;
                            _selectedIndices.push(_local3);
                        };
                        caretIndex = _local3;
                    } else {
                        _selectedIndices = [_local3];
                        lastCaretIndex = (caretIndex = _local3);
                    };
                };
            };
            dispatchEvent(new Event(Event.CHANGE));
            invalidate(InvalidationType.DATA);
        }
        public function get length():uint{
            return (_dataProvider.length);
        }
        public function get allowMultipleSelection():Boolean{
            return (_allowMultipleSelection);
        }
        protected function onPreChange(_arg1:DataChangeEvent):void{
            switch (_arg1.changeType){
                case DataChangeType.REMOVE:
                case DataChangeType.ADD:
                case DataChangeType.INVALIDATE:
                case DataChangeType.REMOVE_ALL:
                case DataChangeType.REPLACE:
                case DataChangeType.INVALIDATE_ALL:
                    break;
                default:
                    preChangeItems = selectedItems;
            };
        }
        public function getRendererStyle(_arg1:String, _arg2:int=-1):Object{
            return (rendererStyles[_arg1]);
        }
        override protected function setVerticalScrollPosition(_arg1:Number, _arg2:Boolean=false):void{
            var _local3:Number;
            if (_arg1 == _verticalScrollPosition){
                return;
            };
            _local3 = (_arg1 - _verticalScrollPosition);
            _verticalScrollPosition = _arg1;
            if (_arg2){
                dispatchEvent(new ScrollEvent(ScrollBarDirection.VERTICAL, _local3, _arg1));
            };
        }
        protected function moveSelectionHorizontally(_arg1:uint, _arg2:Boolean, _arg3:Boolean):void{
        }
        public function set selectedIndices(_arg1:Array):void{
            if (!_selectable){
                return;
            };
            _selectedIndices = ((_arg1)==null) ? [] : _arg1.concat();
            invalidate(InvalidationType.SELECTED);
        }
        public function get selectedIndex():int{
            return (((_selectedIndices.length)==0) ? -1 : _selectedIndices[(_selectedIndices.length - 1)]);
        }
        override protected function draw():void{
            super.draw();
        }
        override protected function configUI():void{
            super.configUI();
            listHolder = new Sprite();
            addChild(listHolder);
            listHolder.scrollRect = contentScrollRect;
            list = new Sprite();
            listHolder.addChild(list);
        }
        public function addItem(_arg1:Object):void{
            _dataProvider.addItem(_arg1);
            invalidateList();
        }
        protected function handleCellRendererMouseEvent(_arg1:MouseEvent):void{
            var _local2:ICellRenderer;
            var _local3:String;
            _local2 = (_arg1.target as ICellRenderer);
            _local3 = ((_arg1.type)==MouseEvent.ROLL_OVER) ? ListEvent.ITEM_ROLL_OVER : ListEvent.ITEM_ROLL_OUT;
            dispatchEvent(new ListEvent(_local3, false, false, _local2.listData.column, _local2.listData.row, _local2.listData.index, _local2.data));
        }
        public function clearRendererStyle(_arg1:String, _arg2:int=-1):void{
            É¾  ³ý rendererStyles[_arg1];
            updatedRendererStyles[_arg1] = null;
            invalidate(InvalidationType.RENDERER_STYLES);
        }
        protected function handleCellRendererDoubleClick(_arg1:MouseEvent):void{
            var _local2:ICellRenderer;
            var _local3:uint;
            if (!_enabled){
                return;
            };
            _local2 = (_arg1.currentTarget as ICellRenderer);
            _local3 = _local2.listData.index;
            dispatchEvent(new ListEvent(ListEvent.ITEM_DOUBLE_CLICK, false, true, _local2.listData.column, _local2.listData.row, _local3, _local2.data));
        }
        public function get rowCount():uint{
            return (0);
        }
        public function isItemSelected(_arg1:Object):Boolean{
            return ((selectedItems.indexOf(_arg1) > -1));
        }
        public function set dataProvider(_arg1:DataProvider):void{
            if (_dataProvider != null){
                _dataProvider.removeEventListener(DataChangeEvent.DATA_CHANGE, handleDataChange);
                _dataProvider.removeEventListener(DataChangeEvent.PRE_DATA_CHANGE, onPreChange);
            };
            _dataProvider = _arg1;
            _dataProvider.addEventListener(DataChangeEvent.DATA_CHANGE, handleDataChange, false, 0, true);
            _dataProvider.addEventListener(DataChangeEvent.PRE_DATA_CHANGE, onPreChange, false, 0, true);
            clearSelection();
            invalidateList();
        }
        override protected function drawLayout():void{
            super.drawLayout();
            contentScrollRect = listHolder.scrollRect;
            contentScrollRect.width = availableWidth;
            contentScrollRect.height = availableHeight;
            listHolder.scrollRect = contentScrollRect;
        }
        public function getItemAt(_arg1:uint):Object{
            return (_dataProvider.getItemAt(_arg1));
        }
        override protected function initializeAccessibility():void{
            if (SelectableList.createAccessibilityImplementation != null){
                SelectableList.createAccessibilityImplementation(this);
            };
        }
        public function scrollToIndex(_arg1:int):void{
        }
        public function removeItem(_arg1:Object):Object{
            return (_dataProvider.removeItem(_arg1));
        }
        public function get dataProvider():DataProvider{
            return (_dataProvider);
        }
        public function set maxHorizontalScrollPosition(_arg1:Number):void{
            _maxHorizontalScrollPosition = _arg1;
            invalidate(InvalidationType.SIZE);
        }
        public function setRendererStyle(_arg1:String, _arg2:Object, _arg3:uint=0):void{
            if (rendererStyles[_arg1] == _arg2){
                return;
            };
            updatedRendererStyles[_arg1] = _arg2;
            rendererStyles[_arg1] = _arg2;
            invalidate(InvalidationType.RENDERER_STYLES);
        }
        public function invalidateItemAt(_arg1:uint):void{
            var _local2:Object;
            _local2 = _dataProvider.getItemAt(_arg1);
            if (_local2 != null){
                invalidateItem(_local2);
            };
        }
        public function set selectedItems(_arg1:Array):void{
            var _local2:Array;
            var _local3:uint;
            var _local4:int;
            if (_arg1 == null){
                selectedIndices = null;
                return;
            };
            _local2 = [];
            _local3 = 0;
            while (_local3 < _arg1.length) {
                _local4 = _dataProvider.getItemIndex(_arg1[_local3]);
                if (_local4 != -1){
                    _local2.push(_local4);
                };
                _local3++;
            };
            selectedIndices = _local2;
        }
        public function clearSelection():void{
            selectedIndex = -1;
        }
        override public function get maxHorizontalScrollPosition():Number{
            return (_maxHorizontalScrollPosition);
        }
        public function get selectedItems():Array{
            var _local1:Array;
            var _local2:uint;
            _local1 = [];
            _local2 = 0;
            while (_local2 < _selectedIndices.length) {
                _local1.push(_dataProvider.getItemAt(_selectedIndices[_local2]));
                _local2++;
            };
            return (_local1);
        }
        public function set selectedIndex(_arg1:int):void{
            selectedIndices = ((_arg1)==-1) ? null : [_arg1];
        }

    }
}//package fl.controls 
