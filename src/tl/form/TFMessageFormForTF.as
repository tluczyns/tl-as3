package tl.form {
	import flash.text.TextField;
	import flash.utils.Timer;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.text.AntiAliasType;
	import flash.text.TextFormatAlign;
	import tl.types.DspObjUtils;
	import flash.events.TimerEvent;
	
	public class TFMessageFormForTF extends TextField {
		
		private var arrTextBadMessage: Array;
		private var timerHideMessage: Timer;
		
		public function TFMessageFormForTF(arrTextBadMessage: Array, colorBadMessage: int = 0xFF0000, tFormatMessage: TextFormat = null, autoSize: String = TextFieldAutoSize.LEFT): void {
			this.arrTextBadMessage = arrTextBadMessage || [];
			super();
			this.alpha = 0;
			this.visible = false;
			this.embedFonts = true;
			this.autoSize = autoSize;
			this.type = "dynamic";
			this.selectable = false;
			this.multiline = this.wordWrap = false;
			this.antiAliasType = AntiAliasType.ADVANCED;
			this.text = " ";
            tFormatMessage.color = colorBadMessage;
			if (autoSize == TextFieldAutoSize.RIGHT) tFormatMessage.align = TextFormatAlign.RIGHT;
            this.setTextFormat(tFormatMessage);
			this.defaultTextFormat = tFormatMessage;
		}
		
		public function showAndHideMessage(typeMessage: uint): void {
			if (typeMessage < this.arrTextBadMessage.length) {
				this.text = this.arrTextBadMessage[typeMessage];
				DspObjUtils.hideShow(this, 1);
				if (this.timerHideMessage != null) this.timerHideMessage.stop();
				this.timerHideMessage = new Timer(Math.round(Math.pow(this.text.length, 0.62) * 250), 1);
				this.timerHideMessage.addEventListener(TimerEvent.TIMER_COMPLETE, this.onTimerCompleteHideMessage);
				this.timerHideMessage.start();
			}
		}
		
		public function hideMessage(): void {
			if ((this.timerHideMessage) && (this.timerHideMessage.running)) {
				this.timerHideMessage.dispatchEvent(new TimerEvent(TimerEvent.TIMER_COMPLETE));
				this.timerHideMessage.stop();
			}
		}
		
		protected function onTimerCompleteHideMessage(e: TimerEvent): void {
			DspObjUtils.hideShow(this, 0);
		}
		
	}

}