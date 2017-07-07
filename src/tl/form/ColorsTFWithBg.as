package tl.form {
	
	public class ColorsTFWithBg {
		
		public var colorTFOk: int = -1;
		public var colorTFBad: int = -1;
		public var colorBgTFOk: int = -1;
		public var colorBgTFBad: int = -1;
		
		public function ColorsTFWithBg(colorTFOk: int = 0x000000, colorTFBad: int = 0xFFFFFF, colorBgTFOk: int = 0xFFFFFF, colorBgTFBad: int = 0xE65152): void {
			this.colorTFOk = colorTFOk;
			this.colorTFBad = colorTFBad;
			this.colorBgTFOk = colorBgTFOk;
			this.colorBgTFBad = colorBgTFBad;
		}
		
	}

}