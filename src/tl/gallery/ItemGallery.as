package tl.gallery {
	import tl.btn.BtnHitWithEvents;
	import flash.display.Sprite;
	import tl.btn.EventBtnHit;
	
	public class ItemGallery extends BtnHitWithEvents {
		
		public var gallery: GalleryCircle;
		public var num: uint;
		protected var objData: Object;
		public var time: Number;
		
		public function ItemGallery(gallery: GalleryCircle, num: Number, objData: Object = null, hit: Sprite = null): void {
			this.gallery = gallery;
			this.objData = objData;
			this.num = num;
			this.draw();
			super(hit);
			if (!this.gallery.optionsController.isItemClickable) this.isEnabled = false;
		}
		
		protected function draw(): void {
			/*this.graphics.beginFill(uint(this.objData), 1);
			this.graphics.drawRect(-10, -10, 20, 20);
			this.graphics.endFill();*/
		}
		
		protected function deleteDraw(): void {
			//this.graphics.clear();
		}
		
		public function render(time: Number, timeOne: Number): void {
			/*this.scaleX = this.scaleY = 3 * (1 - Math.abs(0.5 - time))
			this.x = -50 + time * 300;
			this.rotationY = - 90 + time * 180;*/
		}
		
		public function set selected(value: Boolean): void {
			//trace("value:", value)
		}
		
		override protected function onClicked(e: EventBtnHit): void {
			this.dispatchEvent(new EventGallery(EventGallery.SELECTED_ITEM_CHANGED, this.num, true));
		}
		
		override public function destroy(): void {
			this.deleteDraw();
			super.destroy();
		}
		
	}

}