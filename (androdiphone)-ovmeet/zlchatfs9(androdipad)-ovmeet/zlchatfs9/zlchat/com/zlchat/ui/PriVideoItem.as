//hong QQ:1410919373
package com.zlchat.ui {
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import com.zlchat.events.*;
    import flash.media.*;

    public class PriVideoItem extends VideoItem {

        override protected function changeAudioDV(_arg1:VideoEvent1):void{
            if (_user.userID == nc.userID){
                if (_stream != null){
                    _stream.attachAudio(nc.mic);
                };
            };
        }
        override protected function changeVideoDV(_arg1:VideoEvent1):void{
            if (_user.userID == nc.userID){
                if (_stream != null){
                    video.attachCamera(nc.cam);
                    _stream.attachCamera(nc.cam);
                };
            };
        }
        override public function clearStream():void{
            if (_user.userID != nc.userID){
                video.attachNetStream(null);
                video.visible = false;
            } else {
                video.attachCamera(null);
                video.visible = false;
            };
            if (_stream != null){
                _stream.close();
            };
        }
        override public function set speaker(_arg1:Object):void{
            _user = _arg1;
            if (_user.userID != nc.userID){
                //_stream = new NetStream(nc);
		//	_stream = new NetStream(nc.ncvideo);
	    	//创建netStream与用户组的链接，我们用他来发送视频和音频流
				_stream = new NetStream(nc.ncvideo, nc.groupSpecifier.groupspecWithAuthorizations());
				//_stream.bufferTime = 0;
		
                _stream.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
                video.attachNetStream(_stream);
                _stream.play(("pri" + _user.userID));
                video.visible = true;
                bufBar.visible = true;
            } else {
                video.attachCamera(nc.cam);
                //_stream = new NetStream(nc);
				//_stream = new NetStream(nc.ncvideo);
				//创建netStream与用户组的链接，我们用他来发送视频和音频流
				_stream = new NetStream(nc.ncvideo, nc.groupSpecifier.groupspecWithAuthorizations());

				//_stream.bufferTime = 0;
					
				//私聊H264
				var vh264Settings:H264VideoStreamSettings = new H264VideoStreamSettings();
				vh264Settings.setProfileLevel(H264Profile.BASELINE,H264Level.LEVEL_5_1); 
				
				_stream.videoStreamSettings = vh264Settings;

                _stream.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
                _stream.attachCamera(nc.cam);
                _stream.attachAudio(nc.mic);
                _stream.publish(("pri" + _user.userID));
                video.visible = true;
            };
        }

    }
}//package com.zlchat.ui 
