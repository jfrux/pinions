/**
* @name Aliases
* @hint 
*/
component extends="hike" accessors=true {

	property name="frozen"
			type="boolean"
			getter="true"
			setter="true";

	property name="map"
			type="struct";
	
	import "cf_modules.Foundry.*";
	import "cf_modules.Console.*";
	import "cf_modules.UnderscoreCF.Underscore";
	import "common";
	import "extensions";

	variables.stub = new Common().stub;

	public any function init() {
		variables.jArrayUtils = createObject("java","org.apache.commons.lang.ArrayUtils");
		variables._ = new Underscore();
		variables.Extensions = new Extensions();
		variables.Console = new Console();
		this.map = {};
		setFrozen(false);
		return this;
	}

	public any function get(ext) {
		theExt = Extensions.normalize(ext);

		if (NOT structKeyExists(this.map,theExt) OR _.isEmpty(this.map[theExt])) {
			this.map[theExt] = new Extensions();

			if(this.getFrozen()) {
				this.map[theExt].freeze();
			}
		}

		return this.map[theExt];
	}

	public void function prepend(extension) {
		var aliases = duplicate(arguments);
		var ext = arguments[1];
		structDelete(aliases,'extension');
		
		for(i=1; i <= listLen(structKeyList(aliases),","); i++) {
			this.get(ext).prepend(aliases[i]);
		}
	}

	public void function append(extension) {
		var aliases = duplicate(arguments);
		var ext = arguments[1];
		structDelete(aliases,'extension');
		
		for(i=1; i <= listLen(structKeyList(aliases),","); i++) {
			this.get(ext).append(aliases[i]);
		}
	}

	public void function remove(extension,alias) {
		this.get(arguments.extension).remove(arguments.alias);
	}

	public any function clone() {
		var obj = new Aliases();

		structEach(this.map, function(key,value) {
			obj.append(arguments.key,value.toArray());
		});
		
		return obj;
	}

	public any function freeze() {
		this.setFrozen(true);
		_.each(this.map,
			function(aliases) { 
				aliases.freeze(); 
			});
		stub(this,['prepend','append','remove'],"Frozen object.");

		return this;
	}

	public any function toObject() {
		return _.clone(this.map);
	}

}