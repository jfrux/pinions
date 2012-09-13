/**
* @name Common.cfc
* @hint 
*/
component extends="hike" {
	import "vendor.underscore";
	public any function init() {
		return this;
	}

	// provides shortcut to define data property
	public any function prop(obj, name, val) {
	   //Object.defineProperty(obj, name, {value: val});
	};


	// helper that stubs `obj` with methods throwing error when they are called
	public any function stub(obj, methods, msg) {
	  _ = new Underscore();
	  msg = (!_.isEmpty(msg)) ? (": " & msg) : "";

	  _.each(methods,function (func) {
	    obj[func] = function () {
	      throw "Can't call `" & func & "()`" & msg;
	    };
	  });
	};
}