package tl.btn {
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
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
			this.posXYInitArrow = this.arrow[["x", "y"][this.isMoveXOrY]];
			if (this.isPrevNext == 0)
				this.arrow[["scaleX", "scaleY"][this.isMoveXOrY]] = -1;
			super(hit);
		}
		
		override public function createGenericHit(rectDimension: Rectangle = null): Sprite {
			var hit: Sprite = new Sprite();
			hit.graphics.beginFill(0xffffff, 0);
			hit.graphics.drawRect(0, 0, this.arrow.width + [this.posXYInitArrow + this.moveXYArrow, 0][this.isMoveXOrY], this.arrow.y + this.arrow.height + [0, this.posXYInitArrow + this.moveXYArrow][this.isMoveXOrY]);
			hit.graphics.endFill();
			return hit;
		}
		
		private function initArrow(arrow: DisplayObject = null): void {
			if ((this.arrow == null) && (arrow != null)) {
				this.addChild(arrow);
				this.arrow = arrow;
			}
		}
		
		private function removeArrow(): void {
			TweenMax.killTweensOf(this.arrow);
			this.removeChild(this.arrow);
			this.arrow = null;
		}
		
		override protected function createVecTweenMouseOutOver(): Vector.<TweenMax> {
			var objTweenFrom: Object = {useFrames: (this.timeAnimArrow >= 1), immediateRender: true}
			objTweenFrom[["x", "y"][this.isMoveXOrY]] = this.posXYInitArrow + [this.arrow[["width", "height"][this.isMoveXOrY]] + this.moveXYArrow, 0][this.isPrevNext];
			var objTweenTo: Object = {ease: Cubic.easeOut, onComplete: this.animArrow};
			objTweenTo[["x", "y"][this.isMoveXOrY]] = objTweenFrom[["x", "y"][this.isMoveXOrY]] + this.moveXYArrow;
			return new <TweenMax>[TweenMax.fromTo(this.arrow, this.timeAnimArrow, objTweenFrom, objTweenTo)];
		}
		
		override public function setElementsOnOutOver(isOutOver: uint): void {
			if (isOutOver == 0) TweenMax.killTweensOf(this.arrow);
			super.setElementsOnOutOver(isOutOver);
		}
		
		private function animArrow(): void {
			var objTween: Object = {useFrames: uint(this.timeAnimArrow >= 1), ease: Sine.easeIn, yoyo: true, repeat: -1};
			objTween[["x", "y"][this.isMoveXOrY]] = this.posXYInitArrow - this.moveXYArrow + [this.arrow[["width", "height"][this.isMoveXOrY]], 0][this.isPrevNext];
			TweenMax.to(this.arrow, this.timeAnimArrow, objTween);
		}
		
		override public function destroy(): void {
			this.removeArrow();
			super.destroy();
		}
		
	}

}