package tl.btn {
	import tl.vspm.EventModel;
	
	public class EventBtnHit extends EventModel {
		
		public static const OVER: String = "over";
		public static const OUT: String = "out";
		public static const DOWN: String = "down";
		public static const UP: String = "up";
		public static const CLICKED: String = "clicked";
		
		public function EventBtnHit(type: String, data: * = null): void {
			super(type, data);//, true);
		}
		
	}

}