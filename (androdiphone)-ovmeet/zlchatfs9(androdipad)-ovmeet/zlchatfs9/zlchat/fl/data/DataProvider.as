//hong QQ:1410919373
package fl.data {
    import flash.events.*;
    import fl.events.*;

    public class DataProvider extends EventDispatcher {

        protected var data:Array;

        public function DataProvider(_arg1:Object=null){
            if (_arg1 == null){
                data = [];
            } else {
                data = getDataFromObject(_arg1);
            };
        }
        protected function dispatchPreChangeEvent(_arg1:String, _arg2:Array, _arg3:int, _arg4:int):void{
            dispatchEvent(new DataChangeEvent(DataChangeEvent.PRE_DATA_CHANGE, _arg1, _arg2, _arg3, _arg4));
        }
        public function invalidateItemAt(_arg1:int):void{
            checkIndex(_arg1, (data.length - 1));
            dispatchChangeEvent(DataChangeType.INVALIDATE, [data[_arg1]], _arg1, _arg1);
        }
        public function getItemIndex(_arg1:Object):int{
            return (data.indexOf(_arg1));
        }
        protected function getDataFromObject(_arg1:Object):Array{
            var _local2:Array;
            var _local3:Array;
            var _local4:uint;
            var _local5:Object;
            var _local6:XML;
            var _local7:XMLList;
            var _local8:XML;
            var _local9:XMLList;
            var _local10:XML;
            var _local11:XMLList;
            var _local12:XML;
            if ((_arg1 is Array)){
                _local3 = (_arg1 as Array);
                if (_local3.length > 0){
                    if ((((_local3[0] is String)) || ((_local3[0] is Number)))){
                        _local2 = [];
                        _local4 = 0;
                        while (_local4 < _local3.length) {
                            _local5 = {
                                label:String(_local3[_local4]),
                                data:_local3[_local4]
                            };
                            _local2.push(_local5);
                            _local4++;
                        };
                        return (_local2);
                    };
                };
                return (_arg1.concat());
            };
            if ((_arg1 is DataProvider)){
                return (_arg1.toArray());
            };
            if ((_arg1 is XML)){
                _local6 = (_arg1 as XML);
                _local2 = [];
                _local7 = _local6.*;
                for each (_local8 in _local7) {
                    _arg1 = {};
                    _local9 = _local8.attributes();
                    for each (_local10 in _local9) {
                        _arg1[_local10.localName()] = _local10.toString();
                    };
                    _local11 = _local8.*;
                    for each (_local12 in _local11) {
                        if (_local12.hasSimpleContent()){
                            _arg1[_local12.localName()] = _local12.toString();
                        };
                    };
                    _local2.push(_arg1);
                };
                return (_local2);
            };
            throw (new TypeError((("Error: Type Coercion failed: cannot convert " + _arg1) + " to Array or DataProvider.")));
        }
        public function removeItemAt(_arg1:uint):Object{
            var _local2:Array;
            checkIndex(_arg1, (data.length - 1));
            dispatchPreChangeEvent(DataChangeType.REMOVE, data.slice(_arg1, (_arg1 + 1)), _arg1, _arg1);
            _local2 = data.splice(_arg1, 1);
            dispatchChangeEvent(DataChangeType.REMOVE, _local2, _arg1, _arg1);
            return (_local2[0]);
        }
        public function addItem(_arg1:Object):void{
            dispatchPreChangeEvent(DataChangeType.ADD, [_arg1], (data.length - 1), (data.length - 1));
            data.push(_arg1);
            dispatchChangeEvent(DataChangeType.ADD, [_arg1], (data.length - 1), (data.length - 1));
        }
        public function sortOn(_arg1:Object, _arg2:Object=null){
            var _local3:Array;
            dispatchPreChangeEvent(DataChangeType.SORT, data.concat(), 0, (data.length - 1));
            _local3 = data.sortOn(_arg1, _arg2);
            dispatchChangeEvent(DataChangeType.SORT, data.concat(), 0, (data.length - 1));
            return (_local3);
        }
        public function sort(... _args){
            var _local2:Array;
            dispatchPreChangeEvent(DataChangeType.SORT, data.concat(), 0, (data.length - 1));
            _local2 = data.sort.apply(data, _args);
            dispatchChangeEvent(DataChangeType.SORT, data.concat(), 0, (data.length - 1));
            return (_local2);
        }
        public function addItems(_arg1:Object):void{
            addItemsAt(_arg1, data.length);
        }
        public function concat(_arg1:Object):void{
            addItems(_arg1);
        }
        public function clone():DataProvider{
            return (new DataProvider(data));
        }
        public function toArray():Array{
            return (data.concat());
        }
        public function get length():uint{
            return (data.length);
        }
        public function addItemAt(_arg1:Object, _arg2:uint):void{
            checkIndex(_arg2, data.length);
            dispatchPreChangeEvent(DataChangeType.ADD, [_arg1], _arg2, _arg2);
            data.splice(_arg2, 0, _arg1);
            dispatchChangeEvent(DataChangeType.ADD, [_arg1], _arg2, _arg2);
        }
        public function getItemAt(_arg1:uint):Object{
            checkIndex(_arg1, (data.length - 1));
            return (data[_arg1]);
        }
        override public function toString():String{
            return ((("DataProvider [" + data.join(" , ")) + "]"));
        }
        public function invalidateItem(_arg1:Object):void{
            var _local2:uint;
            _local2 = getItemIndex(_arg1);
            if (_local2 == -1){
                return;
            };
            invalidateItemAt(_local2);
        }
        protected function dispatchChangeEvent(_arg1:String, _arg2:Array, _arg3:int, _arg4:int):void{
            dispatchEvent(new DataChangeEvent(DataChangeEvent.DATA_CHANGE, _arg1, _arg2, _arg3, _arg4));
        }
        protected function checkIndex(_arg1:int, _arg2:int):void{
            if ((((_arg1 > _arg2)) || ((_arg1 < 0)))){
                throw (new RangeError((((("DataProvider index (" + _arg1) + ") is not in acceptable range (0 - ") + _arg2) + ")")));
            };
        }
        public function addItemsAt(_arg1:Object, _arg2:uint):void{
            var _local3:Array;
            checkIndex(_arg2, data.length);
            _local3 = getDataFromObject(_arg1);
            dispatchPreChangeEvent(DataChangeType.ADD, _local3, _arg2, ((_arg2 + _local3.length) - 1));
            data.splice.apply(data, [_arg2, 0].concat(_local3));
            dispatchChangeEvent(DataChangeType.ADD, _local3, _arg2, ((_arg2 + _local3.length) - 1));
        }
        public function replaceItem(_arg1:Object, _arg2:Object):Object{
            var _local3:int;
            _local3 = getItemIndex(_arg2);
            if (_local3 != -1){
                return (replaceItemAt(_arg1, _local3));
            };
            return (null);
        }
        public function removeItem(_arg1:Object):Object{
            var _local2:int;
            _local2 = getItemIndex(_arg1);
            if (_local2 != -1){
                return (removeItemAt(_local2));
            };
            return (null);
        }
        public function merge(_arg1:Object):void{
            var _local2:Array;
            var _local3:uint;
            var _local4:uint;
            var _local5:uint;
            var _local6:Object;
            _local2 = getDataFromObject(_arg1);
            _local3 = _local2.length;
            _local4 = data.length;
            dispatchPreChangeEvent(DataChangeType.ADD, data.slice(_local4, data.length), _local4, (this.data.length - 1));
            _local5 = 0;
            while (_local5 < _local3) {
                _local6 = _local2[_local5];
                if (getItemIndex(_local6) == -1){
                    data.push(_local6);
                };
                _local5++;
            };
            if (data.length > _local4){
                dispatchChangeEvent(DataChangeType.ADD, data.slice(_local4, data.length), _local4, (this.data.length - 1));
            } else {
                dispatchChangeEvent(DataChangeType.ADD, [], -1, -1);
            };
        }
        public function replaceItemAt(_arg1:Object, _arg2:uint):Object{
            var _local3:Array;
            checkIndex(_arg2, (data.length - 1));
            _local3 = [data[_arg2]];
            dispatchPreChangeEvent(DataChangeType.REPLACE, _local3, _arg2, _arg2);
            data[_arg2] = _arg1;
            dispatchChangeEvent(DataChangeType.REPLACE, _local3, _arg2, _arg2);
            return (_local3[0]);
        }
        public function invalidate():void{
            dispatchEvent(new DataChangeEvent(DataChangeEvent.DATA_CHANGE, DataChangeType.INVALIDATE_ALL, data.concat(), 0, data.length));
        }
        public function removeAll():void{
            var _local1:Array;
            _local1 = data.concat();
            dispatchPreChangeEvent(DataChangeType.REMOVE_ALL, _local1, 0, _local1.length);
            data = [];
            dispatchChangeEvent(DataChangeType.REMOVE_ALL, _local1, 0, _local1.length);
        }

    }
}//package fl.data 
