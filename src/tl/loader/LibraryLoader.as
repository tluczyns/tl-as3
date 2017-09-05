package tl.loader {
	import flash.display.Sprite;
	import tl.loader.QueueLoadContent;
	import tl.loader.progress.LoaderProgress;
	import caurina.transitions.Tweener;
	import flash.display.DisplayObject;
	
    public class LibraryLoader extends Sprite {
		
		private static const TIME_HIDE_SHOW: Number = 0.2;
		
		private var loaderProgress: LoaderProgress;
		protected var queueLoadContent: QueueLoadContent;
		private var arrIndSwfLib: Array;
		protected var isAllLibrariesLoaded: Boolean;
		public var arrSwfLib: Array;
		
		function LibraryLoader(arrFilenameSwfLib: Array): void {
			this.createAndInitLoaderProgress();
			this.prepareQueueLoadContent(arrFilenameSwfLib);
		}
		
		protected function createLoaderProgress(): LoaderProgress {
			return new LoaderProgress();
		}
		
		private function createAndInitLoaderProgress(): void {
			this.loaderProgress = this.createLoaderProgress();
			this.addChild(this.loaderProgress);
			this.loaderProgress.alpha = 0;
			Tweener.addTween(this.loaderProgress, {alpha: 1, time: LibraryLoader.TIME_HIDE_SHOW, transition: "linear", onComplete: this.startLoading});
		}
		
		private function prepareQueueLoadContent(arrFilenameSwfLib: Array): void {
			this.queueLoadContent = new QueueLoadContent(this.onContentLoadCompleteHandler, this, this.loaderProgress);
			this.loadContent(arrFilenameSwfLib);
		}
		
		protected function loadContent(arrFilenameSwfLib: Array): void {
			this.arrIndSwfLib = [];
			for (var i:uint = 0; i < arrFilenameSwfLib.length; i++) {
				this.arrIndSwfLib.push(this.queueLoadContent.addToLoadQueue(String(arrFilenameSwfLib[i])));
			}
		}
		
		private function startLoading(): void {
			this.queueLoadContent.startLoading();
		}
		
		protected function onContentLoadCompleteHandler(arrContent: Array): void {
			this.isAllLibrariesLoaded = true;
			this.arrSwfLib = new Array(this.arrIndSwfLib.length);
			for (var i:uint = 0; i < this.arrIndSwfLib.length; i++) {
				var objSwfLib: Object = arrContent[this.arrIndSwfLib[i]];
				if (objSwfLib.isLoaded) {
					if (objSwfLib.type == QueueLoadContent.SWF) {
						this.arrSwfLib[i] = objSwfLib.content;
						Library.addSwf(DisplayObject(objSwfLib.content));
					}
				} else this.isAllLibrariesLoaded = false;
			}
			this.hideLoaderProgress();
		}
		
		private function hideLoaderProgress(): void {
			Tweener.addTween(this.loaderProgress, {alpha: 0, time: LibraryLoader.TIME_HIDE_SHOW, transition: "linear", onComplete: this.onHideLoaderProgress});
		}
		
		private function removeLoaderProgress(): void {
			this.loaderProgress.destroy();
			this.removeChild(this.loaderProgress);
			this.loaderProgress = null;
		}
		
		protected function onHideLoaderProgress(): void {
			this.removeLoaderProgress();
			if (this.isAllLibrariesLoaded) this.dispatchEvent(new EventLibraryLoader(EventLibraryLoader.LIBRARIES_LOAD_SUCCESS));
			else this.dispatchEvent(new EventLibraryLoader(EventLibraryLoader.LIBRARIES_LOAD_ERROR));
		}
		
	}
}
