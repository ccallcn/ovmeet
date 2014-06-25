//hong QQ:1410919373
package com.zlchat.events {
    import flash.events.*;

    public class VideoEvent1 extends Event {

        public static const ADD:String = "add";
        public static const START:String = "start";
        public static const DEL:String = "del";
        public static const STOPV:String = "stop_video";
        public static const STOP:String = "stop";
        public static const STOPA:String = "stop_audio";

        public var speaker:Object;

        public function VideoEvent1(_arg1:String, _arg2:Object){
            super(_arg1, false, false);
            speaker = _arg2;
        }
        override public function clone():Event{
            return (new VideoEvent1(this.type, speaker));
        }

    }
}//package com.zlchat.events 
