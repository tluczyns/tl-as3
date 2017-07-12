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
		private var arrTextDurationMessage: Array;
		public var arrTextIsBadGoodHideMessage: Array;
		public var colorsTFMessage: ColorsTFMessage;
		private var tFormatMessage: TextFormat;
		private var timerHideMessage: Timer;
		public var typeHideMessage: uint;
		
		public function TFMessageForm(classForm: Form, arrTextDurationMessage: Array, arrTextIsBadGoodHideMessage: Array, colorsTFMessage: ColorsTFMessage = null, tFormatMessage: TextFormat = null, width: Number = 0): void {
			this.classForm = classForm;
			this.arrTextDurationMessage = arrTextDurationMessage || [];
			this.arrTextIsBadGoodHideMessage = arrTextIsBadGoodHideMessage || [];
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
		
		public function showDurationMessage(typeMessage: uint): void {
			TextFieldUtilsDots.stopAddDots(this);
			DspObjUtils.hideShow(this, 1);
			this.setColor(this.colorsTFMessage.colorDurationMessage);
			this.text = this.arrTextDurationMessage[typeMessage];
			TextFieldUtilsDots.addDots(this);
		}
		
		public function showAndHideMessage(typeHideMessage: uint): void {
			if (typeHideMessage < this.arrTextIsBadGoodHideMessage.length) {
				if (this.arrTextIsBadGoodHideMessage[typeHideMessage].text) {
					TextFieldUtilsDots.stopAddDots(this);
					this.text = this.arrTextIsBadGoodHideMessage[typeHideMessage].text;
				}
				DspObjUtils.hideShow(this, 1);
				this.typeHideMessage = typeHideMessage;
				this.setColor([this.colorsTFMessage.colorBadHideMessage, this.colorsTFMessage.colorGoodHideMessage][this.arrTextIsBadGoodHideMessage[typeHideMessage].isBadGood]);
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
			DspObjUtils.hideShow(this, 0, -1, this.finishHideTFMessageForm);
		}
		
		private function finishHideTFMessageForm(): void {
			this.text = "";
			this.classForm.isSubmitting = false;
			this.classForm.blockUnblock(1);
			var isBadGoodHideMessage: uint = this.arrTextIsBadGoodHideMessage[this.typeHideMessage].isBadGood;
			if (isBadGoodHideMessage == 0) this.classForm.dispatchEvent(new EventForm(EventForm.SUBMIT_ERROR));
			else if (isBadGoodHideMessage == 1) this.classForm.dispatchEvent(new EventForm(EventForm.SUBMIT_SUCCESS));
		}
		
		public function destroy(e: Event = null): void {
			TextFieldUtilsDots.stopAddDots(this);
			DspObjUtils.hideShow(this, 0);
			this.dispatchEvent(new Event(TFMessageForm.DESTROYED));
		}
		
	}
	
}