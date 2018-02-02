package tl.gallery {
	
	public class OptionsController extends Object {
		
		public var isArrow: Boolean; 
		public var isLoopItemsByArrow: Boolean;
		public var isTFNumItem: Boolean;
		public var isItemClickable: Boolean;
		public var isMouseMove: Boolean;
		public var isMouseWheel: Boolean;
		public var isAutoChangeItem: Boolean;
		public var isSetMouseWheelOnStage: Boolean;
		public var timeChangeItemFirstTime: uint;
		public var timeChangeItem: uint;
		
		public function OptionsController(isArrow: Boolean = false, isLoopItemsByArrow: Boolean = true, isTFNumItem: Boolean = false, isItemClickable: Boolean = false, isMouseWheel: Boolean = true, isSetMouseWheelOnStage: Boolean = false, isMouseMove: Boolean = false, isAutoChangeItem: Boolean = false, timeChangeItemFirstTime: uint = 5000, timeChangeItem: uint = 2500): void {
			this.isArrow = isArrow;
			this.isLoopItemsByArrow = isLoopItemsByArrow;
			this.isTFNumItem = isTFNumItem;
			this.isItemClickable = isItemClickable;
			this.isMouseWheel = isMouseWheel;
			this.isSetMouseWheelOnStage = isSetMouseWheelOnStage;
			this.isMouseMove = isMouseMove;
			this.isAutoChangeItem = isAutoChangeItem;
			this.timeChangeItemFirstTime = timeChangeItemFirstTime;
			this.timeChangeItem = timeChangeItem;
		}
		
	}

}