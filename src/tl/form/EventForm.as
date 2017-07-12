package tl.form {
	import tl.vspm.EventModel;

	public class EventForm extends EventModel {

		public static const SUBMIT_SUCCESS: String = "submitSuccess";
		public static const SUBMIT_ERROR: String = "submitError";
		
		public function EventForm(type: String, data: * = null): void {
			super(type, data);
		}
		
	}

}