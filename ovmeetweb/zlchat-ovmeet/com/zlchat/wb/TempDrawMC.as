//hong QQ:1410919373
package com.zlchat.wb {
    import flash.display.*;
    import flash.events.*;
    import com.zlchat.events.*;
    import flash.text.*;

    public class TempDrawMC extends Sprite {

        public var rectBorder:RectBorder;
        public var txtTemp:TextField;

        protected function fsOut(_arg1:FocusEvent):void{
            rectBorder.visible = false;
        }
        protected function fsIn(_arg1:FocusEvent):void{
            rectBorder.visible = true;
        }
        protected function bdResize(_arg1:BorderEvent):void{
            txtTemp.width = _arg1.rect.w;
        }
        public function showTextField(){
            rectBorder = new RectBorder(100, 30);
            addChild(rectBorder);
            rectBorder.x = 0;
            rectBorder.y = 0;
            txtTemp = new TextField();
            txtTemp.type = TextFieldType.INPUT;
            addChild(txtTemp);
            txtTemp.wordWrap = true;
            txtTemp.autoSize = TextFieldAutoSize.LEFT;
            txtTemp.width = 97;
            txtTemp.height = 27;
            txtTemp.x = 0;
            txtTemp.y = 0;
            txtTemp.addEventListener(Event.CHANGE, txtChange);
            rectBorder.addEventListener(BorderEvent.RESIZE, bdResize);
            addEventListener(FocusEvent.FOCUS_OUT, fsOut);
            addEventListener(FocusEvent.FOCUS_IN, fsIn);
        }
        protected function txtChange(_arg1:Event):void{
            if (txtTemp.height > rectBorder.height){
                rectBorder.Resize((txtTemp.width + 5), (txtTemp.height + 5));
            };
        }

    }
}//package com.zlchat.wb 
