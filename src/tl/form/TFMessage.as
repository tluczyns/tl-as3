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
	
	public class TFMessage extends TextField {
		
		static public const DESTROYED: String = "destroyed";
		
		private var arrTextDurationMessage: Array;
		protected var arrTextIsBadGoodCloseMessage: Array;
		public var colorsTFMessage: ColorsTFMessage;
		private var tFormatMessage: TextFormat;
		private var timerCloseMessage: Timer;
		public var typeCloseMessage: uint;
		
		
		public function TFMessage(arrTextDurationMessage: Array, arrTextIsBadGoodCloseMessage: Array, tFormatMessage: TextFormat, colorsTFMessage: ColorsTFMessage = null): void {
			this.arrTextDurationMessage = arrTextDurationMessage || [];
			this.arrTextIsBadGoodCloseMessage = arrTextIsBadGoodCloseMessage || [];
			this.colorsTFMessage = colorsTFMessage || new ColorsTFMessage();
			super();
			this.alpha = 0;
			this.visible = false;
			this.embedFonts = true;
			this.autoSize = TextFieldAutoSize.LEFT;
			this.type = "dynamic";
			this.selectable = false;
			this.multiline = false;
			this.wordWrap = false;
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
		
		public function showAndCloseMessage(typeCloseMessage: uint): void {
			if (typeCloseMessage < this.arrTextIsBadGoodCloseMessage.length) {
				if (this.arrTextIsBadGoodCloseMessage[typeCloseMessage].text) {
					TextFieldUtilsDots.stopAddDots(this);
					this.text = this.arrTextIsBadGoodCloseMessage[typeCloseMessage].text;
				}
				DspObjUtils.hideShow(this, 1);
				this.typeCloseMessage = typeCloseMessage;
				this.setColor([this.colorsTFMessage.colorBadCloseMessage, this.colorsTFMessage.colorGoodCloseMessage][this.arrTextIsBadGoodCloseMessage[typeCloseMessage].isBadGood]);
				if (this.timerCloseMessage != null) this.timerCloseMessage.stop();
				this.timerCloseMessage = new Timer(Math.round(Math.pow(this.text.length, 0.62) * 3.5 * 100), 1);//60
				this.timerCloseMessage.addEventListener(TimerEvent.TIMER_COMPLETE, this.onTimerCompleteCloseMessage);
				this.timerCloseMessage.start();
			}
		}
		
		private function setColor(color: uint): void {
			this.tFormatMessage.color = color;
			this.setTextFormat(this.tFormatMessage);
			this.defaultTextFormat = this.tFormatMessage;
		}
		
		public function onTimerCompleteCloseMessage(e: TimerEvent = null): void {
			DspObjUtils.hideShow(this, 0, 10, this.destroy);
		}
		
		public function destroy(e: Event = null): void {
			TextFieldUtilsDots.stopAddDots(this);
			DspObjUtils.hideShow(this, 0);
			this.dispatchEvent(new Event(TFMessage.DESTROYED));
		}
		
	}
	
}