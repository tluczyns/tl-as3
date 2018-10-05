package tl.loader {
	import flash.display.Sprite;
	import tl.loader.progress.LoaderProgress;
	import tl.app.InitUtils;
	//import com.greensock.TweenNano;
	//import com.greensock.easing.Linear;
	import caurina.transitions.Tweener;
	import flash.events.Event;
	
	public class LoaderSwfOne extends Sprite {
		
		static public var TIME_HIDE_SHOW: Number = 0.4
		static public var TIME_SHOW_SWF: Number = 0.4;
		
		protected var pathSwf: String;
		protected var loaderProgress: LoaderProgress;
		protected var swf: *;
		
		public function LoaderSwfOne(): void {}
		
		protected function init(pathSwf: String, scaleMode: String = "noScale"): void {
			InitUtils.initApp(this, scaleMode);
			this.pathSwf = pathSwf;
			this.createAndInitLoaderProgress();
		}
		
		private function createAndInitLoaderProgress(): void {
			this.loaderProgress = this.createLoaderProgress();
			this.loaderProgress.addWeightContent(1);
			this.loaderProgress.alpha = 0;
			this.addChild(this.loaderProgress);
			//TweenNano.from(this.loaderProgress, LoaderSwfOne.TIME_HIDE_SHOW, {alpha: 0, ease: Linear.easeNone, onComplete: this.loadSwf});
			Tweener.addTween(this.loaderProgress, {time: LoaderSwfOne.TIME_HIDE_SHOW, alpha: 1, transition: "linear", onComplete: this.loadSwf})
		}
		
		protected function createLoaderProgress(): LoaderProgress {
			return new LoaderProgress(null, this.isTLOrCenterAnchorPointWhenCenterOnStage);
		}
		
		protected function get isTLOrCenterAnchorPointWhenCenterOnStage(): uint {
			return 0;
		}
		
		protected function loadSwf(): void {
			this.swf = new LoaderExt({url: this.pathSwf, onLoadComplete: this.onLoadComplete, onLoadProgress: this.loaderProgress.onLoadProgress});
			this.swf.alpha = 0;
			this.loaderProgress.initNextLoad();
		}
			
		private function onLoadComplete(event: Event): void {
			this.loaderProgress.setLoadProgress(1);
			this.hideLoaderProgressAndShowSwf();
		}
		
		protected function hideLoaderProgressAndShowSwf(): void {
			//TweenNano.to(this.loaderProgress, LoaderSwfOne.TIME_HIDE_SHOW, {alpha: 0, ease: Linear.easeNone, onComplete: this.deleteLoaderProgressAndShowSwf});
			Tweener.addTween(this.loaderProgress, {time: LoaderSwfOne.TIME_HIDE_SHOW, alpha: 0, transition: "linear", onComplete: this.deleteLoaderProgressAndShowSwf})
		}
		
		private function deleteLoaderProgress(): void {
			this.loaderProgress.destroy();
			this.removeChild(this.loaderProgress);
			this.loaderProgress = null;
		}
		
		protected function deleteLoaderProgressAndShowSwf(): void {
			this.deleteLoaderProgress();
			this.showSwf();
		}
		
		protected function initSwfVariables(): void {
			//np: this.swf.content["login"] = (root.loaderInfo.parameters.login) ? String(root.loaderInfo.parameters.login) : "";
		}
		
		protected function get isTweenShow(): Boolean {
			return false;
		}
		
		protected function showSwf(): void {
			this.initSwfVariables();
			this.addChild(this.swf);
			this.swf.alpha = 1 - uint(this.isTweenShow);
			//if (!isTweenShow) TweenNano.from(this.swf.content, LoaderSwfOne.TIME_SHOW_SWF, {alpha: 0, ease: Linear.easeNone, onComplete: this.initSwf});
			if (!isTweenShow) Tweener.addTween(this.swf.content, {time: LoaderSwfOne.TIME_HIDE_SHOW, alpha: 1, transition: "linear", onComplete: this.initSwf})
			else this.initSwf();
		}
		
		protected function initSwf(): void {
			this.destroy();
			if (this.swf.content.init) this.swf.content.init();
		}
		
		protected function destroy(): void {}
		
	}

}