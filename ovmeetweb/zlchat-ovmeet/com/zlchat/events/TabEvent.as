//hong QQ:1410919373
package com.zlchat.events {
    import flash.events.*;

    public class TabEvent extends Event {

        public static const SWITCH:String = "switch";

        public var key:Object;

        public function TabEvent(_arg1:String, _arg2:Object){
            super(_arg1, false, false);
            key = _arg2;
        }
        override public function clone():Event{
            return (new TabEvent(this.type, key));
        }

    }
}//package com.zlchat.events 
