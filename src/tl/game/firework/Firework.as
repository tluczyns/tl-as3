package tl.game.firework {
	import flash.display.Sprite;
	import tl.loader.SoundExt;
	import flash.events.Event;
	import flash.geom.ColorTransform;
	import tl.types.DspObjUtils;
	import tl.loader.Library;
	
	public class Firework extends Sprite {
		
		private var countPoints: uint;
		private var speed: Number;
		private var gravity: Number;
		private var range: Number;
		private var soundFirework: SoundExt;
		private var vecLine: Vector.<LineFirework>;	
		private var vecPoint: Vector.<PointFirework>;
		
		public function Firework(params: Object): void {
			this.copyParameters(params);
			this.createSoundFirework(params.nameSoundFirework);
			this.setColor();
			this.createPoints();
			this.addEventListener(Event.ENTER_FRAME, this.onEnterFrame);
		}
		
		protected function getHSL(): Object {
			var h: Number, s: Number, l: Number;
			h = 204; //0 to 360
			s = 0.8 + Math.random() * 0.2; //0 to 1
			if (Math.random() > 0.5) l = 0.9 + Math.random() * 0.1;
			else l = 0.4 + Math.random() * 0.2
			//0 to 1
			return {h: h, s: s, l: l}
		}
		
		private function setColor(): void {
			var colorTransform: ColorTransform = new ColorTransform();
			var objRGB: Object = DspObjUtils.getRGB(this.getHSL());
			colorTransform.color = objRGB.r << 16 | objRGB.g << 8 | objRGB.b;
			this.transform.colorTransform = colorTransform;
		}
		
		private function copyParameters(params: Object): void {
			this.x = params.x;
			this.y = params.y;
			this.countPoints = params.countPoints;
			this.speed = params.speed;
			this.gravity = params.gravity;
			this.range = params.range;
		}
		
		private function createSoundFirework(nameSoundFirework: String): void {
			if (nameSoundFirework) {
				this.soundFirework = Library.getMovieClip(nameSoundFirework);
				this.soundFirework.initVolume = 0.5;
				this.soundFirework.playExt();
			}
		}
		
		private function removeSoundFirework(): void {
			if (this.soundFirework) {
				this.soundFirework.destroy();
				this.soundFirework = null;
			}
		}

		protected function get classPoint(): Class {
			return PointFirework;
		}
		
		private function createPoints(): void {
			this.vecPoint = new Vector.<PointFirework>(this.countPoints);
			this.vecLine = new Vector.<LineFirework>();
			for (var i: uint = 0; i < this.countPoints; i++) {
				var point: PointFirework = new this.classPoint(this, i, this.speed, this.gravity, this.range);
				this.addChild(point);
				this.vecPoint[i] = point;
			}
		}
		
		internal function removePoint(i: uint): void {
			var point: PointFirework = this.vecPoint[i];
			this.removeChild(point);
			point.destroy();
			point = this.vecPoint[i] = null;
			this.countPoints--;
		}
		
		private function removePoints(): void {
			for (var i: uint = 0; i < this.vecPoint.length; i++) {
				var point: PointFirework = this.vecPoint[i];
				if (point) {
					this.removeChild(point);
					point.destroy();
					point = null;
				}
			}
			this.vecPoint = null;
		}
		
		protected function get classLine(): Class {
			return LineFirework;
		}
		
		internal function createLine(): LineFirework {
			var line: LineFirework = new this.classLine(this, this.vecLine.length);
			this.addChild(line);
			this.vecLine.push(line);
			return line;
		}
		
		internal function removeLine(i: uint): void {
			var line: LineFirework = this.vecLine[i];
			this.removeChild(line);
			line.destroy();
			line = this.vecLine[i] = null;
			
		}
		
		private function removeLines(): void {
			for (var i: uint = 0; i < this.vecLine.length; i++) {
				var line: LineFirework = this.vecLine[i];
				if (line) {
					this.removeChild(line);
					line.destroy();
					line = this.vecLine[i] = null;
				}
			}
			this.vecLine = null;
		}
		
		private function onEnterFrame(e: Event): void {
			if (this.countPoints <= 0) {
				this.destroy();
			}
		}
		
		public function destroy(): void {
			this.removeEventListener(Event.ENTER_FRAME, this.onEnterFrame);
			this.removePoints();
			this.removeLines();
			this.removeSoundFirework();
			this.parent.removeChild(this);
			delete this;
		}
		
	}
	
}