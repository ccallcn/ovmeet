//hong QQ:1410919373
package fl.managers {
    import fl.core.*;
    import flash.text.*;
    import flash.utils.*;

    public class StyleManager {

        private static var _instance:StyleManager;

        private var globalStyles:Object;
        private var classToDefaultStylesDict:Dictionary;
        private var styleToClassesHash:Object;
        private var classToStylesDict:Dictionary;
        private var classToInstancesDict:Dictionary;

        public function StyleManager(){
            styleToClassesHash = {};
            classToInstancesDict = new Dictionary(true);
            classToStylesDict = new Dictionary(true);
            classToDefaultStylesDict = new Dictionary(true);
            globalStyles = UIComponent.getStyleDefinition();
        }
        public static function clearComponentStyle(_arg1:Object, _arg2:String):void{
            var _local3:Class;
            var _local4:Object;
            _local3 = getClassDef(_arg1);
            _local4 = getInstance().classToStylesDict[_local3];
            if (((!((_local4 == null))) && (!((_local4[_arg2] == null))))){
                É¾  ³ý _local4[_arg2];
                invalidateComponentStyle(_local3, _arg2);
            };
        }
        private static function getClassDef(_arg1:Object):Class{
            var component:* = _arg1;
            if ((component is Class)){
                return ((component as Class));
            };
            try {
                return ((getDefinitionByName(getQualifiedClassName(component)) as Class));
            } catch(e:Error) {
                if ((component is UIComponent)){
                    try {
                        return ((component.loaderInfo.applicationDomain.getDefinition(getQualifiedClassName(component)) as Class));
                    } catch(e:Error) {
                    };
                };
            };
            return (null);
        }
        public static function clearStyle(_arg1:String):void{
            setStyle(_arg1, null);
        }
        public static function setComponentStyle(_arg1:Object, _arg2:String, _arg3:Object):void{
            var _local4:Class;
            var _local5:Object;
            _local4 = getClassDef(_arg1);
            _local5 = getInstance().classToStylesDict[_local4];
            if (_local5 == null){
                _local5 = (getInstance().classToStylesDict[_local4] = {});
            };
            if (_local5 == _arg3){
                return;
            };
            _local5[_arg2] = _arg3;
            invalidateComponentStyle(_local4, _arg2);
        }
        private static function setSharedStyles(_arg1:UIComponent):void{
            var _local2:StyleManager;
            var _local3:Class;
            var _local4:Object;
            var _local5:String;
            _local2 = getInstance();
            _local3 = getClassDef(_arg1);
            _local4 = _local2.classToDefaultStylesDict[_local3];
            for (_local5 in _local4) {
                _arg1.setSharedStyle(_local5, getSharedStyle(_arg1, _local5));
            };
        }
        public static function getComponentStyle(_arg1:Object, _arg2:String):Object{
            var _local3:Class;
            var _local4:Object;
            _local3 = getClassDef(_arg1);
            _local4 = getInstance().classToStylesDict[_local3];
            return (((_local4)==null) ? null : _local4[_arg2]);
        }
        private static function getInstance(){
            if (_instance == null){
                _instance = new (StyleManager)();
            };
            return (_instance);
        }
        private static function invalidateComponentStyle(_arg1:Class, _arg2:String):void{
            var _local3:Dictionary;
            var _local4:Object;
            var _local5:UIComponent;
            _local3 = getInstance().classToInstancesDict[_arg1];
            if (_local3 == null){
                return;
            };
            for (_local4 in _local3) {
                _local5 = (_local4 as UIComponent);
                if (_local5 == null){
                } else {
                    _local5.setSharedStyle(_arg2, getSharedStyle(_local5, _arg2));
                };
            };
        }
        private static function invalidateStyle(_arg1:String):void{
            var _local2:Dictionary;
            var _local3:Object;
            _local2 = getInstance().styleToClassesHash[_arg1];
            if (_local2 == null){
                return;
            };
            for (_local3 in _local2) {
                invalidateComponentStyle(Class(_local3), _arg1);
            };
        }
        public static function registerInstance(_arg1:UIComponent):void{
            var inst:* = null;
            var classDef:* = null;
            var target:* = null;
            var defaultStyles:* = null;
            var styleToClasses:* = null;
            var n:* = null;
            var instance:* = _arg1;
            inst = getInstance();
            classDef = getClassDef(instance);
            if (classDef == null){
                return;
            };
            if (inst.classToInstancesDict[classDef] == null){
                inst.classToInstancesDict[classDef] = new Dictionary(true);
                target = classDef;
                while (defaultStyles == null) {
                    if (target["getStyleDefinition"] != null){
                        defaultStyles = target["getStyleDefinition"]();
                        break;
                    };
                    try {
                        target = (instance.loaderInfo.applicationDomain.getDefinition(getQualifiedSuperclassName(target)) as Class);
                    } catch(err:Error) {
                        try {
                            target = (getDefinitionByName(getQualifiedSuperclassName(target)) as Class);
                        } catch(e:Error) {
                            defaultStyles = UIComponent.getStyleDefinition();
                            break;
                        };
                    };
                };
                styleToClasses = inst.styleToClassesHash;
                for (n in defaultStyles) {
                    if (styleToClasses[n] == null){
                        styleToClasses[n] = new Dictionary(true);
                    };
                    styleToClasses[n][classDef] = true;
                };
                inst.classToDefaultStylesDict[classDef] = defaultStyles;
                inst.classToStylesDict[classDef] = {};
            };
            inst.classToInstancesDict[classDef][instance] = true;
            setSharedStyles(instance);
        }
        public static function getStyle(_arg1:String):Object{
            return (getInstance().globalStyles[_arg1]);
        }
        private static function getSharedStyle(_arg1:UIComponent, _arg2:String):Object{
            var _local3:Class;
            var _local4:StyleManager;
            var _local5:Object;
            _local3 = getClassDef(_arg1);
            _local4 = getInstance();
            _local5 = _local4.classToStylesDict[_local3][_arg2];
            if (_local5 != null){
                return (_local5);
            };
            _local5 = _local4.globalStyles[_arg2];
            if (_local5 != null){
                return (_local5);
            };
            return (_local4.classToDefaultStylesDict[_local3][_arg2]);
        }
        public static function setStyle(_arg1:String, _arg2:Object):void{
            var _local3:Object;
            _local3 = getInstance().globalStyles;
            if ((((_local3[_arg1] === _arg2)) && (!((_arg2 is TextFormat))))){
                return;
            };
            _local3[_arg1] = _arg2;
            invalidateStyle(_arg1);
        }

    }
}//package fl.managers 
