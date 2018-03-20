package tl.btn {
	import com.greensock.TweenMax;
	import flash.display.Sprite;

	public class BtnHitWithEvents extends BtnHitWithEventsSimple implements IBtnWithEvents {
		
		public var vecTweenMouseOutOver: Vector.<TweenMax>;
		
		public function BtnHitWithEvents(hit: Sprite = null, isEnabled: Boolean = true, isConstruct: Boolean = true): void {
			this.vecTweenMouseOutOver = this.createVecTweenMouseOutOver();
			this.pauseVecTweenMouseOutOver();
			super(hit, isEnabled, isConstruct);
		}
		
		protected function createVecTweenMouseOutOver(): Vector.<TweenMax> {
			//throw new Error("no effect on btn over/out? come on!");
			return new <TweenMax>[];
		}
		
		private function pauseVecTweenMouseOutOver(): void {
			var isPausedVecTweenMouseOutOver: Boolean = this.isPausedVecTweenMouseOutOver;
			for (var i: uint = 0; i < this.vecTweenMouseOutOver.length; i++) {
				var tweenMouseOutOver: TweenMax = this.vecTweenMouseOutOver[i];
				tweenMouseOutOver.paused(isPausedVecTweenMouseOutOver);
			}
		}
		
		protected function get isPausedVecTweenMouseOutOver(): Boolean {
			return true;
		}
		
		private function removeVecTweenMouseOutOver(): void {
			for (var i: uint = 0; i < this.vecTweenMouseOutOver.length; i++) {
				var tweenMouseOutOver: TweenMax = this.vecTweenMouseOutOver[i];
				tweenMouseOutOver.kill();
				tweenMouseOutOver = null;
			}
			this.vecTweenMouseOutOver = new <TweenMax>[];
		}
		
		override public function setElementsOnOutOver(isOutOver: uint): void {
			if (this.vecTweenMouseOutOver) {
				for (var i: uint = 0; i < this.vecTweenMouseOutOver.length; i++) {
					var tweenMouseOutOver: TweenMax = this.vecTweenMouseOutOver[i];
					tweenMouseOutOver[["reverse", "play"][isOutOver]]();
				}
			}
		}
		
		override public function destroy(): void {
			this.removeVecTweenMouseOutOver();
			super.destroy()
		}
		
	}

}