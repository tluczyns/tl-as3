package tl.game.firework {
	import flash.display.Sprite;
	import flash.events.Event;

	public class PointFirework extends Sprite {
		
		private var classFirework: Firework;
		private var ind: Number;
		private var speed: Number;
		private var gravity: Number;
		private var range: Number;
		private var finalX: Number, finalY: Number;
		private var numLine: uint, countLines: uint;

		public function PointFirework(classFirework: Firework, ind: Number, speed: Number, gravity: Number, range: Number): void {
			this.classFirework = classFirework;
			this.ind = ind;
			this.speed = speed;
			this.gravity = gravity;
			this.range = range;
			this.finalX = -this.range + Math.random() * (this.range * 2);
			this.finalY = -this.range + Math.random() * (this.range * 2);
			this.numLine = 0;
			this.countLines = 100;
			this.draw();
			this.addEventListener(Event.ENTER_FRAME, this.onEnterFrame);
		}
		
		protected function draw(): void {
			this.graphics.beginFill(0xffffff, 1);
			this.graphics.drawCircle(0, 0, 2);
			this.graphics.endFill();
		}

		private function onEnterFrame(e: Event): void {
			var diffX:Number = (this.finalX - this.x) / this.speed;
			var diffY:Number = (this.finalY - this.y) / this.speed;
			this.finalY += this.gravity;
			if ((this.numLine < this.countLines) && (this.alpha > 0.2)) {
				var line: LineFirework = this.classFirework.createLine();
				line.x = this.x;
				line.y = this.y;
				line.scaleX = diffX / 10;
				line.scaleY = diffY / 10;
				this.numLine++;
			}
			this.x += diffX;
			this.y += diffY;
			this.alpha -= 0.03;
			if (Math.abs(diffX) <= 0.5) {
				this.destroy();
				this.classFirework.removePoint(this.ind);
			}
		}
		
		public function destroy(): void {
			this.removeEventListener(Event.ENTER_FRAME, this.onEnterFrame);
		}

	}

}