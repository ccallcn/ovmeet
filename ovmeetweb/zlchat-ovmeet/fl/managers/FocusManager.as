//hong QQ:1410919373
package fl.managers {
    import fl.core.*;
    import fl.controls.*;
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;
    import flash.utils.*;
    import flash.ui.*;

    public class FocusManager implements IFocusManager {

        private var focusableObjects:Dictionary;
        private var _showFocusIndicator:Boolean = true;
        private var defButton:Button;
        private var focusableCandidates:Array;
        private var _form:DisplayObjectContainer;
        private var _defaultButtonEnabled:Boolean = true;
        private var activated:Boolean = false;
        private var _defaultButton:Button;
        private var calculateCandidates:Boolean = true;
        private var lastFocus:InteractiveObject;
        private var lastAction:String;

        public function FocusManager(_arg1:DisplayObjectContainer){
            activated = false;
            calculateCandidates = true;
            _showFocusIndicator = true;
            _defaultButtonEnabled = true;
            super();
            focusableObjects = new Dictionary(true);
            if (_arg1 != null){
                _form = _arg1;
                addFocusables(DisplayObject(_arg1));
                _arg1.addEventListener(Event.ADDED, addedHandler);
                _arg1.addEventListener(Event.REMOVED, removedHandler);
                activate();
            };
        }
        public function get showFocusIndicator():Boolean{
            return (_showFocusIndicator);
        }
        private function getIndexOfNextObject(_arg1:int, _arg2:Boolean, _arg3:Boolean, _arg4:String):int{
            var _local5:int;
            var _local6:int;
            var _local7:DisplayObject;
            var _local8:IFocusManagerGroup;
            var _local9:int;
            var _local10:DisplayObject;
            var _local11:IFocusManagerGroup;
            _local5 = focusableCandidates.length;
            _local6 = _arg1;
            while (true) {
                if (_arg2){
                    _arg1--;
                } else {
                    _arg1++;
                };
                if (_arg3){
                    if (((_arg2) && ((_arg1 < 0)))){
                        break;
                    };
                    if (((!(_arg2)) && ((_arg1 == _local5)))){
                        break;
                    };
                } else {
                    _arg1 = ((_arg1 + _local5) % _local5);
                    if (_local6 == _arg1){
                        break;
                    };
                };
                if (isValidFocusCandidate(focusableCandidates[_arg1], _arg4)){
                    _local7 = DisplayObject(findFocusManagerComponent(focusableCandidates[_arg1]));
                    if ((_local7 is IFocusManagerGroup)){
                        _local8 = IFocusManagerGroup(_local7);
                        _local9 = 0;
                        while (_local9 < focusableCandidates.length) {
                            _local10 = focusableCandidates[_local9];
                            if ((_local10 is IFocusManagerGroup)){
                                _local11 = IFocusManagerGroup(_local10);
                                if ((((_local11.groupName == _local8.groupName)) && (_local11.selected))){
                                    _arg1 = _local9;
                                    break;
                                };
                            };
                            _local9++;
                        };
                    };
                    return (_arg1);
                };
            };
            return (_arg1);
        }
        public function set form(_arg1:DisplayObjectContainer):void{
            _form = _arg1;
        }
        private function addFocusables(_arg1:DisplayObject, _arg2:Boolean=false):void{
            var focusable:* = null;
            var io:* = null;
            var doc:* = null;
            var i:* = 0;
            var child:* = null;
            var o:* = _arg1;
            var skipTopLevel:Boolean = _arg2;
            if (!skipTopLevel){
                if ((o is IFocusManagerComponent)){
                    focusable = IFocusManagerComponent(o);
                    if (focusable.focusEnabled){
                        if (((focusable.tabEnabled) && (isTabVisible(o)))){
                            focusableObjects[o] = true;
                            calculateCandidates = true;
                        };
                        o.addEventListener(Event.TAB_ENABLED_CHANGE, tabEnabledChangeHandler);
                        o.addEventListener(Event.TAB_INDEX_CHANGE, tabIndexChangeHandler);
                    };
                } else {
                    if ((o is InteractiveObject)){
                        io = (o as InteractiveObject);
                        if (((((io) && (io.tabEnabled))) && ((findFocusManagerComponent(io) == io)))){
                            focusableObjects[io] = true;
                            calculateCandidates = true;
                        };
                        io.addEventListener(Event.TAB_ENABLED_CHANGE, tabEnabledChangeHandler);
                        io.addEventListener(Event.TAB_INDEX_CHANGE, tabIndexChangeHandler);
                    };
                };
            };
            if ((o is DisplayObjectContainer)){
                doc = DisplayObjectContainer(o);
                o.addEventListener(Event.TAB_CHILDREN_CHANGE, tabChildrenChangeHandler);
                if ((((((doc is Stage)) || ((doc.parent is Stage)))) || (doc.tabChildren))){
                    i = 0;
                    while (i < doc.numChildren) {
                        try {
                            child = doc.getChildAt(i);
                            if (child != null){
                                addFocusables(doc.getChildAt(i));
                            };
                        } catch(error:SecurityError) {
                        };
                        i = (i + 1);
                    };
                };
            };
        }
        private function getChildIndex(_arg1:DisplayObjectContainer, _arg2:DisplayObject):int{
            return (_arg1.getChildIndex(_arg2));
        }
        private function mouseFocusChangeHandler(_arg1:FocusEvent):void{
            if ((_arg1.relatedObject is TextField)){
                return;
            };
            _arg1.preventDefault();
        }
        private function focusOutHandler(_arg1:FocusEvent):void{
            var _local2:InteractiveObject;
            _local2 = (_arg1.target as InteractiveObject);
        }
        private function isValidFocusCandidate(_arg1:DisplayObject, _arg2:String):Boolean{
            var _local3:IFocusManagerGroup;
            if (!isEnabledAndVisible(_arg1)){
                return (false);
            };
            if ((_arg1 is IFocusManagerGroup)){
                _local3 = IFocusManagerGroup(_arg1);
                if (_arg2 == _local3.groupName){
                    return (false);
                };
            };
            return (true);
        }
        public function findFocusManagerComponent(_arg1:InteractiveObject):InteractiveObject{
            var _local2:InteractiveObject;
            _local2 = _arg1;
            while (_arg1) {
                if ((((_arg1 is IFocusManagerComponent)) && (IFocusManagerComponent(_arg1).focusEnabled))){
                    return (_arg1);
                };
                _arg1 = _arg1.parent;
            };
            return (_local2);
        }
        private function sortFocusableObjectsTabIndex():void{
            var _local1:Object;
            var _local2:InteractiveObject;
            focusableCandidates = [];
            for (_local1 in focusableObjects) {
                _local2 = InteractiveObject(_local1);
                if (((_local2.tabIndex) && (!(isNaN(Number(_local2.tabIndex)))))){
                    focusableCandidates.push(_local2);
                };
            };
            focusableCandidates.sort(sortByTabIndex);
        }
        private function removeFocusables(_arg1:DisplayObject):void{
            var _local2:Object;
            var _local3:DisplayObject;
            if ((_arg1 is DisplayObjectContainer)){
                _arg1.removeEventListener(Event.TAB_CHILDREN_CHANGE, tabChildrenChangeHandler);
                _arg1.removeEventListener(Event.TAB_INDEX_CHANGE, tabIndexChangeHandler);
                for (_local2 in focusableObjects) {
                    _local3 = DisplayObject(_local2);
                    if (DisplayObjectContainer(_arg1).contains(_local3)){
                        if (_local3 == lastFocus){
                            lastFocus = null;
                        };
                        _local3.removeEventListener(Event.TAB_ENABLED_CHANGE, tabEnabledChangeHandler);
                        É¾  ³ý focusableObjects[_local2];
                        calculateCandidates = true;
                    };
                };
            };
        }
        private function addedHandler(_arg1:Event):void{
            var _local2:DisplayObject;
            _local2 = DisplayObject(_arg1.target);
            if (_local2.stage){
                addFocusables(DisplayObject(_arg1.target));
            };
        }
        private function getTopLevelFocusTarget(_arg1:InteractiveObject):InteractiveObject{
            while (_arg1 != InteractiveObject(form)) {
                if ((((((((_arg1 is IFocusManagerComponent)) && (IFocusManagerComponent(_arg1).focusEnabled))) && (IFocusManagerComponent(_arg1).mouseFocusEnabled))) && (UIComponent(_arg1).enabled))){
                    return (_arg1);
                };
                _arg1 = _arg1.parent;
                if (_arg1 == null){
                    break;
                };
            };
            return (null);
        }
        private function tabChildrenChangeHandler(_arg1:Event):void{
            var _local2:DisplayObjectContainer;
            if (_arg1.target != _arg1.currentTarget){
                return;
            };
            calculateCandidates = true;
            _local2 = DisplayObjectContainer(_arg1.target);
            if (_local2.tabChildren){
                addFocusables(_local2, true);
            } else {
                removeFocusables(_local2);
            };
        }
        public function sendDefaultButtonEvent():void{
            defButton.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
        }
        public function getFocus():InteractiveObject{
            var _local1:InteractiveObject;
            _local1 = form.stage.focus;
            return (findFocusManagerComponent(_local1));
        }
        private function isEnabledAndVisible(_arg1:DisplayObject):Boolean{
            var _local2:DisplayObjectContainer;
            var _local3:TextField;
            var _local4:SimpleButton;
            _local2 = DisplayObject(form).parent;
            while (_arg1 != _local2) {
                if ((_arg1 is UIComponent)){
                    if (!UIComponent(_arg1).enabled){
                        return (false);
                    };
                } else {
                    if ((_arg1 is TextField)){
                        _local3 = TextField(_arg1);
                        if ((((_local3.type == TextFieldType.DYNAMIC)) || (!(_local3.selectable)))){
                            return (false);
                        };
                    } else {
                        if ((_arg1 is SimpleButton)){
                            _local4 = SimpleButton(_arg1);
                            if (!_local4.enabled){
                                return (false);
                            };
                        };
                    };
                };
                if (!_arg1.visible){
                    return (false);
                };
                _arg1 = _arg1.parent;
            };
            return (true);
        }
        public function set defaultButton(_arg1:Button):void{
            var _local2:Button;
            _local2 = (_arg1) ? Button(_arg1) : null;
            if (_local2 != _defaultButton){
                if (_defaultButton){
                    _defaultButton.emphasized = false;
                };
                if (defButton){
                    defButton.emphasized = false;
                };
                _defaultButton = _local2;
                defButton = _local2;
                if (_local2){
                    _local2.emphasized = true;
                };
            };
        }
        private function deactivateHandler(_arg1:Event):void{
            var _local2:InteractiveObject;
            _local2 = InteractiveObject(_arg1.target);
        }
        public function setFocus(_arg1:InteractiveObject):void{
            if ((_arg1 is IFocusManagerComponent)){
                IFocusManagerComponent(_arg1).setFocus();
            } else {
                form.stage.focus = _arg1;
            };
        }
        private function setFocusToNextObject(_arg1:FocusEvent):void{
            var _local2:InteractiveObject;
            if (!hasFocusableObjects()){
                return;
            };
            _local2 = getNextFocusManagerComponent(_arg1.shiftKey);
            if (_local2){
                setFocus(_local2);
            };
        }
        private function hasFocusableObjects():Boolean{
            var _local1:Object;
            for (_local1 in focusableObjects) {
                return (true);
            };
            return (false);
        }
        private function tabIndexChangeHandler(_arg1:Event):void{
            calculateCandidates = true;
        }
        private function sortFocusableObjects():void{
            var _local1:Object;
            var _local2:InteractiveObject;
            focusableCandidates = [];
            for (_local1 in focusableObjects) {
                _local2 = InteractiveObject(_local1);
                if (((((_local2.tabIndex) && (!(isNaN(Number(_local2.tabIndex)))))) && ((_local2.tabIndex > 0)))){
                    sortFocusableObjectsTabIndex();
                    return;
                };
                focusableCandidates.push(_local2);
            };
            focusableCandidates.sort(sortByDepth);
        }
        private function keyFocusChangeHandler(_arg1:FocusEvent):void{
            showFocusIndicator = true;
            if ((((((_arg1.keyCode == Keyboard.TAB)) || ((_arg1.keyCode == 0)))) && (!(_arg1.isDefaultPrevented())))){
                setFocusToNextObject(_arg1);
                _arg1.preventDefault();
            };
        }
        private function getIndexOfFocusedObject(_arg1:DisplayObject):int{
            var _local2:int;
            var _local3:int;
            _local2 = focusableCandidates.length;
            _local3 = 0;
            _local3 = 0;
            while (_local3 < _local2) {
                if (focusableCandidates[_local3] == _arg1){
                    return (_local3);
                };
                _local3++;
            };
            return (-1);
        }
        public function hideFocus():void{
        }
        private function removedHandler(_arg1:Event):void{
            var _local2:int;
            var _local3:DisplayObject;
            var _local4:InteractiveObject;
            _local3 = DisplayObject(_arg1.target);
            if ((((_local3 is IFocusManagerComponent)) && ((focusableObjects[_local3] == true)))){
                if (_local3 == lastFocus){
                    IFocusManagerComponent(lastFocus).drawFocus(false);
                    lastFocus = null;
                };
                _local3.removeEventListener(Event.TAB_ENABLED_CHANGE, tabEnabledChangeHandler);
                É¾  ³ý focusableObjects[_local3];
                calculateCandidates = true;
            } else {
                if ((((_local3 is InteractiveObject)) && ((focusableObjects[_local3] == true)))){
                    _local4 = (_local3 as InteractiveObject);
                    if (_local4){
                        if (_local4 == lastFocus){
                            lastFocus = null;
                        };
                        É¾  ³ý focusableObjects[_local4];
                        calculateCandidates = true;
                    };
                    _local3.addEventListener(Event.TAB_ENABLED_CHANGE, tabEnabledChangeHandler);
                };
            };
            removeFocusables(_local3);
        }
        private function sortByDepth(_arg1:InteractiveObject, _arg2:InteractiveObject):Number{
            var _local3:String;
            var _local4:String;
            var _local5:int;
            var _local6:String;
            var _local7:String;
            var _local8:String;
            var _local9:DisplayObject;
            var _local10:DisplayObject;
            _local3 = "";
            _local4 = "";
            _local8 = "0000";
            _local9 = DisplayObject(_arg1);
            _local10 = DisplayObject(_arg2);
            while (((!((_local9 == DisplayObject(form)))) && (_local9.parent))) {
                _local5 = getChildIndex(_local9.parent, _local9);
                _local6 = _local5.toString(16);
                if (_local6.length < 4){
                    _local7 = (_local8.substring(0, (4 - _local6.length)) + _local6);
                };
                _local3 = (_local7 + _local3);
                _local9 = _local9.parent;
            };
            while (((!((_local10 == DisplayObject(form)))) && (_local10.parent))) {
                _local5 = getChildIndex(_local10.parent, _local10);
                _local6 = _local5.toString(16);
                if (_local6.length < 4){
                    _local7 = (_local8.substring(0, (4 - _local6.length)) + _local6);
                };
                _local4 = (_local7 + _local4);
                _local10 = _local10.parent;
            };
            return (((_local3 > _local4)) ? 1 : ((_local3 < _local4)) ? -1 : 0);
        }
        public function get defaultButton():Button{
            return (_defaultButton);
        }
        private function activateHandler(_arg1:Event):void{
            var _local2:InteractiveObject;
            _local2 = InteractiveObject(_arg1.target);
            if (lastFocus){
                if ((lastFocus is IFocusManagerComponent)){
                    IFocusManagerComponent(lastFocus).setFocus();
                } else {
                    form.stage.focus = lastFocus;
                };
            };
            lastAction = "ACTIVATE";
        }
        public function showFocus():void{
        }
        public function set defaultButtonEnabled(_arg1:Boolean):void{
            _defaultButtonEnabled = _arg1;
        }
        public function getNextFocusManagerComponent(_arg1:Boolean=false):InteractiveObject{
            var _local2:DisplayObject;
            var _local3:String;
            var _local4:int;
            var _local5:Boolean;
            var _local6:int;
            var _local7:int;
            var _local8:IFocusManagerGroup;
            if (!hasFocusableObjects()){
                return (null);
            };
            if (calculateCandidates){
                sortFocusableObjects();
                calculateCandidates = false;
            };
            _local2 = form.stage.focus;
            _local2 = DisplayObject(findFocusManagerComponent(InteractiveObject(_local2)));
            _local3 = "";
            if ((_local2 is IFocusManagerGroup)){
                _local8 = IFocusManagerGroup(_local2);
                _local3 = _local8.groupName;
            };
            _local4 = getIndexOfFocusedObject(_local2);
            _local5 = false;
            _local6 = _local4;
            if (_local4 == -1){
                if (_arg1){
                    _local4 = focusableCandidates.length;
                };
                _local5 = true;
            };
            _local7 = getIndexOfNextObject(_local4, _arg1, _local5, _local3);
            return (findFocusManagerComponent(focusableCandidates[_local7]));
        }
        private function mouseDownHandler(_arg1:MouseEvent):void{
            var _local2:InteractiveObject;
            if (_arg1.isDefaultPrevented()){
                return;
            };
            _local2 = getTopLevelFocusTarget(InteractiveObject(_arg1.target));
            if (!_local2){
                return;
            };
            showFocusIndicator = false;
            if (((((!((_local2 == lastFocus))) || ((lastAction == "ACTIVATE")))) && (!((_local2 is TextField))))){
                setFocus(_local2);
            };
            lastAction = "MOUSEDOWN";
        }
        private function isTabVisible(_arg1:DisplayObject):Boolean{
            var _local2:DisplayObjectContainer;
            _local2 = _arg1.parent;
            while (((((_local2) && (!((_local2 is Stage))))) && (!(((_local2.parent) && ((_local2.parent is Stage))))))) {
                if (!_local2.tabChildren){
                    return (false);
                };
                _local2 = _local2.parent;
            };
            return (true);
        }
        public function get nextTabIndex():int{
            return (0);
        }
        private function keyDownHandler(_arg1:KeyboardEvent):void{
            if (_arg1.keyCode == Keyboard.TAB){
                lastAction = "KEY";
                if (calculateCandidates){
                    sortFocusableObjects();
                    calculateCandidates = false;
                };
            };
            if (((((((defaultButtonEnabled) && ((_arg1.keyCode == Keyboard.ENTER)))) && (defaultButton))) && (defButton.enabled))){
                sendDefaultButtonEvent();
            };
        }
        private function focusInHandler(_arg1:FocusEvent):void{
            var _local2:InteractiveObject;
            var _local3:Button;
            _local2 = InteractiveObject(_arg1.target);
            if (form.contains(_local2)){
                lastFocus = findFocusManagerComponent(InteractiveObject(_local2));
                if ((lastFocus is Button)){
                    _local3 = Button(lastFocus);
                    if (defButton){
                        defButton.emphasized = false;
                        defButton = _local3;
                        _local3.emphasized = true;
                    };
                } else {
                    if (((defButton) && (!((defButton == _defaultButton))))){
                        defButton.emphasized = false;
                        defButton = _defaultButton;
                        _defaultButton.emphasized = true;
                    };
                };
            };
        }
        private function tabEnabledChangeHandler(_arg1:Event):void{
            var _local2:InteractiveObject;
            var _local3:Boolean;
            calculateCandidates = true;
            _local2 = InteractiveObject(_arg1.target);
            _local3 = (focusableObjects[_local2] == true);
            if (_local2.tabEnabled){
                if (((!(_local3)) && (isTabVisible(_local2)))){
                    if (!(_local2 is IFocusManagerComponent)){
                        _local2.focusRect = false;
                    };
                    focusableObjects[_local2] = true;
                };
            } else {
                if (_local3){
                    É¾  ³ý focusableObjects[_local2];
                };
            };
        }
        public function set showFocusIndicator(_arg1:Boolean):void{
            _showFocusIndicator = _arg1;
        }
        public function get form():DisplayObjectContainer{
            return (_form);
        }
        private function sortByTabIndex(_arg1:InteractiveObject, _arg2:InteractiveObject):int{
            return (((_arg1.tabIndex > _arg2.tabIndex)) ? 1 : ((_arg1.tabIndex < _arg2.tabIndex)) ? -1 : sortByDepth(_arg1, _arg2));
        }
        public function activate():void{
            if (activated){
                return;
            };
            form.stage.addEventListener(FocusEvent.MOUSE_FOCUS_CHANGE, mouseFocusChangeHandler, false, 0, true);
            form.stage.addEventListener(FocusEvent.KEY_FOCUS_CHANGE, keyFocusChangeHandler, false, 0, true);
            form.addEventListener(FocusEvent.FOCUS_IN, focusInHandler, true);
            form.addEventListener(FocusEvent.FOCUS_OUT, focusOutHandler, true);
            form.stage.addEventListener(Event.ACTIVATE, activateHandler, false, 0, true);
            form.stage.addEventListener(Event.DEACTIVATE, deactivateHandler, false, 0, true);
            form.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
            form.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler, true);
            activated = true;
            if (lastFocus){
                setFocus(lastFocus);
            };
        }
        public function deactivate():void{
            form.stage.removeEventListener(FocusEvent.MOUSE_FOCUS_CHANGE, mouseFocusChangeHandler);
            form.stage.removeEventListener(FocusEvent.KEY_FOCUS_CHANGE, keyFocusChangeHandler);
            form.removeEventListener(FocusEvent.FOCUS_IN, focusInHandler, true);
            form.removeEventListener(FocusEvent.FOCUS_OUT, focusOutHandler, true);
            form.stage.removeEventListener(Event.ACTIVATE, activateHandler);
            form.stage.removeEventListener(Event.DEACTIVATE, deactivateHandler);
            form.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
            form.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler, true);
            activated = false;
        }
        public function get defaultButtonEnabled():Boolean{
            return (_defaultButtonEnabled);
        }

    }
}//package fl.managers 
