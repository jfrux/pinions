/*
* @name Base.cfc
* @hint 
*/
component accessors=true {
	import "cf_modules.UnderscoreCF.Underscore";
	import "cf_modules.cf-path.Path";
	import "cf_modules.cf-hike.lib.trail";
	import "version";
	import "asset_attributes";
	import "assets.*";
	import "helpers.*";

	public any function init() {
		//3rd party
		variables.path = new Path();
		variables._ = new Underscore();
		
		//mixin internal functions into this cfc
		this = _.extend(this,new Paths());
		this = _.extend(this,new Mime());
		this = _.extend(this,new Processing());
		this = _.extend(this,new Engines());

			//
			// override [[Paths]] mixin methods
			//
			attr_with_expire_index('digestAlgorithm', 'md5');

			attr_with_expire_index('version', '');
			// func_proxy_with_expire_index('prependPath',this.prependPath);
			// func_proxy_with_expire_index('appendPath',this.appendPath);
			// func_proxy_with_expire_index('clearPaths',this.clearPaths);

			//
			// override [[Mime]] mixin methods
			//

			func_proxy_with_expire_index('registerMimeType', function (mimeType, ext) {
			  this.__trail__.extensions.append(ext);
			});

			//
			// override [[Engines]] mixin methods
			//

			func_proxy_with_expire_index('registerEngine', function (ext, klass) {
			  this.addEngineToTrail(ext, klass);
			});

			//
			// override [[Processing]] mixin methods
			//

			func_proxy_with_expire_index('registerPreprocessor',this.registerPreprocessor);
			func_proxy_with_expire_index('registerPostprocessor',this.registerPostprocessor);
			func_proxy_with_expire_index('registerBundleProcessor',this.registerBundleProcessor);
			func_proxy_with_expire_index('unregisterPreprocessor',this.unregisterPreprocessor);
			func_proxy_with_expire_index('unregisterPostprocessor',this.unregisterPostprocessor);
			func_proxy_with_expire_index('unregisterBundleProcessor',this.unregisterBundleProcessor);

		return this;
	}

	public void function attr_with_expire_index(name, value) {
	  "__name__" = "__#name#__";

	  // set underlying value
	  this[__name__] = value;

	  // provide getters/setter
	  this["get#name#"] = function () {
	      return this[__name__];
	  }

	  this["set#name#"] = function (val) {
	      this.expireIndex();
	      this[__name__] = val;
	  }
	}

	function func_proxy_with_expire_index(name, func) {
		var orig = this[name];
		var theFunc = arguments.func;
		this[name] = function() {
			this.expireIndex();

			if (isDefined("theFunc")) {
				theFunc(argumentCollection=arguments);
			}

			orig(argumentCollection=arguments);
		};
	}

	public any function getDigest() {
		// Do not cache, so the caller can safely mutate it with `.update`
		  var digest = crypto.createHash(this.digestAlgorithm);

		  // Mixin Mincer release version and custom environment version.
		  // So any new releases will affect all your assets.
		  digest.update(VERSION, 'utf8');
		  digest.update(this.version, 'utf8');

		  return digest;
	}



	/**
	* resolve(logicalPath[, options = {}[, fn]]) -> String
	* - logicalPath (String)
	* - options (Object)
	* - fn (Function)
	*
	* Finds the expanded real path for a given logical path by
	* searching the environment's paths.
	*
	* env.resolve("application.js")
	*   => "/path/to/app/javascripts/application.js.coffee"
	*
	* An Error with `code = 'FileNotFound'` is raised if the file does not exist.
	**/
	public any function resolve(logicalPath, options, fn) {
	  var err;
	  var resolved;
	  var args;

	  if (fn) {
	    args = this.attributesFor(logicalPath).searchPaths;
	    resolved = this.__trail__.find(args, options, fn);
	  } else {
	    resolved = this.resolve(logicalPath, options, function (pathname) {
	      return pathname;
	    });

	    if (!resolved) {
	      err = new Error("couldn't find file '" + logicalPath + "'");
	      err.code = 'FileNotFound';
	      throw err;
	    }
	  }

	  return resolved;
	};


	/**
	* entries(pathname) -> Array
	* - pathname (String)
	*
	* Proxy to `Hike.Trail entries`. Works like `fs.readdirSync`.
	* Subclasses may cache this method.
	**/
	public any function entries(pathname) {
	  return this.__trail__.entries(pathname);
	};


	/**
	* stat(pathname) -> fs.Stats
	* - pathname (String)
	*
	* Proxy to `Hike.Trail stat`. Works like `fs.statSync`.
	* Subclasses may cache this method.
	**/
	public any function stat(pathname) {
	  return this.__trail__.stat(pathname);
	};


	/**
	* getFileDigest(pathname) -> String
	* - pathname (String)
	*
	* Read and compute digest of filename.
	* Subclasses may cache this method.
	**/
	public any function getFileDigest(pathname) {
	  var stat = this.stat(pathname);

	  if (stat && stat.isDirectory()) {
	    // If directory, digest the list of filenames
	    return this.digest.update(this.entries(pathname).join(',')).digest('hex');
	  }

	  // If file, digest the contents
	  return this.digest.update(fs.readFileSync(pathname)).digest('hex');
	};


	/** internal
	* attributesFor(pathname) -> AssetAttributes
	* - pathname (String)
	*
	* Returns a `AssetAttributes` for `pathname`
	**/
	public any function attributesFor(pathname) {
		//writeDump(arguments.pathname);
	  return new asset_attributes(this, arguments.pathname);
	};


	/** internal
	* contentTypeOf(pathname) -> String
	* - pathname (String)
	*
	* Returns content type of `pathname`
	**/
	public any function contentTypeOf(pathname) {
	  return this.attributesFor(pathname).contentType;
	};


	/**
	* findAsset(pathname[, options = {}]) -> Asset
	* - pathname (String)
	* - options (Object)
	*
	* Find asset by logical path or expanded path.
	**/
	public any function findAsset(pathname, options) {
	  var logical_path = pathname;

	  if (isAbsolute(pathname)) {
	    if (!this.stat(pathname)) {
	      return;
	    }

	    logical_path = this.attributesFor(pathname).logicalPath;
	  } else {
	    try {
	      pathname = this.resolve(logical_path);
	    } catch (err) {
	      if ('FileNotFound' === err.code) {
	        return null;
	      }

	      throw err;
	    }
	  }

	  return this.buildAsset(logical_path, pathname, options);
	};



	/**
	* precompile(files[, callback]) -> Void
	* - files (Array):
	* - callback (Function):
	*
	* Helper to make sure that given list of `files` were compiled.
	* Similar to [[Manifestcompile]], but does not write anything to disk.
	*
	* environment.precompile(["app.js"], function (err, data) {
	* // data => {
	* // files: {
	* // "app.js" : "app-2e8e9a7c6b0aafa0c9bdeec90ea30213.js"
	* // },
	* // assets: {
	* // "app-2e8e9a7c6b0aafa0c9bdeec90ea30213.js" : {
	* // "logical_path" : "app.js",
	* // "mtime" : "2011-12-13T21:47:08-06:00",
	* // "digest" : "2e8e9a7c6b0aafa0c9bdeec90ea30213"
	* // }
	* // }
	* // }
	* });
	*
	* Needed when you want to render HTML with some JavaScript injected right
	* into your page (e.g. single-page offline documentation) and your template
	* engine does not support asynchronous helpers (e.g. Jade requires helpers
	* to be synchronous).
	**/
	public any function precompile(files, callback) {
	  var self = this;
	  var data = {files: {}, assets: {}};
	  var paths = [];

	  this.eachLogicalPath(files, function (pathname) {
	    paths.push(pathname);
	  });

	  paths = _.union(paths, _.select(files, isAbsolute));
	  async.forEachSeries(paths, function (pathname, next) {
	    var asset = self.findAsset(pathname, {bundle: true});

	    if (!asset) {
	      next(new Error("Can not find asset '" + pathname + "'"));
	      return;
	    }

	    asset.compile(function (err, asset) {
	      if (err) {
	        next(err);
	        return;
	      }

	      data.assets[asset.logicalPath] = asset.digestPath;
	      data.files[asset.digestPath] = {
	        logical_path: asset.logicalPath,
	        mtime: asset.mtime.toISOString(),
	        size: asset.length,
	        digest: asset.digest
	      };

	      next();
	    });
	  }, function (err) {
	    callback(err, data);
	  });
	};


	/**
	* eachEntry(root, iterator) -> Void
	* - root (String)
	* - iterator (Function)
	*
	* Calls `iterator` on each found file or directory in alphabetical order:
	*
	* env.eachEntry('/some/path', function (entry) {
	* console.log(entry);
	* });
	* // -> "/some/path/a"
	* // -> "/some/path/a/b.txt"
	* // -> "/some/path/a/c.txt"
	* // -> "/some/path/b.txt"
	**/
	public any function eachEntry(root, iterator) {
	  var self = this;
	  var paths = [];
	  path = new Path();

	  _.each(this.entries(root),function (filename) {
	    var pathname = path.join(root, filename);
	    var stats = getFileInfo(pathname);

	    if (!isDefined('stats')) {
	      // File not found - silently skip it.
	      // It might happen only if we got "broken" symlink in real life.
	      // See https://github.com/nodeca/mincer/issues/18
	      return;
	    }

	    paths.add(pathname);
	    writeDump(paths);
	    if (directoryExists(pathname)) {
	      self.eachEntry(pathname, function (subpath) {
	        paths.add(subpath);
	      });
	    }
	  });
	  _.each(ArraySort(paths,"text"),iterator);
	};


	/**
	* eachFile(iterator) -> Void
	* - iterator (Function)
	*
	* Calls `iterator` for each file found within all registered paths.
	**/
	public any function eachFile(iterator) {
	  var self = this;
	  _.each(this.__trail__.paths,function (root) {
	    self.eachEntry(root, function (pathname) {
	      if (!directoryExists(pathname)) {
	        iterator(pathname);
	      }
	    });
	  });
	};


	// Returns true if there were no filters, or `filename` matches at least one
	function matches_filter(filters, filename) {
	  if (0 === filters.length) {
	    return true;
	  }

	  return _.any(filters, function (filter) {
	    if (_.isRegExp(filter)) {
	      return filter.test(filename);
	    }

	    if (_.isFunction(filter)) {
	      return filter(filename);
	    }

	    // prepare string to become RegExp.
	    // mimics shells globbing
	    filter = filter.toString().rereplacenocase(filter,"\*\*|\*|\?|\\.|\.",function (m) {
	      switch (m[0]) {
	        case "*": return "**" === m ? ".+?" : "[^/]+?";
	        case "?": return "[^/]?";
	        case ".": return "\\.";
	        // handle `\\.` part
	        default: return m;
	      }
	    }, "ALL");

	    // prepare RegExp
	    filter = new RegExp('^' + filter + '$');
	    return filter.test(filename);
	  });
	}


	// Returns logicalPath for `filename` if it mtches given filters
	function logical_path_for_filename(self, filters, filename) {
	  var logical_path = self.attributesFor(filename).getlogicalPath();

	  if (matches_filter(filters, logical_path)) {
	    return logical_path;
	  }

	  // If filename is an index file, retest with alias
	  if ('index' === path.basename(filename).split('.').shift()) {
	    logical_path = rereplace(logical_path,"/\/index\./", '.',"all");
	    if (matches_filter(filters, logical_path)) {
	      return logical_path;
	    }
	  }
	}


	/**
	* eachLogicalPath(filters, iterator) -> Void
	* - filters (Array)
	* - iterator (Function)
	*
	* Calls `iterator` on each found logical path (once per unique path) that
	* matches at least one of the given filters.
	*
	* Each filter might be a `String`, `RegExp` or a `Function`.
	**/
	public any function eachLogicalPath(filters, iterator) {
	  var self = this;
	  var files = {};

	  this.eachFile(function (filename) {
	    var logical_path = this.logical_path_for_filename(self, filters, filename);
	    if (logical_path && !files[logical_path]) {
	      iterator(logical_path);
	      files[logical_path] = true;
	    }
	  });
	};


	// circular call protection helper.
	// keeps array of required pathnames until the function
	// that originated protection finishes it's execution
	circular_calls = [];
	function circular_call_protection(pathname, callback) {
	  var reset = (_.isEmpty(circular_calls));
	 var calls = circular_calls || (circular_calls = []);
	var result;
	 var error;

	  if (0 <= calls.indexOf(pathname)) {
	    if (reset) { circular_calls = null; }
	    throw new Error("Circular dependency detected: " + pathname +
	                    " has already been required");
	  }

	  calls.push(pathname);

	  try {
	    result = callback();
	  } catch (err) {
	    error = err;
	  }

	  if (reset) {
	    circular_calls = null;
	  }

	  if (error) {
	    throw error;
	  }

	  return result;
	}


	// creates instance of [[StaticAsset]], [[BundledAsset]] or [[ProcessedAsset]]
	public any function buildAsset(logicalPath, pathname, options) {
	  var self = this;

	  options = options || {};

	  // If there are any processors to run on the pathname, use
	  // `BundledAsset`. Otherwise use `StaticAsset` and treat is as binary.

	  if (0 === this.attributesFor(pathname).processors.length) {
	    return new StaticAsset(this.index, logicalPath, pathname);
	  }

	  if (options.bundle) {
	    return new BundledAsset(this.index, logicalPath, pathname);
	  }

	  return circular_call_protection(pathname, function () {
	    return new ProcessedAsset(self.index, logicalPath, pathname);
	  });
	};


	// Returns cache key for given `pathname` based on options
	public any function cacheKeyFor(pathname, options) {
	  return pathname + String(options.bundle ? 1 : 0);
	};
}