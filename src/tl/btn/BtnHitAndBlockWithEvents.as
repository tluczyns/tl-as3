package tl.btn {
	import flash.display.Sprite;
	import com.greensock.TweenNano; 
	import com.greensock.easing.*;
	import flash.events.MouseEvent;
	
	public class BtnHitAndBlockWithEvents extends BtnHitWithEvents implements IBtnWithEvents, IBtnBlock, IBtn {
		
		private var _isEnabled: Boolean;
		private var isOver: Boolean;
		
		public function BtnHitAndBlockWithEvents(hit: Sprite = null, isEnabled: Boolean = false): void {
			super(hit);
			this._isEnabled = !isEnabled;
			this.isEnabled = isEnabled;
			this.isOver = false;
		}
		
		protected function setUnblockBlockWhenAddRemoveMouseEvents(isRemoveAdd: uint): void {
			TweenNano.killTweensOf(this);
			TweenNano.to(this, 0.3, {alpha: [0.3, 1][isRemoveAdd], ease: Linear.easeNone});
		}
		
		override public function addMouseEvents(): void {
			this.isEnabled = true;
		}
		
		override public function removeMouseEvents(): void {
			this.isEnabled = false;
		}
		
		override protected function onMouseOver(event: MouseEvent): void {
			this.isOver = true;
			if (this.isEnabled) {
				super.onMouseOver(event);
			}
		}
		
		override protected function onMouseOut(event: MouseEvent): void {
			this.isOver = false;
			if (this.isEnabled) {
				super.onMouseOut(event);
			}
		}
		
		public function get isEnabled(): Boolean {
			return this._isEnabled;
		}
		
		public function set isEnabled(value: Boolean): void {
			if (value != this._isEnabled) {
				if ((this.isOver) && (!value)) this.hit.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OUT, false));
				this._isEnabled = value;
				this.setUnblockBlockWhenAddRemoveMouseEvents(uint(value));
				if (value) {
					this.hit.addEventListener(MouseEvent.MOUSE_OVER, this.onMouseOver);
					this.hit.addEventListener(MouseEvent.MOUSE_OUT, this.onMouseOut);
					super.addMouseEvents();
				} else {
					super.removeMouseEvents();
					this.hit.removeEventListener(MouseEvent.MOUSE_OVER, this.onMouseOver);
					this.hit.removeEventListener(MouseEvent.MOUSE_OUT, this.onMouseOut);
				}
				if ((this.isOver) && (value)) this.hit.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OVER, false));
			}
		}
		
		override public function destroy(): void {
			TweenNano.killTweensOf(this);
			super.destroy();
		}
		
	}

}