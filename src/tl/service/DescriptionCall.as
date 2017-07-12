package tl.service {
	
	public class DescriptionCall extends Object {
		
		public var isUrlLoaderOrServiceAmfOrExternalInterfaceOrCustomMethod: uint;
		public var strUrlOrMethod: String;
		public var serviceAmf: * //ServiceAmf;
		public var authorizationDataForUrlLoader: String;
		
		public function DescriptionCall(isUrlLoaderOrServiceAmfOrExternalInterfaceOrCustomMethod: uint, strUrlOrMethod: String, serviceAmf: * = null, authorizationDataForUrlLoader: String = ""): void { //authorizationDataForUrlLoader to String w format login:password
			this.isUrlLoaderOrServiceAmfOrExternalInterfaceOrCustomMethod = isUrlLoaderOrServiceAmfOrExternalInterfaceOrCustomMethod;
			this.strUrlOrMethod = strUrlOrMethod;
			this.serviceAmf = serviceAmf;
			this.authorizationDataForUrlLoader = authorizationDataForUrlLoader;
		}
		
	}

}