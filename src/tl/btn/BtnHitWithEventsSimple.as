package tl.btn {
	import flash.display.Sprite;

	public class BtnHitWithEventsSimple extends BtnHit implements IBtnWithEvents {
		
		public function BtnHitWithEventsSimple(hit: Sprite = null): void {
			this.addBtnHitEvents();
			super(hit);
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

		private function onOver(event: EventBtnHit): void {
			this.setElementsOnOutOver(1);
		}
		
		private function onOut(event: EventBtnHit): void {
			this.setElementsOnOutOver(0);
		}
		
		public function setElementsOnOutOver(isOutOver: uint): void {
			//throw new Error("setElementsOnOutOver must be implemented");
		}
		
		protected function onClicked(e: EventBtnHit): void {
			//throw new Error("onClicked must be implemented");
		}
		
		override public function destroy(): void {
			this.removeBtnHitEvents();
			super.destroy()
		}
		
	}

}