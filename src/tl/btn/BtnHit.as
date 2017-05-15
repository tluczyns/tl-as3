package tl.btn {
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.events.MouseEvent;
	import caurina.transitions.Tweener;	
	
	public class BtnHit extends MovieClip implements IBtn {
		
		private var _isEnabled: Boolean;
		private var isOver: Boolean;
		
		public var hit: Sprite;
		
		public function BtnHit(hit: Sprite = null, isEnabled: Boolean = true, rectDimension: Rectangle = null): void {
			this.initHit(hit, rectDimension);
			this.addMouseEventsForIsOver();
			this.isOver = false;
			this._isEnabled = !isEnabled;
			this.isEnabled = isEnabled;
		}
		
		//hit
		
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
		
		//mouse events for isOver
		
		private function addMouseEventsForIsOver(): void {
			this.hit.addEventListener(MouseEvent.MOUSE_OVER, this.onMouseOverBase);
			this.hit.addEventListener(MouseEvent.MOUSE_OUT, this.onMouseOutBase);
		}
		
		
		private function removeMouseEventsForIsOver(): void {
			this.hit.removeEventListener(MouseEvent.MOUSE_OUT, this.onMouseOutBase);
			this.hit.removeEventListener(MouseEvent.MOUSE_OVER, this.onMouseOverBase);
		}
		
		private function onMouseOverBase(e: MouseEvent): void {
			this.isOver = true;
		}
		
		private function onMouseOutBase(e: MouseEvent): void {
			this.isOver = false;
		}
		
		//mouse events
		
		private function addMouseEvents(): void {
			this.hit.tabEnabled = false;	
			if (!this.hit.buttonMode) {
				this.dispatchEvent(new EventBtnHit(EventBtnHit.OUT));
				this.hit.buttonMode = true;
				this.hit.addEventListener(MouseEvent.MOUSE_OVER, this.onMouseOver);
				this.hit.addEventListener(MouseEvent.MOUSE_OUT, this.onMouseOut);
				this.hit.addEventListener(MouseEvent.MOUSE_DOWN, this.onMouseDown);
				this.hit.addEventListener(MouseEvent.MOUSE_UP, this.onMouseUp);
				this.hit.addEventListener(MouseEvent.CLICK, this.onClick);
			}
		}
		
		private function removeMouseEvents(): void {
			if (this.hit.buttonMode) {
				this.dispatchEvent(new EventBtnHit(EventBtnHit.OUT));
				this.hit.buttonMode = false;
				this.hit.removeEventListener(MouseEvent.MOUSE_OVER, this.onMouseOver);
				this.hit.removeEventListener(MouseEvent.MOUSE_OUT, this.onMouseOut);
				this.hit.removeEventListener(MouseEvent.MOUSE_DOWN, this.onMouseDown);
				this.hit.removeEventListener(MouseEvent.MOUSE_UP, this.onMouseUp);
				this.hit.removeEventListener(MouseEvent.CLICK, this.onClick);
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
		
		//set enabled
		
		public function get isEnabled(): Boolean {
			return this._isEnabled;
		}
		
		public function set isEnabled(value: Boolean): void {
			if (value != this._isEnabled) {
				if ((this.isOver) && (!value)) this.onMouseOut(null);
				this._isEnabled = value;
				this.setElementsIsEnabled(uint(value));
				if (value) this.addMouseEvents();
				else this.removeMouseEvents();
				if ((this.isOver) && (value)) this.onMouseOver(null);
			}
		}
		
		protected function setElementsIsEnabled(isDisabledEnabled: uint): void {
			Tweener.removeTweens(this);
			Tweener.addTween(this, {time: 0.3, alpha: [0.3, 1][isDisabledEnabled], transition: "linear"});
			//TweenNano.killTweensOf(this);
			//TweenNano.to(this, 0.3, {alpha: [0.3, 1][isRemoveAdd], ease: Linear.easeNone});
		}
		
		//
		
		protected function removeHit(): void {
			if (this.hit != null) {
				this.removeChild(this.hit);
				this.hit = null;
			}
		}
		
		public function destroy(): void {
			Tweener.removeTweens(this);
			//TweenNano.killTweensOf(this);
			this._isEnabled = false;
			this.removeMouseEvents();
			this.removeMouseEventsForIsOver();
			this.removeHit();
		}
		
	}

}