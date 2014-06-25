//hong QQ:1410919373
package com.zlchat.ui {
    import fl.controls.*;
    import flash.display.*;
    import flash.events.*;
    import com.zlchat.events.*;
    import com.zlchat.utils.*;

    public class RoomInfoPane extends BasePane {

        private var btnUpdate:SimpleButton;
        private var txtRoomInfo:TextArea;

        public function RoomInfoPane(){
            txtRoomInfo = new TextArea();
            addChild(txtRoomInfo);
            txtRoomInfo.x = 0;
            txtRoomInfo.y = 0;
            txtRoomInfo.htmlText = (("<font  size='+1' color='#000000' face='宋体'>" + "会议信息") + "</font>");
            btnUpdate = new BtnUpdate();
            addChild(btnUpdate);
            btnUpdate.x = 2;
            btnUpdate.addEventListener(MouseEvent.CLICK, updateRoomInfo);
        }
        protected function onSetRole(_arg1:Event):void{
            if (nc.role == "2"){
                btnUpdate.visible = true;
            } else {
                btnUpdate.visible = false;
            };
        }
        protected function updateRoomInfo(_arg1:Event):void{
            nc.call("updateRoomInfo", null, "txtRoomInfo", txtRoomInfo.text);
            nc.netGroup.post(new String(((((((("<font size='+1' color='#ff0000'> " + "系统提示:") + "(") + ChatConnection.getChineseTime()) + "):</font>") + "<font size='+2' color='ff0000'> ") + nc.realName) + "管理员已经更新会议信息!</font><br>")));
        }
        override public function Resize(_arg1:Number, _arg2:Number):void{
            super.Resize(_arg1, _arg2);
            txtRoomInfo.width = _arg1;
            txtRoomInfo.height = ((_arg2 - btnUpdate.height) - 8);
            btnUpdate.y = ((_arg2 - btnUpdate.height) - 2);
        }
        protected function onUpdateInfo(_arg1:RoomInfoEvent):void{
            txtRoomInfo.htmlText = (("<font  size='+1' color='#000000' face='宋体'>" + _arg1.key) + "</font>");
        }
        override public function set conn(_arg1:ChatConnection){
            nc = _arg1;
            nc.addEventListener(RoomInfoEvent.TXTROOMINFO, onUpdateInfo);
            nc.addEventListener("setRole", onSetRole);
            if (nc.role == "2"){
                btnUpdate.visible = true;
            } else {
                btnUpdate.visible = false;
            };
        }

    }
}//package com.zlchat.ui 
