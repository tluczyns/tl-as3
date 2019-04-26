package tl.fx {
	import flash.display.Sprite;
	import flash.display.DisplayObject;
	import tl.loader.Library;
	import flash.geom.PerspectiveProjection;
	import flash.geom.Matrix3D;
	
	public class Cube extends Sprite {
		
		static private const COUNT_FACES: uint = 6;
		
		private var vecTexture: Vector.<DisplayObject>;
		private var vecFace: Vector.<Sprite>;
		private var relativeDspObjForSortZScreen: DisplayObject;
		
		public function Cube(vecTexture: Vector.<DisplayObject> = null, prefixClassFace: String = "", halfDimension: Number = 0, relativeDspObjForSortZScreen: DisplayObject = null): void {
			this.vecTexture = vecTexture;
			var isSetHalfDimension: Boolean = (!halfDimension);
			this.relativeDspObjForSortZScreen = relativeDspObjForSortZScreen;
			//create faces
			var i: uint;
			if ((prefixClassFace) && (!this.vecTexture)) {
				this.vecTexture = new Vector.<DisplayObject>(Cube.COUNT_FACES);
				for (i = 0; i < Cube.COUNT_FACES; i++)
					this.vecTexture[i] = Library.getDisplayObject(prefixClassFace + String(i));
			}
			this.vecFace = new Vector.<Sprite>(Cube.COUNT_FACES);
			var face: Sprite
			if (isSetHalfDimension) halfDimension = Infinity;
			for (i = 0; i < Cube.COUNT_FACES; i++) {
				face = new Sprite();
				var texture: DisplayObject = this.vecTexture[i];
				if (texture) {
					texture.x = - texture.width / 2;
					texture.y = - texture.height / 2;
					if (isSetHalfDimension) halfDimension = Math.min(halfDimension, Math.min(texture.width, texture.height) / 2);
					face.addChild(texture);
				}
				this.vecFace[i] = face;
				this.addChild(face);
			}
			//set position / rotation faces
			for (i = 0; i < Cube.COUNT_FACES; i++) {
				face = this.vecFace[i];
				switch (i) {
					case 0: face.x = -halfDimension; //side left
							face.rotationY = 90;
							break;
					case 1: face.x = halfDimension; //side right
							face.rotationY = -90;
							break;
					case 2: face.y = -halfDimension; //top
							face.rotationX = 90;
							break;
					case 3: face.y = halfDimension; //bottom
							face.rotationX = -90;
							break;
					case 4: face.z = -halfDimension; //front
							break;
					case 5: face.z = halfDimension; //back
							break;
				}
			}
			//perspective projection
			this.transform.perspectiveProjection = new PerspectiveProjection();
			this.transform.perspectiveProjection.fieldOfView = 110;
		}
		
		override public function set rotationX(value: Number): void {
			super.rotationX = value;
			this.sortZScreen();
		}
		
		override public function set rotationY(value: Number): void {
			super.rotationY = value;
			this.sortZScreen();
		}
		
		override public function set rotationZ(value: Number): void {
			super.rotationZ = value;
			this.sortZScreen();
		}
		
		private function sortZScreen(): void {
			if (this.relativeDspObjForSortZScreen) {
				var transformedMatrix: Matrix3D;
				var arrSort: Array = new Array(Cube.COUNT_FACES);
				var face: Sprite;
				for (var i: uint = 0; i < Cube.COUNT_FACES; i++) {
					face = this.vecFace[i];
					transformedMatrix = face.transform.getRelativeMatrix3D(this.relativeDspObjForSortZScreen);
					arrSort[i]= {face: face, zScreen: transformedMatrix.position.z};
				}
				arrSort.sortOn("zScreen", Array.NUMERIC | Array.DESCENDING);
				for (i = 0; i < Cube.COUNT_FACES; i++) {
					face = arrSort[i].face;
					this.setChildIndex(face, i);
					face.visible = (i >= 3);
				}
			}
		}
		
		public function destroy(): void {
			for (var i: uint = 0; i < Cube.COUNT_FACES; i++) {
				var face: Sprite = this.vecFace[i];
				var texture: DisplayObject = this.vecTexture[i];
				if (texture) face.removeChild(texture);
				this.removeChild(face);
				face = null;
			}
			this.vecFace = null;
		}
		
	}

}


