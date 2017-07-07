package tl.form {
	import flash.text.TextField;
	import flash.utils.Timer;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import tl.types.DspObjUtils;
	import flash.events.TimerEvent;
	
	public class TFMessageFormForTF extends TextField {
		
		private var arrTextBadMessage: Array;
		private var timerCloseMessage: Timer;
		
		public function TFMessageFormForTF(arrTextBadMessage: Array, tFormatMessage: TextFormat, colorBadMessage: int = 0xFF0000): void {
			this.arrTextBadMessage = arrTextBadMessage || [];
			super();
			this.alpha = 0;
			this.visible = false;
			this.embedFonts = true;
			this.autoSize = TextFieldAutoSize.LEFT;
			this.type = "dynamic";
			this.selectable = false;
			this.multiline = false;
			this.text = " ";
			tFormatMessage = tFormatMessage ? tFormatMessage : new TextFormat(null, 11);
            tFormatMessage.color = colorBadMessage;
            this.setTextFormat(tFormatMessage);
			this.defaultTextFormat = tFormatMessage;
		}
		
		
		public function showAndCloseMessage(typeMessage: uint): void {
			if (typeMessage < this.arrTextBadMessage.length) {
				this.text = this.arrTextBadMessage[typeMessage];
				DspObjUtils.hideShow(this, 1);
				if (this.timerCloseMessage != null) this.timerCloseMessage.stop();
				this.timerCloseMessage = new Timer(Math.round(Math.pow(this.text.length, 0.62) * 200), 1);
				this.timerCloseMessage.addEventListener(TimerEvent.TIMER_COMPLETE, this.onTimerCompleteCloseMessage);
				this.timerCloseMessage.start();
			}
		}
		
		public function closeMessage(): void {
			if ((this.timerCloseMessage) && (this.timerCloseMessage.running)) {
				this.timerCloseMessage.dispatchEvent(new TimerEvent(TimerEvent.TIMER_COMPLETE));
				this.timerCloseMessage.stop();
			}
		}
		
		protected function onTimerCompleteCloseMessage(e: TimerEvent): void {
			DspObjUtils.hideShow(this, 0);
		}
		
	}

}