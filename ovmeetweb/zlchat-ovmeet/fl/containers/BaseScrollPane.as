//hong QQ:1410919373
package fl.containers {
    import fl.core.*;
    import fl.controls.*;
    import flash.display.*;
    import flash.geom.*;
    import flash.events.*;
    import fl.events.*;

    public class BaseScrollPane extends UIComponent {

        protected static const SCROLL_BAR_STYLES:Object = {
            upArrowDisabledSkin:"upArrowDisabledSkin",
            upArrowDownSkin:"upArrowDownSkin",
            upArrowOverSkin:"upArrowOverSkin",
            upArrowUpSkin:"upArrowUpSkin",
            downArrowDisabledSkin:"downArrowDisabledSkin",
            downArrowDownSkin:"downArrowDownSkin",
            downArrowOverSkin:"downArrowOverSkin",
            downArrowUpSkin:"downArrowUpSkin",
            thumbDisabledSkin:"thumbDisabledSkin",
            thumbDownSkin:"thumbDownSkin",
            thumbOverSkin:"thumbOverSkin",
            thumbUpSkin:"thumbUpSkin",
            thumbIcon:"thumbIcon",
            trackDisabledSkin:"trackDisabledSkin",
            trackDownSkin:"trackDownSkin",
            trackOverSkin:"trackOverSkin",
            trackUpSkin:"trackUpSkin",
            repeatDelay:"repeatDelay",
            repeatInterval:"repeatInterval"
        };

        private static var defaultStyles:Object = {
            repeatDelay:500,
            repeatInterval:35,
            skin:"ScrollPane_upSkin",
            contentPadding:0,
            disabledAlpha:0.5
        };

        protected var defaultLineScrollSize:Number = 4;
        protected var _maxHorizontalScrollPosition:Number = 0;
        protected var vScrollBar:Boolean;
        protected var disabledOverlay:Shape;
        protected var hScrollBar:Boolean;
        protected var availableWidth:Number;
        protected var _verticalPageScrollSize:Number = 0;
        protected var vOffset:Number = 0;
        protected var _verticalScrollBar:ScrollBar;
        protected var useFixedHorizontalScrolling:Boolean = false;
        protected var contentWidth:Number = 0;
        protected var contentHeight:Number = 0;
        protected var _horizontalPageScrollSize:Number = 0;
        protected var background:DisplayObject;
        protected var _useBitmpScrolling:Boolean = false;
        protected var contentPadding:Number = 0;
        protected var availableHeight:Number;
        protected var _horizontalScrollBar:ScrollBar;
        protected var contentScrollRect:Rectangle;
        protected var _horizontalScrollPolicy:String;
        protected var _verticalScrollPolicy:String;

        public function BaseScrollPane(){
            contentWidth = 0;
            contentHeight = 0;
            contentPadding = 0;
            vOffset = 0;
            _maxHorizontalScrollPosition = 0;
            _horizontalPageScrollSize = 0;
            _verticalPageScrollSize = 0;
            defaultLineScrollSize = 4;
            useFixedHorizontalScrolling = false;
            _useBitmpScrolling = false;
            super();
        }
        public static function getStyleDefinition():Object{
            return (mergeStyles(defaultStyles, ScrollBar.getStyleDefinition()));
        }

        protected function handleWheel(_arg1:MouseEvent):void{
            if (((((!(enabled)) || (!(_verticalScrollBar.visible)))) || ((contentHeight <= availableHeight)))){
                return;
            };
            _verticalScrollBar.scrollPosition = (_verticalScrollBar.scrollPosition - (_arg1.delta * verticalLineScrollSize));
            setVerticalScrollPosition(_verticalScrollBar.scrollPosition);
            dispatchEvent(new ScrollEvent(ScrollBarDirection.VERTICAL, _arg1.delta, horizontalScrollPosition));
        }
        public function get verticalScrollPosition():Number{
            return (_verticalScrollBar.scrollPosition);
        }
        protected function drawDisabledOverlay():void{
            if (enabled){
                if (contains(disabledOverlay)){
                    removeChild(disabledOverlay);
                };
            } else {
                disabledOverlay.x = (disabledOverlay.y = contentPadding);
                disabledOverlay.width = availableWidth;
                disabledOverlay.height = availableHeight;
                disabledOverlay.alpha = (getStyleValue("disabledAlpha") as Number);
                addChild(disabledOverlay);
            };
        }
        public function set verticalScrollPosition(_arg1:Number):void{
            drawNow();
            _verticalScrollBar.scrollPosition = _arg1;
            setVerticalScrollPosition(_verticalScrollBar.scrollPosition, false);
        }
        protected function setContentSize(_arg1:Number, _arg2:Number):void{
            if ((((((contentWidth == _arg1)) || (useFixedHorizontalScrolling))) && ((contentHeight == _arg2)))){
                return;
            };
            contentWidth = _arg1;
            contentHeight = _arg2;
            invalidate(InvalidationType.SIZE);
        }
        public function get horizontalScrollPosition():Number{
            return (_horizontalScrollBar.scrollPosition);
        }
        public function get horizontalScrollBar():ScrollBar{
            return (_horizontalScrollBar);
        }
        override public function set enabled(_arg1:Boolean):void{
            if (enabled == _arg1){
                return;
            };
            _verticalScrollBar.enabled = _arg1;
            _horizontalScrollBar.enabled = _arg1;
            super.enabled = _arg1;
        }
        public function get verticalLineScrollSize():Number{
            return (_verticalScrollBar.lineScrollSize);
        }
        public function get horizontalScrollPolicy():String{
            return (_horizontalScrollPolicy);
        }
        protected function calculateAvailableSize():void{
            var _local1:Number;
            var _local2:Number;
            var _local3:Number;
            var _local4:Number;
            var _local5:Number;
            _local1 = ScrollBar.WIDTH;
            _local2 = (contentPadding = Number(getStyleValue("contentPadding")));
            _local3 = ((height - (2 * _local2)) - vOffset);
            vScrollBar = (((_verticalScrollPolicy == ScrollPolicy.ON)) || ((((_verticalScrollPolicy == ScrollPolicy.AUTO)) && ((contentHeight > _local3)))));
            _local4 = ((width - (vScrollBar) ? _local1 : 0) - (2 * _local2));
            _local5 = (useFixedHorizontalScrolling) ? _maxHorizontalScrollPosition : (contentWidth - _local4);
            hScrollBar = (((_horizontalScrollPolicy == ScrollPolicy.ON)) || ((((_horizontalScrollPolicy == ScrollPolicy.AUTO)) && ((_local5 > 0)))));
            if (hScrollBar){
                _local3 = (_local3 - _local1);
            };
            if (((((((hScrollBar) && (!(vScrollBar)))) && ((_verticalScrollPolicy == ScrollPolicy.AUTO)))) && ((contentHeight > _local3)))){
                vScrollBar = true;
                _local4 = (_local4 - _local1);
            };
            availableHeight = (_local3 + vOffset);
            availableWidth = _local4;
        }
        public function get maxVerticalScrollPosition():Number{
            drawNow();
            return (Math.max(0, (contentHeight - availableHeight)));
        }
        public function set horizontalScrollPosition(_arg1:Number):void{
            drawNow();
            _horizontalScrollBar.scrollPosition = _arg1;
            setHorizontalScrollPosition(_horizontalScrollBar.scrollPosition, false);
        }
        public function get horizontalLineScrollSize():Number{
            return (_horizontalScrollBar.lineScrollSize);
        }
        public function set verticalPageScrollSize(_arg1:Number):void{
            _verticalPageScrollSize = _arg1;
            invalidate(InvalidationType.SIZE);
        }
        public function get verticalScrollPolicy():String{
            return (_verticalScrollPolicy);
        }
        protected function setHorizontalScrollPosition(_arg1:Number, _arg2:Boolean=false):void{
        }
        public function get useBitmapScrolling():Boolean{
            return (_useBitmpScrolling);
        }
        protected function handleScroll(_arg1:ScrollEvent):void{
            if (_arg1.target == _verticalScrollBar){
                setVerticalScrollPosition(_arg1.position);
            } else {
                setHorizontalScrollPosition(_arg1.position);
            };
        }
        public function set verticalLineScrollSize(_arg1:Number):void{
            _verticalScrollBar.lineScrollSize = _arg1;
        }
        public function get verticalScrollBar():ScrollBar{
            return (_verticalScrollBar);
        }
        protected function setVerticalScrollPosition(_arg1:Number, _arg2:Boolean=false):void{
        }
        public function set horizontalPageScrollSize(_arg1:Number):void{
            _horizontalPageScrollSize = _arg1;
            invalidate(InvalidationType.SIZE);
        }
        override protected function draw():void{
            if (isInvalid(InvalidationType.STYLES)){
                setStyles();
                drawBackground();
                if (contentPadding != getStyleValue("contentPadding")){
                    invalidate(InvalidationType.SIZE, false);
                };
            };
            if (isInvalid(InvalidationType.SIZE, InvalidationType.STATE)){
                drawLayout();
            };
            updateChildren();
            super.draw();
        }
        public function set horizontalScrollPolicy(_arg1:String):void{
            _horizontalScrollPolicy = _arg1;
            invalidate(InvalidationType.SIZE);
        }
        override protected function configUI():void{
            var _local1:Graphics;
            super.configUI();
            contentScrollRect = new Rectangle(0, 0, 85, 85);
            _verticalScrollBar = new ScrollBar();
            _verticalScrollBar.addEventListener(ScrollEvent.SCROLL, handleScroll, false, 0, true);
            _verticalScrollBar.visible = false;
            _verticalScrollBar.lineScrollSize = defaultLineScrollSize;
            addChild(_verticalScrollBar);
            copyStylesToChild(_verticalScrollBar, SCROLL_BAR_STYLES);
            _horizontalScrollBar = new ScrollBar();
            _horizontalScrollBar.direction = ScrollBarDirection.HORIZONTAL;
            _horizontalScrollBar.addEventListener(ScrollEvent.SCROLL, handleScroll, false, 0, true);
            _horizontalScrollBar.visible = false;
            _horizontalScrollBar.lineScrollSize = defaultLineScrollSize;
            addChild(_horizontalScrollBar);
            copyStylesToChild(_horizontalScrollBar, SCROLL_BAR_STYLES);
            disabledOverlay = new Shape();
            _local1 = disabledOverlay.graphics;
            _local1.beginFill(0xFFFFFF);
            _local1.drawRect(0, 0, width, height);
            _local1.endFill();
            addEventListener(MouseEvent.MOUSE_WHEEL, handleWheel, false, 0, true);
        }
        protected function calculateContentWidth():void{
        }
        public function get verticalPageScrollSize():Number{
            if (isNaN(availableHeight)){
                drawNow();
            };
            return (((((_verticalPageScrollSize == 0)) && (!(isNaN(availableHeight))))) ? availableHeight : _verticalPageScrollSize);
        }
        protected function drawLayout():void{
            calculateAvailableSize();
            calculateContentWidth();
            background.width = width;
            background.height = height;
            if (vScrollBar){
                _verticalScrollBar.visible = true;
                _verticalScrollBar.x = ((width - ScrollBar.WIDTH) - contentPadding);
                _verticalScrollBar.y = contentPadding;
                _verticalScrollBar.height = availableHeight;
            } else {
                _verticalScrollBar.visible = false;
            };
            _verticalScrollBar.setScrollProperties(availableHeight, 0, (contentHeight - availableHeight), verticalPageScrollSize);
            setVerticalScrollPosition(_verticalScrollBar.scrollPosition, false);
            if (hScrollBar){
                _horizontalScrollBar.visible = true;
                _horizontalScrollBar.x = contentPadding;
                _horizontalScrollBar.y = ((height - ScrollBar.WIDTH) - contentPadding);
                _horizontalScrollBar.width = availableWidth;
            } else {
                _horizontalScrollBar.visible = false;
            };
            _horizontalScrollBar.setScrollProperties(availableWidth, 0, (useFixedHorizontalScrolling) ? _maxHorizontalScrollPosition : (contentWidth - availableWidth), horizontalPageScrollSize);
            setHorizontalScrollPosition(_horizontalScrollBar.scrollPosition, false);
            drawDisabledOverlay();
        }
        protected function drawBackground():void{
            var _local1:DisplayObject;
            _local1 = background;
            background = getDisplayObjectInstance(getStyleValue("skin"));
            background.width = width;
            background.height = height;
            addChildAt(background, 0);
            if (((!((_local1 == null))) && (!((_local1 == background))))){
                removeChild(_local1);
            };
        }
        public function set horizontalLineScrollSize(_arg1:Number):void{
            _horizontalScrollBar.lineScrollSize = _arg1;
        }
        public function get horizontalPageScrollSize():Number{
            if (isNaN(availableWidth)){
                drawNow();
            };
            return (((((_horizontalPageScrollSize == 0)) && (!(isNaN(availableWidth))))) ? availableWidth : _horizontalPageScrollSize);
        }
        public function get maxHorizontalScrollPosition():Number{
            drawNow();
            return (Math.max(0, (contentWidth - availableWidth)));
        }
        protected function setStyles():void{
            copyStylesToChild(_verticalScrollBar, SCROLL_BAR_STYLES);
            copyStylesToChild(_horizontalScrollBar, SCROLL_BAR_STYLES);
        }
        protected function updateChildren():void{
            _verticalScrollBar.enabled = (_horizontalScrollBar.enabled = enabled);
            _verticalScrollBar.drawNow();
            _horizontalScrollBar.drawNow();
        }
        public function set verticalScrollPolicy(_arg1:String):void{
            _verticalScrollPolicy = _arg1;
            invalidate(InvalidationType.SIZE);
        }
        public function set useBitmapScrolling(_arg1:Boolean):void{
            _useBitmpScrolling = _arg1;
            invalidate(InvalidationType.STATE);
        }

    }
}//package fl.containers 
