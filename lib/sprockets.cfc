import "sprockets/engines/coffee";
import "sprockets/engines/ejs";
import "sprockets/engines/haml_coffee";
import "sprockets/engines/jade";
import "sprockets/engines/jst";
import "sprockets/engines/less";
import "sprockets/engines/stylus";
import "sprockets/processors/charset_normalizer";
import "sprockets/processors/debug_comments";
import "sprockets/processors/directive_processor";
import "sprockets/processors/safety_colons";
import "sprockets/server";
import "sprockets/environment";
import "vendor/mime";
		
/**
* @name Sprockets.cfc
* @hint A port of Sprockets(ruby) for Coldfusion
*/
component {
	// Main exported properties ////////////////////////////////////////////////////
	
	property name="VERSION" type="string" getter=true setter=false;

	this.VERSION = new sprockets.version();


	/** read-only
	* this.logger -> Logger
	**/
	property name="logger"
		type="sprockets.logger"
		getter=true
		setter=false;

	this.logger = new sprockets.logger();


	// Spicy Sauce :)) /////////////////////////////////////////////////////////////

	// main internal properties.
	// each new environment clone these properties for initial states,
	// so they can be used to set "defaults" for all environment instances.
	property name="__trail__" type="vendor.hike.trail";
	property name="__engines__";
	property name="__mimeTypes__" type="struct";
	property name="__preProcessors__" type="struct";
	property name="__postProcessors__" type="struct";
	property name="__bundleProcessors__" type="struct";

	public any function init() {
		variables._ = new vendor.underscore();
		this["__trail__"] = new vendor.hike.Trail();
		this["__engines__"] = {};
		this["__mimeTypes__"] = new vendor.Mime();
		this["__preProcessors__"] = {};
		this["__postProcessors__"] = {};
		this["__bundleProcessors__"] = {};

		// Engines /////////////////////////////////////////////////////////////////////
		/**
		* this.EjsEngine -> EjsEngine
		**/
		this.EjsEngine = new sprockets.engines.ejs();


		/**
		* this.HamlCoffeeEngine -> HamlCoffeeEngine
		**/
		this.HamlCoffeeEngine = new sprockets.engines.haml_coffee();


		/**
		* this.JadeEngine -> JadeEngine
		**/
		this.JadeEngine = new sprockets.engines.jade();


		/**
		* this.JstEngine -> JstEngine
		**/
		this.JstEngine = new sprockets.engines.jst();


		/**
		* this.LessEngine -> LessEngine
		**/
		this.LessEngine = new sprockets.engines.less();


		/**
		* this.StylusEngine -> StylusEngine
		**/
		this.StylusEngine = new sprockets.engines.stylus();


		/**
		* this.CoffeeEngine -> CoffeeEngine
		**/
		this.CoffeeEngine = new sprockets.engines.coffee();


		// Processors //////////////////////////////////////////////////////////////////


		/**
		* this.DebugComments -> DebugComments
		**/
		this.DebugComments = new sprockets.processors.debug_comments();


		/**
		* this.DirectiveProcessor -> DirectiveProcessor
		**/
		this.DirectiveProcessor = new sprockets.processors.directive_processor();


		/**
		* this.CharsetNormalizer -> CharsetNormalizer
		**/
		this.CharsetNormalizer = new sprockets.processors.charset_normalizer();


		/**
		* this.SafetyColons -> SafetyColons
		**/
		this.SafetyColons = new sprockets.processors.safety_colons();


		// Main exported classes ///////////////////////////////////////////////////////


		/**
		* this.Environment -> Environment
		**/
		this.Environment = createObject("component","lib.sprockets.environment");


		/**
		* this.Manifest -> Manifest
		**/
		this.Manifest = createObject("component","lib.sprockets.manifest");


		/**
		* this.Template -> Template
		**/
		this.Template = new sprockets.template();


		/**
		* this.Server -> Server
		**/
		this.Server = new sprockets.server();


		// Main exported functions /////////////////////////////////////////////////////


		/** alias of: Server.createServer
		* this.createServer(environment[, manifest]) -> Function
		**/
		this.createServer = this.Server.createServer;



		// mixin helpers
		_.extend(this,new sprockets.helpers.engines());
		_.extend(this,new sprockets.helpers.mime());
		_.extend(this,new sprockets.helpers.processing());
		_.extend(this,new sprockets.helpers.paths());

		return this;
	}
}