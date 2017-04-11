package tl.videoPlayer {
	import flash.display.Sprite;

	public class ControllerSoundBar extends Sprite {
		
		public var sideTop: Sprite;
		public var center: Sprite;
		public var sideBottom: Sprite;
		
		public function ControllerSoundBar(): void {}
		
		override public function set height(value: Number): void {
			this.center.height = value - this.sideTop.height - this.sideBottom.height;
			this.sideBottom.y = this.center.y + this.center.height + this.sideBottom.height;
		}
		
	}
	
}