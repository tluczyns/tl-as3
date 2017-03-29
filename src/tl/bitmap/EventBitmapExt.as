package tl.bitmap {
	import tl.vspm.EventModel;

	public class EventBitmapExt extends EventModel {

		public static const BITMAPDATA_SET: String = "bitmapdataSet";
		
		public function EventBitmapExt(type: String, data: * = null): void {
			super(type, data);
		}
		
	}

}