//hong QQ:1410919373
package fl.controls.listClasses {
    import fl.core.*;

    public class ListData {

        protected var _index:uint;
        protected var _owner:UIComponent;
        protected var _label:String;
        protected var _icon:Object = null;
        protected var _row:uint;
        protected var _column:uint;

        public function ListData(_arg1:String, _arg2:Object, _arg3:UIComponent, _arg4:uint, _arg5:uint, _arg6:uint=0){
            _icon = null;
            super();
            _label = _arg1;
            _icon = _arg2;
            _owner = _arg3;
            _index = _arg4;
            _row = _arg5;
            _column = _arg6;
        }
        public function get owner():UIComponent{
            return (_owner);
        }
        public function get label():String{
            return (_label);
        }
        public function get row():uint{
            return (_row);
        }
        public function get index():uint{
            return (_index);
        }
        public function get icon():Object{
            return (_icon);
        }
        public function get column():uint{
            return (_column);
        }

    }
}//package fl.controls.listClasses 
