//hong QQ:1410919373
package com.zlchat.events {
    import flash.events.*;

    public class PrivateEvent extends Event {

        public static const INVITE:String = "invite";

        public var detail:Object;
        public var userItem:Object;

        public function PrivateEvent(_arg1:String, _arg2:Object, _arg3:Object){
            super(_arg1, false, false);
            userItem = _arg2;
            detail = _arg3;
        }
        override public function clone():Event{
            return (new PrivateEvent(this.type, userItem, detail));
        }

    }
}//package com.zlchat.events 
