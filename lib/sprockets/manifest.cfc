/**
* @name Manifest.cfc
* @hint 
*/
component accessors=true {
	import "vendor.underscore";
	import "vendor.path";

	property name="environment"
	type="environment"
	getter=true
	setter=true;

	property name="data"
		type="struct";

	property name="dir"
			type="string"
			getter=true
			setter=true;

	property name="path"
			type="string"
			getter=true
			setter=true;

	public any function init(environment,pathname) {
		var data = {};
		variables._ = new Underscore();
		variables.path = new Path();

		this.environment = arguments.environment;
		
		if('' === path.extname(arguments.pathname)) {
			this.setDir(path.resolve(arguments.pathname));
			this.setPath(path.join(this.getDir(),'manifest.json'));
		} else {
			this.setDir(path.dirname(arguments.pathname));
			this.setPath(path.resolve(arguments.pathname));
		}

		if(fileExists(this.getPath())) {
			try {
				data = deserializeJson(fileRead(this.path));
			} catch (err) {
				writeDump(var = this.getPath() & " is invalid: " & err,abort = true);
			}
		}

		this.data = (!_.isEmpty(data) && _.isStruct(data)) ? data : {};

		return this;
	}

	/**
	* Manifest#assets -> Object
	*
	* Returns internal assets mapping. Keys are logical paths which
	* map to the latest fingerprinted filename.
	*
	*
	* ##### Synopsis:
	*
	* Logical path (String): Fingerprint path (String)
	*
	*
	* ##### Example:
	*
	* {
	* "application.js" : "application-2e8e9a7c6b0aafa0c9bdeec90ea30213.js",
	* "jquery.js" : "jquery-ae0908555a245f8266f77df5a8edca2e.js"
	* }
	**/
	public any function getAssets() {
	  if (!this.data.assets) {
	    this.data.assets = {};
	  }

	  return this.data.assets;
	};


	/**
	* Manifest#files -> Object
	*
	* Returns internal file directory listing. Keys are filenames
	* which map to an attributes array.
	*
	*
	* ##### Synopsis:
	*
	* Fingerprint path (String):
	* logical_path: Logical path (String)
	* mtime: ISO8601 mtime (String)
	* digest: Base64 hex digest (String)
	*
	*
	* ##### Example:
	*
	* {
	* "application-2e8e9a7c6b0aafa0c9bdeec90ea30213.js" : {
	* 'logical_path' : "application.js",
	* 'mtime' : "2011-12-13T21:47:08-06:00",
	* 'digest' : "2e8e9a7c6b0aafa0c9bdeec90ea30213"
	* }
	* }
	**/
	public any function getFiles() {
	  if (!this.data.files) {
	    this.data.files = {};
	  }

	  return this.data.files;
	};


	// Basic wrapper around Environment#findAsset and Environment#compile.
	// Logs compile time.
	public any function compileAsset(logicalPath, callback) {
	  var self = this;
	  var timer = start_timer;
	  var asset = self.environment.findAsset(logicalPath, {bundle: true});

	  if (!asset) {
	    callback(new Error("Can not find asset '" + logicalPath + "'"));
	    return;
	  }

	  asset.compile(function (err, asset) {
	    if (err) {
	      callback(err);
	      return;
	    }

	    logger.warn(format('Compiled %s (%dms)', logicalPath, timer.stop()));
	    callback(err, asset);
	  });
	};


	/**
	* Manifest#compile(files[, callback]) -> Void
	* - files (Array):
	* - callback (Function):
	*
	* Compile and write asset(s) to directory. The asset is written to a
	* fingerprinted filename like `app-2e8e9a7c6b0aafa0c9bdeec90ea30213.js`.
	* An entry is also inserted into the manifest file.
	*
	* manifest.compile(["app.js"], function (err, data) {
	* // data => {
	* // files: {
	* // "app.js" : "app-2e8e9a7c6b0aafa0c9bdeec90ea30213.js",
	* // ...
	* // },
	* // assets: {
	* // "app-2e8e9a7c6b0aafa0c9bdeec90ea30213.js" : {
	* // "logical_path" : "app.js",
	* // "mtime" : "2011-12-13T21:47:08-06:00",
	* // "digest" : "2e8e9a7c6b0aafa0c9bdeec90ea30213"
	* // },
	* // ...
	* // }
	* // }
	* });
	**/
	public any function compile(files, callback) {
	  var self = this;
	  var paths = [];

	  this.environment.eachLogicalPath(files, function (pathname) {
	    paths.push(pathname);
	  });

	  paths = _.union(paths, _.select(files, isAbsolute));

	  async.forEachSeries(paths, function (logicalPath, next) {
	    self.compileAsset(logicalPath, function(err, asset) {
	      var target;

	      if (err) {
	        callback(err);
	        return;
	      }

	      target = path.join(self.dir, asset.digestPath);

	      self.assets[asset.logicalPath] = asset.digestPath;
	      self.files[asset.digestPath] = {
	        logical_path: asset.logicalPath,
	        mtime: asset.mtime.toISOString(),
	        size: asset.length,
	        digest: asset.digest
	      };

	      fs.exists(target, function (exists) {
	        if (exists) {
	          logger.debug('Skipping ' + target + ', already exists');
	          self.save(next);
	          return;
	        }

	        logger.info('Writing ' + target);
	        async.series([
	          function (next) { asset.writeTo(target, {}, next); },
	          function (next) { self.save(next); }
	        ], next);
	      });
	    });
	  }, function (err) {
	    callback(err, self.data);
	  });
	};


	// Persist manifest back to FS
	public any function save(callback) {
		thread
		action="run"
		name="manifestSave"
		appname="sprockets"
		{
			if(!directoryExists(this.dir)) {
				directoryCreate(this.dir);
			}

			fileWrite(this.path,serializeJson(this.data));

			callback();
		}
	};
}