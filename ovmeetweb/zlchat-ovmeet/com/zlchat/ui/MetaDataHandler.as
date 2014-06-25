//hong QQ:1410919373
package com.zlchat.ui {

    public class MetaDataHandler {

        public var duration:int = 0;

        public function onPlayStatus(_arg1:Object):void{
        }
        public function onMetaData(_arg1:Object):void{
            var _local2:Object;
            if (_arg1 != null){
                for (_local2 in _arg1) {
                    if (_local2 == "duration"){
                        duration = Math.floor(int(_arg1[_local2]));
                    };
                };
            };
        }

    }
}//package com.zlchat.ui 
