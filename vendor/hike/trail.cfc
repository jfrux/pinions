import "vendor/Underscore";
import "index";
import "paths";
import "extensions";
import "common";
import "aliases";

/**
* @name Trail
* @hint Public container class for holding paths and extensions.
*/
component accessors=true {
	/**
	* @getter false
	* @setter false
	* @hint This is an immutable property.
	* @default "."
	**/
	property type="string" name="root" default="."; 

	property name="paths"
			type="any"
			getter="true"
			setter="true"; 


	/**
	* @getter true
	* @setter true
	**/
	property any extensions;

	/**
	* @getter true
	* @setter true
	**/
	property any aliases;

	/**
	* @getter true
	* @setter true
	**/
	property any index;

	public any function init(root) {
		this.root = arguments.root;
		// _ is referenced throughout this cfc
		variables._ = new vendor.Underscore();
		this.setPaths(new Paths(this.root));
		this.setExtensions(new Extensions());
		this.setAliases(new Aliases());
		this.setIndex(new Index());
		

		return this;
	}


	
}

function index_proxy(proto, func) {
  proto[func] = function () {
    var index = this.index;
    return index[func].apply(index, arguments);
  };
}