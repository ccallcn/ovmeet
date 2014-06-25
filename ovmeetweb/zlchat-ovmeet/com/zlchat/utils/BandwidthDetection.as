//hong QQ:1410919373
package com.zlchat.utils {
    import flash.events.*;
    import flash.net.*;
    import com.zlchat.events.*;

    public class BandwidthDetection extends EventDispatcher {

        protected var nc:NetConnection;

        public function dispatchComplete(_arg1:Object):void{
            var _local2:BandwidthDetectEvent = new BandwidthDetectEvent(BandwidthDetectEvent.DETECT_COMPLETE);
            _local2.info = _arg1;
            dispatchEvent(_local2);
        }
        public function dispatchFailed(_arg1:Object):void{
            var _local2:BandwidthDetectEvent = new BandwidthDetectEvent(BandwidthDetectEvent.DETECT_FAILED);
            _local2.info = _arg1;
            dispatchEvent(_local2);
        }
        public function dispatch(_arg1:Object, _arg2:String):void{
            var _local3:BandwidthDetectEvent = new BandwidthDetectEvent(_arg2);
            _local3.info = _arg1;
            dispatchEvent(_local3);
        }
        public function set connection(_arg1:NetConnection):void{
            nc = _arg1;
        }
        public function dispatchStatus(_arg1:Object):void{
            var _local2:BandwidthDetectEvent = new BandwidthDetectEvent(BandwidthDetectEvent.DETECT_STATUS);
            _local2.info = _arg1;
            dispatchEvent(_local2);
        }

    }
}//package com.zlchat.utils 
