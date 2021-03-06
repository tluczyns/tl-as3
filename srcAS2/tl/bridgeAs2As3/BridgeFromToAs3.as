﻿import tl.bridgeAs2As3.LocalConnectionFromAs3;
import tl.bridgeAs2As3.LocalConnectionToAs3;

class tl.bridgeAs2As3.BridgeFromToAs3 extends MovieClip {
	
	private var lcFromAs3: LocalConnectionFromAs3;
	private var lcToAs3: LocalConnectionToAs3;

	public function BridgeFromToAs3(suffNameConnection: String) {
		this.lcFromAs3 = new LocalConnectionFromAs3(this, suffNameConnection);
		this.lcToAs3 = new LocalConnectionToAs3(suffNameConnection);
	}
	
	public function call(strFunction: String, args: Array) {
		this.lcToAs3.call(strFunction, args);
	}
	
}