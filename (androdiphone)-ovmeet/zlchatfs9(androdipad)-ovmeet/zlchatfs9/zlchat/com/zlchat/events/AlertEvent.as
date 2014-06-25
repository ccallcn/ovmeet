//hong QQ:1410919373
package com.zlchat.events {
    import flash.events.*;

    public class AlertEvent extends Event {

        public static const CANCEL:String = "cancel";
        public static const OK:String = "ok";

        public var para:Object;

        public function AlertEvent(_arg1:String, _arg2:Object){
            super(_arg1, false, false);
            para = _arg2;
        }
        override public function clone():Event{
            return (new AlertEvent(this.type, para));
        }

    }
}//package com.zlchat.events 
