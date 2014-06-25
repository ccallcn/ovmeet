//hong QQ:1410919373
package fl.controls {
    import flash.display.*;

    public class CheckBox extends LabelButton {

        private static var defaultStyles:Object = {
            icon:null,
            upIcon:"CheckBox_upIcon",
            downIcon:"CheckBox_downIcon",
            overIcon:"CheckBox_overIcon",
            disabledIcon:"CheckBox_disabledIcon",
            selectedDisabledIcon:"CheckBox_selectedDisabledIcon",
            focusRectSkin:null,
            focusRectPadding:null,
            selectedUpIcon:"CheckBox_selectedUpIcon",
            selectedDownIcon:"CheckBox_selectedDownIcon",
            selectedOverIcon:"CheckBox_selectedOverIcon",
            textFormat:null,
            disabledTextFormat:null,
            embedFonts:null,
            textPadding:5
        };
        public static var createAccessibilityImplementation:Function;

        public static function getStyleDefinition():Object{
            return (defaultStyles);
        }

        override public function drawFocus(_arg1:Boolean):void{
            var _local2:Number;
            super.drawFocus(_arg1);
            if (_arg1){
                _local2 = Number(getStyleValue("focusRectPadding"));
                uiFocusRect.x = (background.x - _local2);
                uiFocusRect.y = (background.y - _local2);
                uiFocusRect.width = (background.width + (_local2 << 1));
                uiFocusRect.height = (background.height + (_local2 << 1));
            };
        }
        override public function get autoRepeat():Boolean{
            return (false);
        }
        override public function set autoRepeat(_arg1:Boolean):void{
        }
        override public function set toggle(_arg1:Boolean):void{
            throw (new Error("Warning: You cannot change a CheckBox's toggle."));
        }
        override public function get toggle():Boolean{
            return (true);
        }
        override protected function configUI():void{
            var _local1:Shape;
            var _local2:Graphics;
            super.configUI();
            super.toggle = true;
            _local1 = new Shape();
            _local2 = _local1.graphics;
            _local2.beginFill(0, 0);
            _local2.drawRect(0, 0, 100, 100);
            _local2.endFill();
            background = (_local1 as DisplayObject);
            addChildAt(background, 0);
        }
        override protected function drawLayout():void{
            var _local1:Number;
            super.drawLayout();
            _local1 = Number(getStyleValue("textPadding"));
            switch (_labelPlacement){
                case ButtonLabelPlacement.RIGHT:
                    icon.x = _local1;
                    textField.x = (icon.x + (icon.width + _local1));
                    background.width = ((textField.x + textField.width) + _local1);
                    background.height = (Math.max(textField.height, icon.height) + (_local1 * 2));
                    break;
                case ButtonLabelPlacement.LEFT:
                    icon.x = ((width - icon.width) - _local1);
                    textField.x = (((width - icon.width) - (_local1 * 2)) - textField.width);
                    background.width = ((textField.width + icon.width) + (_local1 * 3));
                    background.height = (Math.max(textField.height, icon.height) + (_local1 * 2));
                    break;
                case ButtonLabelPlacement.TOP:
                case ButtonLabelPlacement.BOTTOM:
                    background.width = (Math.max(textField.width, icon.width) + (_local1 * 2));
                    background.height = ((textField.height + icon.height) + (_local1 * 3));
                    break;
            };
            background.x = Math.min((icon.x - _local1), (textField.x - _local1));
            background.y = Math.min((icon.y - _local1), (textField.y - _local1));
        }
        override protected function drawBackground():void{
        }
        override protected function initializeAccessibility():void{
            if (CheckBox.createAccessibilityImplementation != null){
                CheckBox.createAccessibilityImplementation(this);
            };
        }

    }
}//package fl.controls 
