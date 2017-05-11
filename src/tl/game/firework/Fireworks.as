package tl.game.firework {
	import flash.display.Sprite;
	import com.greensock.TweenMax;

	public class Fireworks extends Sprite {
		
		private var _width: Number = 400;
		private var _height: Number = 200;
		public var objMargin: Object = {top : 20, left: 70, bottom: 250, right: 70};
		private var _x: Number, _y: Number;
		private var baseCountPoints: Number = 60;
		private var toleranceCountPoints: Number = 20;
		private var countPoints: Number;
		private var baseSpeed: Number = 10;
		private var toleranceSpeed: Number = 2;
		private var speed: Number;
		private var maxGravity: Number = 5;
		private var toleranceGravity: Number = 2;
		private var gravity: Number;
		private var maxRange: Number = 130;
		private var toleranceRange: Number = 30;
		private var range: Number;
		private var timeWhenFireworkOccur:Number = 0.5;
		private var nameSoundFirework: String;
		
		private var tweenAddFirework: TweenMax;
		
		public function Fireworks(params: Object = null): void {
			params = params || {};
			this._width = params.width || this._width;
			this._height = params.height || this._height;
			this.objMargin = params.objMargin || this.objMargin;
			this.baseCountPoints = params.baseCountPoints || this.baseCountPoints;
			this.toleranceCountPoints = params.toleranceCountPoints || this.toleranceCountPoints;
			this.baseSpeed = params.baseSpeed || this.baseSpeed;
			this.toleranceSpeed = params.toleranceSpeed || this.toleranceSpeed;
			this.maxGravity = params.maxGravity || this.maxGravity;
			this.toleranceGravity = params.toleranceGravity || this.toleranceGravity;
			this.maxRange = params.maxRange || this.maxRange;
			this.toleranceRange = params.toleranceRange || this.toleranceRange;
			this.timeWhenFireworkOccur = params.timeWhenFireworkOccur || this.timeWhenFireworkOccur;
			this.nameSoundFirework = params.nameSoundFirework || this.nameSoundFirework;
		}

		public function start(): void {
			this.tweenAddFirework = new TweenMax(this, this.timeWhenFireworkOccur, {onStart: this.addFirework, onRepeat: this.addFirework, yoyo: true, repeat: -1});
		}
		
		public function stop(): void  {
			if (this.tweenAddFirework) {
				this.tweenAddFirework.kill();
				this.tweenAddFirework = null;
			}
		}
		
		protected function get classFirework(): Class {
			return Firework;
		}
		
		private function addFirework(): void {
			var firework: Firework = new this.classFirework(this.getFireworkParameters())
			this.addChild(firework);
		}
		
		private function getFireworkParameters(): Object {
			this._x = objMargin.left + Math.random() * (this._width - objMargin.left - objMargin.right);
			this._y = objMargin.top + Math.random() * (this._height - objMargin.top - objMargin.bottom);
			this.countPoints = this.baseCountPoints - this.toleranceCountPoints + Math.random() * (this.toleranceCountPoints * 2)
			this.speed = this.baseSpeed - this.toleranceSpeed + Math.random() * (this.toleranceSpeed * 2);
			this.gravity = Math.max(this.maxGravity - this.toleranceGravity + Math.random() * (this.toleranceGravity * 2), 0);
			this.range = Math.max(this.maxRange - this.toleranceRange + Math.random() * (this.toleranceRange * 2), 30);
			return {classFireworks: this, x: this._x, y: this._y, countPoints: this.countPoints, speed: this.speed, gravity: this.gravity, range: this.range, nameSoundFirework: this.nameSoundFirework};
		}
		
		public function destroy(): void {
			this.stop();
		}
		
	}
	
}