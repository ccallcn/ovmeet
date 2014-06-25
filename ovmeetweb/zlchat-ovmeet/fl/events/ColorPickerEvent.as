//hong QQ:1410919373
package fl.events {
    import flash.events.*;

    public class ColorPickerEvent extends Event {

        public static const ITEM_ROLL_OUT:String = "itemRollOut";
        public static const ITEM_ROLL_OVER:String = "itemRollOver";
        public static const CHANGE:String = "change";
        public static const ENTER:String = "enter";

        protected var _color:uint;

        public function ColorPickerEvent(_arg1:String, _arg2:uint){
            super(_arg1, true);
            _color = _arg2;
        }
        override public function toString():String{
            return (formatToString("ColorPickerEvent", "type", "bubbles", "cancelable", "color"));
        }
        public function get color():uint{
            return (_color);
        }
        override public function clone():Event{
            return (new ColorPickerEvent(type, color));
        }

    }
}//package fl.events 
