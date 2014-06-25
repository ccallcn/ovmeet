//hong QQ:1410919373
package fl.controls.progressBarClasses {
    import fl.core.*;
    import flash.display.*;
    import flash.events.*;

    public class IndeterminateBar extends UIComponent {

        private static var defaultStyles:Object = {indeterminateSkin:"ProgressBar_indeterminateSkin"};

        protected var bar:Sprite;
        protected var barMask:Sprite;
        protected var patternBmp:BitmapData;
        protected var animationCount:uint = 0;

        public function IndeterminateBar(){
            animationCount = 0;
            super();
            setSize(0, 0);
            startAnimation();
        }
        public static function getStyleDefinition():Object{
            return (defaultStyles);
        }

        protected function drawBar():void{
            var _local1:Graphics;
            if (patternBmp == null){
                return;
            };
            _local1 = bar.graphics;
            _local1.clear();
            _local1.beginBitmapFill(patternBmp);
            _local1.drawRect(0, 0, (_width + patternBmp.width), _height);
            _local1.endFill();
        }
        protected function drawMask():void{
            var _local1:Graphics;
            _local1 = barMask.graphics;
            _local1.clear();
            _local1.beginFill(0, 0);
            _local1.drawRect(0, 0, _width, _height);
            _local1.endFill();
        }
        override public function get visible():Boolean{
            return (super.visible);
        }
        override public function set visible(_arg1:Boolean):void{
            if (_arg1){
                startAnimation();
            } else {
                stopAnimation();
            };
            super.visible = _arg1;
        }
        protected function startAnimation():void{
            addEventListener(Event.ENTER_FRAME, handleEnterFrame, false, 0, true);
        }
        override protected function draw():void{
            if (isInvalid(InvalidationType.STYLES)){
                drawPattern();
                invalidate(InvalidationType.SIZE, false);
            };
            if (isInvalid(InvalidationType.SIZE)){
                drawBar();
                drawMask();
            };
            super.draw();
        }
        override protected function configUI():void{
            bar = new Sprite();
            addChild(bar);
            barMask = new Sprite();
            addChild(barMask);
            bar.mask = barMask;
        }
        protected function stopAnimation():void{
            removeEventListener(Event.ENTER_FRAME, handleEnterFrame);
        }
        protected function drawPattern():void{
            var _local1:DisplayObject;
            _local1 = getDisplayObjectInstance(getStyleValue("indeterminateSkin"));
            if (patternBmp){
                patternBmp.dispose();
            };
            patternBmp = new BitmapData((_local1.width << 0), (_local1.height << 0), true, 0);
            patternBmp.draw(_local1);
        }
        protected function handleEnterFrame(_arg1:Event):void{
            if (patternBmp == null){
                return;
            };
            animationCount = ((animationCount + 2) % patternBmp.width);
            bar.x = -(animationCount);
        }

    }
}//package fl.controls.progressBarClasses 
