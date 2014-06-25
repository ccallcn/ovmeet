//hong QQ:1410919373
package com.zlchat.ui {
    import flash.geom.*;
    import com.zlchat.mainapp.*;

    public class TipManager {

        public static var videoTip:VideoTip;
        public static var rootMC:MainApp;
        public static var speakerTip:SpeakerTip;
        public static var userTip:UserTip;

        public static function showSpeakerTip(_arg1:Point, _arg2:Object):void{
            if (speakerTip == null){
                speakerTip = new SpeakerTip(rootMC);
            };
            rootMC.addChild(speakerTip);
            speakerTip.visible = true;
            speakerTip.x = (_arg1.x - 20);
            speakerTip.y = (_arg1.y - 70);
            speakerTip.userItem = _arg2;
        }
        public static function showUserTip(_arg1:Point, _arg2:Object):void{
            if (userTip == null){
                userTip = new UserTip(rootMC);
            };
            rootMC.addChild(userTip);
            userTip.visible = true;
           // userTip.x = (_arg1.x - 20);
           // userTip.y = (_arg1.y - 70);
	    userTip.x = _arg1.x-120;
            userTip.y = _arg1.y+10;
            userTip.userItem = _arg2;
        }
        public static function showVideoTip(_arg1:Point, _arg2:VideoItem):void{
            if (videoTip == null){
                videoTip = new VideoTip();
            };
            rootMC.addChild(videoTip);
            videoTip.visible = true;
            //videoTip.x = (_arg1.x - 20);
            //videoTip.y = (_arg1.y - 70);
	    videoTip.x = _arg1.x-100;
            videoTip.y = _arg1.y+10;
            videoTip.videoItem = _arg2;
        }

    }
}//package com.zlchat.ui 
