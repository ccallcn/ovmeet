//hong QQ:1410919373
package com.zlchat.ui {
    import fl.controls.listClasses.*;
    import fl.controls.*;
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;

    public class UserItem extends CellRenderer implements ICellRenderer {

        private var txtUserName:TextField;
        private var statusBtn:MovieClip;
        private var roleBtn:MovieClip;
        private var status:String;
        protected var isPlay = false;

        public function UserItem(){
            removeChild(super.textField);
            roleBtn = new HeadIcon();
            txtUserName = new TextField();
            addChild(roleBtn);
            addChild(txtUserName);
            txtUserName.x = (roleBtn.width + 2);
            txtUserName.width = 120;
            txtUserName.y = 5;
            statusBtn = new StatusButton();
            addChild(statusBtn);
            statusBtn.visible = false;
        }
        override public function setSize(_arg1:Number, _arg2:Number):void{
            super.setSize(_arg1, _arg2);
            if (statusBtn != null){
                txtUserName.x = (roleBtn.width + 2);
                txtUserName.width = ((_arg1 - roleBtn.width) - 10);
                statusBtn.x = (_arg1 - 20);
                statusBtn.y = ((_arg2 - statusBtn.height) / 2);
                roleBtn.y = ((_arg2 - roleBtn.height) / 2);
                txtUserName.y = ((_arg2 - roleBtn.height) / 2);
            };
        }
        override public function set listData(_arg1:ListData):void{
            super._listData = _arg1;
        }
        override public function set data(_arg1:Object):void{
            super._data = _arg1;
            txtUserName.htmlText = (("<font  size='+1' color='#000000' face='宋体'>" + _arg1.label) + "</font>");
            statusBtn.gotoAndStop(2);
            roleBtn.gotoAndStop(1);
            switch (_arg1.data.role){
                case "2":
                    roleBtn.gotoAndStop(1);
                    break;
                case "3":
                    roleBtn.gotoAndStop(2);
                    break;
                case "4":
                    roleBtn.gotoAndStop(3);
                    break;
                default:
                    roleBtn.gotoAndStop(3);
            };
            if (_arg1.data.videoSeat != -2){
                statusBtn.visible = true;
                if (_arg1.data.videoSeat > 0){
                    statusBtn.gotoAndStop(2);
                } else {
                    statusBtn.gotoAndStop(1);
                };
            } else {
                statusBtn.visible = false;
            };
        }

    }
}//package com.zlchat.ui 
