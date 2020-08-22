package tl.app {
	import tl.types.Singleton;
	import flash.display.Stage;
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	//import flash.events.NativeWindowDisplayStateEvent;
	import flash.events.InvokeEvent;
	//import flash.display.NativeWindowDisplayState;
	//import flash.utils.setTimeout;	
	import tl.vspm.StateModel;
	
	public class HandlerInvokeWithParams extends Singleton {
		
		static private var isAppReady: Boolean;
		static private var stage: Stage;
		static private var functionHandleParams: Function;
		static private var arrNameParam: Array;
		static private var arrValueParam: Array;
		
		static public function init(stage: Stage, functionHandleParams: Function = null, arrNameParam: Array = null): void {
			HandlerInvokeWithParams.isAppReady = false;
			HandlerInvokeWithParams.stage = stage;
			HandlerInvokeWithParams.functionHandleParams = functionHandleParams;
			if (arrNameParam) {
				HandlerInvokeWithParams.arrNameParam = arrNameParam;
				HandlerInvokeWithParams.arrValueParam = new Array(HandlerInvokeWithParams.arrNameParam.length)
			}
			HandlerInvokeWithParams.addInvokeEvents();
		}
		
		static private function addInvokeEvents(): void {
			NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE, HandlerInvokeWithParams.onDeactivateApp);
			//HandlerInvokeWithParams.stage.nativeWindow.addEventListener(NativeWindowDisplayStateEvent.DISPLAY_STATE_CHANGING, HandlerInvokeWithParams.onNativeWindowDisplayStateChanging);
			NativeApplication.nativeApplication.addEventListener(InvokeEvent.INVOKE, HandlerInvokeWithParams.onInvokeApp);
		}
		
		//static private var isBlockRestoreAfterMinimize: Boolean;
		
		static private function onDeactivateApp(e: Event): void {
			HandlerInvokeWithParams.stage.nativeWindow.alwaysInFront = false;
			HandlerInvokeWithParams.stage.nativeWindow.orderToBack();
			/*if (HandlerInvokeWithParams.stage.nativeWindow.displayState != NativeWindowDisplayState.MINIMIZED) {
				HandlerInvokeWithParams.isBlockRestoreAfterMinimize = true;
				setTimeout(HandlerInvokeWithParams.unblockRestoreAfterMinimize, 500);
				HandlerInvokeWithParams.stage.nativeWindow.minimize();
			}*/
		}
		
		/*static private function unblockRestoreAfterMinimize(): void {
			HandlerInvokeWithParams.isBlockRestoreAfterMinimize = false;
		}
		
		static private function onNativeWindowDisplayStateChanging(e: NativeWindowDisplayStateEvent): void {
			if ((e.afterDisplayState != NativeWindowDisplayState.MINIMIZED) && (HandlerInvokeWithParams.isBlockRestoreAfterMinimize))
				e.preventDefault();
		}*/
		
		static private function onInvokeApp(e: InvokeEvent): void {
			HandlerInvokeWithParams.stage.nativeWindow.alwaysInFront = true;
			HandlerInvokeWithParams.stage.nativeWindow.orderToFront()
			HandlerInvokeWithParams.stage.focus = HandlerInvokeWithParams.stage;
			HandlerInvokeWithParams.stage.nativeWindow.activate();
			NativeApplication.nativeApplication.activate(HandlerInvokeWithParams.stage.nativeWindow);
			//HandlerInvokeWithParams.stage.nativeWindow.maximize();
			if (e.arguments && e.arguments.length) {
				var urlWithParams: String = e.arguments[0];
				//urlWithParams = "aa://page=34&search=ssaddsa"
				urlWithParams = urlWithParams.replace(/^['"]*|\/*['"]*$/g, ""); //removing start/end quotes and last slash
				var indexOfSeparator: int = urlWithParams.indexOf(":");
				if (indexOfSeparator > -1) StateModel.trackEvent("invokeApp", urlWithParams.substring(0, indexOfSeparator), urlWithParams.substring(indexOfSeparator + 3));
				if (HandlerInvokeWithParams.arrNameParam) 
					HandlerInvokeWithParams.arrValueParam = HandlerInvokeWithParams.arrNameParam.map(function(nameParam: String, index: int, array: Array): String {
						return HandlerInvokeWithParams.getValueParam(urlWithParams, nameParam);
					}, HandlerInvokeWithParams);
				if (HandlerInvokeWithParams.isAppReady) HandlerInvokeWithParams.callFunctionHandleParams();
			}
		}
		
		static private function getValueParam(urlWithParams: String, nameParam: String): String {
			var regExpParam: RegExp = new RegExp(nameParam + "=([^&/]+)");
			var matchValueParam: Array = regExpParam.exec(urlWithParams);
			var valueParam: String;
			if ((matchValueParam) && (matchValueParam.length >= 2)) valueParam = matchValueParam[1];
			return valueParam;
		}
		
		static private function callFunctionHandleParams(): void {
			if (HandlerInvokeWithParams.functionHandleParams != null) HandlerInvokeWithParams.functionHandleParams.apply(null, HandlerInvokeWithParams.arrValueParam);
		}
		
		static public function setAppReadyAndCallFunctionHandleParams(): void {
			HandlerInvokeWithParams.isAppReady = true;
			HandlerInvokeWithParams.callFunctionHandleParams();
		}
		
	}

}