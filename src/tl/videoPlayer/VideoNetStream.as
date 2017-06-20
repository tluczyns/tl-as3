package tl.videoPlayer {
	import flash.net.NetStream;
	import flash.display.MovieClip;
	import com.greensock.plugins.TweenPlugin;
	import com.greensock.plugins.VolumePlugin;
	import flash.net.NetConnection;
	import com.greensock.TweenLite;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import flash.events.NetStatusEvent;
	import flash.events.Event;
	import flash.utils.ByteArray;
	import flash.net.NetStreamAppendBytesAction;
	import com.greensock.easing.Linear;
	
	public class VideoNetStream extends NetStream {
		
		private var _urlOrBaVideo: *;
		private var isLoop: Boolean;
		private var isGoToBeginWhenStop: Boolean;
		private var metadata: Metadata;
		public var isLoaded: Boolean;
		private var mcEF: MovieClip;
		private var filePosBAForSeek: Number = 0;
		private var timeBAForSeek: Number = 0;
		
		public function VideoNetStream(urlOrBaVideo: *, isPausePlay: uint = 0, isLoop: Boolean = false, inBufferSeek: Boolean = false, isGoToBeginWhenStop: Boolean = true, bufferTime: Number = 2): void {
			TweenPlugin.activate([VolumePlugin])
			this.isLoop = isLoop;
			this.inBufferSeek = inBufferSeek;
			this.isGoToBeginWhenStop = isGoToBeginWhenStop;
			var nc: NetConnection = new NetConnection();
			nc.connect(null);
			super(nc);
			this._urlOrBaVideo = urlOrBaVideo;
			this.configStream(bufferTime);
			this.addListeners();
			TweenLite.to(this, 0, {volume: ModelVideoPlayer._volume});
			ModelVideoPlayer.isPausePlay = isPausePlay;
		}

		private function configStream(bufferTime: Number = 2): void {
			this.isLoaded = false;
			this.metadata = new Metadata();
			this.metadata.onMetaData = this.onMetaDataHandler;
			this.client = this.metadata;
			//this.bufferTime = bufferTime;
			ModelVideoPlayer.dispatchEvent(EventModelVideoPlayer.STREAM_SET, this);
			ModelVideoPlayer.addEventListener(EventModelVideoPlayer.VIDEO_CONTAINER_ADDED, this.assignStreamToVideoContainer);
			this.addEventListener(NetStatusEvent.NET_STATUS, this.onNetStatusHandler);
			this.mcEF = new MovieClip();
		}
		
		public function get urlOrBaVideo(): * {
			return this._urlOrBaVideo;
		}
		
		public function set urlOrBaVideo(value: *): void {
			this.close();
			this._urlOrBaVideo = value;
			this.isLoaded = false;
			this.metadata.duration = NaN;
		}
		
		private function assignStreamToVideoContainer(e: EventModelVideoPlayer): void {
			var videoContainer: VideoContainer = VideoContainer(e.data);
			videoContainer.video.attachNetStream(this);
			if (getDefinitionByName(getQualifiedClassName(e.data)) == VideoContainerResizable)
				ModelVideoPlayer.metadata = this.metadata;
		}
		
		private function addListeners(): void {
			ModelVideoPlayer.addEventListener(EventModelVideoPlayer.PAUSE_PLAY, this.pauseOrPlay);	
			ModelVideoPlayer.addEventListener(EventModelVideoPlayer.STOP, this.stop);
			//ModelVideoPlayer.addEventListener(EventModelVideoPlayer.BUFFER_EMPTY, this.stop);
			ModelVideoPlayer.addEventListener(EventModelVideoPlayer.VOLUME_CHANGE, this.volumeChange);
			ModelVideoPlayer.addEventListener(EventModelVideoPlayer.STREAM_SEEK, this.streamSeek);
		}
		
		private function removeListeners(): void {
			ModelVideoPlayer.removeEventListener(EventModelVideoPlayer.PAUSE_PLAY, this.pauseOrPlay);	
			ModelVideoPlayer.removeEventListener(EventModelVideoPlayer.STOP, this.stop);
			//ModelVideoPlayer.removeEventListener(EventModelVideoPlayer.BUFFER_EMPTY, this.stop);
			ModelVideoPlayer.removeEventListener(EventModelVideoPlayer.VOLUME_CHANGE, this.volumeChange);
			ModelVideoPlayer.removeEventListener(EventModelVideoPlayer.STREAM_SEEK, this.streamSeek);
		}
		
		private function pauseOrPlay(e: EventModelVideoPlayer): void {
			var isPausePlay: uint = uint(e.data);
			//trace("isPausePlay:", isPausePlay)
			if (isPausePlay == 0) {
				this.mcEF.dispatchEvent(new Event(Event.ENTER_FRAME));
				this.mcEF.removeEventListener(Event.ENTER_FRAME, this.onEnterFrameProgressHandler);
				this.pause();
			} else if (isPausePlay == 1) {
				ModelVideoPlayer.isStop = false;
				this.mcEF.addEventListener(Event.ENTER_FRAME, this.onEnterFrameProgressHandler);
				this.mcEF.dispatchEvent(new Event(Event.ENTER_FRAME));
				if (this.isLoaded) this.resume();
				else {
					if (this.urlOrBaVideo is String) this.play(this.urlOrBaVideo);
					else if (this.urlOrBaVideo is ByteArray) {
						this.play(null);
						this.appendBytesAction(NetStreamAppendBytesAction.RESET_BEGIN);
						this.appendBytes(this.urlOrBaVideo);
						this.appendBytesAction(NetStreamAppendBytesAction.END_SEQUENCE);
					}
					this.resume();
					this.mcEF.addEventListener(Event.ENTER_FRAME, this.onEnterFrameLoadHandler);
					this.isLoaded = true;
				}
			}
		}

		private function onEnterFrameProgressHandler(e: Event): void {
			if ((this.metadata != null) && (!isNaN(this.metadata.duration))) {
				var time: Number = this.time;
				if (this._urlOrBaVideo is ByteArray) time += this.timeBAForSeek;
				var ratioPlayedTimeStream: Number = time / this.metadata.duration;
				ModelVideoPlayer.dispatchEvent(EventModelVideoPlayer.STREAM_PROGRESS, ratioPlayedTimeStream);
			}
		}
		
		private function onEnterFrameLoadHandler(e: Event):void {
			var ratioLoadedStream: Number = this.bytesLoaded / this.bytesTotal;
			ModelVideoPlayer.dispatchEvent(EventModelVideoPlayer.STREAM_LOAD, ratioLoadedStream);
			if (ratioLoadedStream == 1) this.mcEF.removeEventListener(Event.ENTER_FRAME, this.onEnterFrameLoadHandler);
		}
		
		private function stop(e: EventModelVideoPlayer): void {
			ModelVideoPlayer.isStop = true;
			ModelVideoPlayer.isPausePlay = 0;
			if (this.isGoToBeginWhenStop) ModelVideoPlayer.dispatchEvent(EventModelVideoPlayer.STREAM_SEEK, 0);
		}
		
		private function volumeChange(e: EventModelVideoPlayer): void {
			var volume: Number = Number(e.data);
			TweenLite.to(this, 0.4, {volume: volume, ease: Linear.easeNone});
		}
		
		private function streamSeek(e: EventModelVideoPlayer): void {
			if (this.isLoaded) {
				var ratioPosVideo: Number = Number(e.data);
				var timeSeek: Number = Math.round(ratioPosVideo * [this.metadata.duration, 1][uint(ratioPosVideo > 1)])
				if (this._urlOrBaVideo is ByteArray) {
					var timeNext: Number;
					var timeCurrent: Number;
					for (var i: uint = 0; i < this.metadata.arrKeyFrame.length; i++) {
						timeCurrent = this.metadata.arrKeyFrame[i].time;
						timeNext = (i < this.metadata.arrKeyFrame.length - 1) ? this.metadata.arrKeyFrame[i + 1].time : Infinity;
						if ((timeSeek >= timeCurrent) && (timeSeek < timeNext)) {
							this.filePosBAForSeek = this.metadata.arrKeyFrame[i].filePos;
							this.timeBAForSeek = timeSeek = timeCurrent;
							break;
						}
					}
				}
				this.seek(timeSeek);
				ModelVideoPlayer.dispatchEvent(EventModelVideoPlayer.STREAM_PROGRESS, ratioPosVideo);
			}
		}
		
		/*-------------------------------videoHandlers--------------------------------*/
		
		private function onNetStatusHandler(event: NetStatusEvent): void {
			//trace("code:"+event.info.code);
			switch(event.info.code) {
				case 'NetStream.Play.Start':
					break;
				case 'NetStream.Play.Stop':
					ModelVideoPlayer.dispatchEvent(EventModelVideoPlayer.STREAM_SEEK, 0);
					if (!this.isLoop) ModelVideoPlayer.dispatchEvent(EventModelVideoPlayer.STOP); 
					break;
				case 'NetStream.FileStructureInvalid':				
					break;
				case 'NetStream.Play.StreamNotFound':
					break;
				case 'NetStream.Seek.Notify':
					if (this._urlOrBaVideo is ByteArray) {
						if (this.timeBAForSeek > this.metadata.duration - 0.3) {
							ModelVideoPlayer.dispatchEvent(EventModelVideoPlayer.BUFFER_EMPTY); 
						} else {
							this.appendBytesAction(NetStreamAppendBytesAction.RESET_SEEK);
							var baVideoFromPosSeek: ByteArray = new ByteArray();
							ByteArray(this._urlOrBaVideo).position = this.filePosBAForSeek;
							ByteArray(this._urlOrBaVideo).readBytes(baVideoFromPosSeek);
							this.appendBytes(baVideoFromPosSeek);
						}
					}					
					break;
				case 'NetStream.Buffer.Empty':
					if (this._urlOrBaVideo is ByteArray) ModelVideoPlayer.dispatchEvent(EventModelVideoPlayer.STOP);
					else ModelVideoPlayer.dispatchEvent(EventModelVideoPlayer.STREAM_SEEK, 0);
					ModelVideoPlayer.dispatchEvent(EventModelVideoPlayer.BUFFER_EMPTY); 
					break;
				case 'NetStream.Buffer.Full':
					ModelVideoPlayer.dispatchEvent(EventModelVideoPlayer.BUFFER_FULL); 
					break;
			}
		}
		
		private function onMetaDataHandler(objMetaData: Object): void {
			if (objMetaData.keyframes) {
				this.metadata.arrKeyFrame = new Array(objMetaData.keyframes.times.length);
				for (var i: uint = 0; i < objMetaData.keyframes.times.length; i++)
					this.metadata.arrKeyFrame[i] = {time: objMetaData.keyframes.times[i], filePos: objMetaData.keyframes.filepositions[i]};
			}
			
			this.metadata.width = objMetaData.width;
			this.metadata.height = objMetaData.height;
			this.metadata.seekPoints = objMetaData.seekpoints;
			this.metadata.frameRate = objMetaData.videoframerate;
			this.metadata.duration = objMetaData.duration;
			ModelVideoPlayer.metadata = this.metadata;
		}
		
		public function destroy(): void {
			this.removeListeners();
			ModelVideoPlayer.removeEventListener(EventModelVideoPlayer.VIDEO_CONTAINER_ADDED, this.assignStreamToVideoContainer);	
			this.removeEventListener(NetStatusEvent.NET_STATUS, this.onNetStatusHandler);
			if (this.mcEF) {
				this.mcEF.removeEventListener(Event.ENTER_FRAME, this.onEnterFrameProgressHandler);	
				this.mcEF.removeEventListener(Event.ENTER_FRAME, this.onEnterFrameLoadHandler);
			}
			this.close();
		}
		
	}

}