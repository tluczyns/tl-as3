﻿import tl.bridgeAs2As3.BridgeFromToAs3;

class tl.bridgeAs2As3.LocalConnectionFromAs3 extends LocalConnection {
	
	public var classBridgeFromToAs3: BridgeFromToAs3
	
	public function LocalConnectionFromAs3(classBridgeFromToAs3: BridgeFromToAs3, suffNameConnection: String) {
		this.classBridgeFromToAs3 = classBridgeFromToAs3;
		this.connect("connFromAs3ToAs2" + suffNameConnection);
	}
	
	public function connectionCall(strFunction: String, args: Array) {
		Function(this.classBridgeFromToAs3[strFunction]).apply(this.classBridgeFromToAs3, [args]);
	}
	
}