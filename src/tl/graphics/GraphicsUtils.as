package tl.graphics {
	import tl.types.Singleton;
	import flash.display.Graphics;
	import flash.geom.Point;

	public class GraphicsUtils extends Singleton {
		
		static public function drawRing(gfx: Graphics, radius0: Number, radius1: Number, color: uint, alpha: Number = 1, lengthVertical: Number = 0, lengthHorizontal: Number = 0): void {
			var c1:Number = radius0 * (Math.SQRT2 - 1);
			var c2:Number = radius0 * Math.SQRT2 / 2;
			var d:Number = radius0 * 2;
			
			var c3:Number = radius1 * (Math.SQRT2 - 1);
			var c4:Number = radius1 * Math.SQRT2 / 2;
			var d1:Number = radius1 * 2;
			var d2:Number = radius0 - radius1;
			
			gfx.beginFill(color, alpha);
			gfx.moveTo(lengthVertical + d, lengthHorizontal + radius0);
			gfx.curveTo(lengthVertical + d, lengthHorizontal + radius0 + c1, lengthVertical + radius0 + c2, lengthHorizontal + radius0 + c2);
			gfx.curveTo(lengthVertical + radius0 + c1, lengthHorizontal + d, lengthVertical + radius0, lengthHorizontal + d);
			gfx.lineTo(radius0, lengthHorizontal + d)
			gfx.curveTo(radius0 - c1, lengthHorizontal + d, radius0 - c2, lengthHorizontal + radius0 + c2);
			gfx.curveTo(0, lengthHorizontal + radius0 + c1, 0, lengthHorizontal + radius0);
			gfx.lineTo(0, radius0)
			gfx.curveTo(0, radius0 - c1, radius0 - c2, radius0 - c2);
			gfx.curveTo(radius0 - c1, 0, radius0, 0);
			gfx.lineTo(lengthVertical + radius0, 0)
			gfx.curveTo(lengthVertical + radius0 + c1, 0, lengthVertical + radius0 + c2, radius0 - c2);
			gfx.curveTo(lengthVertical + d, radius0 - c1, lengthVertical + d, radius0);
			gfx.lineTo(lengthVertical + d, lengthHorizontal + radius0)
			
			gfx.moveTo(lengthVertical + d2 + d1, lengthHorizontal + d2 + radius1);
			gfx.curveTo(lengthVertical + d2 + d1, lengthHorizontal + d2 + radius1 + c3, lengthVertical + d2 + radius1 + c4, lengthHorizontal + d2 + radius1 + c4);
			gfx.curveTo(lengthVertical + d2 + radius1 + c3, lengthHorizontal + d2 + d1, lengthVertical + d2 + radius1, lengthHorizontal + d2 + d1);
			gfx.lineTo(d2 + radius1, lengthHorizontal + d2 + d1)
			gfx.curveTo(d2 + radius1 - c3, lengthHorizontal + d2 + d1, d2 + radius1 - c4, lengthHorizontal + d2 + radius1 + c4);
			gfx.curveTo(d2, lengthHorizontal + d2 + radius1 + c3, d2, lengthHorizontal + d2 + radius1);
			gfx.lineTo(d2, d2 + radius1)
			gfx.curveTo(d2, d2 + radius1 - c3, d2 + radius1 - c4, d2 + radius1 - c4);
			gfx.curveTo(d2 + radius1 - c3, d2, d2 + radius1, d2);
			gfx.lineTo(lengthVertical + d2 + radius1, d2)
			gfx.curveTo(lengthVertical + d2 + radius1 + c3, d2, lengthVertical + d2 + radius1 + c4, d2 + radius1 - c4);
			gfx.curveTo(lengthVertical + d2 + d1, d2 + radius1 - c3, lengthVertical + d2 + d1, d2 + radius1);
			gfx.lineTo(lengthVertical + d2 + d1, lengthHorizontal + d2 + radius1)
			gfx.endFill();
		}
		
		static public function drawFrame(gfx: Graphics, thickness: Number, width: Number, height: Number, color: uint, alpha: Number = 1): void {
			gfx.beginFill(color, alpha);	
			gfx.drawRect(0, 0, width, thickness);
			gfx.drawRect(0, height - thickness, width, thickness);
			gfx.drawRect(0, thickness, thickness, height - 2 * thickness);
			gfx.drawRect(width - thickness, thickness, thickness, height - 2 * thickness);
			gfx.endFill();
		}
		
		static public function drawRoundPath(vecPosSrc: Vector.<Point>, graphics: Graphics = null, radius: Number = 20, closePath: Boolean = false): Vector.<Point> {
			var graphics: Graphics;
			var vecPosTarget: Vector.<Point>;
			if (!graphics) vecPosTarget = new Vector.<Point>();
			// code by Philippe / http://philippe.elsass.me
			var count: int = vecPosSrc.length;
			if (count < 2) return null;
			if (closePath && count < 3) return null;
			
			var p0:Point = vecPosSrc[0];
			var p1:Point = vecPosSrc[1];
			var p2:Point;
			var pp0:Point;
			var pp2:Point;
			
			var last:Point;
			if (!closePath) {
				graphics ? graphics.moveTo(p0.x, p0.y) : vecPosTarget.push(p0);
				last = vecPosSrc[count - 1];
			}
			var n: int = (closePath) ? count + 1 : count - 1;
			for (var i: int = 1; i < n; i++) {
				p2 = vecPosSrc[(i + 1) % count];
				
				var v0: Point = p0.subtract(p1);
				var v2: Point = p2.subtract(p1);
				var r: Number = Math.max(1, Math.min(radius, Math.min(v0.length / 2, v2.length / 2)));
				v0.normalize(r);
				v2.normalize(r);
				pp0 = p1.add(v0);
				pp2 = p1.add(v2);
				
				if (i == 1 && closePath) {
					graphics ? graphics.moveTo(pp0.x, pp0.y) : vecPosTarget.push(pp0);
					last = pp0;
				} else {
					graphics ? graphics.lineTo(pp0.x, pp0.y) : vecPosTarget.push(pp0);
				}
				graphics ? graphics.curveTo(p1.x, p1.y, pp2.x, pp2.y) : vecPosTarget.push(p1, pp2);
				p0 = p1;
				p1 = p2;
			}
			graphics ? graphics.lineTo(last.x, last.y) : vecPosTarget.push(last);
			return vecPosTarget;
		}
		
	}

}