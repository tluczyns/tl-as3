package tl.videoPlayer {
	import flash.display.Sprite;
	import tl.types.DspObjUtils;
	import flash.events.MouseEvent;

	public dynamic class ControllerSoundOffOn extends ControllerVideoPlayer {
		
		public var indicatorSoundOff: Sprite;
		public var indicatorSoundOn: Sprite;
		private var oldVolume: Number;
		
		public function ControllerSoundOffOn(): void {
			if (ModelVideoPlayer.volume > 0) this.oldVolume = ModelVideoPlayer.volume;
			else this.oldVolume = 1;
			this.indicatorSoundOff.alpha = 0;
			this.indicatorSoundOn.alpha = 0;
			ModelVideoPlayer.addEventListener(EventModelVideoPlayer.VOLUME_CHANGE, this.setVisibleIndicator);
			this.setVisibleIndicator();
		}
		
		protected function setVisibleIndicator(e: EventModelVideoPlayer = null): void {
			var isSoundOffOn: uint = Math.ceil(Number(e ? e.data : ModelVideoPlayer.volume));
			DspObjUtils.hideShow(this.indicatorSoundOff, 1 - isSoundOffOn);
			DspObjUtils.hideShow(this.indicatorSoundOn, isSoundOffOn);
		}
		
		override protected function onClickHandler(event: MouseEvent): void {
			if (ModelVideoPlayer.volume > 0) this.oldVolume = ModelVideoPlayer.volume;
			ModelVideoPlayer.volume = [this.oldVolume, 0][uint(ModelVideoPlayer.volume > 0)];
		}
		
		override public function destroy(): void {
			ModelVideoPlayer.removeEventListener(EventModelVideoPlayer.VOLUME_CHANGE, this.setVisibleIndicator);
			super.destroy();
		}
		
	}

}