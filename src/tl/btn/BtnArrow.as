package tl.btn {
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import com.greensock.core.Animation;
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	
	public class BtnArrow extends BtnHitWithEvents {
		
		public var isPrevNext: uint;
		private var isMoveXOrY: uint;
		protected var moveXYArrow: Number;
		protected var timeAnimArrow: Number;
		private var posXYInitArrow: Number;
		
		public var arrow: DisplayObject;
		
		public function BtnArrow(isPrevNext: uint, isMoveXOrY: uint = 0, arrow: DisplayObject = null, moveXYArrow: Number = 3, timeAnimArrow: Number = 5, hit: Sprite = null): void {
			this.isPrevNext = isPrevNext;
			this.isMoveXOrY = isMoveXOrY;
			this.moveXYArrow = moveXYArrow;
			this.timeAnimArrow = timeAnimArrow;
			this.initArrow(arrow);
			super(hit);
		}
		
		override public function createGenericHit(rectDimension: Rectangle = null): Sprite {
			var hit: Sprite = new Sprite();
			hit.graphics.beginFill(0xffffff, 0);
			hit.graphics.drawRect(- [this.moveXYArrow, 0][this.isMoveXOrY], - [0, this.moveXYArrow][this.isMoveXOrY], this.posXYInitArrow + this.arrow.width + [this.moveXYArrow * 2, 0][this.isMoveXOrY], this.posXYInitArrow + this.arrow.height + [0, this.moveXYArrow * 2][this.isMoveXOrY]);
			hit.graphics.endFill();
			return hit;
		}
		
		private function initArrow(arrow: DisplayObject = null): void {
			if ((this.arrow == null) && (arrow != null)) {
				this.arrow = arrow;
				this.addChild(this.arrow);
			}
			this.posXYInitArrow = this.arrow[["x", "y"][this.isMoveXOrY]];
			this.arrow[["x", "y"][this.isMoveXOrY]] = this.posXYInitArrow;
			if (this.isPrevNext == 0) this.arrow[["scaleX", "scaleY"][this.isMoveXOrY]] = -1;
		}
		
		protected function deleteArrow(): void {
			TweenMax.killTweensOf(this.arrow);
			this.removeChild(this.arrow);
			this.arrow = null;
		}
		
		override protected function setElementsIsEnabled(isDisabledEnabled: uint): void {
			TweenMax.killTweensOf(this);
			TweenMax.to(this, 0.3, {alpha: [0.3, 1][isDisabledEnabled], ease: Linear.easeNone});
		}
		
		override protected function createTweenMouseOutOver(): Animation {
			var objTween: Object = {ease: Cubic.easeOut, onComplete: this.animArrow};
			objTween[["x", "y"][this.isMoveXOrY]] = this.posXYInitArrow + this.moveXYArrow;
			return new TweenMax(this.arrow, this.timeAnimArrow, objTween);
		}
		
		override public function setElementsOnOutOver(isOutOver: uint): void {
			if (isOutOver == 0) TweenMax.killTweensOf(this.arrow);
			super.setElementsOnOutOver(isOutOver);
		}
		
		private function animArrow(): void {
			var objTween: Object = {useFrames: uint(this.timeAnimArrow >= 1), ease: Sine.easeIn, yoyo: true, repeat: -1};
			objTween[["x", "y"][this.isMoveXOrY]] = this.posXYInitArrow - this.moveXYArrow;
			TweenMax.to(this.arrow, this.timeAnimArrow, objTween);
		}
		
		override public function destroy(): void {
			this.deleteArrow();
			super.destroy();
		}
		
	}

}