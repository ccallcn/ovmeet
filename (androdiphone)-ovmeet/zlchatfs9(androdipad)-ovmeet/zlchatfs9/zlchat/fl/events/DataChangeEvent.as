//hong QQ:1410919373
package fl.events {
    import flash.events.*;

    public class DataChangeEvent extends Event {

        public static const PRE_DATA_CHANGE:String = "preDataChange";
        public static const DATA_CHANGE:String = "dataChange";

        protected var _items:Array;
        protected var _endIndex:uint;
        protected var _changeType:String;
        protected var _startIndex:uint;

        public function DataChangeEvent(_arg1:String, _arg2:String, _arg3:Array, _arg4:int=-1, _arg5:int=-1):void{
            super(_arg1);
            _changeType = _arg2;
            _startIndex = _arg4;
            _items = _arg3;
            _endIndex = ((_arg5)==-1) ? _startIndex : _arg5;
        }
        public function get changeType():String{
            return (_changeType);
        }
        public function get startIndex():uint{
            return (_startIndex);
        }
        public function get items():Array{
            return (_items);
        }
        override public function clone():Event{
            return (new DataChangeEvent(type, _changeType, _items, _startIndex, _endIndex));
        }
        override public function toString():String{
            return (formatToString("DataChangeEvent", "type", "changeType", "startIndex", "endIndex", "bubbles", "cancelable"));
        }
        public function get endIndex():uint{
            return (_endIndex);
        }

    }
}//package fl.events 
