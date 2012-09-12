import "vendor/path";
/**
* 
* @name AssetAttributes
* @hint 
*/
component {
	property name="searchPaths"
				type="array";

	property name="logicalPath"
				type="string";


	property name="extensions"
				type="array";

	public any function init(environment,pathname) {
		
		return this;
	}

	public any function getSearchPaths() {
		var paths = [this.pathname]
		var exts = this.extensions.join("");
		var path_without_extensions;

		if ('index' !== path.basename(this.pathname, exts)) {
			path_without_extensions = this.extensions.reduce(function (p, ext) {
			  return p.replace(ext, '');
		}, this.pathname);

		paths.push(path.join(path_without_extensions, "index" + exts));
		}

		return paths;
	}

	public any function getLogicalPath() {
		var pathname = this.pathname, paths = this.environment.paths, root_path;

		root_path = _.detect(paths, function (root) {
		return root === pathname.substr(0, root.length);
		});

		if (!root_path) {
		throw new Error("File outside paths: " + pathname + " isn't in paths: " +
		            paths.join(", "));
		}

		pathname = pathname.replace(root_path + "/", "");
		pathname = this.engineExtensions.reduce(function (p, ext) {
		return p.replace(ext, "");
		}, pathname);

		if (!this.formatExtension) {
		pathname += (this.engineFormatExtension || '');
		}

		return pathname;
	}

	public any function getExtensions() {
		var extensions;

		if (!this.__extensions__) {
		extensions = path.basename(this.pathname).split('.').slice(1);
		prop(this, '__extensions__', extensions.map(function (ext) {
		  return "." + ext;
		}));
		}


		return this.__extensions__.slice();
	}

	public any function getFormatExtension() {
		return _.find(this.extensions.reverse(), function (ext) {
		    return this.getMimeType(ext) && !this.getEngines(ext);
		  }, this.environment);
	}

	public any function getEngineExtensions() {
		var env = this.environment,
		      exts = this.extensions,
		      offset = exts.indexOf(this.formatExtension);

		  if (0 <= offset) {
		    exts = exts.slice(offset + 1);
		  }

		  return _.filter(exts, function (ext) { return !!env.getEngines(ext); });
	}

	public any function getEngines() {
		var env = this.environment;
  return this.engineExtensions.map(function (ext) { return env.getEngines(ext); });
	}

	public any function getProcessors() {
		return [].concat(this.environment.getPreProcessors(this.contentType),
                   this.engines.reverse(),
                   this.environment.getPostProcessors(this.contentType));
	}

	public any function getContentType() {
		var mime_type;

		  if (!this.__contentType__) {
		    mime_type = this.engineContentType || 'application/octet-stream';

		    if (this.formatExtension) {
		      mime_type = this.environment.getMimeType(this.formatExtension, mime_type);
		    }

		    prop(this, '__contentType__', mime_type);
		  }

		  return this.__contentType__;
	}

	public any function getEngineContentType() {
		var engine = _.detect(this.engines.reverse(), function (engine) {
		    return !!engine.defaultMimeType;
		  });

		  return (engine || {}).defaultMimeType;
	}

	public any function getEngineFormatExtension() {
		var type = this.engineContentType;
		if (type) {
		return this.environment.getExtensionForMimeType(type);
		}
	}
}