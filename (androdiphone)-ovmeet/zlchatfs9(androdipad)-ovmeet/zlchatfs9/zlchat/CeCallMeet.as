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
	
	public class CeCallMeet extends Sprite {
		
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
		 
		addChild(mainmeet);　
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
 
		public function removeRoom():void {
				
				removeChild(mainmeet);
				webView.stage=this.stage
				webView.loadURL(stringurl);
				//webView.viewPort = new Rectangle( 0, 0,stage.stageWidth, stage.stageHeight);
		}
		 
	}
	
}
