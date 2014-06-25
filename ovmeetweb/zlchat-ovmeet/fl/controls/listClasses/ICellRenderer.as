//hong QQ:1410919373
package fl.controls.listClasses {

    public interface ICellRenderer {

        function setSize(_arg1:Number, _arg2:Number):void;
        function get listData():ListData;
        function get data():Object;
        function setMouseState(_arg1:String):void;
        function set x(_arg1:Number):void;
        function set y(_arg1:Number):void;
        function set data(_arg1:Object):void;
        function set selected(_arg1:Boolean):void;
        function set listData(_arg1:ListData):void;
        function get selected():Boolean;

    }
}//package fl.controls.listClasses 
