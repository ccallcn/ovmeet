//hong QQ:1410919373
package com.zlchat.ui {
    import flash.display.*;
    import flash.text.*;

    public class TabButton extends MovieClip {

        private var tf:TextFormat;
        private var title:TextField;

        public function TabButton(_arg1:String){
            addFrameScript(0, frame1);
            title = new TextField();
            title.text = _arg1;
            tf = new TextFormat();
            //tf.color = "0x42728D";
	    tf.color = "0xFFFFFF";
            tf.size = 14;
            title.setTextFormat(tf);
            addChild(title);
            title.width = (title.textWidth + 4);
            title.height = (title.textHeight + 4);
            title.autoSize = TextFieldAutoSize.CENTER;
            title.x = ((this.width - title.width) / 2);
            title.y = ((this.height - title.height) / 2);
            title.selectable = false;
            title.wordWrap = false;
            title.type = TextFieldType.DYNAMIC;
            useHandCursor = true;
            buttonMode = true;
            mouseChildren = false;
        }
        public function changeState(_arg1:int):void{
            gotoAndStop(_arg1);
            if (_arg1 == 1){
                tf = new TextFormat();
                //tf.color = "0x42728D";
		tf.color = "0xFFFFFF";
                tf.size = 14;
                title.setTextFormat(tf);
            } else {
                tf = new TextFormat();
                tf.color = "0xFFFFFF";
                tf.size = 14;
                title.setTextFormat(tf);
            };
        }
        public function setTitle(_arg1:String):void{
            //tf.color = "0x42728D";
	    tf.color = "0xFFFFFF";
            tf.size = 14;
            title.setTextFormat(tf);
            title.text = _arg1;
        }
        function frame1(){
            stop();
        }
        public function set label(_arg1:String):void{
            title.text = _arg1;
            tf = new TextFormat();
            if (this.currentFrame == 1){
               // tf.color = "0x42728D";
	       tf.color = "0xFFFFFF";
            } else {
                tf.color = "0xFFFFFF";
            };
            tf.size = 14;
            title.setTextFormat(tf);
            title.width = (title.textWidth + 4);
            title.height = (title.textHeight + 4);
            title.autoSize = TextFieldAutoSize.CENTER;
            title.x = ((this.width - title.width) / 2);
            title.y = ((this.height - title.height) / 2);
        }

    }
}//package com.zlchat.ui 
