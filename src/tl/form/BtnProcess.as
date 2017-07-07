package tl.form {
	import flash.display.Sprite;
	import tl.btn.BtnHitWithEventsSimpleAndEnterCallback;
	
	
	public class BtnProcess extends BtnHitWithEventsSimpleAndEnterCallback {
		
		public function BtnProcess(hit: Sprite = null, isEnabled: Boolean = true): void {
			super(hit, isEnabled);
		}
		
	}

}