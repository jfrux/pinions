/**
* @name Environment.cfc
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

	public any function init() {
		variables._ = new Underscore();
		variables.Sprockets = new lib.Sprockets();
		this = _.extend(this,new base());
		this.__trail__ = new Trail();
		this["__mimeTypes__"] = new vendor.Mime();
		// append paths
		_.each(Sprockets.paths, function (path) {
			this.appendPath(path);
		}, this);

		// append default engines
		_.each(this.getEngines(), function (klass, ext) {
			this.addEngineToTrail(ext, klass);
		}, this);

		// register default mimeType extensions
		_.each(this.__mimeTypes__.types, function (type, ext) {
			this.__trail__.extensions.append(ext);
		}, this);

		// force drop cache
		this.expireIndex();

		return this;
	}

	/**
	* Environment#findAsset(path[, options]) -> Asset
	*
	* Proxies call to [[Index#findAsset]] of the one time [[Environment#index]]
	* instance. [[Index#findAsset]] automatically pushes cache here.
	**/
	public any function findAsset(path, options) {
	  var asset;

	  options = options || {};
	  options.bundle = (undefined === options.bundle) ? true : !!options.bundle;

	  // Ensure inmemory cached assets are still fresh on every lookup
	  asset = this.__assets__[this.cacheKeyFor(path, options)];
	  if (asset && asset.isFresh(this)) {
	    return asset;
	  }

	  // Cache is pushed upstream by Index#find_asset
	  return this.index.findAsset(path, options);
	};


	/** internal
	* Environment#expireIndex() -> Void
	*
	* Reset assets internal cache.
	**/
	public any function expireIndex() {
	  this.__assets__ = {};
	};


	/**
	* Environment#registerHelper(name, func) -> Void
	* Environment#registerHelper(helpers) -> Void
	*
	* Proxy to [[Context.registerHelper]] of current [[Environment#ContextClass]].
	*
	*
	* ##### Example
	*
	* env.registerHelper('foo', function () {});
	*
	* // shorthand syntax of
	*
	* env.ContextClass.registerHelper('foo', function () {});
	**/
	public any function registerHelper() {
	  this.ContextClass.registerHelper.apply(null, arguments);
	};


}