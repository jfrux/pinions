/**
* @name Paths.cfc
* @hint An internal mixin whose public methods are exposed on the [[Environment]] and [[Index]] classes.<br/>Provides helpers to work with `Hike.Trail` instance. 
* @usage internal 
* @type mixin
*/
component accessors=true {
	import "vendor.underscore";
	import "vendor.hike.trail";

	property name="root"
			type="string";
	property name="paths"
			type="any"
			default="";
	property name="__trail__"
			type="any";

	public any function init() {
		variables._ = new Underscore();
		this.paths = [];
		return this;
	}

	/**
	* Paths#prependPath(path) -> Void
	*
	* Prepend a `path` to the `paths` list.
	* Paths at the end have the least priority.
	**/
	public any function prependPath(path) {
	  this.__trail__.paths.prepend(path);
	};


	/**
	* Paths#appendPath(path) -> Void
	*
	* Append a `path` to the `paths` list.
	* Paths at the beginning have a higher priority.
	**/
	public any function appendPath(path) {
	  this.__trail__.paths.append(path);
	};


	/**
	* Paths#clearPaths() -> Void
	*
	* Clear all paths and start fresh.
	*
	* There is no mechanism for reordering paths, so its best to
	* completely wipe the paths list and reappend them in the order
	* you want.
	**/
	public any function clearPaths() {
	  var trail = this.__trail__;

	  this.paths.forEach(function (path) {
	    trail.remove(path);
	  });
	};

	public any function getPaths() {
	  return _.toArray(this.__trail__.paths);
	};
	public any function getRoot() {
	  return this.__trail__.root;
	};

}