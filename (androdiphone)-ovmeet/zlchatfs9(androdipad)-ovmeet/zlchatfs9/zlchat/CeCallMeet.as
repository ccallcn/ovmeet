package  {
	
	import flash.display.MovieClip; 
	import flash.media.StageWebView; 
	import flash.events.LocationChangeEvent; 
	import flash.geom.Rectangle; 
	import flash.net.navigateToURL; 
	import flash.net.URLRequest; 
	
	import flash.events.KeyboardEvent; 
	import flash.events.Event;
	import flash.desktop.NativeApplication;

	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.utils.*;
	import flash.system.*;
	import flash.external.*; 	
	
	import com.zlchat.mainapp.MainApp;
	
	public class CeCallMeet extends MovieClip {
		
		var webView:StageWebView = new StageWebView();
		var mainmeet:MainApp=new MainApp();
		var stringurl="http://m.cecall.cc/cemeet/upload/android/meetlogin.html";
		public function CeCallMeet() {
			 
			 if(this.numChildren> 0)
			   this.removeChildAt(this.numChildren-1);//去掉加密后的ＬＯＧ
			
			stage.scaleMode = StageScaleMode.NO_SCALE; 
			stage.align = StageAlign.TOP_LEFT;
			//先将缩放模式设置成无缩放模式 
			stage.addEventListener(Event.RESIZE, stageResizeHandler, false, 0, true);
			
			webView.stage = this.stage; 
			webView.addEventListener(flash.events.LocationChangeEvent.LOCATION_CHANGE, onLocationChanging );  
			webView.loadURL(stringurl);

			dispatchEvent(new Event(Event.RESIZE));
		 
			if(Capabilities.cpuArchitecture=="ARM")
			{
			  NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE, handleActivate, false, 0, true);
			  NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE, handleDeactivate, false, 0, true);
			  NativeApplication.nativeApplication.addEventListener(KeyboardEvent.KEY_DOWN, handleKeys, false, 0, true);
			}
		 

		}
		protected function stageResizeHandler(event:Event) : void
		{
		    if(webView.stage !=null)
			webView.viewPort = new Rectangle( 0, 0,stage.stageWidth, stage.stageHeight);  
		    return;
		}// end function
		private function handleActivate(event:Event):void
		{
		    NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.KEEP_AWAKE;
		}
		private function handleDeactivate(event:Event):void
		{
		    NativeApplication.nativeApplication.exit();
		}

		private function handleKeys(event:KeyboardEvent):void
		{
		    if(event.keyCode == Keyboard.BACK)
		    NativeApplication.nativeApplication.exit();
		} 
		public function reExit():void
		{
		    NativeApplication.nativeApplication.exit();
		} 
		private function onLocationChanging(event:LocationChangeEvent):void 
		{ 
 		    // trace("The location changed:"+event.location);
			
			if(location(event.location)=="preloader.mobile" || location(event.location)=="action.mobile")
			{
				   event.preventDefault();//停止页面响应
			       var _loc_2:* = new Object();

				    //_loc_2["userName"] = "332240";
				    //_loc_2["realName"] = "332240";
				  　//_loc_2["role"] = "2";
				   　//_loc_2["pwd"] = "332240";
				    //_loc_2["roomID"] = 332240;
				  　 //_loc_2["scriptType"] = "php";
				  　 //_loc_2["mediaServer"] ="m.cecall.cc";
			  　	_loc_2["url"] = urllocation(decodeURI(event.location));
					
					
				addChild(mainmeet);　

				//trace("The location changed:"+event.location);
				//trace("字符1:"+location(event.location));
				//trace("字符2:"+paramstring(event.location));

				 
				 var queryStr=paramstring(decodeURI(event.location));
				 var params:Array = queryStr.split("&"); 
				 //trace(params);
				
				  //参数取值操作
				  for(var j:uint = 0; j < params.length; j++) {
					   //trace(j + ", " + params[j]);
					var paramsname=params[j].substring(0,params[j].lastIndexOf("="));
					var paramsvalue=params[j].substring(params[j].lastIndexOf("=")+1,params[j].length);
						
					if(paramsname=="userName")
						_loc_2["userName"] = paramsvalue; 
					if(paramsname=="realName")
						 _loc_2["realName"] = paramsvalue;
						// _loc_2["realName"] = unescape(paramsvalue);
					if(paramsname=="role")
						 _loc_2["role"] = paramsvalue;
					if(paramsname=="password")	 
						_loc_2["pwd"] = paramsvalue;
					if(paramsname=="roomID")	
						_loc_2["roomID"] = paramsvalue;
					if(paramsname=="scriptType")
						_loc_2["scriptType"] =paramsvalue;
					if(paramsname=="mediaServer")	
						_loc_2["mediaServer"] = paramsvalue;
					//if(paramsname=="url")
						// _loc_2["url"] = paramsvalue;
					if(paramsname=="type"){
						 if(paramsvalue=="exit")
						{//程序退出
							// NativeApplication.nativeApplication.exit();
							reExit();
						}　
					}
					//trace(paramsname+":"+paramsvalue);
				 }
					 /**
					    trace(_loc_2["userName"]);
					    trace(_loc_2["realName"]);;
					  　trace(_loc_2["role"]);
					   　trace(_loc_2["pwd"]);
					    trace(_loc_2["roomID"]);
					  　 trace(_loc_2["scriptType"]);;
					  　 trace(_loc_2["mediaServer"]);
					  　 trace(_loc_2["url"]);
					  **/

				webView.stage=null;
				trace("权限设置："+_loc_2["role"]);
				mainmeet.setPreloader(this, _loc_2, true);
				dispatchEvent(new Event(Event.RESIZE));
				
				


				//webView.viewPort=null;

				//webView.dispose();//垃圾回收要彻底销毁对象

				//webView=null;//置空
			}
 

		} 
		public function removeRoom():void {
				
				removeChild(mainmeet);
				webView.stage=this.stage
				webView.loadURL(stringurl);
				//webView.viewPort = new Rectangle( 0, 0,stage.stageWidth, stage.stageHeight);
		}
		
		private function location(_arg1:String):String{
		    var _local3:int;
		    var _local4:int;
		    var _local2:String = _arg1;
		    if (_local2 != null){
			_local3 = _local2.lastIndexOf("/");
			_local4 = _local2.lastIndexOf("?");
			return (_local2.substring((_local3 + 1), _local4));
		    };
		    return ("");
		}
		private function paramstring(_arg1:String):String{
		    var _local3:int; 
		    var _local2:String = _arg1;
		    if (_local2 != null){
			_local3 = _local2.lastIndexOf("?"); 
			return (_local2.substring((_local3 + 1), _local2.length));
		    };
		    return ("");
		}
		private function urllocation(_arg1:String):String{
		    var _local3:int; 
		    var _local2:String = _arg1;
		    if (_local2 != null){
			_local3 = _local2.lastIndexOf("/"); 
			return (_local2.substring(0,_local3+1));
		    };
		    return ("");
		}		
	}
	
}
