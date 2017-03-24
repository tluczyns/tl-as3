package tl.btn {
	import flash.display.Sprite;
	import com.greensock.TweenMax;

	public class BtnHitWithEvents extends BtnHit implements IBtnWithEvents {
		
		private var vecTweenMouseOutOver: Vector.<TweenMax>;
		
		public function BtnHitWithEvents(hit: Sprite = null): void {
			this.vecTweenMouseOutOver = this.createVecTweenMouseOutOver();
			this.addBtnHitEvents();
			super(hit);
		}
		
		protected function createVecTweenMouseOutOver(): Vector.<TweenMax> {
			//throw new Error("no effect on btn over/out? come on!");
			return new <TweenMax>[];
		}
		
		private function removeVecTweenMouseOutOver(): void {
			for (var i: uint = 0; i < this.vecTweenMouseOutOver.length; i++) {
				var tweenMouseOutOver: TweenMax = this.vecTweenMouseOutOver[i];
				tweenMouseOutOver.kill();
				tweenMouseOutOver = null;
			}
			this.vecTweenMouseOutOver = new <TweenMax>[];
		}
		
		public function addBtnHitEvents(): void {
			this.addEventListener(EventBtnHit.OVER, this.onOver);
			this.addEventListener(EventBtnHit.OUT, this.onOut);
			this.addEventListener(EventBtnHit.CLICKED, this.onClicked);
		}
		
		public function removeBtnHitEvents(): void {
			this.removeEventListener(EventBtnHit.CLICKED, this.onClicked);
			this.removeEventListener(EventBtnHit.OUT, this.onOut);
			this.removeEventListener(EventBtnHit.OVER, this.onOver);
		}

		public function setElementsOnOutOver(isOutOver: uint): void {
			if (this.vecTweenMouseOutOver) {
				for (var i: uint = 0; i < this.vecTweenMouseOutOver.length; i++) {
					var tweenMouseOutOver: TweenMax = this.vecTweenMouseOutOver[i];
					tweenMouseOutOver[["reverse", "play"][isOutOver]]();
				}
			}
		}
		
		private function onOver(event: EventBtnHit): void {
			this.setElementsOnOutOver(1);
		}
		
		private function onOut(event: EventBtnHit): void {
			this.setElementsOnOutOver(0);
		}
		
		protected function onClicked(e: EventBtnHit): void {
			//throw new Error("onClicked must be implemented");
		}
		
		override public function destroy(): void {
			this.removeBtnHitEvents();
			this.removeVecTweenMouseOutOver();
			super.destroy()
		}
		
	}

}