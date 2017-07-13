package tl.form {
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.text.AntiAliasType;
	import flash.utils.Timer;
	import tl.tf.TextFieldUtilsDots;
	import tl.types.DspObjUtils;
	import flash.events.TimerEvent;
	import flash.events.Event;
	
	public class TFMessageForm extends TextField {
		
		static public const DESTROYED: String = "destroyed";
		
		private var classForm: Form;
		private var arrDurationMessage: Array;
		public var arrResponseBadMessage: Array;
		public var arrResponseGoodMessage: Array;
		private var colorsTFMessage: ColorsTFMessage;
		private var tFormatMessage: TextFormat;
		private var timerHideMessage: Timer;
		private var isBadGood: uint;
		
		public function TFMessageForm(classForm: Form, arrDurationMessage: Array, arrResponseBadMessage: Array, arrResponseGoodMessage: Array, colorsTFMessage: ColorsTFMessage = null, tFormatMessage: TextFormat = null, width: Number = 0): void {
			this.classForm = classForm;
			this.arrDurationMessage = arrDurationMessage || [];
			this.arrResponseBadMessage = arrResponseBadMessage || [];
			this.arrResponseGoodMessage = arrResponseGoodMessage || [];
			this.colorsTFMessage = colorsTFMessage || new ColorsTFMessage();
			super();
			this.alpha = 0;
			this.visible = false;
			this.embedFonts = true;
			this.autoSize = TextFieldAutoSize.LEFT;
			this.type = "dynamic";
			this.selectable = false;
			this.multiline = this.wordWrap = (width > 0);
			if (width > 0) this.width = width;
			this.antiAliasType = AntiAliasType.ADVANCED;
			this.text = " ";
            this.tFormatMessage = tFormatMessage ? tFormatMessage : new TextFormat(null, 11);
            this.setColor(this.colorsTFMessage.colorDurationMessage);
		}
		
		public function showDurationMessage(num: uint): void {
			TextFieldUtilsDots.stopAddDots(this);
			DspObjUtils.hideShow(this, 1);
			this.setColor(this.colorsTFMessage.colorDurationMessage);
			this.text = this.arrDurationMessage[num];
			TextFieldUtilsDots.addDots(this);
		}
		
		public function showResponseMessage(num: uint, isBadGood: uint): void {
			var arrMessage: Array = [this.arrResponseBadMessage, this.arrResponseGoodMessage][isBadGood];
			if (num < arrMessage.length) {
				this.isBadGood = isBadGood;
				if (arrMessage[num]) {
					TextFieldUtilsDots.stopAddDots(this);
					this.text = arrMessage[num];
				}
				DspObjUtils.hideShow(this, 1);
				this.setColor([this.colorsTFMessage.colorBadHideMessage, this.colorsTFMessage.colorGoodHideMessage][isBadGood]);
				if (this.timerHideMessage != null) this.timerHideMessage.stop();
				this.timerHideMessage = new Timer(Math.round(Math.pow(this.text.length, 0.62) * 3.5 * 100), 1);//60
				this.timerHideMessage.addEventListener(TimerEvent.TIMER_COMPLETE, this.onTimerCompleteHideMessage);
				this.timerHideMessage.start();
			}
		}
		
		private function setColor(color: uint): void {
			this.tFormatMessage.color = color;
			this.setTextFormat(this.tFormatMessage);
			this.defaultTextFormat = this.tFormatMessage;
		}
		
		public function onTimerCompleteHideMessage(e: TimerEvent = null): void {
			DspObjUtils.hideShow(this, 0, -1, this.finishHideMessage);
		}
		
		private function finishHideMessage(): void {
			this.text = "";
			this.classForm.isSubmitting = false;
			this.classForm.blockUnblock(1);
			if (this.isBadGood == 0) this.classForm.dispatchEvent(new EventForm(EventForm.SUBMIT_ERROR));
			else if (this.isBadGood == 1) this.classForm.dispatchEvent(new EventForm(EventForm.SUBMIT_SUCCESS));
		}
		
		public function destroy(e: Event = null): void {
			TextFieldUtilsDots.stopAddDots(this);
			DspObjUtils.hideShow(this, 0);
			this.dispatchEvent(new Event(TFMessageForm.DESTROYED));
		}
		
	}
	
}