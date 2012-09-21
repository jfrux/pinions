/**
 *  class CoffeeEngine
 *
 *  Engine for the CoffeeScript compiler. You will need `coffee-script`
 *  module installed in order to use [[Pinions]] with `*.coffee` files:
 *
 *  ##### SUBCLASS OF
 *
 *  [[Template]]
 **/

component name="Processing" accessors=true {
	public any function init() {
		return this;
	}
	
	// 3rd-party
	var _ = require('underscore');
	var coffee; // initialized later


	// internal
	var Template  = require('../template');
	var prop      = require('../common').prop;


	////////////////////////////////////////////////////////////////////////////////


	// Class constructor
	var CoffeeEngine = module.exports = function CoffeeEngine() {
	  Template.apply(this, arguments);
	};


	require('util').inherits(CoffeeEngine, Template);


	// Check whenever coffee-script module is loaded
	CoffeeEngine.prototype.isInitialized = function () {
	  return !!coffee;
	};


	// Autoload coffee-script library
	CoffeeEngine.prototype.initializeEngine = function () {
	  coffee = this.require('coffee-script');
	};


	// Internal (private) options storage
	var options = {bare: true};


	/**
	 *  CoffeeEngine.setOptions(value) -> Void
	 *  - value (Object):
	 *
	 *  Allows to set CoffeeScript compilation options.
	 *  Default: `{bare: true}`.
	 *
	 *  ##### Example
	 *
	 *      CoffeeScript.setOptions({bare: true});
	 **/
	CoffeeEngine.setOptions = function (value) {
	  options = _.clone(value);
	};


	// Render data
	CoffeeEngine.prototype.evaluate = function (context, locals, callback) {
	  try {
	    var result = coffee.compile(this.data, _.clone(options));
	    callback(null, result);
	  } catch (err) {
	    callback(err);
	  }
	};


	// Expose default MimeType of an engine
	prop(CoffeeEngine, 'defaultMimeType', 'application/javascript');

}