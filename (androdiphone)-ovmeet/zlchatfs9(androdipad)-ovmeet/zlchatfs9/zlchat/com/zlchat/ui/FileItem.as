//hong QQ:1410919373
package com.zlchat.ui {
    import fl.controls.listClasses.*;
    import fl.controls.*;
    import flash.display.*;
    import flash.text.*;

    public class FileItem extends CellRenderer implements ICellRenderer {

        private var txtUserName:TextField;

        public function FileItem(){
            removeChild(super.textField);
            txtUserName = new TextField();
            addChild(txtUserName);
            txtUserName.width = 640;
            txtUserName.x = 5;
            txtUserName.y = 5;
        }
        override public function set listData(_arg1:ListData):void{
            super._listData = _arg1;
        }
        override public function setSize(_arg1:Number, _arg2:Number):void{
            super.setSize(_arg1, _arg2);
        }
        override public function set data(_arg1:Object):void{
            super._data = _arg1;
            txtUserName.htmlText = (("<font  size='+0' color='#000000' face='宋体'>" + _arg1.label) + "</font>");
        }

    }
}//package com.zlchat.ui 
