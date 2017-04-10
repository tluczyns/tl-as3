package tl.videoPlayer {
	import flash.display.Sprite;
	import tl.types.DspObjUtils;
	import flash.events.MouseEvent;

	public class ControllerSoundOffOn extends ControllerVideoPlayer {
		
		public var indicator: Sprite;
		private var oldVolume: Number;
		
		public function ControllerSoundOffOn(): void {
			this.oldVolume = 1;
			this.indicator.alpha = 0;
			ModelVideoPlayer.addEventListener(EventModelVideoPlayer.VOLUME_CHANGE, this.setVisibleIndicator);
		}
		
		protected function setVisibleIndicator(e: EventModelVideoPlayer): void {
			var isSoundOffOn: uint = Math.ceil(Number(e.data));
			DspObjUtils.hideShow(this.indicator, 1 - isSoundOffOn);
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