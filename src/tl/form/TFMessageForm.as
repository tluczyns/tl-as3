package tl.form {
	import flash.text.TextFormat;
	import flash.events.TimerEvent;
	import tl.types.DspObjUtils;
	
	public class TFMessageForm extends TFMessage {
		
		private var classForm: Form;
		
		public function TFMessageForm(classForm: Form, arrTextDurationMessage: Array, arrTextIsBadGoodCloseMessage: Array, tFormatMessage: TextFormat, colorsTFMessage: ColorsTFMessage = null): void {
			this.classForm = classForm;
			super(arrTextDurationMessage, arrTextIsBadGoodCloseMessage, tFormatMessage, colorsTFMessage);
		}
		
		override public function onTimerCompleteCloseMessage(e: TimerEvent = null): void {
			DspObjUtils.hideShow(this, 0, -1, this.finishHideTFMessageForm);
		}
		
		private function finishHideTFMessageForm(): void {
			this.classForm.isProcessing = false;
			this.classForm.blockUnblock(1);
			var isBadGoodCloseMessage: uint = this.arrTextIsBadGoodCloseMessage[this.typeCloseMessage].isBadGood;
			if (isBadGoodCloseMessage == 0) this.classForm.dispatchEvent(new EventForm(EventForm.PROCESSED_NEGATIVE));
			else if (isBadGoodCloseMessage == 1) this.classForm.dispatchEvent(new EventForm(EventForm.PROCESSED_POSITIVE));
		}
		
	}

}