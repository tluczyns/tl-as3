package tl.btn {
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	public class BtnHit extends MovieClip implements IBtn {
		
		public var hit: Sprite;
		
		public function BtnHit(hit: Sprite = null, rectDimension: Rectangle = null): void {
			this.initHit(hit, rectDimension);
			this.addMouseEvents();
		}

		private function initHit(hit: Sprite = null, rectDimension: Rectangle = null): void {
			if (this.hit == null) { 
				if (!hit) hit = this.createGenericHit(rectDimension);
				hit.alpha = 0;
				this.addChild(hit);
				this.hit = hit;
			}
		}
		
		public function createGenericHit(rectDimension: Rectangle = null): Sprite {
			if (rectDimension == null) rectDimension = this.getRect(this);
			var hit: Sprite = new Sprite();
			hit.x = rectDimension.x;
			hit.y = rectDimension.y;
			hit.graphics.beginFill(0x000000, 0);
			hit.graphics.drawRect(0, 0, rectDimension.width + 0.1, rectDimension.height + 0.1);
			hit.graphics.endFill();
			return hit;
		}
		
		public function createGenericHitAndAddMouseEvents(rectDimension: Rectangle = null): void {
			this.createGenericHit(rectDimension);
			this.addMouseEvents();
		}
		
		public function addMouseEvents(): void {
			this.hit.tabEnabled = false;	
			if (!this.hit.buttonMode) {
				this.dispatchEvent(new EventBtnHit(EventBtnHit.OUT));
				this.hit.buttonMode = true;
				this.hit.addEventListener(MouseEvent.MOUSE_OVER, this.onMouseOver);
				this.hit.addEventListener(MouseEvent.MOUSE_OUT, this.onMouseOut);
				this.hit.addEventListener(MouseEvent.MOUSE_DOWN, this.onMouseDown);
				this.hit.addEventListener(MouseEvent.MOUSE_UP, this.onMouseUp);
				this.hit.addEventListener(MouseEvent.CLICK, this.onClick);
				this.hit.addEventListener(MouseEvent.MOUSE_OVER, this.onMouseOverForMouseMove);
				this.hit.addEventListener(MouseEvent.MOUSE_MOVE, this.onMouseMove);
			}
		}
		
		public function removeMouseEvents(): void {
			if (this.hit.buttonMode) {
				this.dispatchEvent(new EventBtnHit(EventBtnHit.OUT));
				this.hit.buttonMode = false;
				this.hit.removeEventListener(MouseEvent.MOUSE_OVER, this.onMouseOver);
				this.hit.removeEventListener(MouseEvent.MOUSE_OUT, this.onMouseOut);
				this.hit.removeEventListener(MouseEvent.MOUSE_DOWN, this.onMouseDown);
				this.hit.removeEventListener(MouseEvent.MOUSE_UP, this.onMouseUp);
				this.hit.removeEventListener(MouseEvent.CLICK, this.onClick);
				if (this.hit.hasEventListener(MouseEvent.MOUSE_MOVE)) {
					this.hit.removeEventListener(MouseEvent.MOUSE_MOVE, this.onMouseMove);
					this.hit.removeEventListener(MouseEvent.MOUSE_OVER, this.onMouseOverForMouseMove);
				}
			}
		}

		protected function onMouseOver(e: MouseEvent): void {
			this.dispatchEvent(new EventBtnHit(EventBtnHit.OVER));
		}
		
		protected function onMouseOut(e: MouseEvent): void {
			this.dispatchEvent(new EventBtnHit(EventBtnHit.OUT));	
		}
		
		private function onMouseDown(e: MouseEvent): void {
			this.dispatchEvent(new EventBtnHit(EventBtnHit.DOWN));
		}
		
		private function onMouseUp(e: MouseEvent): void {
			this.dispatchEvent(new EventBtnHit(EventBtnHit.UP));	
		}
		
		private function onClick(e: MouseEvent): void {
			this.dispatchEvent(new EventBtnHit(EventBtnHit.CLICKED));
		}
		
		private function onMouseOverForMouseMove(e: MouseEvent): void {
			if (this.hit.hasEventListener(MouseEvent.MOUSE_MOVE)) {
				this.hit.removeEventListener(MouseEvent.MOUSE_MOVE, this.onMouseMove);
				this.hit.removeEventListener(MouseEvent.MOUSE_OVER, this.onMouseOverForMouseMove);
			}
		}
		
		private function onMouseMove(e: MouseEvent): void {
			this.hit.removeEventListener(MouseEvent.MOUSE_MOVE, this.onMouseMove);
			this.hit.removeEventListener(MouseEvent.MOUSE_OVER, this.onMouseOverForMouseMove);
			this.onMouseOver(e);
		}
		
		protected function removeHit(): void {
			if (this.hit != null) {
				this.removeChild(this.hit);
				this.hit = null;
			}
		}
		
		public function destroy(): void {
			this.removeMouseEvents();
			this.removeHit();
		}
		
	}

}