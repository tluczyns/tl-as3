package tl.ui {
	import tl.types.Singleton;
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.events.Event;
	
	//based on com.senocular.utils.Key
	public class Key extends Singleton {
		
		static private var stage: Stage;
		static private var arrKeyDown: Array;
		
		static public function construct(stage: Stage): void {
			if ((stage != null) && (Key.stage == null)) {
				Key.stage = stage;
				Key.arrKeyDown = [];
				Key.stage.addEventListener(KeyboardEvent.KEY_DOWN, Key.onKeyDown);
				Key.stage.addEventListener(KeyboardEvent.KEY_UP, Key.onKeyUp);
				Key.stage.addEventListener(Event.DEACTIVATE, Key.removeKeys);
			}
		}
		
		static private function removeKeys(e: Event): void {
			Key.arrKeyDown = [];
		}
		
		static private function onKeyDown(e: KeyboardEvent): void {
			if (Key.arrKeyDown.indexOf(e.keyCode) == -1)
				Key.arrKeyDown.push(e.keyCode)
		}
		
		static private function onKeyUp(e: KeyboardEvent): void {
			var indexOfKeyCode: uint = Key.arrKeyDown.indexOf(e.keyCode);
			if (indexOfKeyCode > -1)
				Key.arrKeyDown.splice(indexOfKeyCode, 1);
		}
		
		static public function isDown(keyCode: uint): Boolean {
			return Boolean(Key.arrKeyDown.indexOf(keyCode) > -1);
		}
		
		static public function getLastDown(arrKeyCode: Array): int {
			var maxIndexOfKeyCode: int = -1
			for (var i: uint = 0; i < arrKeyCode.length; i++) {
				maxIndexOfKeyCode = Math.max(maxIndexOfKeyCode, Key.arrKeyDown.indexOf(arrKeyCode[i]));
			}
			if (maxIndexOfKeyCode > -1) return Key.arrKeyDown[maxIndexOfKeyCode];
			else return -1;
		}
		
		
		static public function destroy():void {
			if (Key.stage) {
				Key.stage.removeEventListener(Event.DEACTIVATE, Key.removeKeys);
				Key.stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
				Key.stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
				Key.stage = null;
				Key.arrKeyDown = null;
			}
		}
		
	}

}