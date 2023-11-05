package tl.app {
	import tl.types.Singleton;
	import flash.display.Stage;
	import com.childoftv.websockets.WebSocketServer;
	import flash.desktop.NativeApplication;
	import flash.events.InvokeEvent;
	import tl.vspm.StateModel;
	import com.childoftv.websockets.events.ClientEvent;
	
	public class HandlerInvokeWithParams extends Singleton {
		
		static private var isAppReady: Boolean;
		static private var stage: Stage;
		static private var functionHandle: Function;
		static private var arrNameParam: Array;
		static private var arrValueParam: Array;
		static private var isMaximizeOnInvoke: Boolean;
		static private var webSocketServer: WebSocketServer;
		static private var isForVSPM: Boolean;
		static private var indSection: String;
		
		static public function init(stage: Stage, functionHandle: Function = null, arrNameParam: Array = null, isMaximizeOnInvoke: Boolean = false, isForVSPM: Boolean = false): void {
			HandlerInvokeWithParams.isAppReady = false;
			HandlerInvokeWithParams.stage = stage;
			HandlerInvokeWithParams.functionHandle = functionHandle;
			HandlerInvokeWithParams.arrNameParam = arrNameParam || [];
			HandlerInvokeWithParams.arrValueParam = new Array(HandlerInvokeWithParams.arrNameParam.length);
			HandlerInvokeWithParams.isMaximizeOnInvoke = isMaximizeOnInvoke;
			HandlerInvokeWithParams.isForVSPM = isForVSPM;
			HandlerInvokeWithParams.addInvokeEvents();
		}
		
		static private function addInvokeEvents(): void {
			NativeApplication.nativeApplication.addEventListener(InvokeEvent.INVOKE, HandlerInvokeWithParams.onInvokeApp);
		}
		
		static private function onInvokeApp(e: InvokeEvent): void {
			HandlerInvokeWithParams.stage.nativeWindow.alwaysInFront = true;
			HandlerInvokeWithParams.stage.nativeWindow.alwaysInFront = false;
			HandlerInvokeWithParams.stage.nativeWindow.activate();
			NativeApplication.nativeApplication.activate(HandlerInvokeWithParams.stage.nativeWindow);
			HandlerInvokeWithParams.stage.focus = HandlerInvokeWithParams.stage;
			if (HandlerInvokeWithParams.isMaximizeOnInvoke) HandlerInvokeWithParams.stage.nativeWindow.maximize();
			if (e.arguments && e.arguments.length) {
				var urlWithParams: String = e.arguments[0];
				//urlWithParams = "aa://page=34&search=ssaddsa"
				urlWithParams = urlWithParams.replace(/^['"]*|\/*['"]*$/g, ""); //removing start/end quotes and last slash
				var indexOfSeparator: int = urlWithParams.indexOf(":");
				if (indexOfSeparator > -1) {
					urlWithParams = urlWithParams.substring(indexOfSeparator + 3);
					StateModel.trackEvent("invokeApp", urlWithParams.substring(0, indexOfSeparator), urlWithParams);
					HandlerInvokeWithParams.arrValueParam = HandlerInvokeWithParams.arrNameParam.map(function(nameParam: String, index: int, array: Array): String {
						return HandlerInvokeWithParams.getValueParam(urlWithParams, nameParam);
					}, HandlerInvokeWithParams);
					var portSocketServer: uint = uint(HandlerInvokeWithParams.getValueParam(urlWithParams, "portSocketServer"));
					if (portSocketServer) HandlerInvokeWithParams.createSocketServer(portSocketServer);
					if (HandlerInvokeWithParams.isForVSPM) HandlerInvokeWithParams.indSection = urlWithParams;
					if (HandlerInvokeWithParams.isAppReady) HandlerInvokeWithParams.callFunctionHandle();
				}
			}
		}
		
		static private function getValueParam(urlWithParams: String, nameParam: String): String {
			var regExpParam: RegExp = new RegExp(nameParam + "=([^&/]+)");
			var matchValueParam: Array = regExpParam.exec(urlWithParams);
			var valueParam: String;
			if ((matchValueParam) && (matchValueParam.length >= 2)) valueParam = matchValueParam[1];
			return valueParam;
		}
		
		static private function createSocketServer(portSocketServer: uint): void {
			if (!HandlerInvokeWithParams.webSocketServer) {
				HandlerInvokeWithParams.webSocketServer = new WebSocketServer();
				HandlerInvokeWithParams.webSocketServer.addEventListener(ClientEvent.CLIENT_MESSAGE_EVENT, HandlerInvokeWithParams.onWebSocketServerClientMessage);
				HandlerInvokeWithParams.webSocketServer.attemptBind(portSocketServer, "127.0.0.1");
			}
		}
		
		static public function onWebSocketServerClientMessage(e: ClientEvent): void {
			var location: String = HandlerInvokeWithParams.webSocketServer.getClientKeyBySocket(e.socket);
			trace("Client message from ", location, e.msg);
		}
		
		static private function callFunctionHandle(): void {
			if (HandlerInvokeWithParams.functionHandle != null) {
				var arrValueParam: Array
				if (HandlerInvokeWithParams.isForVSPM) {
					arrValueParam = HandlerInvokeWithParams.arrValueParam.concat();
					arrValueParam.unshift(HandlerInvokeWithParams.indSection);
				} else {
					arrValueParam = HandlerInvokeWithParams.arrValueParam;
				}
				HandlerInvokeWithParams.functionHandle.apply(null, arrValueParam);
			}
		}
		
		static public function setAppReadyAndCallFunctionHandle(): void {
			HandlerInvokeWithParams.isAppReady = true;
			HandlerInvokeWithParams.callFunctionHandle();
		}
		
	}

}