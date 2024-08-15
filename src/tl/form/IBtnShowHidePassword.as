package tl.form {
	import tl.btn.IBtn;
	
	public interface IBtnShowHidePassword extends IBtn {
		
		function changeIndicator(isPasswordHiddenVisible: uint): void;
		
	}

}