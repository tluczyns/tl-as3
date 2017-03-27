package tl.gallery {
	
	public interface IMultiItemGallery extends IRenderable {
		
		function get id(): String;
		function set id(value: String): void;
		function get selected(): Boolean;
		function set selected(value: Boolean): void;
		
	}
	
}