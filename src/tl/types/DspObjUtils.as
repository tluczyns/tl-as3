package tl.types {
	import tl.types.Singleton;
	import flash.utils.Dictionary;
	import com.greensock.plugins.TweenPlugin;
	import com.greensock.plugins.AutoAlphaPlugin;
	import flash.display.DisplayObject;
	import com.greensock.TweenLite;
	import com.greensock.easing.Linear;
	import com.greensock.plugins.HexColorsPlugin;
	import com.greensock.plugins.TintPlugin;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getQualifiedSuperclassName;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.display.MovieClip;
	import com.greensock.plugins.FramePlugin;
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.display.IGraphicsData;
	import flash.display.GraphicsSolidFill;
	import flash.display.GraphicsStroke;
	import flash.display.Bitmap;
	import flash.media.Sound;
	import flash.display.BitmapData;
	
	public class DspObjUtils extends Singleton {
	
		private static var dictOnCompleteHide: Dictionary;
		private static var dictOnCompleteHideParams: Dictionary;
		
		{
			DspObjUtils.dictOnCompleteHide = new Dictionary();
			DspObjUtils.dictOnCompleteHideParams = new Dictionary();
			TweenPlugin.activate([AutoAlphaPlugin]);
		}
		
		public static function hideShow(dspObj: DisplayObject, isHideShow: uint, numFrames: int = 10, onComplete: Function = null, onCompleteParams: Array = null): void {
			//if (((isHideShow == 0) && (dspObj.alpha > 0)) || ((isHideShow == 1) && (dspObj.alpha < 1))) {
				if (numFrames == -1) numFrames = 10;
				if (isHideShow == 0) {
					DspObjUtils.dictOnCompleteHide[dspObj] = onComplete;
					if (DspObjUtils.dictOnCompleteHide[dspObj] != null) {
						DspObjUtils.dictOnCompleteHideParams[dspObj] = (onCompleteParams != null) ? onCompleteParams: [];
					}
					onComplete = function(dspObj: DisplayObject): void {
						dspObj.visible = false;
						if (DspObjUtils.dictOnCompleteHide[dspObj] != null) DspObjUtils.dictOnCompleteHide[dspObj].apply(null, DspObjUtils.dictOnCompleteHideParams[dspObj]);
					}
					onCompleteParams = [dspObj]; 
				} else if (isHideShow == 1) {
					dspObj.visible = true;
					if (onComplete != null)
						onCompleteParams = (onCompleteParams != null) ? onCompleteParams : [];
				}
				try {
					TweenLite.killTweensOf(dspObj, {autoAlpha: true});
				} catch(e: TypeError) {};
				TweenLite.to(dspObj, numFrames, {autoAlpha: isHideShow, useFrames: true, ease: Linear.easeNone, onComplete: onComplete, onCompleteParams: onCompleteParams});
			//}
		}
		
		public static function setColor(dspObj: DisplayObject, tint: uint, numFrames: int = 10, onComplete: Function = null, onCompleteParams: Array = null): void {
			if (onComplete != null) onCompleteParams = (onCompleteParams != null) ? onCompleteParams : [];
			TweenPlugin.activate([HexColorsPlugin, TintPlugin]);
			if ((getDefinitionByName(getQualifiedClassName(dspObj)) == TextField) || (getDefinitionByName(getQualifiedSuperclassName(dspObj)) == TextField)) {
				var objColorTf: Object = {tint: TextField(dspObj).getTextFormat().color};
				TweenLite.killTweensOf(objColorTf, {hexColors: true});
				TweenLite.to(objColorTf, numFrames, {hexColors:{tint: tint}, useFrames: true, ease: Linear.easeNone, onUpdate: DspObjUtils.drawColorTf, onUpdateParams: [TextField(dspObj), objColorTf], onComplete: onComplete, onCompleteParams: onCompleteParams});
			} else {
				TweenLite.killTweensOf(dspObj, {tint: true});
				TweenLite.to(dspObj, numFrames, {tint: tint, useFrames: true, ease: Linear.easeNone, onComplete: onComplete, onCompleteParams: onCompleteParams});
			}
		}
		
		static private function drawColorTf(tf: TextField, objColorTf: Object): void {
			var tFormat: TextFormat = tf.getTextFormat();
			tFormat.color = objColorTf.tint;
			tf.defaultTextFormat = tFormat;
			tf.setTextFormat(tFormat); 
		}
		
		static public function playToFrame(mc: MovieClip, targetFrame: int = -1, onComplete: Function = null, onCompleteParams: Array = null): void {
			DspObjUtils.stopPlaying(mc);
			if (targetFrame == -1) targetFrame = mc.totalFrames;
			if (targetFrame != mc.currentFrame) TweenLite.to(mc, Math.abs(targetFrame - mc.currentFrame), {frame: targetFrame, useFrames: true, ease: Linear.easeNone, onComplete: onComplete, onCompleteParams: onCompleteParams});
			else if (Boolean(onComplete)) onComplete.apply(null, onCompleteParams);
		}
		
		static public function stopPlaying(mc: MovieClip): void {
			TweenPlugin.activate([FramePlugin]);
			TweenLite.killTweensOf(mc, {frame: true});
		}
		
		static public function skew(target: DisplayObject, _x:Number, _y:Number):void {
			var mtx: Matrix = new Matrix();
			mtx.b = _y / target.width;
			mtx.c = _x / target.height;
			mtx.concat(target.transform.matrix);
			target.transform.matrix = mtx;
		}
		
		static public function convertMatrix3DTo2D(target: DisplayObject): void {
			var mrx3DTarget: Matrix3D = target.transform.matrix3D;
			if (mrx3DTarget) {
				var dataMrx3DTarget:Vector.<Number> = mrx3DTarget.rawData;
				var mrxTarget:Matrix = new Matrix();
				mrxTarget.a = dataMrx3DTarget[0];
				mrxTarget.c = dataMrx3DTarget[1];
				mrxTarget.tx = target.x //- targetBounds.x;
				mrxTarget.b = dataMrx3DTarget[4];
				mrxTarget.d = dataMrx3DTarget[5];
				mrxTarget.ty = target.y //- targetBounds.y;
				target.transform.matrix3D = null;
				target.transform.matrix = mrxTarget;
			}
		}
		
		static public function cloneGraphics(dspObject: DisplayObject, colorToSet: int = -1,  alphaToSet: Number = 1): DisplayObject {
			var dspObjectClone: DisplayObject = null;
			var classBaseDspObject: Class = (dspObject is Shape) ? Shape : ((dspObject is Sprite) ? Sprite : Object);
			if ((classBaseDspObject == Shape) || (classBaseDspObject == Sprite)) {
				dspObjectClone = new classBaseDspObject();
				var graphicsDspObj: Vector.<IGraphicsData> = classBaseDspObject(dspObject).graphics.readGraphicsData();
				if (colorToSet != -1) {
					for each (var iGraphicsData: IGraphicsData in graphicsDspObj) {
						var graphicsSolidFill: GraphicsSolidFill = null;
						if (iGraphicsData is GraphicsSolidFill)	graphicsSolidFill = GraphicsSolidFill(iGraphicsData)
						else if ((iGraphicsData is GraphicsStroke) && (GraphicsStroke(iGraphicsData).fill is GraphicsSolidFill)) graphicsSolidFill = GraphicsSolidFill(GraphicsStroke(iGraphicsData).fill);
						if (graphicsSolidFill) {
							graphicsSolidFill.color = colorToSet;
							graphicsSolidFill.alpha = alphaToSet;
						}
					}
				}
				classBaseDspObject(dspObjectClone).graphics.drawGraphicsData(graphicsDspObj);
			}
			if (dspObject is DisplayObjectContainer) {
				if (!dspObjectClone) dspObjectClone = new Sprite();
				for (var i: uint = 0; i < DisplayObjectContainer(dspObject).numChildren; i++) {
					var child: DisplayObject = DisplayObjectContainer(dspObject).getChildAt(i);
					var childClone: DisplayObject = DspObjUtils.cloneGraphics(child, colorToSet, alphaToSet);
					if (childClone) Sprite(dspObjectClone).addChild(childClone);
				}
			}
			if (dspObjectClone) {
				DspObjUtils.cloneDspObjProps(dspObjectClone, dspObject, false);
				dspObjectClone.visible = dspObject.visible;
				if (alphaToSet == 1) dspObjectClone.alpha = dspObject.alpha;
				dspObjectClone.blendMode = dspObject.blendMode;
			}
			return dspObjectClone;
		}
		
		static public function cloneDspObjProps(dspObjTarget: Object, dspObjSrc: Object, isTryCloneName: Boolean = true, isSetMrxTransformWithParent: Boolean = false, parentDspObjSrcUntilWhichCopyDspObjProps: DisplayObjectContainer = null): void {
			dspObjSrc = dspObjSrc || {};
			dspObjSrc.scaleX = dspObjSrc.scaleX || dspObjSrc.scale;
			dspObjSrc.scaleY = dspObjSrc.scaleY || dspObjSrc.scale;
			if (isTryCloneName) {
				try {
					if (dspObjSrc.name) dspObjTarget.name = dspObjSrc.name;
				} catch (e: Error) {}
			}
			var mrxTransformSrc: Matrix;
			var mrxTransformSrcWithParent: Matrix;
			if (dspObjSrc is DisplayObject) {
				mrxTransformSrc = DisplayObject(dspObjSrc).transform.matrix.clone();
				DisplayObject(dspObjSrc).transform.matrix = mrxTransformSrc; //needed - bug in flash?
				if ((isSetMrxTransformWithParent) && (parentDspObjSrcUntilWhichCopyDspObjProps)) {
					mrxTransformSrcWithParent = mrxTransformSrc.clone();
					var parentDspObjSrc: DisplayObjectContainer = DisplayObject(dspObjSrc).parent;
					while ((parentDspObjSrc) && (parentDspObjSrc != parentDspObjSrcUntilWhichCopyDspObjProps)) {
						mrxTransformSrcWithParent.concat(parentDspObjSrc.transform.matrix);
						parentDspObjSrc = parentDspObjSrc.parent;
					}
				}
			} else {
				mrxTransformSrc = dspObjSrc.mrxTransform;
				if (isSetMrxTransformWithParent) mrxTransformSrcWithParent = dspObjSrc.mrxTransformWithParent;
			}
			var mrxTransformTarget: Matrix = [mrxTransformSrc, mrxTransformSrcWithParent][uint(isSetMrxTransformWithParent)];
			if  (mrxTransformSrc) {
				if (dspObjTarget is DisplayObject)
					DisplayObject(dspObjTarget).transform.matrix = mrxTransformTarget;
				else {
					dspObjTarget.mrxTransform = mrxTransformSrc;
					dspObjTarget.mrxTransformWithParent = mrxTransformSrcWithParent;
				}
			}
			if ((!mrxTransformSrc) || (!(dspObjTarget is DisplayObject))) {
				dspObjTarget.x = (mrxTransformTarget ? mrxTransformTarget.tx : dspObjSrc.x) || 0;
				dspObjTarget.y = (mrxTransformTarget ? mrxTransformTarget.ty : dspObjSrc.y) || 0;
				dspObjTarget.rotation = (mrxTransformTarget ? (Math.atan(mrxTransformTarget.c / mrxTransformTarget.d) || Math.atan(- mrxTransformTarget.b / mrxTransformTarget.a)) : dspObjSrc.rotation) || 0;
				dspObjTarget.scaleX = (mrxTransformTarget ? Math.sqrt(Math.pow(mrxTransformTarget.a, 2) + Math.pow(mrxTransformTarget.b, 2)) : dspObjSrc.scaleX) || 1;
				dspObjTarget.scaleY = (mrxTransformTarget ? Math.sqrt(Math.pow(mrxTransformTarget.c, 2) + Math.pow(mrxTransformTarget.d, 2)) : dspObjSrc.scaleY) || 1;
			}
		}
		
		/*static public function cloneDspObjProps(dspObjTarget: Object, dspObjSrc: Object, isTryCloneName: Boolean = true): void {
			dspObjSrc = dspObjSrc || {};
			dspObjSrc.scaleX = dspObjSrc.scaleX || dspObjSrc.scale;
			dspObjSrc.scaleY = dspObjSrc.scaleY || dspObjSrc.scale;
			if (isTryCloneName) {
				try {
					if (dspObjSrc.name) dspObjTarget.name = dspObjSrc.name;
				} catch (e: Error) {}
			}
			if ((dspObjSrc is DisplayObject) && (dspObjTarget is DisplayObject))
				DisplayObject(dspObjTarget).transform.matrix = DisplayObject(dspObjSrc).transform.matrix.clone();
			else {
				dspObjTarget.x = dspObjSrc.x || 0;
				dspObjTarget.y = dspObjSrc.y || 0;
				dspObjTarget.rotation = dspObjSrc.rotation || 0;
				dspObjTarget.scaleX = dspObjSrc.scaleX || 1;
				dspObjTarget.scaleY = dspObjSrc.scaleY || 1;
			}
		}*/
		
		static public function deleteDspObj(dspObj: DisplayObject): void {
			if (dspObj is DisplayObjectContainer) {
				for (var i: uint = 0; i < DisplayObjectContainer(dspObj).numChildren; i++)
					DspObjUtils.deleteDspObj(DisplayObjectContainer(dspObj).getChildAt(i));
			} else if (dspObj is Bitmap) {
				Bitmap(dspObj).bitmapData.dispose();
				Bitmap(dspObj).bitmapData = null;
			} else if (dspObj is Shape) {
				Shape(dspObj).graphics.clear();
			}
			dspObj = null;
		}
		
		static public function stopPlayAllMovieClips(dspObj: DisplayObject, isStopPlay: uint): void {
			if (dspObj is MovieClip)
				MovieClip(dspObj)[["stop","play"][isStopPlay]]();
			if (dspObj is DisplayObjectContainer) {
				for (var i: uint = 0; i < DisplayObjectContainer(dspObj).numChildren; i++)
					DspObjUtils.stopPlayAllMovieClips(DisplayObjectContainer(dspObj).getChildAt(i), isStopPlay);
			}
		}
		
		static public function setTargetMovieClipsOnSameFrame(dspObjSrc: DisplayObject, dspObjTarget: DisplayObject): void {
			if ((dspObjSrc is MovieClip) && (dspObjTarget is MovieClip))
				MovieClip(dspObjTarget).gotoAndPlay(MovieClip(dspObjSrc).currentFrame);
			if (dspObjSrc is DisplayObjectContainer) {
				for (var i: uint = 0; i < DisplayObjectContainer(dspObjSrc).numChildren; i++)
					DspObjUtils.setTargetMovieClipsOnSameFrame(DisplayObjectContainer(dspObjSrc).getChildAt(i), DisplayObjectContainer(dspObjTarget).getChildAt(i));
			}
		}
		
		static public function lookForChild(container: DisplayObjectContainer, classChildToFind: Class = null, nameChildToFind: String = null): DisplayObject {
			var childFound: DisplayObject = null;
			var i: uint = 0;
			while ((!childFound) && (i < container.numChildren)) {
				var child: DisplayObject = container.getChildAt(i++);
				if (((classChildToFind) && (child is classChildToFind)) || ((nameChildToFind) && (child.name == nameChildToFind))) childFound = child;
				else if (child is DisplayObjectContainer) childFound = DspObjUtils.lookForChild(DisplayObjectContainer(child), classChildToFind, nameChildToFind);
			}
			return childFound;
		}
		
		static public function getDspObjFromNameClass(nameClassDspObj: String): DisplayObject {
			var classDspObj: Class = getDefinitionByName(nameClassDspObj) as Class;
			var dspObj: *;
			try {
				dspObj = new classDspObj();
				if (!((dspObj is MovieClip) || (dspObj is Sound)))
					dspObj = null;
			} catch (e: Error) {}
			if (!dspObj) {
				try {
					var bmpDataDspObj: BitmapData = new classDspObj(0, 0);
					if (bmpDataDspObj) dspObj  = new Bitmap(bmpDataDspObj, "auto", true);
				} catch (e: Error) {}	
			}
			return dspObj;
		}
		
	}

}