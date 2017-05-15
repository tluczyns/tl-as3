package tl.btn {
	import flash.display.Sprite;
	import caurina.transitions.Tweener;
	
	public class BtnClose extends BtnHitWithEventsSimple {
		
		public static var TIME_MOUSE_OVER_OUT: Number = 0.3;
		
		public var cross: Sprite;
		
		public function BtnClose(cross: Sprite = null, hit: Sprite = null): void {
			this.initCross(cross);
			super(hit, true);
			this.cross.x = this.hit.width / 2;
			this.cross.y = this.hit.height / 2;
		}
		
		private function initCross(cross: Sprite): void {
			if ((this.cross == null) && (cross != null)) {
				this.addChild(cross);
				this.cross = cross;
			}
		}
		
		override public function setElementsOnOutOver(isOutOver: uint): void {
			var targetScale: Number = [1, 0.7][isOutOver];
			Tweener.addTween(this.cross, {time: BtnClose.TIME_MOUSE_OVER_OUT, scaleX: targetScale, scaleY: targetScale, rotation: [-360, 360][isOutOver], transition: "easeInOutQuad"});
		}
		
		private function removeCross(): void {
			Tweener.removeTweens(this.cross);
			this.removeChild(this.cross);
			this.cross = null;
		}
		
		override public function destroy(): void {
			this.removeCross();
			super.destroy();
		}
		
	}

}