/**
* 
* @name Index
* @hint 
*/
component extends="hike" {
	import "vendor.underscore";
	import "vendor.path";
	/**
	* new Index(root, paths, extensions, aliases)
	**/
	public any function init(root, paths, extensions, aliases) {
		/** internal, read-only
		* Index#root -> String
		*
		* Root path. This attribute is immutable.
		**/
		this.root = arguments.root;

		// Freeze is used here so an error is throw if a mutator method
		// is called on the array. Mutating `paths`, `extensions`, or
		// `aliases` would have unpredictable results.

		/** read-only
		* Index#paths -> Paths
		*
		* Immutable (frozen) [[Paths]] collection.
		**/
		this.paths = arguments.paths.clone();

		/** read-only
		* Index#extensions -> Extensions
		*
		* Immutable (frozen) [[Extensions]] collection.
		**/
		this.extensions = arguments.extensions.clone();

		/** read-only
		* Index#aliases -> Aliases
		*
		* Immutable map of aliases.
		**/
		this.aliases = arguments.aliases.clone();

		// internal cache

		this.__entries__ = {};
		this.__patterns__ = {};
		this.__stats__ = {};
	}


	//PRIVATE
	private function sort_matches(self, matches, basename) {
	  var aliases = self.aliases.get(path.extname(basename)).toArray();

	  return _.sortBy(matches, function (match) {
	    var extnames = ListToArray(replace(basename, '','all'),".");
	    return extnames.reduce(function (sum, ext) {
	      ext = '.' + ext;

	      if (0 <= self.extensions.indexOf(ext)) {
	        return sum + self.extensions.indexOf(ext) + 1;
	      } else if (0 <= aliases.indexOf(ext)) {
	        return sum + aliases.indexOf(ext) + 11;
	      } else {
	        return sum;
	      }
	    }, 0);
	  });
	}

	//HELPERS
	// escape special chars.
	// so the string could be safely used as literal in the RegExp.
	function regexp_escape(str) {
	  return rereplaceNoCase(str,"([.?*+{}()\[\]])",'\\$1','all');
	}

	// tells whenever pathname seems like a relative path or not
	function is_relative(pathname) {
	  return (arrayLen(reMatchNoCase("^\.{1,2}\/",pathname)) GT 0);
	}

	// Returns a `Regexp` that matches the allowed extensions.
	//
	// pattern_for(self, "index.html");
	// // -> /^index(.html|.htm)(.builder|.erb)*$/
	function pattern_for(self, basename) {
	  var aliases;
	  var extname;
	  var pattern;

	  if (!self.__patterns__[basename]) {
	    extname = path.extname(basename);
	    aliases = self.aliases.get(extname).toArray();

	    if (0 === aliases.length) {
	      pattern = regexp_escape(basename);
	    } else {
	      basename = path.basename(basename, extname);
	      aliases.addAll(extname);
	      pattern = regexp_escape(basename) &
	                 '(?:' & _.map(aliases, regexp_escape).join('|') & ')';
	    }

	    pattern += '(?:' + _.map(self.extensions.toArray(), regexp_escape).join('|') + ')*';
	    self.__patterns__[basename] = new RegExp('^' + pattern + '$');
	  }

	  return self.__patterns__[basename];
	}


	// Checks if the path is actually on the file system and performs
	// any syscalls if necessary.
	function match(self, dirname, basename, fn) {
	  var ret;
	  var pathname;
	  var stats;
	  var pattern;
	  var matches = self.entries(dirname);

	  pattern = pattern_for(self, basename);
	  matches = matches.filter(function (m) { return pattern.test(m); });
	  matches = sort_matches(self, matches, basename);

	  while (matches.length && undefined === ret) {
	    pathname = path.join(dirname, matches.shift());
	    stats = getFileInfo(pathname);

	    if (stats && stats.isFile()) {
	      ret = fn(pathname);
	    }
	  }

	  return ret;
	}


	// Returns true if `dirname` is a subdirectory of any of the `paths`
	function contains_path(self, dirname) {
	  return _.any(self.paths.toArray(), function (path) {
	    return path === dirname.substr(0, path.length);
	  });
	}


	// Finds relative logical path, `../test/test_trail`. Requires a
	// `base_path` for reference.
	function find_in_base_path (self, logical_path, base_path, fn) {
	  var candidate = path.resolve(base_path, logical_path);
	  var dirname = path.dirname(candidate);
	  var basename = path.basename(candidate);

	  if (contains_path(self, dirname)) {
	    return match(self, dirname, basename, fn);
	  }
	}


	// Finds logical path across all `paths`
	function find_in_paths(self, logical_path, fn) {
	  var dirname = path.dirname(logical_path);
	  var basename = path.basename(logical_path);
	  var paths = self.paths.toArray();
	  var pathname;

	  while (paths.length && undefined === pathname) {
	    pathname = match(self, path.resolve(paths.shift(), dirname), basename, fn);
	  }

	  return pathname;
	}


	// PUBLIC //////////////////////////////////////////////////////////////////////


	


	/**
	* Index#index -> Index
	*
	* Self-reference to be compatable with the [[Trail]] interface.
	**/
	public any function getIndex() {
		return this;
	};


	/**
	* Index#find(logical_paths[, options][, fn]) -> String
	*
	* The real implementation of `find`.
	* [[Trail#find]] generates a one time index and delegates here.
	*
	* See [[Trail#find]] for usage.
	**/
	public any function find(logical_paths, options, fn) {
	  var pathname;
	  var base_path;
	  var logical_path;

	  if (!fn && _.isFunction(options)) {
	    fn = options;
	    options = {};
	  } else if (!fn) {
	    return this.find(logical_paths, options, function (p) {
	      return p;
	    });
	  }

	  options = options || {};
	  base_path = options.basePath || this.root;
	  logical_paths = _.isArray(logical_paths) ? logical_paths.slice() : [logical_paths];

	  while (logical_paths.length && undefined === pathname) {
	    logical_path = rereplace(logical_paths.pop(),"^\/", '',"ALL");

	    if (is_relative(logical_path)) {
	      pathname = find_in_base_path(this, logical_path, base_path, fn);
	    } else {
	      pathname = find_in_paths(this, logical_path, fn);
	    }
	  }

	  return pathname;
	};


	/**
	* Index#entries(pathname) -> Array
	* - pathname(String): Pathname to get files list for.
	*
	* A cached version of `fs.readdirSync` that filters out `.` files and
	* `~` swap files. Returns an empty `Array` if the directory does
	* not exist.
	**/
	public any function entries(pathname) {
	  if (!this.__entries__[pathname]) {
	    try {
	      this.__entries__[pathname] = [];
	      this.__entries__[pathname] = fs.readdirSync(pathname || '').filter(function (f) {
	        return (!arrayLen(reMatch("^\.|~$|^\##.*\##$",f)));
	      }).sort();
	    } catch (err) {
	      if ('ENOENT' !== err.code) {
	        throw err;
	      }
	    }
	  }

	  return this.__entries__[pathname];
	};


	/**
	* Index#stat(pathname) -> Stats|Null
	* - pathname(String): Pathname to get stats for.
	*
	* Cached version of `path.statsSync()`.
	* Retuns `null` if file does not exists.
	**/
	public any function stat(pathname) {
		//writeDump(pathname[1]);
	  if (!isDefined("theIndex.__stats__[pathname]")) {
	    try {
	    	//writeDump(var=pathname,abort=true);
	      theIndex.__stats__[pathname] = "";
	      theIndex.__stats__[pathname] = GetFileInfo(pathname);
	    } catch (err) {
	      if ('ENOENT' !== err.code) {
	        throw err;
	      }
	    }
	  }

	  return theIndex.__stats__[pathname];
	};
}

// Sorts candidate matches by their extension priority.
// Extensions in the front of the `extensions` carry more weight.
