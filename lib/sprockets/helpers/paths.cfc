/**
* @name Paths.cfc
* @hint 
*/
component {
	public any function init() {
		
		return this;
	}

	/**
	* Paths#prependPath(path) -> Void
	*
	* Prepend a `path` to the `paths` list.
	* Paths at the end have the least priority.
	**/
	function prependPath(path) {
	  this.__trail__.paths.prepend(path);
	};


	/**
	* Paths#appendPath(path) -> Void
	*
	* Append a `path` to the `paths` list.
	* Paths at the beginning have a higher priority.
	**/
	function appendPath(path) {
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
	function clearPaths() {
	  var trail = this.__trail__;

	  this.paths.forEach(function (path) {
	    trail.remove(path);
	  });
	};


}