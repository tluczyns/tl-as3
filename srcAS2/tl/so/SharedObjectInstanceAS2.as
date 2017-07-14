class tl.so.SharedObjectInstanceAS2 extends Object {
	
	private var so: SharedObject;
	
	function SharedObjectInstanceAS2(soName: String) {
		if (soName) this.so = SharedObject.getLocal(soName, "/");
	}
		
	public function setPropValue(propName: String, propValue): Boolean {
		if (this.so != null) {
			this.so.data[propName] = propValue;
			this.so.flush();
			return true;
		} return false;
	}
	
	public function getPropValue(propName: String, defaultValue) {
		return ((this.so != null) && (this.so.data[propName] != undefined)) ? this.so.data[propName] : defaultValue;
	}
	
	public function destroy(): Void {
		this.so.flush();
		this.so.close();
		this.so = null;
	}
	
}