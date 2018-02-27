package tl.btn {
	import flash.display.Sprite;

	public class BtnHitWithEventsSimple extends BtnHit implements IBtnWithEvents {
		
		public var isOutOver: uint;
		
		public function BtnHitWithEventsSimple(hit: Sprite = null, isEnabled: Boolean = true, isConstruct: Boolean = true): void {
			this.addBtnHitEvents();
			super(hit, isEnabled, isConstruct);
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
			this.isOutOver = 1;
			this.setElementsOnOutOver(1);
		}
		
		private function onOut(event: EventBtnHit): void {
			this.isOutOver = 0;
			this.setElementsOnOutOver(0);
		}
		
		public function setElementsOnOutOver(isOutOver: uint): void {
			for (var i: uint = 0; i < this.vecInjector.length; i++) {
				var injector: InjectorBtnHit = this.vecInjector[i];
				if (injector is InjectorBtnHitWithEvents) InjectorBtnHitWithEvents(injector).setElementsOnOutOver(this, isOutOver);
			}
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