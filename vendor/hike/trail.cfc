/**
* @name Trail
* @hint Public container class for holding paths and extensions.
*/
component accessors=true extends="hike" {
	import "vendor.underscore";
	import "vendor.path";
	import "vendor.hike.paths";
	import "vendor.hike.extensions";
	import "vendor.hike.index";
	/**
	* @getter false
	* @setter false
	* @hint This is an immutable property.
	* @default "."
	**/
	property type="string" name="root" default="."; 

	property name="paths"
			type="any"
			getter=true
			setter=true; 

	property name="extensions"
		getter=true
		setter=true;

	property name="aliases"
		getter=true
		setter=true;

	property name="index";

	public any function init(root = "") {
		variables._ = new Underscore();
		variables.path = new Path();
		this.root = path.resolve((!_.isEmpty(arguments.root))? arguments.root : "");
		
		this.paths = new Paths(this.root);
		this.extensions = new Extensions();
		this.aliases = new Aliases();
		this.index = getIndex();

		return this;
	}

	public any function getIndex() {
		return new Index(this.root, this.paths, this.extensions, this.aliases);
	}


	function index_proxy(proto, func) {
		loc = {};
		loc.proto = arguments.proto;
		loc.func = arguments.func;
		
		loc.proto[loc.func] = function() {
			var index = this.index;

			return index[loc.func](pathname=this.root);
		};
	}

	/**
	* Trail#find(logical_paths[, options][, fn]) -> String
	* - logical_paths (String|Array): One or many (fallbacks) logical paths.
	* - options (Object): Options hash. See description below.
	* - fn (Function): Block to execute on each matching path. See description below.
	*
	* Returns the expanded path for a logical path in the path collection.
	*
	* trail = new Trail("/home/ixti/Projects/hike-js");
	*
	* trail.extensions.append(".js");
	* trail.paths.append("lib", "test");
	*
	* trail.find("hike/trail");
	* // -> "/home/ixti/Projects/hike-js/lib/hike/trail.js"
	*
	* trail.find("test_trail");
	* // -> "/home/ixti/Projects/hike/test/test_trail.js"
	*
	* `find` accepts multiple fallback logical paths that returns the
	* first match.
	*
	* trail.find(["hike", "hike/index"]);
	*
	* is equivalent to
	*
	* trail.find("hike") || trail.find("hike/index");
	*
	* Though `find` always returns the first match, it is possible
	* to iterate over all shadowed matches and fallbacks by supplying
	* a _block_ function (`fn`).
	*
	* trail.find(["hike", "hike/index"], function (path) {
	* console.warn(path);
	* });
	*
	* This allows you to filter your matches by any condition.
	*
	* trail.find("application", function (path) {
	* if ("text/css" == mime_type_for(path)) {
	* return path;
	* }
	* });
	*
	*
	* ##### Options
	*
	* - **basePath** (String): You can specify "alternative" _base path_ to be
	* used upon searching. Default: [[Trail#root]].
	*
	* ##### Block function
	*
	* Some kind of iterator that is called on each matching pathname. Once this
	* function returns anything but `undefned` - iteration is stopped and the
	* value of this function returned.
	*
	* Default:
	*
	* function (path) { return path; }
	**/
	index_proxy(this, 'find');


	/**
	* Trail#entries(pathname) -> Array
	*
	* Wrapper over [[Index#entries]] using one-time instance of [[Trail#index]].
	**/
	index_proxy(this, 'entries');


	/**
	* Trail#stat(pathname) -> Stats|Null
	*
	* Wrapper over [[Index#stat]] using one-time instance of [[Trail#index]].
	**/
	index_proxy(this, 'stat');
	
}



