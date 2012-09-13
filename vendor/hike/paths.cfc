/**
* @name Paths.cfc
* @hint 
*/
component extends="hike" {
	import "normalized_array";
	property name="__root__" type="string";

	public any function init(root = "") {
		variables._ = new vendor.Underscore();
		this = _.extend(this,new normalized_array());
		this.__root__ = arguments.root;
		return this;
	}

	// require('util').inherits(Paths, NormalizedArray);


	/**
	 *  Paths#clone() -> Paths
	 *
	 *  Return copy of the instance.
	 **/
	public any function clone() {
	  var obj = this.init(this.__root__);
	  obj.prepend(_.toArray(this));
	  return obj;
	};


	/**
	 *  Paths#normalize(path) -> String
	 *
	 *  Relative paths added to this array are expanded relative to `root`.
	 *
	 *      paths = new Paths("/usr/local");
	 *
	 *      paths.append("tmp");
	 *      paths.append("/tmp");
	 *
	 *      paths.toArray();
	 *      // -> ["/usr/local/tmp", "/tmp"]
	 **/
	public any function normalize(path) {
	  if ('/' !== path[0]) {
	    path = resolvePath(this.__root__, path);
	  }

	  return normalizePath(path);
	};

}