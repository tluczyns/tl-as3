﻿package tl.videoPlayer {
	import flash.display.Sprite;
	import com.greensock.TweenNano;
	import tl.types.DspObjUtils;
	import com.greensock.easing.Linear;
	import flash.events.MouseEvent;
	
	public class VideoCover extends ControllerVideoPlayer {
		
		public var imgSplash: Sprite;
		public var markPausePlay: ControllerPausePlay;
		
		public var isOver: Boolean = false;
		
		public function VideoCover(): void {
			super();
		}
		
		override public function addMouseEvents(): void {
			super.addMouseEvents();
			if (this.imgSplash != null) {
				ModelVideoPlayer.addEventListener(EventModelVideoPlayer.PAUSE_PLAY, this.hideImgSplashWhenPlay);
				ModelVideoPlayer.addEventListener(EventModelVideoPlayer.STOP, this.showImgSplashWhenStop);	
			}
			ModelVideoPlayer.addEventListener(EventModelVideoPlayer.PAUSE_PLAY, this.hideShowMarkPausePlayFromEvent);
			this.markPausePlay.alpha = 0;
		}
		
		override public function removeMouseEvents(): void {
			if (this.imgSplash != null) {
				ModelVideoPlayer.removeEventListener(EventModelVideoPlayer.PAUSE_PLAY, this.hideImgSplashWhenPlay);
				ModelVideoPlayer.removeEventListener(EventModelVideoPlayer.STOP, this.showImgSplashWhenStop);	
				TweenNano.killTweensOf(this.imgSplash);
			}
			ModelVideoPlayer.removeEventListener(EventModelVideoPlayer.PAUSE_PLAY, this.hideShowMarkPausePlayFromEvent);
			TweenNano.killTweensOf(this.markPausePlay);
			this.markPausePlay.removeMouseEvents();
			super.removeMouseEvents();
		}
		
		private function hideImgSplashWhenPlay(e: EventModelVideoPlayer): void {
			var isPlay: Boolean = Boolean(uint(e.data));
			if (isPlay) DspObjUtils.hideShow(this.imgSplash, 0, 5);
		}
		
		private function showImgSplashWhenStop(e: EventModelVideoPlayer): void {
			DspObjUtils.hideShow(this.imgSplash, 1, 5);
		}
		
		private function hideShowMarkPausePlay(isHideShow: uint, isFromMouseOrEvent: uint): void {
			var targetAlpha: Number;
			if (isHideShow == 0) targetAlpha = [0, 0.15][uint(this.isOver)]
			else if (isHideShow == 1) targetAlpha = [0.15, 1][isFromMouseOrEvent];
			TweenNano.killTweensOf(this.markPausePlay);
			TweenNano.to(this.markPausePlay, 5, {alpha: targetAlpha, ease: Linear.easeNone, delay: [0, 5][uint((isFromMouseOrEvent == 1) && (isHideShow == 1))], useFrames: true});
		}
		
		private function hideShowMarkPausePlayFromEvent(e: EventModelVideoPlayer): void {
			var isPausePlay: uint = uint(e.data);
			this.hideShowMarkPausePlay(1 - isPausePlay, 1);
		}
		
		override protected function onMouseOverHandler(event: MouseEvent): void {
			this.isOver = true;
			if (ModelVideoPlayer.isPausePlay == 1) this.hideShowMarkPausePlay(1, 0);
		}
		
		override protected function onMouseOutHandler(event: MouseEvent): void {
			this.isOver = false;
			if (ModelVideoPlayer.isPausePlay == 1) this.hideShowMarkPausePlay(0, 0);
		}
		
		override protected function onClickHandler(event: MouseEvent): void {
			if (this.alpha > 0) this.markPausePlay.hit.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
		}
		
	}

}