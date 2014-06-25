//hong QQ:1410919373
package com.zlchat.events {
    import flash.events.*;

    public class BorderEvent extends Event {

        public static const RESIZE:String = "rect_resize";

        public var rect:Object;

        public function BorderEvent(_arg1:String, _arg2:Object){
            super(_arg1, false, false);
            rect = _arg2;
        }
        override public function clone():Event{
            return (new BorderEvent(this.type, rect));
        }

    }
}//package com.zlchat.events 
