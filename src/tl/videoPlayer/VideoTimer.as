package tl.videoPlayer {
	import flash.display.Sprite;
	import flash.text.TextField;
	import tl.types.StringUtils;
	
	public class VideoTimer extends Sprite {
		
		public var tfDuration: TextField;
		public var tfTimePlayed: TextField;
		private var _duration: Number = 0;
		
		public function VideoTimer(): void {
			if (ModelVideoPlayer.metadata) this.duration = ModelVideoPlayer.metadata.duration;
			ModelVideoPlayer.addEventListener(EventModelVideoPlayer.METADATA_SET, this.setTfDuration);
			ModelVideoPlayer.addEventListener(EventModelVideoPlayer.STREAM_PROGRESS, this.setTfTimePlayed);
		}
		
		private function setTfDuration(e: EventModelVideoPlayer): void {
			if (Metadata(e.data).duration)
				this.duration = Metadata(e.data).duration;
		}
		
		public function get duration(): Number {
			return _duration;
		}
		
		public function set duration(value: Number): void {
			this.tfDuration.text = this.getStrFromTime(value);
			this._duration = value;
		}
		
		private function setTfTimePlayed(e: EventModelVideoPlayer): void {
			var ratioPlayedTimeStream: Number = Number(e.data);
			this.tfTimePlayed.text = this.getStrFromTime(ratioPlayedTimeStream * this.duration);
		}

		private function getStrFromTime(time: Number): String {
			time = Math.round(time);
			return (StringUtils.addZerosBeforeNumberAndReturnString(Math.floor(time / 60), 2) + ":" + StringUtils.addZerosBeforeNumberAndReturnString(time % 60, 2)); 
		}
		
		public function destroy(): void {
			ModelVideoPlayer.removeEventListener(EventModelVideoPlayer.METADATA_SET, this.setTfDuration);
			ModelVideoPlayer.removeEventListener(EventModelVideoPlayer.STREAM_PROGRESS, this.setTfTimePlayed);
		}
		
	}
	
}