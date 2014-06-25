//hong QQ:1410919373
package com.zlchat.events {
    import flash.events.*;

    public class ConnEvent extends Event {

        public static const FILELIST:String = "FileList";
        public static const USERID:String = "userid";

        public function ConnEvent(_arg1:String){
            super(_arg1, false, false);
        }
        override public function clone():Event{
            return (new ConnEvent(this.type));
        }

    }
}//package com.zlchat.events 
