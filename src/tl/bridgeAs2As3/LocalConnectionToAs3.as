class tl.bridgeAs2As3.LocalConnectionToAs3 extends LocalConnection {
	
	private var suffNameConnection: String;
	
	public function LocalConnectionToAs3(suffNameConnection: String) {
		this.suffNameConnection = suffNameConnection;
	}
	
	function call(strFunction: String, args: Array) {
		this.send('connFromAs2ToAs3' + this.suffNameConnection, 'connectionCall', strFunction, args);
	}
	
}