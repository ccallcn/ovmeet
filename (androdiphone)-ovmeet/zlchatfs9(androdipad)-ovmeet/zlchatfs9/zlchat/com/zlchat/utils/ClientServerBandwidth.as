//hong QQ:1410919373
package com.zlchat.utils {
    import flash.net.*;

    public class ClientServerBandwidth extends BandwidthDetection {

        private var bwTime:int = 0;
        private var cumLatency:int = 1;
        private var payload:Array;
        private var count:int = 0;
        private var pakSent:Array;
        private var now:int = 0;
        private var sent:int = 0;
        private var timePassed:int = 0;
        private var beginningValues:Object;
        private var res:Responder;
        private var deltaTime:int = 0;
        private var KBytes:int = 0;
        private var info:Object;
        private var pakRecv:Array;
        private var deltaUp:int = 0;
        private var overhead:int = 0;
        private var _service:String;
        private var kbitUp:int = 0;
        private var latency:int = 0;
        private var pakInterval:int = 0;

        public function ClientServerBandwidth(){
            payload = new Array();
            pakSent = new Array();
            pakRecv = new Array();
            beginningValues = {};
            info = new Object();
            super();
            var _local1:int;
            while (_local1 < 1200) {
                payload[_local1] = Math.random();
                _local1++;
            };
            res = new Responder(onResult, onStatus);
        }
        override public function dispatchStatus(_arg1:Object):void{
            _arg1.count = this.count;
            _arg1.sent = this.sent;
            _arg1.timePassed = timePassed;
            _arg1.latency = this.latency;
            _arg1.overhead = this.overhead;
            _arg1.pakInterval = this.pakInterval;
            _arg1.cumLatency = this.cumLatency;
            super.dispatchStatus(info);
        }
        public function start():void{
            var _local1:Array = new Array();
            nc.call(_service, res);
        }
        public function set service(_arg1:String):void{
            _service = _arg1;
        }
        private function onResult(_arg1:Object):void{
            var _local2:Object;
            var _local3:Object;
            this.now = (new Date().getTime() / 1);
            if (sent == 0){
                this.beginningValues = _arg1;
                this.beginningValues.time = now;
                var _local4 = sent++;
                this.pakSent[_local4] = now;
                nc.call(_service, res, now);
            } else {
                this.pakRecv[this.count] = now;
                this.pakInterval = ((this.pakRecv[this.count] - this.pakSent[this.count]) * 1);
                this.count++;
                this.timePassed = (now - this.beginningValues.time);
                if (this.count == 1){
                    this.latency = Math.min(timePassed, 800);
                    this.latency = Math.max(this.latency, 10);
                    this.overhead = (_arg1.cOutBytes - this.beginningValues.cOutBytes);
                    _local4 = sent++;
                    this.pakSent[_local4] = now;
                    nc.call(_service, res, now, payload);
                    dispatchStatus(info);
                };
                if ((((this.count >= 1)) && ((timePassed < 1000)))){
                    _local4 = sent++;
                    this.pakSent[_local4] = now;
                    this.cumLatency++;
                    nc.call(_service, res, now, payload);
                    dispatchStatus(info);
                } else {
                    if (this.sent == this.count){
                        if (this.latency >= 100){
                            if ((this.pakRecv[1] - this.pakRecv[0]) > 1000){
                                this.latency = 100;
                            };
                        };
                        payload = new Array();
                        _local2 = _arg1;
                        deltaUp = (((_local2.cOutBytes - this.beginningValues.cOutBytes) * 8) / 1000);
                        deltaTime = (((now - this.beginningValues.time) - (this.latency * this.cumLatency)) / 1000);
                        if (deltaTime <= 0){
                            deltaTime = ((now - this.beginningValues.time) / 1000);
                        };
                        kbitUp = Math.round((deltaUp / deltaTime));
                        KBytes = ((_local2.cOutBytes - this.beginningValues.cOutBytes) / 0x0400);
                        _local3 = new Object();
                        _local3.kbitUp = kbitUp;
                        _local3.deltaUp = deltaUp;
                        _local3.deltaTime = deltaTime;
                        _local3.latency = latency;
                        _local3.KBytes = KBytes;
                        dispatchComplete(_local3);
                    };
                };
            };
        }
        private function onStatus(_arg1:Object):void{
            switch (_arg1.code){
                case "NetConnection.Call.Failed":
                    dispatchFailed(_arg1);
                    break;
            };
        }

    }
}//package com.zlchat.utils 
