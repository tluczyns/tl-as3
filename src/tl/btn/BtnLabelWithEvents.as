package tl.btn {
	//import tl.tf.ITextField;
	import flash.display.Sprite;
	import flash.display.DisplayObject;
	
	public class BtnLabelWithEvents extends BtnHitWithEvents implements IBtnWithEvents {
		
		protected var tfLabel: *//ITextField;
		
		public function BtnLabelWithEvents(strLabel: String, hit: Sprite = null): void {
			this.addTFLabel();
			super(hit);
			this.text = strLabel;
		}
		
		protected function createTFLabel(): * {
			throw new Error("createTFLabel must be implemented !") 
		}
		
		private function addTFLabel(): void {
			this.tfLabel = this.createTFLabel();
			this.addChild(DisplayObject(this.tfLabel));
		}
		
		private function deleteTFLabel(): void {
			this.removeChild(DisplayObject(this.tfLabel));
			this.tfLabel = null;
		}
		
		public function set text(value: String): void {
			this.tfLabel[["text", "htmlText"][uint((value.indexOf("<") != -1) && (value.indexOf(">") != -1))]] = value;
			this.hit.mouseEnabled = (value.indexOf("<a href=") == -1);
			this.shortenWidthBtnToLabelAndSetHeightHitAndPosYTFLabel();
		}
		
		override public function get width(): Number {
			return this.hit.width;
		}
		
		override public function set width(value: Number): void {
			this.tfLabel.width = value - 2 * this.tfLabel.x;
			this.shortenWidthBtnToLabelAndSetHeightHitAndPosYTFLabel();
		}
		
		private function shortenWidthBtnToLabelAndSetHeightHitAndPosYTFLabel(): void {
			this.tfLabel.width = Math.min(this.tfLabel.textWidth + 5, this.tfLabel.width);
			this.hit.width = this.tfLabel.width + 2 * this.tfLabel.x;
			this.hit.height = this.tfLabel.height + 2 * this.tfLabel.y;
			this.tfLabel.y = this.hit.y + (this.hit.height - this.tfLabel.height) / 2;
		}
		
		override public function destroy(): void {
			this.deleteTFLabel();
			super.destroy();
		}
		
	}

}