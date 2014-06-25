//hong QQ:1410919373
package fl.events {
    import flash.events.*;

    public class ListEvent extends Event {

        public static const ITEM_DOUBLE_CLICK:String = "itemDoubleClick";
        public static const ITEM_ROLL_OUT:String = "itemRollOut";
        public static const ITEM_ROLL_OVER:String = "itemRollOver";
        public static const ITEM_CLICK:String = "itemClick";

        protected var _index:int;
        protected var _item:Object;
        protected var _columnIndex:int;
        protected var _rowIndex:int;

        public function ListEvent(_arg1:String, _arg2:Boolean=false, _arg3:Boolean=false, _arg4:int=-1, _arg5:int=-1, _arg6:int=-1, _arg7:Object=null){
            super(_arg1, _arg2, _arg3);
            _rowIndex = _arg5;
            _columnIndex = _arg4;
            _index = _arg6;
            _item = _arg7;
        }
        public function get rowIndex():Object{
            return (_rowIndex);
        }
        public function get index():int{
            return (_index);
        }
        public function get item():Object{
            return (_item);
        }
        public function get columnIndex():int{
            return (_columnIndex);
        }
        override public function clone():Event{
            return (new ListEvent(type, bubbles, cancelable, _columnIndex, _rowIndex));
        }
        override public function toString():String{
            return (formatToString("ListEvent", "type", "bubbles", "cancelable", "columnIndex", "rowIndex", "index", "item"));
        }

    }
}//package fl.events 
