/**
* @name Index.cfc
* @hint 
*/
component accessors=true {
	import "vendor.underscore";
	import "vendor.hike.trail";

	// internal cache
	property name='__assets__'
			type="struct"
			setter=true
			getter=true;
	property name='__engines__'
			type="struct"
			setter=true
			getter=true;

	public any function init(environment) {
		variables._ = new Underscore();
		variables.Sprockets = new lib.Sprockets();
		this = _.extend(this,new base());
		this.environment = arguments.environment;
		this.ContextClass = this.environment.ContextClass;
		this["__trail__"] = this.environment.__trail__.index;
		this["__engines__"] = this.environment.getEngines();
		this["__mimeTypes__"] = this.environment.registeredMimeTypes;
		this["__preProcessors__"] = this.environment.getPreProcessors();
		this["__postProcessors__"] = this.environment.getPostProcessors();
		this["__bundleProcessors__"] = this.environment.getBundleProcessors();
		this['__digestAlgorithm__'] = this.environment.digestAlgorithm;
		this['__version__'] = this.environment.version;
		this['__assets__'] = {};
		this['__digests__'] = {};

		return this;
	}
	/**
	* Index#index -> Index
	*
	* Self-reference to provide same interface as in [[Environment]].
	**/
	public any function getIndex() {
	  return this;
	});

	/**
	* Index.getFileDigest(pathname) -> crypto.Hash
	*
	* Cached version of [[Base#getFileDigest]].
	**/
	public any function getFileDigest(pathname) {
	  if (!isDefined("this.__digests__[pathname]")) {
	    this.__digests__[pathname] = Base.prototype.getFileDigest.call(this, pathname);
	  }

	  return this.__digests__[pathname];
	};

	/**
	* Index#findAsset(pathname[, options]) -> Asset
	*
	* Caches calls to [[Base#findAsset]].
	* Pushes cache to the upstream environment as well.
	**/
	public any function findAsset(path, options) {
	    var asset;
	    var logical_cache_key;
	    var fullpath_cache_key;

		options = options || {};
		options.bundle = (undefined === options.bundle) ? true : options.bundle;
		logical_cache_key = this.cacheKeyFor(pathname, options);

		if (this.__assets__[logical_cache_key]) {
			return this.__assets__[logical_cache_key];
		}

		asset = Base.prototype.findAsset.call(this, pathname, options);

		if (asset) {
			fullpath_cache_key = this.cacheKeyFor(asset.pathname, options);

			// Cache on Index
			this.__assets__[logical_cache_key] =
			this.__assets__[fullpath_cache_key] = asset;

			// Push cache upstream to Environment
			this.environment.__assets__[logical_cache_key] =
			this.environment.__assets__[fullpath_cache_key] = asset;

			return asset;
		}
	};


	/** internal
	* Index#expireIndex() -> Void
	*
	* Throws an error. Kept for keeping same interface as in [[Environment]].
	**/
	public any function expireIndex() {
	   throw new Error("Can't modify immutable index");
	};

}