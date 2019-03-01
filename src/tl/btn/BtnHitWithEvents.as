package tl.btn {
	import com.greensock.core.Animation;
	import flash.display.Sprite;

	public class BtnHitWithEvents extends BtnHitWithEventsSimple implements IBtnWithEvents {
		
		public var tweenMouseOutOver: Animation;
		
		public function BtnHitWithEvents(hit: Sprite = null, isEnabled: Boolean = true, isConstruct: Boolean = true): void {
			this.tweenMouseOutOver = this.createTweenMouseOutOver();
			this.pauseTweenMouseOutOver();
			super(hit, isEnabled, isConstruct);
		}
		
		protected function createTweenMouseOutOver(): Animation {
			//throw new Error("no effect on btn over/out? come on!");
			return null;
		}
		
		private function pauseTweenMouseOutOver(): void {
			if (this.tweenMouseOutOver) {
				this.tweenMouseOutOver.paused(this.isPausedTweenMouseOutOver);
				if (this.isPausedTweenMouseOutOver) this.tweenMouseOutOver.pause(0);
				else this.tweenMouseOutOver.resume(0);
			}
		}
		
		protected function get isPausedTweenMouseOutOver(): Boolean {
			return true;
		}
		
		private function deleteTweenMouseOutOver(): void {
			if (this.tweenMouseOutOver) {
				this.tweenMouseOutOver.kill();
				this.tweenMouseOutOver = null;
			}
		}
		
		override public function setElementsOnOutOver(isOutOver: uint): void {
			if (this.tweenMouseOutOver)
				this.tweenMouseOutOver[["reverse", "play"][isOutOver]]();
}
		
		override public function destroy(): void {
			this.deleteTweenMouseOutOver();
			super.destroy()
		}
		
	}

}