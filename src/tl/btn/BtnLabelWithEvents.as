package tl.btn {
	//import base.tf.ITextField;
	import flash.display.Sprite;
	import flash.display.DisplayObject;
	
	public class BtnLabelWithEvents extends BtnHitWithEvents {
		
		private var tfLabel: *//ITextField;
		
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
		
		private function removeTFLabel(): void {
			this.removeChild(DisplayObject(this.tfLabel));
			this.tfLabel = null;
		}
		
		public function set text(value: String): void {
			this.tfLabel.text = value;
			if (this.hit.height < this.tfLabel.height) this.hit.height = this.tfLabel.height + 2 * this.tfLabel.y;
			this.tfLabel.y = this.hit.y + (this.hit.height - this.tfLabel.height) / 2;
			this.hit.width = this.tfLabel.width + 2 * this.tfLabel.x;
		}
		
		override public function destroy(): void {
			this.removeTFLabel();
			super.destroy();
		}
		
	}

}