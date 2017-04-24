package tl.ui {
	import tl.types.Singleton;
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	
	//based on com.senocular.utils.Key
	public class Key extends Singleton {
		
		static private var stage: Stage;
		static private var objKeysDown: Object;
		
		static public function construct(stage: Stage): void {
			if ((stage != null) && (Key.stage == null)) {
				Key.stage = stage;
				Key.objKeysDown = new Object();
				Key.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
				Key.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);			
			}
		}
		
		static private function onKeyDown(e: KeyboardEvent):void {
			Key.objKeysDown[e.keyCode] = true;
		}
		
		static private function onKeyUp(e: KeyboardEvent):void {
			delete Key.objKeysDown[e.keyCode];
		}
		
		static public function isDown(keyCode:uint): Boolean {
			return Boolean(keyCode in Key.objKeysDown);
		}
		
		static public function destroy():void {
			if (Key.stage) {
				Key.stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
				Key.stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
				Key.stage = null;
				Key.objKeysDown = null;
			}
		}
		
	}

}