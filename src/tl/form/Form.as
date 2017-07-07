package tl.form {
	import flash.display.Sprite;
	import tl.btn.BtnHitWithEventsSimpleAndEnterCallback;
	import tl.service.DescriptionCall;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import tl.btn.EventBtnHit;
	import flash.net.SharedObject;
	import com.greensock.TweenNano;
	import com.greensock.easing.Linear;
	import tl.types.DspObjUtils;
	import tl.utils.FunctionCallback;
	import com.hurlant.util.Base64;
	import tl.loader.URLLoaderExt;
	import tl.service.ExternalInterfaceExt;
	
	public class Form extends Sprite {
		
		static protected var COUNT_FRAMES_CHANGE_COLOR: uint = 3;
		
		protected var descriptionCall: DescriptionCall;
		private var soName: String;
		protected var tFormatMessage: TextFormat;
		protected var colorsTFWithBg: ColorsTFWithBg;
		protected var colorsTFMessage: ColorsTFMessage;
		protected var isEnterListener: Boolean;
		private var dictTFToSoProp: Dictionary;
		private var dictTFToBgTF: Dictionary;
		protected var dictTFToTFMessageForTF: Dictionary;
		protected var dictTFToStrInit: Dictionary;
		private var dictTFToIsNoData: Dictionary;
		protected var arrTF: Array;
		protected var tfMessage: TFMessageForm;
		public var isProcessing: Boolean;
		public var btnProcess: BtnProcess;
		private var idCallProcessForm: int;
		
		public function Form(descriptionCall: DescriptionCall, soName: String = "", tFormatMessage: TextFormat = null, colorsTFWithBg: ColorsTFWithBg = null, colorsTFMessage: ColorsTFMessage = null, posBtnProcess: Point = null, isEnterListener: Boolean = true): void {
			this.descriptionCall = descriptionCall;
			this.soName = soName;
			this.tFormatMessage = tFormatMessage;
			this.colorsTFWithBg = colorsTFWithBg;
			this.colorsTFMessage = colorsTFMessage ? colorsTFMessage : new ColorsTFMessage();
			this.isEnterListener = isEnterListener;
			this.initSoPropForTFs();
			this.initBgTFForTFs();
			this.initMessageTFForTFs();
			this.initTFs();
			this.addBtnProcess(posBtnProcess);
			if ((this.soName != "") && (this.soName != null)) this.getSoPropSharedObjectAndSetTF();
			this.isProcessing = false;
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		protected function onAddedToStage(e:Event): void {
			this.removeEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
			this.blockUnblock(1);
		}
		
		protected function initSoPropForTFs(): void { 
			this.dictTFToSoProp = new Dictionary();	
		}
		
		protected function initSoPropForTF(soPropName: String, tfToSetSoProp: TextField): void {
			this.dictTFToSoProp[tfToSetSoProp] = soPropName;
		}
		
		protected function initBgTFForTFs(): void { 
			this.dictTFToBgTF = new Dictionary();	
		}
		
		protected function initBgTFForTF(bgTF: DisplayObject, tfToSetBg: TextField): void {
			this.dictTFToBgTF[tfToSetBg] = bgTF;
		}
		
		protected function initMessageTFForTFs(): void {
			this.dictTFToTFMessageForTF = new Dictionary();	
		}
		
		protected function initMessageTFForTF(arrStrBadMessage: Array, tfToSetMessage: TextField, posMessageTF: Point = null): void {
			var tfMessageForTF: TFMessageFormForTF = new TFMessageFormForTF(arrStrBadMessage, this.tFormatMessage, this.colorsTFMessage.colorBadCloseMessage);
			var dspForPositionMessageTF: DisplayObject;
			if (this.dictTFToBgTF[tfToSetMessage]) dspForPositionMessageTF = this.dictTFToBgTF[tfToSetMessage];
			else dspForPositionMessageTF = tfToSetMessage;
			if (!posMessageTF) posMessageTF = new Point(dspForPositionMessageTF.x + dspForPositionMessageTF.width + 5, dspForPositionMessageTF.y + (dspForPositionMessageTF.height - tfMessageForTF.height) / 2);
			tfMessageForTF.x = posMessageTF.x;
			tfMessageForTF.y = posMessageTF.y;
			this.addChild(tfMessageForTF);
			this.dictTFToTFMessageForTF[tfToSetMessage] = tfMessageForTF;
		}
		
		protected function initTFs(): void {
			this.arrTF = new Array();
			this.dictTFToStrInit = new Dictionary();
			this.dictTFToIsNoData = new Dictionary();
		}
		
		protected function initTF(tf: TextField, strInitTF: String): void {
			tf.tabIndex = this.arrTF.length + 1;
			tf.focusRect = false;
			this.addStrInitForTF(tf, strInitTF);
			this.addListenersForTF(tf);
			this.arrTF.push(tf);
		}
		
		private function addStrInitForTF(tf: TextField, strInitTF: String): void {
			tf.text = strInitTF;
			this.dictTFToStrInit[tf] = strInitTF;
		}
		
		protected function addListenersForTF(tf: TextField): void {
			tf.addEventListener(FocusEvent.FOCUS_IN, this.onTFFocusIn);
			tf.addEventListener(FocusEvent.FOCUS_OUT, this.onTFFocusOut);
			tf.addEventListener(Event.CHANGE, this.onTFChanged);
			if (this.isEnterListener) tf.addEventListener(KeyboardEvent.KEY_UP, this.onTFKeyUpHandler)
		}
		
		protected function removeListenersForTF(tf: TextField): void {
			tf.removeEventListener(FocusEvent.FOCUS_IN, this.onTFFocusIn);
			tf.removeEventListener(FocusEvent.FOCUS_OUT , this.onTFFocusOut);
			tf.removeEventListener(Event.CHANGE, this.onTFChanged);
			if (this.isEnterListener) tf.removeEventListener(KeyboardEvent.KEY_UP, this.onTFKeyUpHandler)
			
		}
		
		private function onTFFocusIn(e: FocusEvent): void {
			var tf: TextField  = TextField(e.target);
			if (tf.text == this.dictTFToStrInit[tf]) tf.text = "";
		}
		
		private function onTFFocusOut(e: FocusEvent): void {
			var tf: TextField  = TextField(e.target);
			if (tf.text == "") tf.text = this.dictTFToStrInit[tf];
			this.showBadTFMessage(tf);
		}
		
		protected function onTFChanged(event: Event): void {
			var tf: TextField  = TextField(event.target);
			this.checkIsAllDataAndShowBadTFMessageAndUnblockBtnProcess(tf);
		}
		
		protected function onTFKeyUpHandler(e: KeyboardEvent): void {
			var tf: TextField  = TextField(e.target);
			if (e.keyCode == 13) {
				if (this.checkIsAllData()) this.process();
				else if ((this.checkIsNoData(tf) == 0) && (tf.tabIndex < this.arrTF.length)) this.stage.focus = this.arrTF[tf.tabIndex];
			}
		}
		
		protected function checkIsAllDataAndShowBadTFMessageAndUnblockBtnProcess(tf: TextField): void {
			this.checkIsAllDataAndUnblockBtnProcess();
			this.showBadTFMessage(tf);
		}
		
		protected function showBadTFMessage(tf: TextField): void {
			if (this.dictTFToTFMessageForTF[tf] != null) {
				var messageFormForTF: TFMessageFormForTF = TFMessageFormForTF(this.dictTFToTFMessageForTF[tf]);
				if (this.dictTFToIsNoData[tf] > 0)
					messageFormForTF.showAndCloseMessage(this.dictTFToIsNoData[tf] - 1);
				else messageFormForTF.closeMessage();
			}
		}
		
		protected function addTFMessage(arrTextDurationMessage: Array, arrTextIsBadGoodCloseMessage: Array, posTFMessage: Point): void {
			this.tfMessage = new TFMessageForm(this, arrTextDurationMessage, arrTextIsBadGoodCloseMessage, this.tFormatMessage, this.colorsTFMessage);
			this.tfMessage.x = Math.round(posTFMessage.x);
			this.tfMessage.y = Math.round(posTFMessage.y);
			this.addChild(this.tfMessage);
		}
		
		
		protected function get classBtnProcess(): Class {
			return BtnProcess;
		}
		
		protected function addBtnProcess(posBtnProcess: Point): void {
			this.btnProcess = new this.classBtnProcess();
			this.btnProcess.x = posBtnProcess.x;
			this.btnProcess.y = posBtnProcess.y;
			this.addChild(Sprite(this.btnProcess));
			this.btnProcess.addEventListener(EventBtnHit.CLICKED, this.onBtnProcessClicked);
			this.idCallProcessForm = -1;
			this.checkIsAllDataAndUnblockBtnProcess();
		}
		
		private function removeBtnProcess(): void {
			this.btnProcess.destroy();
			this.removeChild(DisplayObject(this.btnProcess));
			this.btnProcess = null;
		}
		
		private function onBtnProcessClicked(e: EventBtnHit): void {
			this.process();
		}
		
		protected function getTFText(tf: TextField): String {
			return (tf.text == this.dictTFToStrInit[tf]) ? "" : tf.text;
		}
		
		protected function isEmail(strEmail: String): Boolean {
			var posAt: int = strEmail.indexOf("@");
			var countAt: uint = 0;
			while (posAt != -1) {
				posAt = strEmail.indexOf("@", posAt + 1);
				countAt++;
			}
			posAt = strEmail.indexOf("@");
			var posLastDot: int = strEmail.lastIndexOf(".");
			var arrDomains: Array = ["ac", "ad", "ae", "af", "ag", "ai", "al", "am", "an", "ao", "aq", "ar", "as", "at", "au", "aw", "ax", "az", "ba", "bb", "bd", "be", "bf", "bg", "bh", "bi", "bj", "bm", "bn", "bo", "br", "bs", "bt", "bw", "by", "bz", "ca", "cc", "cd", "cf", "cg", "ch", "ci", "ck", "cl", "cm", "cn", "co", "cr", "cu", "cv", "cx", "cy", "cz", "de", "dj", "dk", "dm", "do", "dz", "ec", "ee", "eg", "eo", "er", "es", "et", "eu", "fi", "fj", "fk", "fm", "fo", "fr", "ga", "gd", "ge", "gf", "gg", "gh", "gi", "gl", "gm", "gn", "gp", "gq", "gr", "gs", "gt", "gu", "gw", "gy", "hk", "hm", "hn", "hr", "ht", "hu", "id", "ie", "il", "im", "in", "io", "iq", "ir", "is", "it", "je", "jm", "jo", "jp", "ke", "kg", "kh", "ki", "km", "kn", "kp", "kr", "kw", "ky", "kz", "la", "lb", "lc", "li", "lk", "lr", "ls", "lt", "lu", "lv", "ly", "ma", "mc", "me", "md", "mg", "mh", "mk", "ml", "mm", "mn", "mo", "mp", "mq", "mr", "ms", "mt", "mu", "mv", "mw", "mx", "my", "mz", "na", "nc", "ne", "nf", "ng", "ni", "nl", "no", "np", "nr", "nu", "nz", "om", "pa", "pe", "pf", "pg", "ph", "pk", "pl", "pn", "pr", "ps", "pt", "pw", "py", "qa", "re", "ro", "rs", "ru", "rw", "sa", "sb", "sc", "sd", "se", "sg", "sh", "si", "sk", "sl", "sm", "sn", "sr", "st", "sv", "sy", "sz", "tc", "td", "tf", "tg", "th", "tj", "tk", "tl", "tm", "tn", "to", "tr", "tt", "tv", "tw", "tz", "ua", "ug", "uk", "us", "uy", "uz", "va", "vc", "ve", "vg", "vi", "vn", "vu", "wf", "ws", "ye", "za", "zm", "zw", "tp", "su", "yu", "bu", "bx", "fl", "wa", "biz", "com", "edu", "gov", "info", "int", "mil", "name", "net", "org", "pro", "aero", "cat", "coop", "jobs", "museum", "travel", "mobi", "arpa", "root", "post", "tel", "cym", "geo", "kid", "kids", "mail", "safe", "sco", "web", "xxx"];
			return Boolean((countAt == 1) && (posAt > 0) && (posLastDot != -1) && (posLastDot > posAt + 1) && (posLastDot < strEmail.length - 1) && (arrDomains.indexOf(strEmail.substring(posLastDot + 1, strEmail.length).toLowerCase()) > -1));
		}
		
		protected function checkIsNoData(tf: TextField): uint {
			return 0;
		}
		
		protected function checkIsAllData(): Boolean {
			var isAllData: Boolean = true;
			for (var i: uint = 0; i < this.arrTF.length; i++) {
				var tf: TextField = this.arrTF[i];
				var bgTF: DisplayObject = this.dictTFToBgTF[tf];
				var isNoDataInTF: uint = this.checkIsNoData(tf);
				this.dictTFToIsNoData[tf] = isNoDataInTF;
				var isDataBadOkForDisplay: uint = uint((isNoDataInTF == 0) || (isNoDataInTF >= 3));
				if (this.colorsTFWithBg != null) {
					if ((this.colorsTFWithBg.colorTFBad != -1) && (this.colorsTFWithBg.colorTFOk != -1)) DspObjUtils.setColor(tf, [this.colorsTFWithBg.colorTFBad, this.colorsTFWithBg.colorTFOk][isDataBadOkForDisplay], Form.COUNT_FRAMES_CHANGE_COLOR);
					if ((bgTF) && (this.colorsTFWithBg.colorBgTFBad != -1) && (this.colorsTFWithBg.colorBgTFOk != -1)) DspObjUtils.setColor(bgTF, [this.colorsTFWithBg.colorBgTFBad, this.colorsTFWithBg.colorBgTFOk][isDataBadOkForDisplay], Form.COUNT_FRAMES_CHANGE_COLOR);
				}
				if (isNoDataInTF > 0) isAllData = false;
			}
			return isAllData;
		}
		
		public function checkIsAllDataAndUnblockBtnProcess(): void {
			if (this.btnProcess)
				this.btnProcess.isEnabled = this.checkIsAllData();
		}
		
		internal function unblockAndCheckIsAllDataAndUnblockBtnProcess(): void {
			this.blockUnblock(1);
			this.checkIsAllDataAndUnblockBtnProcess();
		}
		
		private function blockUnblockTextFields(isBlockUnblock: uint): void {
			for (var i: uint = 0; i < this.arrTF.length; i++) {
				var tfToBlockUnblock: TextField = this.arrTF[i];
				if (isBlockUnblock == 0) {
					tfToBlockUnblock.type = "dynamic";
					tfToBlockUnblock.selectable = false;
					this.removeListenersForTF(tfToBlockUnblock);
				} else if ((isBlockUnblock == 1) && (!this.isProcessing)) {
					tfToBlockUnblock.type = "input";
					tfToBlockUnblock.selectable = true;
					this.addListenersForTF(tfToBlockUnblock);
				}
			}
		}
		
		public function blockUnblock(isBlockUnblock: uint): void {
			if ((isBlockUnblock == 1) && (this.isProcessing)) isBlockUnblock = 0;
			this.blockUnblockTextFields(isBlockUnblock);
			if (isBlockUnblock == 0) {
				if (this.btnProcess) this.btnProcess.isEnabled = false;
			} else if (isBlockUnblock == 1) {
				this.checkIsAllDataAndUnblockBtnProcess();
				if ((this.arrTF.length > 0) && (this.stage != null)) {
					var tf: TextField = this.arrTF[0];
					this.stage.focus = tf;
					tf.setSelection(0, tf.length);
				}
			}
		}
		
		//////process url and show/hide process message
		
		public function process(arrParams: Array = null): void {
			this.isProcessing = true;
			this.tfMessage.showDurationMessage(0);
			this.blockUnblock(0);
			if ((this.soName != "") && (this.soName != null)) this.copyStrToSoPropSharedObject();
			this.processUrl(arrParams);
		}
		
		protected function processUrl(arrParams: Array = null): void {
			if (this.descriptionCall.isUrlLoaderServiceAmfExternalInterface == 0) {
				var arrObjHeader: Array;
				if (this.descriptionCall.authorizationDataForUrlLoader)
					arrObjHeader = [{name: "Authorization", value:  "Basic " + Base64.encode(this.descriptionCall.authorizationDataForUrlLoader)}];
				var urlLoaderExt: URLLoaderExt = new URLLoaderExt({url: this.descriptionCall.strUrlOrMethod, objParams: arrParams, isGetPost: 1, callbackEnd: new FunctionCallback(this.onUrlRequestResult, this), arrObjHeader: arrObjHeader});
			} else if (this.descriptionCall.isUrlLoaderServiceAmfExternalInterface == 1) {
				arrParams.unshift(this.descriptionCall.strUrlOrMethod, this.onProcessFormSuccess, this.onProcessFormError);
				this.idCallProcessForm = this.descriptionCall.serviceAmf.callServiceFunction.apply(this.descriptionCall.serviceAmf, arrParams);
				//this.idCallProcessForm = this.descriptionCall.serviceAmf.callServiceFunction(this.descriptionCall.strUrlOrMethod, this.onProcessFormSuccess, this.onProcessFormError, arrParams);
			} else if (this.descriptionCall.isUrlLoaderServiceAmfExternalInterface == 2) {
				ExternalInterfaceExt.addCallback("onExternalInterfaceResult", this);
				arrParams.unshift(this.descriptionCall.strUrlOrMethod);
				ExternalInterfaceExt.call.apply(ExternalInterfaceExt, arrParams);
			}
		}
		
		public function onExternalInterfaceResult(result: uint = 1): void {
			this.showAndCloseProcessFormMessage(true, result);
		}
		
		protected function onUrlRequestResult(isProcessed: Boolean, response: *, params: *): void {
			var result: int = -1;
			try {
				if (isProcessed) {
					var responseXML: XML
					if (response is XML) responseXML = response;
					else responseXML = new XML(response);
					result = uint(responseXML.@result);
				}
			} catch (e: Error) {}
			this.showAndCloseProcessFormMessage(isProcessed, result);
		}
		
		private function onProcessFormSuccess(result: * ): void {
			this.showAndCloseProcessFormMessage(true, result);
		}
		
		private function onProcessFormError(error: Object, typeError: uint): void {
			this.showAndCloseProcessFormMessage(false);
		}
		
		protected function showAndCloseProcessFormMessage(isProcessed: Boolean, result: * = -1): void {
			this.idCallProcessForm = -1;
			var typeMessage: uint;
			if (isProcessed) typeMessage = int(result) + 1;
			else typeMessage = 0;
			this.tfMessage.showAndCloseMessage(typeMessage);
		}
		
		//////
		
		protected function getSoPropSharedObjectAndSetTF(): void {
			var so: SharedObject = SharedObject.getLocal(this.soName, "/");
			if (so != null) {
				for (var tf: * in this.dictTFToSoProp) {
					tf = TextField(tf);
					var soPropName: String = this.dictTFToSoProp[tf];
					var str: String = ((so.data[soPropName] != undefined) ? so.data[soPropName]: null);
					tf.text = (str != null) ? str : this.dictTFToStrInit[tf];	
				}
				so.flush();
				so.close();
			}
		}
		
		private function copyStrToSoPropSharedObject(): void {
			var so: SharedObject = SharedObject.getLocal(this.soName, "/");
			if (so != null) {
				for (var tf: * in this.dictTFToSoProp) {
					tf = TextField(tf);
					var soPropName: String = this.dictTFToSoProp[tf];
					so.data[soPropName] = this.getTFText(tf);
				}
				so.flush();
				so.close();
			}
		}
		
		public function hideShow(isHideShow: uint): void {
			if ((isHideShow == 0) && (this.alpha > 0)) {
				this.alpha -= 0.01;
				this.blockUnblock(0);
				DspObjUtils.hideShow(this, 0);
			} else if ((isHideShow == 1) && (this.alpha < 1)) {
				DspObjUtils.hideShow(this, 1, -1, this.blockUnblock, [1]);
			}
		}
		
		override public function get height(): Number {
			return this.btnProcess.y + this.btnProcess.height;
		}
		
		public function destroy(): void {
			this.blockUnblock(0);
			if (this.idCallProcessForm != -1) this.descriptionCall.serviceAmf.abort(this.idCallProcessForm);
			else if (this.descriptionCall.isUrlLoaderServiceAmfExternalInterface == 2) ExternalInterfaceExt.removeCallback("onExternalInterfaceResult");
			if (this.tfMessage) this.tfMessage.destroy();
			if (this.btnProcess) this.removeBtnProcess();
		}
		
	}

}