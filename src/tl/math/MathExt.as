package tl.math {
	import flash.geom.Point;
	
    public class MathExt {

		public static const TO_RADIANS:Number = Math.PI / 180;
		public static const TO_DEGREES:Number = 180 / Math.PI;
		
    	public static function getSign(number: Number):Number {
    		if (number == 0) return 1;
    		else return number / Math.abs(number);
    	}
		
		//floorRange(13.5, 4) = 12, floorRange(-7.3, 5) = -10
		static public function floorRange(val: Number, range: Number): Number {
			return Math.floor(val / range) * range;
		}

		//moduloRangePositive(-7.3, 5) = 2.7, moduloRangePositive(8, 5) = 3
		static public function moduloPositive(val: Number, range: Number): Number {
			return val - MathExt.floorRange(val, range);
		}
    	
		//moduloOnePositive(5.25) = 0.25, moduloOnePositive(-5.25) = 0.75
		static public function moduloOnePositive(val: Number): Number {
			return val - Math.floor(val);
		}
		
    	public static function get randomBool(): Boolean {
            return (Math.random() > 0.5);    	
    	}
		
		public static function getDigitArray(number: uint): Array {
			var lengthNumber: Number = String(Math.floor(number)).length;
			var arrDigit: Array = new Array(lengthNumber);
			for (var i: uint = 0; i < lengthNumber; i++) {
				arrDigit[i] = Math.floor(number / (Math.pow(10, lengthNumber - i - 1))) % 10
			}
			return arrDigit;
		}
		
		//ró¿nica k¹tów ze znakiem (stopnie)
		public static function getAngleSmallestDifference(angle1: Number, angle2: Number): Number {
			var diff: Number;
			angle1 = (angle1 + 360) % 360;
			angle2 = (angle2 + 360) % 360;
			if (Math.abs(angle1 - angle2) > 180) {
				if (angle1 < 180) { //angle2 jest wiêksze od 180
					diff = - (angle1 + (360 - angle2));
				} else { //angle1 jest wiêksze od 180
					diff = angle2 + (360 - angle1);
				}
			} else {
				diff = angle2 - angle1;
			}
			return diff;
		}
		
		//ró¿nica k¹tów bezwzglêdna (radiany)
		static public function minDiffAngle(angle1: Number, angle2: Number): Number {
			angle1 = (angle1 + (Math.PI * 2)) % (Math.PI * 2);
			angle2 = (angle2 + (Math.PI * 2)) % (Math.PI * 2);
			return MathExt.minDiff(angle1, angle2, Math.PI * 2);
		}
		
		
		//2 minDiff 7 w range 8 = 3
		static public function minDiff(val1: Number, val2: Number, range: Number): Number {
			var diff: Number = Math.abs(val1 - val2) % range;
			return Math.min(diff, range - diff);
		}
		
		//2 minDiffWithSign 7 w range 8 = -3, 0 minDiffWithSign 1.25 w range 1.5 = -0.25
		static public function minDiffWithSign(val1: Number, val2: Number, range: Number): Number {
			var diff:Number = (val1 - val2) % range;
			if (Math.abs(diff) > range / 2)
				diff = ((diff < 0) ? diff + range : diff - range) % range;
			return diff;
		}
		
		//roundPrecision(1.95583, 2);  // 1.96
		public static function roundPrecision(val: Number, precision: int): Number {
			var powPrecision: Number = Math.pow(10, precision);
			return (Math.round(val * powPrecision) / powPrecision);
		}
		
		public static function equals(val1: Number, val2: Number, precision: int): Boolean {
			return Boolean(MathExt.roundPrecision(val1, precision) == MathExt.roundPrecision(val2, precision));
		}
		
		public static function equalsWithMarginError(val1: Number, val2: Number, marginError: Number): Boolean {
			return (Math.abs(val1 - val2) < marginError);
		}
		
		
		//dlugosc przeciwprostok¹tnej
		public static function hypotenuse(leg1: Number, leg2: Number): Number {
			return Math.pow(Math.pow(leg1, 2) + Math.pow(leg2, 2), 0.5);
		}
	/*	
		public static function getClosestDistantPointToElipse(elipse: Point, elipseCenterPoint: Point): Point {
			return Math.pow(Math.pow(leg1, 2) + Math.pow(leg2, 2), 0.5);
		}*/
		
		public static function polarToCartesian(radius:Number, angle:Number):Point {
			return new Point(radius * Math.cos(angle * Math.PI / 180), radius * Math.sin(angle * Math.PI / 180));
		}
		
		//numChannel; 0-alpha, 1-red, 2-green, 3-blue
		public static function extractChannel(color: uint, numChannel: uint = 0): Number {
			var channel: Number = (color >> ((3 - numChannel) * 8)) & 0xFF;
			if (numChannel == 0) channel = (channel || 0xFF) / 255; //alpha równe 0 to jest 1;
			return channel;
		}
		
		static public function splitRGB(color: uint): Object {
			return {r: color >> 16 & 0xff, g: color >> 8 & 0xff, b: color & 0xff};
		}
		
		static public function joinRGB(objRGB: Object): uint {			
			return objRGB.r << 16 | objRGB.g << 8 | objRGB.b;
		}
		
		static public function convertColorHTMLToUint(colorHTML: String): uint {
			return uint(colorHTML.replace("#", "0x"));
		}
		
		static public function getHSL(objRGB: Object): Object {
			const r: Number = objRGB.r / 255, g: Number = objRGB.g / 255, b: Number = objRGB.b / 255;
			var max: Number = Math.max(r, g, b), min: Number = Math.min(r, g, b);
			var h: Number, s: Number, l: Number = (max + min) / 2;

			if (max == min) {
				h = s = 0; // achromatic
			} else {
				var d: Number = max - min;
				s = l > 0.5 ? d / (2 - max - min) : d / (max + min);
				switch (max) {
					case r: h = (g - b) / d + (g < b ? 6 : 0); break;
					case g: h = (b - r) / d + 2; break;
					case b: h = (r - g) / d + 4; break;
				}
				h /= 6;
			}
			return {h: h, s: s, l: l};
		}
		
		static public function getRGB(objHSL: Object): Object {
			var h:Number = objHSL.h, s:Number = objHSL.s, l:Number = objHSL.l;
			var r: Number, g: Number, b: Number;
			if (s == 0) {
				r = g = b = l; // achromatic
			} else {
				function hue2rgb(p: Number, q: Number, t: Number): Number {
					if (t < 0) t += 1;
					if (t > 1) t -= 1;
					if (t < 1/6) return p + (q - p) * 6 * t;
					if (t < 1/2) return q;
					if (t < 2/3) return p + (q - p) * (2/3 - t) * 6;
					return p;
				}
				var q: Number = l < 0.5 ? l * (1 + s) : l + s - l * s;
				var p: Number = 2 * l - q;
				r = hue2rgb(p, q, h + 1/3);
				g = hue2rgb(p, q, h);
				b = hue2rgb(p, q, h - 1/3);
			}
			return {r: int(r * 255), g: int(g * 255), b: int(b * 255)};
		}
		
		static public function addZerosBeforeNumberAndReturnString(number: *, digitCount: uint): String {
			var numberStr: String = String(number);
			while (numberStr.length < digitCount) {
				numberStr = "0" + numberStr;
			}
			return numberStr;
		}
		
		static public function convertColorUintToHTML(color: uint) : String {
            var objRGB: Object = MathExt.splitRGB(color);
			var arrRGB: Array = [objRGB.r, objRGB.g, objRGB.b];
            var colorHTML: String = "#";
			for (var i: int = 0; i < arrRGB.length; i++) colorHTML += MathExt.addZerosBeforeNumberAndReturnString(uint(arrRGB[i]).toString(16), 2);
            return colorHTML;
        }
		
		static public function log2(val: Number): Number {
			return Math.log(val) * Math.LOG2E;
		}
		
		static public function log10(val: Number): Number {
			return Math.log(val) * Math.LOG10E;
		}
		
		static public function distanceBetweenTwoPoints(pointStart: Object, pointEnd: Object): Number {
			return MathExt.hypotenuse(Math.abs(pointEnd.x - pointStart.x), Math.abs(pointEnd.y - pointStart.y));
		}
		
		static public function calculateProjectionPointOnSegment(pointSegmentStart: Object, pointSegmentEnd: Object, point: Object, isForcePointProjectionOnSegment: Boolean = false): Point {
			if (!(pointSegmentStart is Point)) pointSegmentStart = new Point(pointSegmentStart.x, pointSegmentStart.y);
			if (!(pointSegmentEnd is Point)) pointSegmentEnd = new Point(pointSegmentEnd.x, pointSegmentEnd.y);
			var u: Number = ((pointSegmentEnd.x - pointSegmentStart.x) * (point.x - pointSegmentStart.x) + (pointSegmentEnd.y - pointSegmentStart.y) * (point.y - pointSegmentStart.y)) / (Math.pow(pointSegmentEnd.x - pointSegmentStart.x, 2) + Math.pow(pointSegmentEnd.y - pointSegmentStart.y, 2));
			var pointProjection: Point = new Point(pointSegmentStart.x + u * (pointSegmentEnd.x - pointSegmentStart.x), pointSegmentStart.y + u * (pointSegmentEnd.y - pointSegmentStart.y));
			if (isForcePointProjectionOnSegment) {
				var nameCoord: String = ["x", "y"][uint(pointSegmentStart.x == pointSegmentEnd.x)];
				var pointSegmentWithMinCoord: Point = Point((pointSegmentStart[nameCoord] < pointSegmentEnd[nameCoord]) ? pointSegmentStart : pointSegmentEnd);
				var pointSegmentWithMaxCoord: Point = Point((pointSegmentWithMinCoord == pointSegmentStart) ? pointSegmentEnd : pointSegmentStart);
				if (pointProjection[nameCoord] < pointSegmentWithMinCoord[nameCoord]) pointProjection = pointSegmentWithMinCoord;
				else if (pointProjection[nameCoord] > pointSegmentWithMaxCoord[nameCoord]) pointProjection = pointSegmentWithMaxCoord;
			}
			return pointProjection;
		}
		
		static public function calculateDistancePointFromSegment(pointSegmentStart: Object, pointSegmentEnd: Object, point: Object): Number {
			return Math.abs((pointSegmentEnd.y - pointSegmentStart.y) * point.x - (pointSegmentEnd.x - pointSegmentStart.x) * point.y + pointSegmentEnd.x * pointSegmentStart.y - pointSegmentStart.x * pointSegmentEnd.y) / Math.pow(Math.pow(pointSegmentEnd.y - pointSegmentStart.y, 2) + Math.pow(pointSegmentEnd.x - pointSegmentStart.x, 2), 0.5);
		}
		
		static public function calculateOffsetPointWithDistanceFromSegment(pointSegmentStart: Point, pointSegmentEnd: Point, distance: Number): Point {
			var angleRadians: Number = angleRadians = Math.atan2(pointSegmentEnd.y - pointSegmentStart.y, pointSegmentEnd.x - pointSegmentStart.x);
			return new Point(Math.sin(angleRadians) * distance, - Math.cos(angleRadians) * distance);
		}
		
		static public function rotatePoint(pointToRotate: Object, angleRadians: Number, pointReference: Object = null): Point {
			if (!pointReference) pointReference = new Point(0, 0);
			return new Point(
				(pointToRotate.x - pointReference.x) * Math.cos(angleRadians) - (pointToRotate.y - pointReference.y) * Math.sin(angleRadians) + pointReference.x,
				(pointToRotate.x - pointReference.x) * Math.sin(angleRadians) + (pointToRotate.y - pointReference.y) * Math.cos(angleRadians) + pointReference.y
			);
		}
		
		static public function xor(lhs: Boolean, rhs: Boolean): Boolean {
			return !(lhs && rhs) && (lhs || rhs);
		}
		
    }
	
}