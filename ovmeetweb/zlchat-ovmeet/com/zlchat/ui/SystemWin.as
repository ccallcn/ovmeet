//hong QQ:1410919373
package com.zlchat.ui {
    import fl.controls.*;
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import com.zlchat.events.*;
    import com.zlchat.utils.*;
    import flash.text.*;
    import flash.media.*;

    public class SystemWin extends ResizeWin {

        private var chk_a_da:CheckBox;
        private var aQ:NumericStepper;
        private var vQ:NumericStepper;
        private var maxVideoSeat:NumericStepper;
        private var chk_sync_ui:CheckBox;
        private var cmbVideo:ComboBox;
        private var chk_lock:CheckBox;
        private var chk_a_dv:CheckBox;
        private var btnOK:SimpleButton;
        private var chk_apply_sp:CheckBox;
        public var txtTitle:TextField;
        private var chk_g_dp:CheckBox;
        private var chk_g_ds:CheckBox;
        private var chk_g_dt:CheckBox;
        private var vSpeed:NumericStepper;
        private var btnApply:SimpleButton;
        private var btnCloseRoom:SimpleButton;
        private var btnCancel:SimpleButton;
        private var cmbAudio:ComboBox;

        public function SystemWin(){
            super(400, 300);
            txtTitle = new TextField();
            txtTitle.text = "会议设置";
            txtTitle.autoSize = TextFieldAutoSize.LEFT;
            var _local1:TextFormat = new TextFormat();
            _local1.size = 12;
            _local1.color = 0xFFFFFF;
            txtTitle.setTextFormat(_local1);
            addChild(txtTitle);
            btnOK = new BtnOK();
            addChild(btnOK);
            btnCancel = new BtnCancel();
            addChild(btnCancel);
            btnApply = new BtnApply();
            addChild(btnApply);
            BtnMin.visible = false;
            BtnMax.visible = false;
            BtnRestore.visible = false;
            btnOK.addEventListener(MouseEvent.CLICK, onOK);
            btnCancel.addEventListener(MouseEvent.CLICK, onCancel);
            btnApply.addEventListener(MouseEvent.CLICK, onApply);
            var _local2:TextField = new TextField();
            _local2.width = 100;
            _local2.text = "#音频视频设置#";
            addChild(_local2);
            _local2.x = 10;
            _local2.y = 30;
            var _local3:TextField = new TextField();
            _local3.text = "视频帧大小:";
            addChild(_local3);
            _local3.x = 10;
            _local3.y = 55;
            cmbVideo = new ComboBox();
            cmbVideo.addItem({
                label:"120*90",
                data:{
                    w:120,
                    h:90
                }
            });
            cmbVideo.addItem({
                label:"240*180",
                data:{
                    w:240,
                    h:180
                }
            });
            cmbVideo.addItem({
                label:"320*240",
                data:{
                    w:320,
                    h:240
                }
            });
            cmbVideo.addItem({
                label:"640*480",
                data:{
                    w:640,
                    h:480
                }
            });
            cmbVideo.addItem({
                label:"782*582",
                data:{
                    w:782,
                    h:582
                }
            });
            cmbVideo.addItem({
                label:"800*600",
                data:{
                    w:800,
                    h:600
                }
			});
            cmbVideo.addItem({
                label:"1080*720",
                data:{
                    w:1080,
                    h:720
                }
            });
            addChild(cmbVideo);
            cmbVideo.width = 80;
            cmbVideo.x = 80;
            cmbVideo.y = 55;
            var _local4:TextField = new TextField();
            _local4.text = "视频帧速率:";
            addChild(_local4);
            _local4.x = 165;
            _local4.y = 55;
            vSpeed = new NumericStepper();
            addChild(vSpeed);
            vSpeed.y = 55;
            vSpeed.x = 240;
            vSpeed.width = 40;
            vSpeed.minimum = 1;
            vSpeed.maximum = 25;
            vSpeed.stepSize = 1;
            vSpeed.value = 1;
            var _local5:TextField = new TextField();
            _local5.text = "图像质量:";
            addChild(_local5);
            _local5.x = 290;
            _local5.y = 55;
            vQ = new NumericStepper();
            addChild(vQ);
            vQ.y = 55;
            vQ.x = 350;
            vQ.width = 40;
            //vQ.minimum = 0;//图像质量
            vQ.minimum = 50;
	    //vQ.maximum = 100;
            vQ.maximum = 95;//图像制量最高95
	    vQ.stepSize = 1;
            vQ.value = 90;
            var _local6:TextField = new TextField();
            _local6.text = "语音质量:";
            addChild(_local6);
            _local6.x = 10;
            _local6.y = 85;
            cmbAudio = new ComboBox();
            cmbAudio.addItem({
                label:"5.5khz",
                data:5.5
            });
            cmbAudio.addItem({
                label:"8khz",
                data:8
            });
            cmbAudio.addItem({
                label:"11khz",
                data:11
            });
            cmbAudio.addItem({
                label:"22khz",
                data:22
            });
            cmbAudio.addItem({
                label:"44khz",
                data:44
            });
            addChild(cmbAudio);
            cmbAudio.width = 80;
            cmbAudio.x = 80;
            cmbAudio.y = 85;
            var _local7:TextField = new TextField();
            _local7.text = "静音阀值:";
            addChild(_local7);
            _local7.x = 165;
            _local7.y = 85;
            aQ = new NumericStepper();
            addChild(aQ);
            aQ.y = 85;
            aQ.x = 240;
            aQ.width = 40;
            //aQ.minimum = 0;
             aQ.minimum = 10;//静音划值最小10
	    aQ.maximum = 100;
            aQ.stepSize = 1;
            aQ.value = 10;
            var _local8:TextField = new TextField();
            _local8.width = 100;
            _local8.text = "#功能设置#";
            addChild(_local8);
            _local8.x = 7;
            _local8.y = 120;
            var _local9:TextFormat = new TextFormat();
            _local9.size = 12;
            chk_lock = new CheckBox();
            chk_lock.label = "锁定房间";
            chk_lock.width = 85;
            chk_lock.setStyle("textFormat", _local9);
            addChild(chk_lock);
            chk_lock.x = 10;
            chk_lock.y = 140;
            chk_g_dp = new CheckBox();
            chk_g_dp.label = "听众禁止私聊";
            chk_g_dp.width = 105;
            chk_g_dp.setStyle("textFormat", _local9);
            addChild(chk_g_dp);
            chk_g_dp.x = 82;
            chk_g_dp.y = 140;
            chk_g_ds = new CheckBox();
            chk_g_ds.label = "听众禁止请求发言";
            chk_g_ds.setStyle("textFormat", _local9);
            chk_g_ds.width = 130;
            addChild(chk_g_ds);
            chk_g_ds.x = 185;
            chk_g_ds.y = 140;
            chk_g_dt = new CheckBox();
            chk_g_dt.label = "听众禁止文本发言";
            chk_g_dt.setStyle("textFormat", _local9);
            chk_g_dt.width = 130;
            addChild(chk_g_dt);
            chk_g_dt.x = 310;
            chk_g_dt.y = 140;
            chk_a_dv = new CheckBox();
            chk_a_dv.label = "禁止所有视频";
            chk_a_dv.setStyle("textFormat", _local9);
            chk_a_dv.width = 125;
            addChild(chk_a_dv);
            chk_a_dv.x = 8;
            chk_a_dv.y = 170;
            chk_a_da = new CheckBox();
            chk_a_da.label = "禁止所有音频";
            chk_a_da.setStyle("textFormat", _local9);
            chk_a_da.width = 125;
            addChild(chk_a_da);
            chk_a_da.x = 104;
            chk_a_da.y = 170;
            chk_sync_ui = new CheckBox();
            chk_sync_ui.label = "同步主持人界面";
            chk_sync_ui.setStyle("textFormat", _local9);
            chk_sync_ui.width = 130;
            addChild(chk_sync_ui);
            chk_sync_ui.x = 204;
            chk_sync_ui.y = 170;
            chk_apply_sp = new CheckBox();
            chk_apply_sp.label = "审批发言请求";
            chk_apply_sp.setStyle("textFormat", _local9);
            chk_apply_sp.width = 130;
            addChild(chk_apply_sp);
            chk_apply_sp.x = 310;
            chk_apply_sp.y = 170;
            var _local10:TextField = new TextField();
            _local10.text = "同时视频数量:";
            addChild(_local10);
            _local10.width = 80;
            _local10.height = 25;
            _local10.x = 10;
            _local10.y = 200;
            maxVideoSeat = new NumericStepper();
            addChild(maxVideoSeat);
            maxVideoSeat.y = 200;
            maxVideoSeat.x = 100;
            maxVideoSeat.width = 40;
            maxVideoSeat.minimum = 1;
            //maxVideoSeat.maximum = 16;
            maxVideoSeat.maximum = 4;
	    maxVideoSeat.stepSize = 1;
            maxVideoSeat.value = 2;
            btnCloseRoom = new BtnCloseRoom();
            addChild(btnCloseRoom);
            btnCloseRoom.y = 200;
            btnCloseRoom.x = 180;
            btnCloseRoom.addEventListener(MouseEvent.CLICK, onCloseRoom);
            Resize(450, 300);
        }
        protected function onOK(_arg1:Event):void{
            dispatchEvent(new AlertEvent(AlertEvent.OK, null));
            apply();
            this.visible = false;
        }
        protected function a_rate(_arg1:RoomInfoEvent):void{
            var _local3:Object;
            var _local2:* = 0;
            _local2 = 0;
            while (_local2 < cmbAudio.length) {
                _local3 = cmbAudio.getItemAt(_local2);
                if (_local3.data == _arg1.key){
                    cmbAudio.selectedIndex = _local2;
                };
                _local2++;
            };
        }
        protected function a_s(_arg1:RoomInfoEvent):void{
            aQ.value = int(_arg1.key);
        }
        protected function a_da(_arg1:RoomInfoEvent):void{
            chk_a_da.selected = _arg1.key;
        }
        protected function lock(_arg1:RoomInfoEvent):void{
            chk_lock.selected = _arg1.key;
        }
        protected function a_dv(_arg1:RoomInfoEvent):void{
            chk_a_dv.selected = _arg1.key;
        }
        protected function sync_ui(_arg1:RoomInfoEvent):void{
            chk_sync_ui.selected = _arg1.key;
        }
        protected function onCancel(_arg1:Event):void{
            this.visible = false;
            dispatchEvent(new AlertEvent(AlertEvent.CANCEL, null));
        }
        protected function v_mode(_arg1:RoomInfoEvent):void{
            var _local4:Object;
            var _local2:Object = _arg1.key;
            vSpeed.value = int(_local2.f);
            var _local3:* = 0;
            _local3 = 0;
            while (_local3 < cmbVideo.length) {
                _local4 = cmbVideo.getItemAt(_local3);
                if (_local4.data.w == _local2.w){
                    cmbVideo.selectedIndex = _local3;
                };
                _local3++;
            };
        }
        protected function apply_sp(_arg1:RoomInfoEvent):void{
            chk_apply_sp.selected = _arg1.key;
        }
        private function onCloseRoom(_arg1:MouseEvent):void{
            var e:* = _arg1;
            nc.netGroup.post(new String((((((("<font size='+1' color='#ff0000'> " + "系统提示:") + "(") + ChatConnection.getChineseTime()) + "):</font>") + "<font size='+2' color='ff0000'> ") + "房间已经关闭，再见!</font><br>")));
            nc.roomInfoSo.send("closeRoom", nc.userID);
            var loader:* = new URLLoader();
            var userRequest:* = new URLRequest(((("closeRoom." + nc.scriptType) + "?roomID=") + nc.roomID));
            try {
                loader.load(userRequest);
            } catch(error:ArgumentError) {
                trace("An ArgumentError has occurred.");
            } catch(error:SecurityError) {
                trace("A SecurityError has occurred.");
            };
        }
        protected function onApply(_arg1:MouseEvent):void{
            apply();
        }
        override public function set conn(_arg1:ChatConnection){
            nc = _arg1;
            nc.addEventListener("g_ds", g_ds);
            nc.addEventListener("g_dp", g_dp);
            nc.addEventListener("g_dt", g_dt);
            nc.addEventListener("a_dv", a_dv);
            nc.addEventListener("a_da", a_da);
            nc.addEventListener("sync_ui", sync_ui);
            nc.addEventListener("lock", lock);
            nc.addEventListener("apply_sp", apply_sp);
            nc.addEventListener("maxVideoSeat", onMaxVideo);
            nc.addEventListener("a_rate", a_rate);
            nc.addEventListener("a_s", a_s);
            nc.addEventListener("v_q", v_q);
            nc.addEventListener("v_mode", v_mode);
        }
        override public function Resize(_arg1:Number, _arg2:Number):void{
            super.Resize(_arg1, _arg2);
            drawBg(_arg1, _arg2);
            btnOK.y = (btnCancel.y = (btnApply.y = ((_arg2 - btnOK.height) - 10)));
            btnOK.x = (((_arg1 - (3 * btnOK.width)) - 10) / 2);
            btnCancel.x = ((btnOK.x + btnCancel.width) + 5);
            btnApply.x = ((btnCancel.x + btnApply.width) + 5);
            txtTitle.x = 6;
            txtTitle.y = 2;
        }
        protected function g_dp(_arg1:RoomInfoEvent):void{
            chk_g_dp.selected = _arg1.key;
        }
        protected function g_ds(_arg1:RoomInfoEvent):void{
            chk_g_ds.selected = _arg1.key;
        }
        protected function g_dt(_arg1:RoomInfoEvent):void{
            chk_g_dt.selected = _arg1.key;
        }
        protected function v_q(_arg1:RoomInfoEvent):void{
            vQ.value = int(_arg1.key);
        }
        protected function apply():void{
            var _local1:Object = new Object();
            _local1.w = cmbVideo.selectedItem.data.w;
            _local1.h = cmbVideo.selectedItem.data.h;
            _local1.f = vSpeed.value;
            if (nc.cam != null){
                nc.cam.setMode(_local1.w, _local1.h, _local1.f);
                nc.cam.setQuality(0, vQ.value);
            };
            nc.roomInfoSo.setProperty("v_mode", _local1);
            nc.roomInfoSo.setProperty("v_q", vQ.value);
            nc.roomInfoSo.setProperty("a_rate", cmbAudio.selectedItem.data);
            nc.roomInfoSo.setProperty("a_s", aQ.value);
            if (nc.mic != null){
                nc.mic.rate = cmbAudio.selectedItem.data;
                nc.mic.setSilenceLevel(aQ.value);
                nc.mic.setUseEchoSuppression(true);
            };
            nc.roomInfoSo.setProperty("applyVideo", chk_apply_sp.selected);
            nc.roomInfoSo.setProperty("g_dp", chk_g_dp.selected);
            nc.roomInfoSo.setProperty("g_dt", chk_g_dt.selected);
            nc.roomInfoSo.setProperty("g_ds", chk_g_ds.selected);
            nc.roomInfoSo.setProperty("a_dv", chk_a_dv.selected);
            nc.roomInfoSo.setProperty("a_da", chk_a_da.selected);
            nc.roomInfoSo.setProperty("sync_ui", chk_sync_ui.selected);
            nc.roomInfoSo.setProperty("lock", chk_lock.selected);
            nc.roomInfoSo.setProperty("maxVideoSeat", maxVideoSeat.value);
            nc.dispatchEvent(new RoomInfoEvent("a_dv", chk_a_dv.selected));
            nc.dispatchEvent(new RoomInfoEvent("a_da", chk_a_da.selected));
        }
        protected function onMaxVideo(_arg1:RoomInfoEvent):void{
            maxVideoSeat.value = int(_arg1.key);
        }
        override protected function onWinClose(_arg1:MouseEvent):void{
            this.visible = false;
            dispatchEvent(new AlertEvent(AlertEvent.CANCEL, null));
        }

    }
}//package com.zlchat.ui 
