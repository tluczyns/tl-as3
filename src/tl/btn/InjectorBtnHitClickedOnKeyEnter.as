package tl.btn {
	import tl.utils.FunctionCallback;
	import tl.ui.Key;
	import flash.ui.Keyboard;
	
	public class InjectorBtnHitClickedOnKeyEnter {
		
		private var target: BtnHit;
		private var callbackDownEnter: FunctionCallback;
		
		public function InjectorBtnHitClickedOnKeyEnter(target: BtnHit) {
			this.target = target;
			Key.construct(target.stage);
			this.callbackDownEnter = new FunctionCallback(this.onKeyDownEnter, this, [Keyboard.ENTER]);
			Key.addCallbackKeyDown(this.callbackDownEnter);
		}
		
		private function onKeyDownEnter(keyCode: uint): void {
			this.target.dispatchEvent(new EventBtnHit(EventBtnHit.CLICKED));
		}
		
		public function destroy(): void {
			Key.removeCallbackKeyDown(this.callbackDownEnter);
			this.target = null;
		}

		
	}

}