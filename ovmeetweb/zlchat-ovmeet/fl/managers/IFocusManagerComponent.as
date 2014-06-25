//hong QQ:1410919373
package fl.managers {

    public interface IFocusManagerComponent {

        function set focusEnabled(_arg1:Boolean):void;
        function drawFocus(_arg1:Boolean):void;
        function setFocus():void;
        function get focusEnabled():Boolean;
        function get tabEnabled():Boolean;
        function get tabIndex():int;
        function get mouseFocusEnabled():Boolean;

    }
}//package fl.managers 
