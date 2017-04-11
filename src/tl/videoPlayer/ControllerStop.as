package tl.videoPlayer {
	import flash.events.MouseEvent;
	
	public dynamic class ControllerStop extends ControllerVideoPlayer {
		
		public function ControllerStop(): void {}
		
		override protected function onClickHandler(event: MouseEvent): void {
			ModelVideoPlayer.dispatchEvent(EventModelVideoPlayer.STOP, null); 
		}
		
	}

}