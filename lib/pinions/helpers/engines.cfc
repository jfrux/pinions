/** internal
 *  mixin Engines
 *
 *  An internal mixin whose public methods are exposed on the [[Environment]]
 *  and [[Index]] classes.
 *
 *  An engine is a type of processor that is bound to an filename
 *  extension. `application.js.coffee` indicates that the
 *  [[engines.coffee]] engine will be ran on the file.
 *
 *  Extensions can be stacked and will be evaulated from right to
 *  left. `application.js.coffee.ejs` will first run `EjsEngine`
 *  then [[engines.coffee]].
 *
 *  All `Engine`s must follow the [[Template]] interface. It is
 *  recommended to subclass [[Template]].
 *
 *  Its recommended that you register engine changes on your local
 *  `Environment` instance.
 *
 *      environment.registerEngine('.foo', FooProcessor);
 *
 *  The global registry is exposed for plugins to register themselves.
 *
 *      Mincer.registerEngine('.ejs', EjsEngine);
 **/


// REQUIRED PROPERTIES /////////////////////////////////////////////////////////
//
// - `__engines__` (Object)
//
////////////////////////////////////////////////////////////////////////////////
component name="Engines" accessors=true {
	/**
	* Engines#engineExtensions -> Array
	*
	* Returns an `Array` of engine extension `String`s.
	*
	* environment.engineExtensions;
	* // -> ['.coffee', '.sass', ...]
	**/
	property name='engineExtensions'
	type="array";

	property name="__engines__"
	type="array";


	public any function init(engines = []) {
		this.__engines__ = (arrayLen(arguments.engines) GT 0)? arguments.engines : [];
		return this;
	}

	/**
	* Engines#getEngines(ext) -> Object|Function
	*
	* Returns an `Object` map of `extension => Engine`s registered on the
	* `Environment`. If an `ext` argument is supplied, the `Engine` register
	* under that extension will be returned.
	*
	* environment.getEngines()
	* // -> { ".styl": StylusEngine, ... }
	*
	* environment.getEngines('.styl')
	* // -> StylusEngine
	**/
	public any function getEngines(ext = "") {
	  if (!_.isEmpty(arguments.ext)) {
	    return this.__engines__[normalizeExtension(arguments.ext)];
	  } else {
	    return _.clone(this.__engines__);
	  }
	};


	
	public any function getEngineExtension() {
	  return _.keys(this.__engines__);
	}

	/**
	* Engines#registerEngine(ext, klass) -> Void
	*
	* Registers a new Engine `klass` for `ext`. If the `ext` already
	* has an engine registered, it will be overridden.
	*
	* environment.registerEngine('.coffee', CoffeeScriptTemplate);
	**/
	public any function registerEngine(ext, klass) {
	  this.__engines__[normalizeExtension(ext)] = klass;
	};


}