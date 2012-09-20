import "lib.pinions.*";
/** 
* @name Pinions.cfc
*/
component {
	property name="VERSION" type="string" getter=true setter=false;

	property name="logger"
		type="pinions.logger"
		getter=true
		setter=false;

	// Spicy Sauce :)) /////////////////////////////////////////////////////////////

	// main internal properties.
	// each new environment clone these properties for initial states,
	// so they can be used to set "defaults" for all environment instances.
	property name="__trail__" type="trail";
	property name="__engines__";
	property name="__mimeTypes__" type="struct";
	property name="__preProcessors__" type="struct";
	property name="__postProcessors__" type="struct";
	property name="__bundleProcessors__" type="struct";


	this.VERSION = new pinions.version();
	//this.logger = new pinions.logger();


	public any function init() {
		variables._ = new Underscore();
		this["__trail__"] = new Trail('/');
		this["__engines__"] = {};
		this["__mimeTypes__"] = new cf_modules.mime.Mime();
		this["__preProcessors__"] = {};
		this["__postProcessors__"] = {};
		this["__bundleProcessors__"] = {};
		this['paths'] = [];

		// Engines /////////////////////////////////////////////////////////////////////
		/**
		* this.EjsEngine -> EjsEngine
		**/
		this['EjsEngine'] = new ejs();


		/**
		* this.HamlCoffeeEngine -> HamlCoffeeEngine
		**/
		this['HamlCoffeeEngine'] = new haml_coffee();


		/**
		* this.JadeEngine -> JadeEngine
		**/
		this['JadeEngine'] = new jade();


		/**
		* this.JstEngine -> JstEngine
		**/
		this['JstEngine'] = new jst();


		/**
		* this.LessEngine -> LessEngine
		**/
		this['LessEngine'] = new less();


		/**
		* this.StylusEngine -> StylusEngine
		**/
		this['StylusEngine'] = new stylus();


		/**
		* this.CoffeeEngine -> CoffeeEngine
		**/
		this['CoffeeEngine'] = new coffee();


		// Processors //////////////////////////////////////////////////////////////////


		/**
		* this.DebugComments -> DebugComments
		**/
		this['DebugComments'] = new debug_comments();


		/**
		* this.DirectiveProcessor -> DirectiveProcessor
		**/
		this['DirectiveProcessor'] = new directive_processor();


		/**
		* this.CharsetNormalizer -> CharsetNormalizer
		**/
		this['CharsetNormalizer'] = new charset_normalizer();


		/**
		* this.SafetyColons -> SafetyColons
		**/
		this['SafetyColons'] = new safety_colons();


		// Main exported classes ///////////////////////////////////////////////////////


		/**
		* this.Environment -> Environment
		**/
		this['Environment'] = createObject("component","lib.environment");


		/**
		* this.Manifest -> Manifest
		**/
		this['Manifest'] = createObject("component","lib.manifest");


		/**
		* this.Template -> Template
		**/
		this['Template'] = new template();


		/**
		* this.Server -> Server
		**/
		this['Server'] = new server();


		// Main exported functions /////////////////////////////////////////////////////


		/** alias of: Server.createServer
		* this.createServer(environment[, manifest]) -> Function
		**/
		this['createServer'] = this.Server.createServer;



		// mixin helpers
		this = _.extend(this,new lib.sprockets.helpers.engines());
		this = _.extend(this,new lib.sprockets.helpers.mime());
		this = _.extend(this,new lib.sprockets.helpers.processing());
		this = _.extend(this,new lib.sprockets.helpers.paths());

		return this;
	}
}