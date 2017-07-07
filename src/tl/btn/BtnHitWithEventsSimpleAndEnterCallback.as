package tl.btn {
	import tl.utils.FunctionCallback;
	import flash.display.Sprite;
	import flash.events.Event;
	import tl.ui.Key;
	import flash.ui.Keyboard;
	
	public class BtnHitWithEventsSimpleAndEnterCallback extends BtnHitWithEventsSimple {
		
		private var callbackDownEnter: FunctionCallback;
			
		public function BtnHitWithEventsSimpleAndEnterCallback(hit: Sprite = null, isEnabled: Boolean = true): void {
			super(hit, isEnabled);
			this.addEventListener(Event.ADDED_TO_STAGE, this.createCallbackKeyDown);
		}
		
		private function createCallbackKeyDown(e: Event): void {
			this.removeEventListener(Event.ADDED_TO_STAGE, this.createCallbackKeyDown);
			Key.construct(this.stage);
			this.callbackDownEnter = new FunctionCallback(this.onKeyDownEnter, this, [Keyboard.ENTER]);
			Key.addCallbackKeyDown(this.callbackDownEnter);
		}
		
		private function onKeyDownEnter(keyCode: uint): void {
			this.dispatchEvent(new EventBtnHit(EventBtnHit.CLICKED));
		}
		
		override public function destroy(): void {
			Key.removeCallbackKeyDown(this.callbackDownEnter);
			super.destroy();
		}
		
	}

}