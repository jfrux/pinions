/** internal
 *  class Processor
 *
 *  Used to create custom processors without need to extend [[Template]] by
 *  simply providing a function to the processor registration methods:
 *
 *      var name = 'my-pre-processor';
 *      var func = function (context, data, callback) {
 *        callback(null, data.toLowerCase());
 *      };
 *
 *      // register custom pre-processor
 *      environment.registerPreProcessor('text/css', name, func);
 *
 *      // unregister custom pre-processor
 *      environment.unregisterPreProcessor('text/css', name);
 *
 *
 *  ##### See Also:
 *
 *  - [[Context]]
 *  - [[Processing]]
 *
 *
 *  ##### SUBCLASS OF
 *
 *  [[Template]]
 **/

component name="processor" extends="template" {
	public any function init() {
		
		return this;
	}

	// stdlib
	var inherits = require('util').inherits;

	// 3rd-party
	var _ = require('underscore');

	// internal
	var Template      = require('./template');
	var prop          = require('./common').prop;
	var beautifyError = require('./common').beautifyError;


	// Class constructor
	var Processor = module.exports = function Processor() {
	  Template.apply(this, arguments);
	};

	inherits(Processor, Template);

	// Run processor
	Processor.prototype.evaluate = function (context, locals, callback) {
	  if (Processor === this.constructor) {
	    callback(new Error("Processor can't be used directly. Use `Processor.create()`."));
	    return;
	  }

	  this.constructor.__func__(context, this.data, function (err, data) {
	    if (err) {
	      callback(beautifyError(err, context.pathname));
	      return;
	    }

	    callback(null, data);
	  });
	};


	/**
	 *  Processor.create(name, func) -> Function
	 *
	 *  Returns new `Processor` subclass.
	 **/
	Processor.create = function (name, func) {
	  var Klass;

	  if (!_.isFunction(func)) {
	    throw new Error("Processor#create() expects second argument to be a function.");
	  }

	  Klass = function () { Processor.apply(this, arguments); };
	  inherits(Klass, Processor);

	  prop(Klass, '__name__', 'Processor:' + name);
	  prop(Klass, '__func__', func);

	  return Klass;
	};

}