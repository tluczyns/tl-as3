package tl.btn {
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.events.MouseEvent;
	//import caurina.transitions.Tweener;	
	
	public class BtnHit extends MovieClip implements IBtn {
		
		private var _isEnabled: Boolean;
		private var isOver: Boolean;
		public var vecInjector: Vector.<InjectorBtnHit>;
		
		public var hit: Sprite;
		
		public function BtnHit(hit: Sprite = null, isEnabled: Boolean = true, isConstruct: Boolean = true): void {
			this.vecInjector = new Vector.<InjectorBtnHit>();
			if (isConstruct) this.construct(hit, isEnabled);
		}
		
		public function construct(hit: Sprite = null, isEnabled: Boolean = true): void {
			this.initHit(hit);
			this.addMouseEventsForIsOver();
			this.isOver = false;
			this._isEnabled = !isEnabled;
			this.isEnabled = isEnabled;
		}
		
		//hit
		
		private function initHit(hit: Sprite = null, rectDimension: Rectangle = null): void {
			if (this.hit == null) { 
				if (!hit) hit = this.createGenericHit(rectDimension);
				this.addChild(hit);
				this.hit = hit;
			}
			if (this.numChildren > 0) this.setChildIndex(this.hit, this.numChildren - 1);
			this.hit.alpha = 0;
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
				this.hit.mouseEnabled = this.hit.mouseChildren = this.hit.buttonMode = true;
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
				this.hit.mouseEnabled = this.hit.mouseChildren = this.hit.buttonMode = false;
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
		
		protected function onMouseDown(e: MouseEvent): void {
			this.dispatchEvent(new EventBtnHit(EventBtnHit.DOWN));
		}
		
		protected function onMouseUp(e: MouseEvent): void {
			this.dispatchEvent(new EventBtnHit(EventBtnHit.UP));	
		}
		
		protected function onClick(e: MouseEvent): void {
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
			//Tweener.removeTweens(this);
			//Tweener.addTween(this, {time: 0.3, alpha: [0.3, 1][isDisabledEnabled], transition: "linear"});
			//TweenNano.killTweensOf(this);
			//TweenNano.to(this, 0.3, {alpha: [0.3, 1][isDisabledEnabled], ease: Linear.easeNone});
			for (var i: uint = 0; i < this.vecInjector.length; i++) {
				var injector: InjectorBtnHit = this.vecInjector[i]
				injector.setElementsIsEnabled(this, isDisabledEnabled);
			}
		}
		
		//injector
		
		public function addInjector(injector: InjectorBtnHit): void {
			if (this.vecInjector.indexOf(injector) == -1) this.vecInjector.push(injector);
		}
		
		private function removeInjector(injector: InjectorBtnHit): Boolean {
			var indOfInjector: int = this.vecInjector.indexOf(injector);
			var isRemove: Boolean = (indOfInjector > -1);
			if (isRemove) this.vecInjector.splice(indOfInjector, 1);
			return isRemove;
		}
		
		//
		
		protected function removeHit(): void {
			if (this.hit != null) {
				this.removeChild(this.hit);
				this.hit = null;
			}
		}
		
		public function destroy(): void {
			//Tweener.removeTweens(this);
			//TweenNano.killTweensOf(this);
			this._isEnabled = false;
			this.removeMouseEvents();
			this.removeMouseEventsForIsOver();
			this.removeHit();
		}
		
	}

}