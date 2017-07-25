package	tl.crypt {
	import flash.utils.ByteArray;
	import com.hurlant.crypto.symmetric.ICipher;
	import com.hurlant.crypto.symmetric.IPad;
	import com.hurlant.crypto.Crypto;
	import com.hurlant.util.Hex;
	import com.hurlant.util.Base64;

	public class CryptString {
		
		private var key: ByteArray;
		private var cipher: ICipher;
		
		public function CryptString(strKey: String): void {
			var pad: IPad = Crypto.getPad("pkcs5");
			this.cipher = Crypto.getCipher("simple-aes-ecb", Hex.toArray(Hex.fromString(strKey)), pad);
			pad.setBlockSize(this.cipher.getBlockSize())
		}
		
		public function encrypt(str: String): String {
			var baStr: ByteArray = Hex.toArray(Hex.fromString(str));
			this.cipher.encrypt(baStr);
			return Base64.encodeByteArray(baStr);
		}
		
		public function decrypt(str: String): String {
			var baStr: ByteArray = Base64.decodeToByteArray(str);
			this.cipher.decrypt(baStr);
			return Hex.toString(Hex.fromArray(baStr));
		}
		
		public function destroy(): void {
			this.cipher.dispose();
			this.cipher = null;
		}
		
	}
	
}