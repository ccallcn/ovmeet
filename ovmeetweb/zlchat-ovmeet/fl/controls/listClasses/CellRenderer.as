//hong QQ:1410919373
package fl.controls.listClasses {
    import fl.controls.*;
    import flash.events.*;

    public class CellRenderer extends LabelButton implements ICellRenderer {

        private static var defaultStyles:Object = {
            upSkin:"CellRenderer_upSkin",
            downSkin:"CellRenderer_downSkin",
            overSkin:"CellRenderer_overSkin",
            disabledSkin:"CellRenderer_disabledSkin",
            selectedDisabledSkin:"CellRenderer_selectedDisabledSkin",
            selectedUpSkin:"CellRenderer_selectedUpSkin",
            selectedDownSkin:"CellRenderer_selectedDownSkin",
            selectedOverSkin:"CellRenderer_selectedOverSkin",
            textFormat:null,
            disabledTextFormat:null,
            embedFonts:null,
            textPadding:5
        };

        protected var _data:Object;
        protected var _listData:ListData;

        public function CellRenderer():void{
            toggle = true;
            focusEnabled = false;
        }
        public static function getStyleDefinition():Object{
            return (defaultStyles);
        }

        override protected function toggleSelected(_arg1:MouseEvent):void{
        }
        override public function get selected():Boolean{
            return (super.selected);
        }
        public function set listData(_arg1:ListData):void{
            _listData = _arg1;
            label = _listData.label;
            setStyle("icon", _listData.icon);
        }
        override public function set selected(_arg1:Boolean):void{
            super.selected = _arg1;
        }
        public function set data(_arg1:Object):void{
            _data = _arg1;
        }
        public function get listData():ListData{
            return (_listData);
        }
        override public function setSize(_arg1:Number, _arg2:Number):void{
            super.setSize(_arg1, _arg2);
        }
        override protected function drawLayout():void{
            var _local1:Number;
            var _local2:Number;
            var _local3:Number;
            _local1 = Number(getStyleValue("textPadding"));
            _local2 = 0;
            if (icon != null){
                icon.x = _local1;
                icon.y = Math.round(((height - icon.height) >> 1));
                _local2 = (icon.width + _local1);
            };
            if (label.length > 0){
                textField.visible = true;
                _local3 = Math.max(0, ((width - _local2) - (_local1 * 2)));
                textField.width = _local3;
                textField.height = (textField.textHeight + 4);
                textField.x = (_local2 + _local1);
                textField.y = Math.round(((height - textField.height) >> 1));
            } else {
                textField.visible = false;
            };
            background.width = width;
            background.height = height;
        }
        public function get data():Object{
            return (_data);
        }

    }
}//package fl.controls.listClasses 
