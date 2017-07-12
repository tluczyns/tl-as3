package tl.ui {
	import tl.types.Singleton;
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.events.Event;
	import tl.utils.FunctionCallback;
	
	//based on com.senocular.utils.Key
	public class Key extends Singleton {
		
		static private var stage: Stage;
		static private var arrKeyDown: Array;
		static private var vecCallbackKeyDown: Vector.<FunctionCallback>;
		static private var vecCallbackKeyUp: Vector.<FunctionCallback>;
		
		static public function construct(stage: Stage): void {
			if ((stage != null) && (Key.stage == null)) {
				Key.stage = stage;
				Key.arrKeyDown = [];
				Key.vecCallbackKeyDown = new Vector.<FunctionCallback>();
				Key.vecCallbackKeyUp = new Vector.<FunctionCallback>();
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
			Key.callbackOnKeyDownUp(0, e.keyCode);
		}
		
		static private function onKeyUp(e: KeyboardEvent): void {
			var indexOfKeyCode: uint = Key.arrKeyDown.indexOf(e.keyCode);
			if (indexOfKeyCode > -1)
				Key.arrKeyDown.splice(indexOfKeyCode, 1);
			Key.callbackOnKeyDownUp(1, e.keyCode);
		}
		
		static private function callbackOnKeyDownUp(isDownUp: uint, keyCode: uint): void {
			var vecCallbackKeyDownUp: Vector.<FunctionCallback> = Key["vecCallbackKey" + ["Down", "Up"][isDownUp]];
			for (var i: uint = 0; i < vecCallbackKeyDownUp.length; i++) {
				var callbackKeyDownUp: FunctionCallback = vecCallbackKeyDownUp[i];
				if (callbackKeyDownUp.params.indexOf(keyCode) > -1) 
					callbackKeyDownUp.call([keyCode]);
			}
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
		
		static public function addCallbackKeyDown(callback: FunctionCallback): void {
			Key.addCallbackKeyDownUp(0, callback);
		}
		
		static public function addCallbackKeyUp(callback: FunctionCallback): void {
			Key.addCallbackKeyDownUp(1, callback);
		}
		
		static private function addCallbackKeyDownUp(isDownUp: uint, callback: FunctionCallback): void {
			var vecCallbackKeyDownUp: Vector.<FunctionCallback> = Key["vecCallbackKey" + ["Down", "Up"][isDownUp]];
			vecCallbackKeyDownUp.push(callback);
		}
		
		static public function removeCallbackKeyDown(callback: FunctionCallback): void {
			Key.removeCallbackKeyDownUp(0, callback);
		}
		
		static public function removeCallbackKeyUp(callback: FunctionCallback): void {
			Key.removeCallbackKeyDownUp(1, callback);
		}
		
		static public function removeCallbackKeyDownUp(isDownUp: uint, callback: FunctionCallback): void {
			var vecCallbackKeyDownUp: Vector.<FunctionCallback> = Key["vecCallbackKey" + ["Down", "Up"][isDownUp]];
			var indexOfCallbackKeyDownUp: uint = vecCallbackKeyDownUp.indexOf(callback);
			if (indexOfCallbackKeyDownUp > -1)
				vecCallbackKeyDownUp.splice(indexOfCallbackKeyDownUp, 1);
		}
		
		static public function destroy():void {
			if (Key.stage) {
				Key.stage.removeEventListener(Event.DEACTIVATE, Key.removeKeys);
				Key.stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
				Key.stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
				Key.stage = null;
				Key.vecCallbackKeyUp = null;
				Key.vecCallbackKeyDown = null;
				Key.arrKeyDown = null;
			}
		}
		
	}

}