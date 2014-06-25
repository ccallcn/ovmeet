//hong QQ:1410919373
package com.zlchat.events {
    import flash.events.*;
    import fl.data.*;

    public class ConnListEvent extends Event {

        public static const VideoListSync:String = "videolistsync";
        public static const UserListSync:String = "userlistsync";
        public static const SpeakerListSync:String = "speakerlistsync";

        public var userListDP:DataProvider;

        public function ConnListEvent(_arg1:String, _arg2:DataProvider){
            super(_arg1, false, false);
            userListDP = _arg2;
        }
        override public function clone():Event{
            return (new ConnListEvent(this.type, userListDP));
        }

    }
}//package com.zlchat.events 
