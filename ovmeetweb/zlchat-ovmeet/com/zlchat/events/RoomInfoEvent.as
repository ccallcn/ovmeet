//hong QQ:1410919373
package com.zlchat.events {
    import flash.events.*;

    public class RoomInfoEvent extends Event {

        public static const TXTROOMINFO:String = "txtRoomInfo";

        public var key:Object;

        public function RoomInfoEvent(_arg1:String, _arg2:Object){
            super(_arg1, false, false);
            key = _arg2;
        }
        override public function clone():Event{
            return (new RoomInfoEvent(this.type, key));
        }

    }
}//package com.zlchat.events 
