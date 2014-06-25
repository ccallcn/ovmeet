//hong QQ:1410919373
package com.zlchat.utils {
    import flash.net.*;

    public class ServerClientBandwidth extends BandwidthDetection {

        private var res:Responder;
        private var _service:String;
        private var info:Object;

        public function ServerClientBandwidth(){
            info = new Object();
            super();
            res = new Responder(onResult, onStatus);
        }
        public function set service(_arg1:String):void{
            _service = _arg1;
        }
        public function start():void{
            nc.call(_service, res);
        }
        private function onStatus(_arg1:Object):void{
            switch (_arg1.code){
                case "NetConnection.Call.Failed":
                    dispatchFailed(_arg1);
                    break;
            };
        }
        private function onResult(_arg1:Object):void{
            dispatchStatus(_arg1);
        }

    }
}//package com.zlchat.utils 
