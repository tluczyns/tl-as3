package tl.filesystem {
	import tl.types.Singleton;
	import flash.filesystem.*;
	
	public class FileUtils extends Singleton {
		
		static public function copyFilesByStreamFromAppToAppStorageDirectory(arrPathRelativeFile: Array): void {
			for each (var pathRelativeFile: String in arrPathRelativeFile)
				FileUtils.copyFileByStreamFromAppToAppStorageDirectory(pathRelativeFile);
		}
		
		static public function copyFileByStreamFromAppToAppStorageDirectory(pathRelativeFile: String): void {
			var fileSrc:File = File.applicationDirectory.resolvePath(pathRelativeFile);
			var fileStreamSrc: FileStream = new FileStream();
			fileStreamSrc.open(fileSrc, FileMode.READ);
			var contentFile: String = fileStreamSrc.readUTFBytes(fileStreamSrc.bytesAvailable);
			fileStreamSrc.close();
			var fileTarget: File = File.applicationStorageDirectory.resolvePath(pathRelativeFile);
			var fileStreamTarget: FileStream = new FileStream();
			fileStreamTarget.open(fileTarget, FileMode.WRITE);
			fileStreamTarget.writeUTFBytes(contentFile);
			fileStreamTarget.close();
		}
		
		static public function copyPathContentFromAppToAppStorageDirectory(pathRelativeFile: String): void {
			var fileSrc:File = File.applicationDirectory.resolvePath(pathRelativeFile); 
			var fileTarget:File = File.applicationStorageDirectory.resolvePath(pathRelativeFile); 
			fileSrc.copyTo(fileTarget, true); 
		}
		
	}

}