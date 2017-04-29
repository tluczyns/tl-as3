package tl.other {
	import flash.net.LocalConnection;
	import flash.sampler.getSavedThis;
	import flash.utils.describeType;
	
	public class Tricks {
		
		public static function runGC(): Boolean {
			try {
				var lc1:LocalConnection = new LocalConnection();
				var lc2:LocalConnection = new LocalConnection();
				lc1.connect('name');
				lc2.connect('name');
			} catch (e: Error) {
				return false;
			}
			return true;
		}
		
		//trace(getFunctionName(new Error());
		public static function getFunctionName(e:Error):String {
			var stackTrace:String = e.getStackTrace();     // entire stack trace
			var startIndex:int = stackTrace.indexOf("at ");// start of first line
			var endIndex:int = stackTrace.indexOf("()");   // end of function name
			stackTrace = stackTrace.substring(startIndex + 3, endIndex);
			return stackTrace.substring(stackTrace.lastIndexOf("/") + 1)
		}
		
		public static function getFunctionName2(f:Function):String {
			// get the object that contains the function (this of f)
			var t:Object = getSavedThis(f);

			// get all methods contained
			var methods:XMLList = describeType(t)..method.@name;

			for each (var m:String in methods) {
				// return the method name if the thisObject of f (t) 
				// has a property by that name 
				// that is not null (null = doesn't exist) and 
				// is strictly equal to the function we search the name of
				if (t.hasOwnProperty(m) && t[m] != null && t[m] === f) return m;            
			}
			// if we arrive here, we haven't found anything... 
			// maybe the function is declared in the private namespace?
			return null;                                        
		}

	}
	
}