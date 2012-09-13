/** 
* @name Sprockets.cfc
* @hint A port of Sprockets(ruby) for Coldfusion
*/
component {
	import "vendor.*";
	import "vendor.hike.*";
	import "sprockets.helpers.*";
	import "sprockets.engines.*";
	import "sprockets.processors.*";
	import "sprockets.*";
	
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
		variables._ = new Underscore();
		this["__trail__"] = new Trail(expandPath('/'));
		this["__engines__"] = {};
		this["__mimeTypes__"] = new vendor.Mime();
		this["__preProcessors__"] = {};
		this["__postProcessors__"] = {};
		this["__bundleProcessors__"] = {};
		this.paths = [];

		// Engines /////////////////////////////////////////////////////////////////////
		/**
		* this.EjsEngine -> EjsEngine
		**/
		this.EjsEngine = new ejs();


		/**
		* this.HamlCoffeeEngine -> HamlCoffeeEngine
		**/
		this.HamlCoffeeEngine = new haml_coffee();


		/**
		* this.JadeEngine -> JadeEngine
		**/
		this.JadeEngine = new jade();


		/**
		* this.JstEngine -> JstEngine
		**/
		this.JstEngine = new jst();


		/**
		* this.LessEngine -> LessEngine
		**/
		this.LessEngine = new less();


		/**
		* this.StylusEngine -> StylusEngine
		**/
		this.StylusEngine = new stylus();


		/**
		* this.CoffeeEngine -> CoffeeEngine
		**/
		this.CoffeeEngine = new coffee();


		// Processors //////////////////////////////////////////////////////////////////


		/**
		* this.DebugComments -> DebugComments
		**/
		this.DebugComments = new debug_comments();


		/**
		* this.DirectiveProcessor -> DirectiveProcessor
		**/
		this.DirectiveProcessor = new directive_processor();


		/**
		* this.CharsetNormalizer -> CharsetNormalizer
		**/
		this.CharsetNormalizer = new charset_normalizer();


		/**
		* this.SafetyColons -> SafetyColons
		**/
		this.SafetyColons = new safety_colons();


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
		this.Template = new template();


		/**
		* this.Server -> Server
		**/
		this.Server = new server();


		// Main exported functions /////////////////////////////////////////////////////


		/** alias of: Server.createServer
		* this.createServer(environment[, manifest]) -> Function
		**/
		this.createServer = this.Server.createServer;



		// mixin helpers
		this = _.extend(this,new lib.sprockets.helpers.engines());
		this = _.extend(this,new lib.sprockets.helpers.mime());
		this = _.extend(this,new lib.sprockets.helpers.processing());
		this = _.extend(this,new lib.sprockets.helpers.paths());

		return this;
	}
}