/** 
* @name Pinions.cfc
* @extends foundry.core
*/
component extends="foundry.core" {
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
		variables._ = require("underscorecf").init();
		variables.hike = require("hike");
		this["__trail__"] = hike.trail;
		this["__engines__"] = {};
		this["__mimeTypes__"] = require("mime");
		this["__preProcessors__"] = {};
		this["__postProcessors__"] = {};
		this["__bundleProcessors__"] = {};
		this['paths'] = [];

		// Engines /////////////////////////////////////////////////////////////////////
		/**
		* this.EjsEngine -> EjsEngine
		**/
		this['EjsEngine'] = require("./pinions/engines/ejs");


		/**
		* this.HamlCoffeeEngine -> HamlCoffeeEngine
		**/
		this['HamlCoffeeEngine'] = require("./pinions/engines/haml_coffee");


		/**
		* this.JadeEngine -> JadeEngine
		**/
		this['JadeEngine'] = require("./pinions/engines/jade");


		/**
		* this.JstEngine -> JstEngine
		**/
		this['JstEngine'] = require("./pinions/engines/jst");


		/**
		* this.LessEngine -> LessEngine
		**/
		this['LessEngine'] = require("./pinions/engines/less");


		/**
		* this.StylusEngine -> StylusEngine
		**/
		this['StylusEngine'] = require("./pinions/engines/stylus");


		/**
		* this.CoffeeEngine -> CoffeeEngine
		**/
		this['CoffeeEngine'] = require("./pinions/engines/coffee");


		// Processors //////////////////////////////////////////////////////////////////


		/**
		* this.DebugComments -> DebugComments
		**/
		this['DebugComments'] = require("./processors/debug_comments");


		/**
		* this.DirectiveProcessor -> DirectiveProcessor
		**/
		this['DirectiveProcessor'] = require("./processors/directive_processor");


		/**
		* this.CharsetNormalizer -> CharsetNormalizer
		**/
		this['CharsetNormalizer'] = require("./processors/charset_normalizer");


		/**
		* this.SafetyColons -> SafetyColons
		**/
		this['SafetyColons'] = require("./processors/safety_colons");


		// Main exported classes ///////////////////////////////////////////////////////


		/**
		* this.Environment -> Environment
		**/
		this['Environment'] = require("lib/environment");


		/**
		* this.Manifest -> Manifest
		**/
		this['Manifest'] = require("lib/manifest");


		/**
		* this.Template -> Template
		**/
		this['Template'] = require("lib/template");


		/**
		* this.Server -> Server
		**/
		this['Server'] = require("lib/server");


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