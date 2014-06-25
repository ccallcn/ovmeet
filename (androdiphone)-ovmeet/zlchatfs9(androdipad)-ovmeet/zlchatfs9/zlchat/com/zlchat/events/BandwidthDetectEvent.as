//hong QQ:1410919373
package com.zlchat.events {
    import flash.events.*;

    public class BandwidthDetectEvent extends Event {

        public static const DETECT_COMPLETE:String = "detect_complete";
        public static const DETECT_FAILED:String = "detect_failed";
        public static const DETECT_STATUS:String = "detect_status";

        private var _info:Object;

        public function BandwidthDetectEvent(_arg1:String){
            super(_arg1);
        }
        public function set info(_arg1:Object):void{
            _info = _arg1;
        }
        public function get info():Object{
            return (_info);
        }

    }
}//package com.zlchat.events 
