import "modules.foundry.lib.*";
import "modules.underscorecf.*";
import "lib.*";
/**
* @name Trail
* @hint Public container class for holding paths and extensions.
*/
component extends="modules.foundry.lib.ClassComponent" {
	property type="string" name="root" default="."; 
	property name="paths" type="paths";
	property name="extensions" type="extensions";
	property name="aliases" type="aliases";
	property name="index";

	public any function init(root = expandPath("/")) {
		variables._ = new Underscore();
		variables.path = new Path();
		
		this['root'] = path.resolve((!_.isEmpty(arguments.root))? arguments.root : "");
		this['paths'] = new Paths(this.root);
		this['extensions'] = new Extensions();
		this['aliases'] = new Aliases();
		
		// internal cache
		this['__entries__'] = {};
		this['__patterns__'] = {};
		this['__stats__'] = {};

		this['index'] = {
			'get' = function() {
				this['index'] = new Index(this.root, this.paths, this.extensions, this.aliases);
				return this.index;
			}
		};

		return this;
	}
	
	public any function index_proxy(proto, func) {
		var loc = {};
		loc.proto = arguments.proto;
		loc.func = arguments.func;
		self = this;
		
		self[loc.func] = function () {
			var index = self.get();
			indexFunc = index[loc.func];

			return indexFunc(argumentCollection=arguments);;
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
	public any function find() {
		return this.index.get().find(argumentCollection=arguments);
	}

	/**
	* Trail#entries(pathname) -> Array
	*
	* Wrapper over [[Index#entries]] using one-time instance of [[Trail#index]].
	**/
	
	public any function entries() {
		return this.index.get().entries(argumentCollection=arguments);
	}

	/**
	* Trail#stat(pathname) -> Stats|Null
	*
	* Wrapper over [[Index#stat]] using one-time instance of [[Trail#index]].
	**/
	public any function stat() {
		return this.index.get().stat(argumentCollection=arguments);
	}
}



