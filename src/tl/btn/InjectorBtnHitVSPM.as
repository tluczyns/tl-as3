package tl.btn {
	import tl.vspm.DescriptionView;
	
	public dynamic class InjectorBtnHitVSPM extends InjectorBtnHit {
		
		public var descriptionView: DescriptionView;
		
		public function InjectorBtnHitVSPM(descriptionView: DescriptionView): void {
			this.descriptionView = descriptionView;
		}
		
	}

}