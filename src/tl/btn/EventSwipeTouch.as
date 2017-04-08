package tl.btn {
	import flash.events.TouchEvent;
	import flash.utils.Dictionary;
	import flash.utils.ByteArray;
	import flash.display.InteractiveObject;
	import flash.geom.Point;
	import tl.math.MathExt;
	
	//for devices that doesn't support TransformGestureEvent.GESTURE_SWIPE
	public class EventSwipeTouch extends TouchEvent {
		
		public static const SWIPE_TOUCH: String = "swipeTouch";
		
		static private const LENGTH_SWIPE_DEFAULT: Number = 100;
		static private var dictInteractiveObjectToDescriptionSwipeTouch: Dictionary = new Dictionary();
		
		public var length: Number;
		public var offsetX: Number;
		public var offsetY: Number;
		
		public function EventSwipeTouch(type: String, bubbles: Boolean = false, cancelable:Boolean=false, offsetX: Number = 0, offsetY: Number = 0, length: Number = EventSwipeTouch.LENGTH_SWIPE_DEFAULT, touchPointID:int=0, isPrimaryTouchPoint:Boolean=false, localX:Number=NaN, localY:Number=NaN, sizeX:Number=NaN, sizeY:Number=NaN, pressure:Number=NaN, relatedObject:InteractiveObject=null, ctrlKey:Boolean=false, altKey:Boolean=false, shiftKey:Boolean=false, commandKey:Boolean=false, controlKey:Boolean=false, timestamp:Number=NaN, touchIntent:String="unknown", samples:ByteArray=null, isTouchPointCanceled:Boolean=false): void {
			super(type, bubbles, cancelable, touchPointID, isPrimaryTouchPoint, localX, localY, sizeX, sizeY, pressure, relatedObject, ctrlKey, altKey, shiftKey, commandKey, controlKey, timestamp, touchIntent, samples, isTouchPointCanceled);
			this.offsetX = offsetX;
			this.offsetY = offsetY;
			this.length = length;
		}
		
		static public function addSwipeTouchEvent(target: InteractiveObject, lengthSwipe: Number = EventSwipeTouch.LENGTH_SWIPE_DEFAULT): void {
			EventSwipeTouch.dictInteractiveObjectToDescriptionSwipeTouch[target] = new DescriptionSwipeTouchForInteractiveObject(lengthSwipe);
			target.addEventListener(TouchEvent.TOUCH_BEGIN, EventSwipeTouch.onTouchBegin, false);
			target.addEventListener(TouchEvent.TOUCH_END, EventSwipeTouch.onTouchEnd, false);
		}
		
		static private function onTouchBegin(e: TouchEvent): void {
			var descriptionSwipeTouch: DescriptionSwipeTouchForInteractiveObject = EventSwipeTouch.dictInteractiveObjectToDescriptionSwipeTouch[InteractiveObject(e.currentTarget)];
			descriptionSwipeTouch.dictTouchIdToPoint[e.touchPointID] = new Point(e.stageX, e.stageY);
		}
		
		static private function onTouchEnd(e: TouchEvent): void {
			var target: InteractiveObject = InteractiveObject(e.currentTarget);
			var descriptionSwipeTouch: DescriptionSwipeTouchForInteractiveObject = EventSwipeTouch.dictInteractiveObjectToDescriptionSwipeTouch[target];
			var pointForTouchId: Point = descriptionSwipeTouch.dictTouchIdToPoint[e.touchPointID];
			if (pointForTouchId) {
				var offsetX: Number = e.stageX - pointForTouchId.x;
				var offsetY: Number = e.stageY - pointForTouchId.y;
				var lengthSwipe: Number = MathExt.hypotenuse(offsetX, offsetY);
				if (lengthSwipe > descriptionSwipeTouch.lengthSwipe)
					target.dispatchEvent(new EventSwipeTouch(EventSwipeTouch.SWIPE_TOUCH, e.bubbles, e.cancelable, offsetX, offsetY, lengthSwipe, e.touchPointID, e.isPrimaryTouchPoint, e.localX, e.localY, e.sizeX, e.sizeY, e.pressure, e.relatedObject, e.ctrlKey, e.altKey, e.shiftKey, e.commandKey, e.controlKey, e.timestamp, e.touchIntent, null, e.isTouchPointCanceled));
				delete descriptionSwipeTouch.dictTouchIdToPoint[e.touchPointID];
			}
		}
		
	}
	
}
import flash.utils.Dictionary;

class DescriptionSwipeTouchForInteractiveObject {
	
	internal var dictTouchIdToPoint: Dictionary = new Dictionary();
	internal var lengthSwipe: Number;
	
	public function DescriptionSwipeTouchForInteractiveObject(lengthSwipe: Number): void {
		this.lengthSwipe = lengthSwipe;
	}
	
}