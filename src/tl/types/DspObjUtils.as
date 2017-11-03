package tl.types {
	import flash.display.GraphicsSolidFill;
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
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.IGraphicsData;
	
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
		
		
		static public function getRGB(objHSL: Object): Object {
			var h:Number = objHSL.h, s:Number = objHSL.s, l:Number = objHSL.l;
			h = h / 360;
			var r:Number;
			var g:Number;
			var b:Number;
 			if (l==0) {
				r=g=b=0;
			} else {
				if(s == 0) 
					r=g=b=l;
				else {
					var t2:Number = (l<=0.5)? l*(1+s):l+s-(l*s);
					var t1:Number = 2*l-t2;
					var t3:Vector.<Number> = new Vector.<Number>();
					t3.push(h+1/3);
					t3.push(h);
					t3.push(h-1/3);
					var clr:Vector.<Number> = new Vector.<Number>();
					clr.push(0);
					clr.push(0);
					clr.push(0);
					for (var i: int = 0; i < 3; i++) {
						if(t3[i]<0)
							t3[i]+=1;
						if(t3[i]>1)
							t3[i]-=1;
 
						if(6*t3[i] < 1)
							clr[i]=t1+(t2-t1)*t3[i]*6;
						else if(2*t3[i]<1)
							clr[i]=t2;
						else if(3*t3[i]<2)
							clr[i]=(t1+(t2-t1)*((2/3)-t3[i])*6);
						else
							clr[i]=t1;
					}
					r=clr[0];
					g=clr[1];
					b=clr[2];
				}
			}
			return {r: int(r*255),g: int(g*255), b: int(b*255)};
		}
		
		static public function cloneGraphics(container: DisplayObjectContainer, colorToSet: int = -1,  alphaToSet: Number = 1): DisplayObjectContainer {
			var containerClone: DisplayObjectContainer = new Sprite();
			for (var i: uint = 0; i < container.numChildren; i++) {
				var child: DisplayObject = container.getChildAt(i);
				var childClone: DisplayObject;
				if (child is Shape) {
					childClone = new Shape();
					var graphicsChild: Vector.<IGraphicsData> = Shape(child).graphics.readGraphicsData();
					if (colorToSet != -1) {
						for each (var iGraphicsData: IGraphicsData in graphicsChild) {
							if (iGraphicsData is GraphicsSolidFill) {
								GraphicsSolidFill(iGraphicsData).color = colorToSet;
								GraphicsSolidFill(iGraphicsData).alpha = alphaToSet;
							}
						}
					}
					Shape(childClone).graphics.drawGraphicsData(graphicsChild);
				} else if (child is DisplayObjectContainer) childClone = DspObjUtils.cloneGraphics(DisplayObjectContainer(child), colorToSet, alphaToSet);
				containerClone.addChild(childClone);
			}
			return containerClone;
		}
		
		static public function cloneDspObjProps(dspObjTarget: Object, dspObjSrc: Object): void {
			dspObjSrc = dspObjSrc || {};
			if (dspObjSrc.name) dspObjTarget.name = dspObjSrc.name;
			dspObjTarget.x = dspObjSrc.x || 0;
			dspObjTarget.y = dspObjSrc.y || 0;
			dspObjTarget.rotation = dspObjSrc.rotation || 0;
			dspObjTarget.scaleX = dspObjSrc.scaleX || 1;
			dspObjTarget.scaleY = dspObjSrc.scaleY || 1;
		}
		
	}

}