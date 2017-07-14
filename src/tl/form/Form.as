package tl.form {
	import flash.display.Sprite;
	import tl.service.DescriptionCall;
	import flash.utils.Dictionary;
	import flash.text.TextFormat;
	import tl.so.SharedObjectInstance;
	import tl.btn.BtnHit;
	import tl.btn.InjectorBtnHitClickedOnKeyEnter;
	import flash.events.Event;
	import flash.display.DisplayObject;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.geom.Point;
	import flash.events.FocusEvent;
	import tl.btn.EventBtnHit;
	import tl.types.DspObjUtils;
	import com.hurlant.util.Base64;
	import tl.loader.URLLoaderExt;
	import tl.utils.FunctionCallback;
	import tl.service.ExternalInterfaceExt;
	
	public class Form extends Sprite {
		
		static protected var COUNT_FRAMES_CHANGE_COLOR: uint = 3;
		
		protected var descriptionCall: DescriptionCall;
		
		protected var colorsTFWithBg: ColorsTFWithBg;
		protected var colorsTFMessage: ColorsTFMessage;
		protected var isEnterListener: Boolean;
		private var dictTFToSoProp: Dictionary;
		private var dictTFToBgTF: Dictionary;
		protected var dictTFToTFMessageForTF: Dictionary;
		private var tFormatMessageForTF: TextFormat;
		private var so: SharedObjectInstance;
		protected var dictTFToStrInit: Dictionary;
		private var dictTFToIsNoData: Dictionary;
		protected var arrTF: Array;
		protected var tfMessage: TFMessageForm;
		public var isSubmitting: Boolean;
		public var btnSubmit: BtnHit;
		private var injectorBtnSubmitClickedOnKeyEnter: InjectorBtnHitClickedOnKeyEnter;
		private var idCallSubmitForm: int;
		
		public function Form(descriptionCall: DescriptionCall, soName: String = "", tFormatMessageForTF: TextFormat = null, colorsTFWithBg: ColorsTFWithBg = null, colorsTFMessage: ColorsTFMessage = null, isEnterListener: Boolean = true): void {
			this.descriptionCall = descriptionCall;
			this.colorsTFWithBg = colorsTFWithBg;
			this.colorsTFMessage = colorsTFMessage ? colorsTFMessage : new ColorsTFMessage();
			this.isEnterListener = isEnterListener;
			this.initSoPropForTFs();
			this.initBgTFForTFs();
			this.initMessageTFForTFs(tFormatMessageForTF);
			this.createSO(soName);
			this.initTFs();
			this.isSubmitting = false;
			this.createBtnSubmit();
			this.addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
		}
		
		protected function onAddedToStage(e:Event): void {
			this.removeEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
			if (this.isEnterListener) this.injectorBtnSubmitClickedOnKeyEnter = new InjectorBtnHitClickedOnKeyEnter(this.btnSubmit);
			this.blockUnblock(1);
		}
		
		protected function initBgTFForTFs(): void { 
			this.dictTFToBgTF = new Dictionary();	
		}
		
		protected function initBgTFForTF(bgTF: DisplayObject, tfToSetBg: TextField): void {
			this.dictTFToBgTF[tfToSetBg] = bgTF;
		}
		
		protected function initMessageTFForTFs(tFormatMessageForTF: TextFormat): void {
			this.dictTFToTFMessageForTF = new Dictionary();	
			this.tFormatMessageForTF = tFormatMessageForTF;
		}
		
		protected function createMessageTFForTF(arrStrBadMessage: Array, tfToSetMessage: TextField, autoSize: String = TextFieldAutoSize.LEFT, posTFMessageForTF: Point = null): TFMessageFormForTF {
			var tfMessageForTF: TFMessageFormForTF = new TFMessageFormForTF(arrStrBadMessage, this.colorsTFMessage.colorBadHideMessage, this.tFormatMessageForTF, autoSize);
			this.addChild(tfMessageForTF);
			if (posTFMessageForTF) {
				tfMessageForTF.x = posTFMessageForTF.x;
				tfMessageForTF.y = posTFMessageForTF.y;
			}
			this.dictTFToTFMessageForTF[tfToSetMessage] = tfMessageForTF;
			return tfMessageForTF;
		}
		
		protected function initSoPropForTFs(): void { 
			this.dictTFToSoProp = new Dictionary();	
		}
		
		protected function initSoPropForTF(soPropName: String, tfToSetSoProp: TextField): void {
			this.dictTFToSoProp[tfToSetSoProp] = soPropName;
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
			var strFromSOForTF: String;
			if (this.so) strFromSOForTF = this.so.getPropValue(this.dictTFToSoProp[tf]);
			tf.text = ((strFromSOForTF) && (strFromSOForTF != "")) ? strFromSOForTF : strInitTF;
			this.dictTFToStrInit[tf] = strInitTF;
		}
		
		protected function addListenersForTF(tf: TextField): void {
			tf.addEventListener(FocusEvent.FOCUS_IN, this.onTFFocusIn);
			tf.addEventListener(FocusEvent.FOCUS_OUT, this.onTFFocusOut);
			tf.addEventListener(Event.CHANGE, this.onTFChanged);
		}
		
		protected function removeListenersForTF(tf: TextField): void {
			tf.removeEventListener(FocusEvent.FOCUS_IN, this.onTFFocusIn);
			tf.removeEventListener(FocusEvent.FOCUS_OUT , this.onTFFocusOut);
			tf.removeEventListener(Event.CHANGE, this.onTFChanged);
		}
		
		protected function onTFFocusIn(e: FocusEvent): void {
			var tf: TextField  = TextField(e.target);
			if (tf.text == this.dictTFToStrInit[tf]) tf.text = "";
		}
		
		protected function onTFFocusOut(e: FocusEvent): void {
			var tf: TextField  = TextField(e.target);
			if (tf.text == "") tf.text = this.dictTFToStrInit[tf];
			this.checkAndHideShowBadTFMessage(tf);
		}
		
		protected function onTFChanged(event: Event): void {
			this.checkIsAllDataAndSetEnableBtnSubmit();
			this.checkAndHideShowBadTFMessage(TextField(event.target));
		}
		
		protected function checkAndHideShowBadTFMessage(tf: TextField): void {
			if (this.dictTFToTFMessageForTF[tf] != null) {
				var messageFormForTF: TFMessageFormForTF = TFMessageFormForTF(this.dictTFToTFMessageForTF[tf]);
				if (this.dictTFToIsNoData[tf] > 0)
					messageFormForTF.showAndHideMessage(this.dictTFToIsNoData[tf] - 1);
				else messageFormForTF.hideMessage();
			}
		}
		
		//so
		
		private function createSO(soName: String): void {
			if ((soName) && (soName != "")) this.so = new SharedObjectInstance(soName);
		}

		private function removeSO(): void {
			if (this.so) {
				this.so.destroy();
				this.so = null;
			}
		}
		
		//tf message
		
		protected function createTFMessage(arrDurationMessage: Array, arrBadMessage: Array, arrGoodMessage: Array, tFormatMessage: TextFormat = null, widthTFMessage: Number = 0, posTFMessage: Point = null): void {
			this.tfMessage = new TFMessageForm(this, arrDurationMessage, arrBadMessage, arrGoodMessage, this.colorsTFMessage, tFormatMessage, widthTFMessage);
			if (posTFMessage) {
				this.tfMessage.x = Math.round(posTFMessage.x);
				this.tfMessage.y = Math.round(posTFMessage.y);
			}
			this.addChild(this.tfMessage);
		}
		
		private function removeTFMessage(): void {
			this.removeChild(this.tfMessage);
			this.tfMessage.destroy();
			this.tfMessage = null;
			
		}
		
		//btn submit
		
		protected function get classBtnSubmit(): Class {
			return BtnHit;
		}
		
		protected function createBtnSubmit(): void {
			this.btnSubmit = new this.classBtnSubmit();
			this.addChild(this.btnSubmit);
			this.btnSubmit.addEventListener(EventBtnHit.CLICKED, this.onBtnSubmitClicked);
			this.idCallSubmitForm = -1;
			this.checkIsAllDataAndSetEnableBtnSubmit();
		}
		
		private function removeBtnSubmit(): void {
			if (this.isEnterListener) {
				this.injectorBtnSubmitClickedOnKeyEnter.destroy();
				this.injectorBtnSubmitClickedOnKeyEnter = null;
			}
			this.btnSubmit.destroy();
			this.removeChild(DisplayObject(this.btnSubmit));
			this.btnSubmit = null;
		}
		
		private function onBtnSubmitClicked(e: EventBtnHit): void {
			if (this.checkIsAllData()) this.submit();
		}
		
		//
		
		protected function getTFText(tf: TextField): String {
			return (tf.text == this.dictTFToStrInit[tf]) ? "" : tf.text;
		}
		
		protected function checkIsNoData(tf: TextField): uint {
			return 0;
		}
		
		protected function checkIsAllData(isSetFocusOnNoDataInTF: Boolean = false): Boolean {
			var isAllData: Boolean = true;
			for (var i: uint = 0; i < this.arrTF.length; i++) {
				var tf: TextField = this.arrTF[i];
				var bgTF: DisplayObject = this.dictTFToBgTF[tf];
				var isNoDataInTF: uint = this.checkIsNoData(tf);
				if ((isSetFocusOnNoDataInTF) && (isNoDataInTF == 0)) this.stage.focus = tf;
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
		
		public function checkIsAllDataAndSetEnableBtnSubmit(isSetFocusOnNoDataInTF: Boolean = false): void {
			this.btnSubmit.isEnabled = this.checkIsAllData(isSetFocusOnNoDataInTF);
		}
		
		private function blockUnblockTextFields(isBlockUnblock: uint): void {
			for (var i: uint = 0; i < this.arrTF.length; i++) {
				var tfToBlockUnblock: TextField = this.arrTF[i];
				if (isBlockUnblock == 0) {
					tfToBlockUnblock.type = "dynamic";
					tfToBlockUnblock.selectable = false;
					this.removeListenersForTF(tfToBlockUnblock);
				} else if ((isBlockUnblock == 1) && (!this.isSubmitting)) {
					tfToBlockUnblock.type = "input";
					tfToBlockUnblock.selectable = true;
					this.addListenersForTF(tfToBlockUnblock);
				}
			}
		}
		
		public function blockUnblock(isBlockUnblock: uint): void {
			if ((isBlockUnblock == 1) && (this.isSubmitting)) isBlockUnblock = 0;
			this.blockUnblockTextFields(isBlockUnblock);
			if (isBlockUnblock == 0) {
				if (this.btnSubmit) this.btnSubmit.isEnabled = false;
			} else if (isBlockUnblock == 1) {
				this.checkIsAllDataAndSetEnableBtnSubmit(true);
				if ((this.arrTF.length > 0) && (this.stage != null)) {
					var tf: TextField = this.arrTF[0];
					this.stage.focus = tf;
					tf.setSelection(0, tf.length);
				}
			}
		}
		
		//////submit url and show/hide submit message
		
		protected function get arrParamsSubmit(): Array {
			return [];
		}
		
		protected function submit(): void {
			this.isSubmitting = true;
			if (this.tfMessage) this.tfMessage.showDurationMessage(0);
			this.blockUnblock(0);
			this.copyStrTFToSoProps();
			var arrParams: Array = this.arrParamsSubmit;
			if (this.descriptionCall.isUrlLoaderOrServiceAmfOrExternalInterfaceOrCustomMethod == 0) {
				var arrObjHeader: Array;
				if (this.descriptionCall.authorizationDataForUrlLoader)
					arrObjHeader = [{name: "Authorization", value:  "Basic " + Base64.encode(this.descriptionCall.authorizationDataForUrlLoader)}];
				var urlLoaderExt: URLLoaderExt = new URLLoaderExt({url: this.descriptionCall.strUrlOrMethod, objParams: arrParams, isGetPost: 1, callback: new FunctionCallback(this.onUrlRequestResult, this), arrObjHeader: arrObjHeader});
			} else if (this.descriptionCall.isUrlLoaderOrServiceAmfOrExternalInterfaceOrCustomMethod == 1) {
				arrParams.unshift(this.descriptionCall.strUrlOrMethod, this.onSubmitFormSuccess, this.onSubmitFormError);
				this.idCallSubmitForm = this.descriptionCall.serviceAmf.callServiceFunction.apply(this.descriptionCall.serviceAmf, arrParams);
				//this.idCallSubmitForm = this.descriptionCall.serviceAmf.callServiceFunction(this.descriptionCall.strUrlOrMethod, this.onSubmitFormSuccess, this.onSubmitFormError, arrParams);
			} else if (this.descriptionCall.isUrlLoaderOrServiceAmfOrExternalInterfaceOrCustomMethod == 2) {
				ExternalInterfaceExt.addCallback("onExternalInterfaceResult", this);
				arrParams.unshift(this.descriptionCall.strUrlOrMethod);
				ExternalInterfaceExt.call.apply(ExternalInterfaceExt, arrParams);
			} else if (this.descriptionCall.isUrlLoaderOrServiceAmfOrExternalInterfaceOrCustomMethod == 3) {
				this[this.descriptionCall.strUrlOrMethod]();
			}
		}
		
		private function copyStrTFToSoProps(): void {
			if (this.so) {
				for (var tf: * in this.dictTFToSoProp) {
					tf = TextField(tf);
					this.so.setPropValue(this.dictTFToSoProp[tf], this.getTFText(tf));
				}
			}
		}
		
		public function onExternalInterfaceResult(result: Object): void {
			this.showAndHideSubmitFormMessage(result.num, result.isBadGood);
		}
		
		protected function onUrlRequestResult(isSuccess: Boolean, response: *, params: *): void {
			var num: uint = 0;
			var isBadGood: uint = 0;
			try {
				if (isSuccess) {
					var responseXML: XML
					if (response is XML) responseXML = response;
					else responseXML = new XML(response);
					num = uint(responseXML.@numResult);
					isBadGood = uint(responseXML.@isBadGoodResult);
				}
			} catch (e: Error) {}
			this.showAndHideSubmitFormMessage(num, isBadGood);
		}
		
		private function onSubmitFormSuccess(result: *): void {
			this.idCallSubmitForm = -1;
			this.showAndHideSubmitFormMessage(result.num, result.isBadGood);
		}
		
		private function onSubmitFormError(error: Object, typeError: uint): void {
			this.idCallSubmitForm = -1;
			this.showAndHideSubmitFormMessage(0, 0);
		}
		
		protected function showAndHideSubmitFormMessage(num: uint, isBadGood: uint): void {
			if (this.tfMessage) this.tfMessage.showResponseMessage(num, isBadGood);
		}
		
		//////
		
		public function hideShow(isHideShow: uint): void {
			if ((isHideShow == 0) && (this.alpha > 0)) {
				this.blockUnblock(0);
				DspObjUtils.hideShow(this, 0);
			} else if ((isHideShow == 1) && (this.alpha < 1)) {
				DspObjUtils.hideShow(this, 1, -1, this.blockUnblock, [1]);
			}
		}
		
		override public function get height(): Number {
			return this.btnSubmit.y + this.btnSubmit.height;
		}
		
		public function destroy(): void {
			this.blockUnblock(0);
			if (this.idCallSubmitForm != -1) this.descriptionCall.serviceAmf.abort(this.idCallSubmitForm);
			else if (this.descriptionCall.isUrlLoaderOrServiceAmfOrExternalInterfaceOrCustomMethod == 2) ExternalInterfaceExt.removeCallback("onExternalInterfaceResult");
			if (this.tfMessage) this.removeTFMessage();
			if (this.btnSubmit) this.removeBtnSubmit();
			this.removeSO();
		}
		
	}

}