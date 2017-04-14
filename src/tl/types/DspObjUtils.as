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
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import com.greensock.plugins.FramePlugin;
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	
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
					TweenLite.killTweensOf(dspObj, false, {autoAlpha: true});
				} catch(e: TypeError) {};
				TweenLite.to(dspObj, numFrames, {autoAlpha: isHideShow, useFrames: true, ease: Linear.easeNone, onComplete: onComplete, onCompleteParams: onCompleteParams});
			//}
		}
		
		public static function setColor(dspObj: DisplayObject, tint: uint, numFrames: int = 10, onComplete: Function = null, onCompleteParams: Array = null): void {
			if (onComplete != null)
				onCompleteParams = (onCompleteParams != null) ? onCompleteParams : [];
			if ((getDefinitionByName(getQualifiedClassName(dspObj)) == TextField) || (getDefinitionByName(getQualifiedSuperclassName(dspObj)) == TextField)) {
				TweenPlugin.activate([HexColorsPlugin, TintPlugin]);
				var objColorTf: Object = {tint: TextField(dspObj).getTextFormat().color};
				TweenLite.killTweensOf(objColorTf, false, {hexColors: true});
				TweenLite.to(objColorTf, numFrames, {hexColors:{tint: tint}, useFrames: true, ease: Linear.easeNone, onUpdate: DspObjUtils.drawColorTf, onUpdateParams: [TextField(dspObj), objColorTf], onComplete: onComplete, onCompleteParams: onCompleteParams});
			} else {
				
				TweenLite.killTweensOf(dspObj, false, {tint: true});
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
			TweenLite.killTweensOf(mc, false, {frame: true});
		}
		
		static public function skew(target: DisplayObject, _x:Number, _y:Number):void {
			var mtx: Matrix = new Matrix();
			mtx.b = _y * Math.PI/180;
			mtx.c = _x * Math.PI/180;
			mtx.concat(target.transform.matrix);
			target.transform.matrix = mtx;
		}
		
		static public function convertMatrix3DTo2D(target: DisplayObject): void {
			var mrx3DTarget: Matrix3D = target.transform.matrix3D;
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

}