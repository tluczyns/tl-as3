package tl.gallery {
	
	public class GalleryFlow extends GalleryCircle {
		
		private var countFieldsForItems: uint;
		
		public function GalleryFlow(arrData: Array = null, countFieldsForItems: uint = 5, numFieldForItemSelected: int = -1, optionsController: OptionsController = null, optionsVisual: OptionsVisual = null, numFirstItemSelected: uint = 0): void {
			/*arrData = [0xff0000, 0x00ff00, 0x0000ff, 0xff00ff, 0x00ffff, 0xffff00];
			this.x = this.y = 300;*/
			this.countFieldsForItems = countFieldsForItems;
			super(arrData, numFieldForItemSelected, optionsController, optionsVisual, numFirstItemSelected);
		}
		
		override protected function get lengthArrItemInField(): Number {
			return (this.countFieldsForItems == 1) ? 1 : this.countFieldsForItems + 1;
		}
		
		override protected function initItem(item: ItemGallery): void {
			if (this.optionsVisual.isAlphaManagement) item.alpha = 0;
		}
		
		override protected function manageArrItemInField(numItemFirst: Number): void {
			var itemInField: ItemGallery;
			var i: uint = 0;
			while (i < this.arrItemInField.length) {
				itemInField = this.arrItemInField[i];
				if ((itemInField) && (!(((itemInField.num >= numItemFirst) && (itemInField.num < numItemFirst + this.arrItemInField.length)) || (itemInField.num < this.arrItemInField.length - (this.arrItem.length - numItemFirst))))) {
					this.containerItem.removeChild(itemInField);
					this.arrItemInField.splice(i, 1);
				} else i++;
			}
			for (i = 0; i < this.lengthArrItemInField; i++) {
				itemInField = this.arrItem[(numItemFirst + i) % this.arrItem.length];
				if (!this.containerItem.contains(itemInField)) {
					this.containerItem.addChild(itemInField);
					this.arrItemInField.push(itemInField);
				}
				//alpha management
				if (this.optionsVisual.isAlphaManagement) {
					var targetAlpha: Number = 1;
					if ((i == 0) || (i == this.arrItemInField.length - 1)) {
						targetAlpha = (this._time % this.timeOne) / this.timeOne;
						if (i == 0) targetAlpha = 1 - targetAlpha;
					}
					itemInField.alpha = targetAlpha;
				}
			}
		}
		
	}

}