package tl.game.firework {
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class LineFirework extends Sprite {
		
		private var classFirework: Firework;
		private var ind: uint;
		
		public function LineFirework(classFirework: Firework, ind: uint): void {
			this.classFirework = classFirework;
			this.ind = ind;
			this.draw();
			this.addEventListener(Event.ENTER_FRAME, this.onEnterFrame);
		}
		
		protected function draw(): void {
			this.graphics.lineStyle(3, 0xB3B3B3, 1);
			this.graphics.moveTo(0, 0);
			this.graphics.lineTo(10, 10);
		}
		
		private function onEnterFrame(e: Event): void {
			this.alpha -= (0.1 + Math.random() * 0.1);
			if (this.alpha <= 0) this.classFirework.removeLine(this.ind);
		}
		
		public function destroy(): void {
			this.removeEventListener(Event.ENTER_FRAME, this.onEnterFrame);
		}
		
	}

}