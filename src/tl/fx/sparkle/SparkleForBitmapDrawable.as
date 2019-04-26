package tl.fx.sparkle {
	import flash.display.Sprite;
	import flash.display.IBitmapDrawable;
	import flash.display.Shape;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import tl.bitmap.BitmapUtils;
	import flash.geom.Matrix;
	import flash.display.GradientType;
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	
	public class SparkleForBitmapDrawable extends Sprite {
		
		private var bmpDrawableForSparkle: IBitmapDrawable;
		private var shpGradientSparkle: Shape;
		private var bmpMaskForSparkle: Bitmap;
		
		public function SparkleForBitmapDrawable(bmpDrawableForSparkle: IBitmapDrawable, dimensionGradient: Number, rotationGradient: Number = 30, color: uint = 0xFFFFFF): void {
			this.bmpDrawableForSparkle = bmpDrawableForSparkle;
			
			var bmpDataMask: BitmapData = BitmapUtils.checkAndDrawBitmapDrawableToBitmapData(bmpDrawableForSparkle);
			this.bmpMaskForSparkle = new Bitmap(bmpDataMask, "auto", true);
			this.addChild(this.bmpMaskForSparkle)
			
			var xLeftEdgeCenterGradientBox: Number = dimensionGradient / 2 - Math.cos(rotationGradient) * (dimensionGradient / 2);
			var yLeftEdgeCenterGradientBox: Number = dimensionGradient / 2 - Math.sin(rotationGradient) * (dimensionGradient / 2);
			var xLeftBottomGradientBox: Number = Math.tan(rotationGradient) * (bmpDataMask.height - yLeftEdgeCenterGradientBox);
			var txGradientBox: Number = xLeftBottomGradientBox - xLeftEdgeCenterGradientBox;
			var widthGradient: Number = dimensionGradient / Math.cos(rotationGradient) + Math.tan(rotationGradient) * bmpDataMask.height;
			var mrxGradient: Matrix = new Matrix();
			mrxGradient.createGradientBox(dimensionGradient, dimensionGradient, rotationGradient, txGradientBox);
			this.shpGradientSparkle = new Shape();
			this.shpGradientSparkle.graphics.beginGradientFill(GradientType.LINEAR, [color, color, color], [0, 1, 0], [0, 127, 255], mrxGradient);
			//this.shpGradientSparkle.graphics.beginGradientFill(GradientType.LINEAR, [color, color, color, color, color], [0.2, 0.5, 1, 0.5, 0.2], [0, 1, 127, 254, 255], mrxGradient);
			this.shpGradientSparkle.graphics.drawRect(0, 0, widthGradient, bmpDataMask.height);
			this.shpGradientSparkle.graphics.endFill();
			this.addChild(this.shpGradientSparkle);
			
			this.bmpMaskForSparkle.cacheAsBitmap = true;
			this.shpGradientSparkle.cacheAsBitmap = true;
			this.shpGradientSparkle.mask = this.bmpMaskForSparkle;
			this.shpGradientSparkle.x = - this.shpGradientSparkle.width;
			
			this.alignToDspObject();
		}
		
		public function alignToDspObject(): void {
			if (this.bmpDrawableForSparkle is DisplayObject) {	
				var dspObjForSparkle: DisplayObject = DisplayObject(this.bmpDrawableForSparkle);
				var rectDspObjForSparkle: Rectangle = dspObjForSparkle.getBounds(dspObjForSparkle);
				this.x = rectDspObjForSparkle.x;
				this.y = rectDspObjForSparkle.y;
				if ((dspObjForSparkle.parent) && (!dspObjForSparkle.parent.contains(this))) dspObjForSparkle.parent.addChild(this);
			}
		}
		
		public function anim(isRepeat: Boolean, time: Number = 1, startDelay: Number = 0, repeatDelay: Number = 0): void {
			if (!isRepeat) this.shpGradientSparkle.x = - this.shpGradientSparkle.width;
			TweenMax.to(this.shpGradientSparkle, time, {x: this.bmpMaskForSparkle.width, ease: Linear.easeNone, repeat: [0, -1][uint(isRepeat)], repeatDelay: repeatDelay, delay: startDelay});
		}
		
		public function pauseResume(isPauseResume: uint): void {
			TweenMax(TweenMax.getTweensOf(this.shpGradientSparkle)[0]).paused(Boolean(1 - isPauseResume));
		}
		
		public function destroy(): void {
			TweenMax.killTweensOf(this.shpGradientSparkle);
			this.shpGradientSparkle.mask = null;
			this.removeChild(this.bmpMaskForSparkle);
			bmpMaskForSparkle.bitmapData.dispose();
			bmpMaskForSparkle = null;
			this.removeChild(this.shpGradientSparkle);
			this.shpGradientSparkle = null;
			if (this.bmpDrawableForSparkle is DisplayObject) {	
				var dspObjForSparkle: DisplayObject = DisplayObject(this.bmpDrawableForSparkle);
				if ((dspObjForSparkle.parent) && (dspObjForSparkle.parent.contains(this))) dspObjForSparkle.parent.removeChild(this);
			}
		}
		
	}

}