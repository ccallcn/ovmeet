//hong QQ:1410919373
package fl.events {
    import flash.events.*;

    public class SliderEvent extends Event {

        public static const CHANGE:String = "change";
        public static const THUMB_PRESS:String = "thumbPress";
        public static const THUMB_DRAG:String = "thumbDrag";
        public static const THUMB_RELEASE:String = "thumbRelease";

        protected var _triggerEvent:String;
        protected var _keyCode:Number;
        protected var _value:Number;
        protected var _clickTarget:String;

        public function SliderEvent(_arg1:String, _arg2:Number, _arg3:String, _arg4:String, _arg5:int=0){
            _value = _arg2;
            _keyCode = _arg5;
            _triggerEvent = _arg4;
            _clickTarget = _arg3;
            super(_arg1);
        }
        public function get clickTarget():String{
            return (_clickTarget);
        }
        override public function clone():Event{
            return (new SliderEvent(type, _value, _clickTarget, _triggerEvent, _keyCode));
        }
        override public function toString():String{
            return (formatToString("SliderEvent", "type", "value", "bubbles", "cancelable", "keyCode", "triggerEvent", "clickTarget"));
        }
        public function get triggerEvent():String{
            return (_triggerEvent);
        }
        public function get value():Number{
            return (_value);
        }
        public function get keyCode():Number{
            return (_keyCode);
        }

    }
}//package fl.events 
