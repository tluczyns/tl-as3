package tl.shader {
	import flash.display.Shader;
	import flash.display.BitmapData;
	import tl.types.Singleton;
	import flash.display.ShaderJob;
	import mx.graphics.shaderClasses.*;
	
	public class ShaderUtils extends Singleton {
		
		static public function applyShader(bmpData: BitmapData, classShader: Class): void {
			var shader: Shader = new classShader();
			shader.data.src.input = bmpData
			shader.data.dst.input = bmpData;
			var shaderJob: ShaderJob = new ShaderJob(shader, bmpData, bmpData.width, bmpData.height);
			shaderJob.start(true);
		}
		
		//TO DO
		
		static public function applySoftLight(bmpData: BitmapData): void {
			ShaderUtils.applyShader(bmpData, SoftLightShader);		
		}
		
		static public function applySaturation(bmpData: BitmapData): void {
			ShaderUtils.applyShader(bmpData, SaturationShader);		
		}
		
		static public function applyLuminosity(bmpData: BitmapData): void {
			ShaderUtils.applyShader(bmpData, LuminosityShader);		
		}
		
		static public function applyLuminosityMask(bmpData: BitmapData): void {
			ShaderUtils.applyShader(bmpData, LuminosityMaskShader);		
		}
		
		static public function applyHue(bmpData: BitmapData): void {
			ShaderUtils.applyShader(bmpData, HueShader);
		}
		
		static public function applyExclusion(bmpData: BitmapData): void {
			ShaderUtils.applyShader(bmpData, ExclusionShader);
		}
		
		static public function applyColor(bmpData: BitmapData): void {
			ShaderUtils.applyShader(bmpData, ColorShader);
		}
		
		
		static public function applyColorBurn(bmpData: BitmapData): void {
			ShaderUtils.applyShader(bmpData, ColorBurnShader);
		}
		
		static public function applyColorDodge(bmpData: BitmapData): void {
			var shaderColorDodge: ColorDodgeShader = new ColorDodgeShader();
			shaderColorDodge.data.src.input = bmpData
			shaderColorDodge.data.dst.input = bmpData;
			var shaderColorDodgeJob: ShaderJob = new ShaderJob(shaderColorDodge, bmpData, bmpData.width, bmpData.height);
			shaderColorDodgeJob.start(true);
		}
		
	}

}