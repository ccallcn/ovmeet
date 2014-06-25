//hong QQ:1410919373
package com.zlchat.wb {
    import fl.controls.*;
    import flash.display.*;
    import com.zlchat.ui.*;
    import flash.events.*;
    import flash.net.*;
    import fl.events.*;
    import flash.text.*;

    public class ToolBar extends Sprite {

        private var toolCircle:MovieClip;
        private var toolImg:MovieClip;
        public var selectedColor:int = 0;
        private var txtTip:TextField;
        private var toolClear:MovieClip;
        private var toolRect:MovieClip;
        private var toolArray:MovieClip;
        private var toolLine:MovieClip;
        private var toolPPT:MovieClip;
        private var bg:Sprite;
        public var wb:WhiteBoardPane;
        private var colorPicker:ColorPicker;
        private var toolDel:MovieClip;
        public var selectedTool:String = "";
        private var toolPen:MovieClip;
        private var toolText:MovieClip;
        private var toolSwitch:MovieClip;
        private var hideTool:Boolean = false;
        public var thickness:int = 2;

        public function ToolBar(){
            bg = new Sprite();
            addChild(bg);
            drawBg();
            toolArray = new ToolArray();

            addChild(toolArray);
            toolArray.x = 8;
            toolArray.y = 10;
            toolArray.name = "array";



            toolPen = new ToolPen();
            addChild(toolPen);
            toolPen.x = 120;
            toolPen.y = 10;
            toolPen.name = "pen";




            toolLine = new ToolLine();
            addChild(toolLine);
            toolLine.x = 36;
            toolLine.y = 10;
            toolLine.name = "line";
            toolRect = new ToolRect();
            addChild(toolRect);
            toolRect.x = 64;
            toolRect.y = 10;
            toolRect.name = "rect";
            toolCircle = new ToolCircle();
            addChild(toolCircle);
            toolCircle.x = 92;
            toolCircle.y = 10;
            toolCircle.name = "circle";
            toolText = new ToolText();
            addChild(toolText);
            toolText.x = 148;
            toolText.y = 10;
            toolText.name = "text";
            toolImg = new ToolImg();
            addChild(toolImg);
            toolImg.x = 176;
            toolImg.y = 10;
            toolImg.name = "img";
            toolDel = new ToolDel();
            addChild(toolDel);
            toolDel.x = 204;
            toolDel.y = 10;
            toolDel.name = "del";
            toolClear = new ToolClear();
            addChild(toolClear);
            toolClear.x = 232;
            toolClear.y = 10;
            toolClear.name = "clear";
            toolPPT = new ToolPPT();
            addChild(toolPPT);
            toolPPT.x = 260;
            toolPPT.y = 10;
            toolPPT.name = "ppt";

            colorPicker = new ColorPicker();
            colorPicker.addEventListener(ColorPickerEvent.CHANGE, changeColor);
            addChild(colorPicker);
            colorPicker.width = 24;
            colorPicker.height = 24;
            colorPicker.x = 288;
            colorPicker.y = 10;

            toolSwitch = new ToolSwitch();
            addChild(toolSwitch);
            toolSwitch.x = 310;
            toolSwitch.y = 2;

            toolSwitch.addEventListener(MouseEvent.CLICK, switchToolBar);
            toolLine.addEventListener(MouseEvent.CLICK, onTool);
            toolRect.addEventListener(MouseEvent.CLICK, onTool);
            toolCircle.addEventListener(MouseEvent.CLICK, onTool);
            toolText.addEventListener(MouseEvent.CLICK, onTool);
            toolPen.addEventListener(MouseEvent.CLICK, onTool);
            toolImg.addEventListener(MouseEvent.CLICK, onTool);
            toolArray.addEventListener(MouseEvent.CLICK, onTool);
            toolDel.addEventListener(MouseEvent.CLICK, onDel);
            toolClear.addEventListener(MouseEvent.CLICK, onClear);
            toolPPT.addEventListener(MouseEvent.CLICK, onPPT);
            txtTip = new TextField();
            txtTip.autoSize = TextFieldAutoSize.LEFT;
            txtTip.textColor = 0xFF0000;
            addChild(txtTip);
            txtTip.visible = false;
            toolArray.addEventListener(MouseEvent.MOUSE_OVER, arrayOnOver);
            toolArray.addEventListener(MouseEvent.MOUSE_OUT, OnOut);
            toolPen.addEventListener(MouseEvent.MOUSE_OVER, penOnOver);
            toolPen.addEventListener(MouseEvent.MOUSE_OUT, OnOut);
            toolLine.addEventListener(MouseEvent.MOUSE_OVER, lineOnOver);
            toolLine.addEventListener(MouseEvent.MOUSE_OUT, OnOut);
            toolCircle.addEventListener(MouseEvent.MOUSE_OVER, circleOnOver);
            toolCircle.addEventListener(MouseEvent.MOUSE_OUT, OnOut);
            toolRect.addEventListener(MouseEvent.MOUSE_OVER, rectOnOver);
            toolRect.addEventListener(MouseEvent.MOUSE_OUT, OnOut);
            toolText.addEventListener(MouseEvent.MOUSE_OVER, textOnOver);
            toolText.addEventListener(MouseEvent.MOUSE_OUT, OnOut);
            toolImg.addEventListener(MouseEvent.MOUSE_OVER, imgOnOver);
            toolImg.addEventListener(MouseEvent.MOUSE_OUT, OnOut);
            toolDel.addEventListener(MouseEvent.MOUSE_OVER, delOnOver);
            toolDel.addEventListener(MouseEvent.MOUSE_OUT, OnOut);
            toolClear.addEventListener(MouseEvent.MOUSE_OVER, clearOnOver);
            toolClear.addEventListener(MouseEvent.MOUSE_OUT, OnOut);
            toolPPT.addEventListener(MouseEvent.MOUSE_OVER, pptOnOver);
            toolPPT.addEventListener(MouseEvent.MOUSE_OUT, OnOut);
        }
        private function clearOnOver(_arg1:MouseEvent):void{
            showTip("清空白板");
        }
        protected function switchToolBar(_arg1:MouseEvent):void{
            if (hideTool){
                toolSwitch.gotoAndStop(1);
                showTool(true);
                hideTool = false;
                //toolSwitch.y = 310;
		toolSwitch.x = 310;
            } else {
                toolSwitch.gotoAndStop(2);
                showTool(false);
                hideTool = true;
                //toolSwitch.y = 2;
		toolSwitch.x = 2;
            };
        }
        private function arrayOnOver(_arg1:MouseEvent):void{
            showTip("选择移动图形");
        }
        protected function changeColor(_arg1:ColorPickerEvent):void{
            selectedColor = _arg1.color;
        }
        protected function onTool(_arg1:MouseEvent):void{
            goto1();
            MovieClip(_arg1.currentTarget).gotoAndStop(2);
            selectedTool = _arg1.currentTarget.name;
            if (selectedTool == "img"){
                wb.onSendFile();
            };
            if (selectedTool == "array"){
                wb.drawMC.visible = false;
            } else {
                wb.drawMC.visible = true;
            };
        }
        protected function onPPT(_arg1:MouseEvent):void{
            wb.openPPT();
        }
        private function drawBg():void{
            bg.graphics.lineStyle(2, 2578295);
            //bg.graphics.beginFill(15268088, 0.8);
            //bg.graphics.drawRect(2, 2, 40, 320);
            bg.graphics.beginFill(15268088, 0.5);
            bg.graphics.drawRoundRect(2, 2, 320,40,10,10);
            bg.graphics.endFill();
        }
        protected function onClear(_arg1:MouseEvent):void{
            selectedTool = _arg1.currentTarget.name;
            goto1();
            MovieClip(_arg1.currentTarget).gotoAndStop(2);
            wb.clearWB();
        }
        protected function goto1():void{
            toolLine.gotoAndStop(1);
            toolRect.gotoAndStop(1);
            toolCircle.gotoAndStop(1);
            toolText.gotoAndStop(1);
            toolPen.gotoAndStop(1);
            toolImg.gotoAndStop(1);
            toolArray.gotoAndStop(1);
            toolDel.gotoAndStop(1);
            toolClear.gotoAndStop(1);
            toolPPT.gotoAndStop(1);
        }
        protected function onDel(_arg1:MouseEvent):void{
            goto1();
            selectedTool = _arg1.currentTarget.name;
            MovieClip(_arg1.currentTarget).gotoAndStop(2);
            wb.drawMC.visible = false;
            wb.delShape();
        }
        private function delOnOver(_arg1:MouseEvent):void{
            showTip("删除图形");
        }
        private function circleOnOver(_arg1:MouseEvent):void{
            showTip("圆");
        }
        protected function showTool(_arg1:Boolean):void{
            toolLine.visible = _arg1;
            toolRect.visible = _arg1;
            toolCircle.visible = _arg1;
            toolText.visible = _arg1;
            toolPen.visible = _arg1;
            toolImg.visible = _arg1;
            toolArray.visible = _arg1;
            toolDel.visible = _arg1;
            toolClear.visible = _arg1;
            toolPPT.visible = _arg1;
            colorPicker.visible = _arg1;
            bg.visible = _arg1;
        }
        private function penOnOver(_arg1:MouseEvent):void{
            showTip("铅笔");
        }
        private function OnOut(_arg1:MouseEvent):void{
            txtTip.visible = false;
        }
        private function rectOnOver(_arg1:MouseEvent):void{
            showTip("矩形");
        }
        private function showTip(_arg1:String):void{
            txtTip.x = (mouseX + 15);
            txtTip.y = (mouseY - 20);
            txtTip.text = _arg1;
            addChild(txtTip);
            txtTip.visible = true;
        }
        private function textOnOver(_arg1:MouseEvent):void{
            showTip("文本");
        }
        private function pptOnOver(_arg1:MouseEvent):void{
            showTip("打开PPT");
        }
        private function priOnOver(_arg1:MouseEvent):void{
            showTip("请求和对方私聊");
        }
        private function lineOnOver(_arg1:MouseEvent):void{
            showTip("直线");
        }
        private function imgOnOver(_arg1:MouseEvent):void{
            showTip("图片");
        }

    }
}//package com.zlchat.wb 
