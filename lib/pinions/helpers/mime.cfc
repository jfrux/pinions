/** internal
 *  mixin Mime
 *
 *  An internal mixin whose public methods are exposed on the [[Environment]]
 *  and [[Index]] classes.
 *
 *  Provides helpers to deal with mime types.
 **/


// REQUIRED PROPERTIES /////////////////////////////////////////////////////////
//
// - `__mimeTypes__` (Mimoza)
//
////////////////////////////////////////////////////////////////////////////////

component name="Mime" {
	property name="__mimetypes__"
			type="vendor.mime";

	public any function init() {
		
		return this;
	}

	// 3rd-party
	var _       = require('underscore');
	var Mimoza  = require('mimoza');


	// internal
	var getter          = require('../common').getter;
	var cloneMimeTypes  = require('../common').cloneMimeTypes;


	////////////////////////////////////////////////////////////////////////////////


	/**
	 *  Mime#getMimeType(ext) -> String
	 *
	 *  Returns the mime type for the `extension`.
	 **/
	module.exports.getMimeType = function (ext) {
	  return this.__mimeTypes__.getMimeType(ext) || Mimoza.getMimeType(ext);
	};


	/**
	 *  Mime#registeredMimeTypes -> Mimoza
	 *
	 *  Returns a copy of `Mimoza` instance with explicitly registered mime types.
	 **/
	getter(module.exports, 'registeredMimeTypes', function () {
	  return cloneMimeTypes(this.__mimeTypes__);
	});


	/**
	 *  Mime#getExtensionForMimeType(type) -> String
	 *
	 *  Returns extension for mime `type`.
	 **/
	module.exports.getExtensionForMimeType = function (type) {
	  return this.__mimeTypes__.getExtension(type) || Mimoza.getExtension(type);
	};


	/**
	 *  Mime#registerMimeType(type, ext) -> Void
	 *
	 *  Register new mime type.
	 **/
	module.exports.registerMimeType = function (mimeType, ext) {
	  this.__mimeTypes__.register(mimeType, ext);
	};

}