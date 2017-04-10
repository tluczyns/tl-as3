package tl.videoPlayer {
	import flash.display.Sprite;
	import tl.types.DspObjUtils;
	import flash.events.MouseEvent;

	public class ControllerPausePlay extends ControllerVideoPlayer {
		
		public var indicatorPause: Sprite;
		public var indicatorPlay: Sprite;
		
		public function ControllerPausePlay(): void {
			this.indicatorPause.alpha = 0;
			this.indicatorPlay.alpha = 0;
			ModelVideoPlayer.addEventListener(EventModelVideoPlayer.PAUSE_PLAY, this.setVisibleIndicatorPausePlay);	
		}
		
		private function setVisibleIndicatorPausePlay(e: EventModelVideoPlayer): void {
			var isPausePlay: uint = uint(e.data);
			DspObjUtils.hideShow(this.indicatorPause, isPausePlay, 5);
			DspObjUtils.hideShow(this.indicatorPlay, 1 - isPausePlay, 5);
		}
		
		override protected function onClickHandler(event: MouseEvent): void {
			ModelVideoPlayer.isPausePlay = 1 - ModelVideoPlayer.isPausePlay;
		}
		
		override public function destroy(): void {
			ModelVideoPlayer.removeEventListener(EventModelVideoPlayer.PAUSE_PLAY, this.setVisibleIndicatorPausePlay);	
			super.destroy();
		}
		
	}

}