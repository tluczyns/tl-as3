package tl.form {

	public class ColorsTFMessage {
		
		public var colorDurationMessage: int;
		public var colorBadHideMessage: int;
		public var colorGoodHideMessage: int;
		
		public function ColorsTFMessage(colorDurationMessage: int = 0, colorBadHideMessage: int = 0, colorGoodHideMessage: int = 0): void {
			this.colorDurationMessage = colorDurationMessage || 0x000000;
			this.colorBadHideMessage = colorBadHideMessage || 0xFF0000;
			this.colorGoodHideMessage = colorGoodHideMessage || 0x009900;
		}
		
	}

}