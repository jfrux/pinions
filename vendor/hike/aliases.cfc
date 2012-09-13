/**
* @name Aliases
* @hint 
*/
component extends="hike" accessors=true {
	import "vendor.Underscore";
	import "vendor.hike.common";
	variables.stub = new Common().stub;
	import "extensions";

	property name="frozen"
			type="boolean"
			getter="true"
			default="false";

	property name="map"
			type="struct";

	public any function init() {
		variables._ = new Underscore();
		this.map = {};
		return this;
	}

	public any function get(ext) {
		arguments.ext = Extensions.normalize(arguments.ext);

		if (!this.map[arguments.ext]) {
			this.map[arguments.ext] = new Extensions();

			if(this.frozen) {
				this.map[arguments.ext].freeze();
			}
		}

		return this.map[ext];
	}

	public any function prepend(extension) {
		this.get(arguments.extension).prepend(_.flatten(arguments).slice(1));
	}

	public any function append(extension,aliases) {
		this.get(arguments.extension).append(_.flatten(arguments).slice(1));
	}

	public any function remove(extension,alias) {
		this.get(arguments.extension).remove(arguments.alias);
	}

	public any function clone() {
		var obj = duplicate(this);

		_.each(this.map, function(aliases,ext) {
			obj.append(arguments.ext,_.toArray(arguments.aliases))
		});

		return obj;
	}

	public any function freeze() {
		frozen = true;
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