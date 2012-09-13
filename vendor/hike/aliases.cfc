/**
* @name Aliases
* @hint 
*/
component extends="hike" accessors=true {
	import "vendor.Underscore";
	import "extensions";

	property name="frozen"
			type="boolean"
			getter="true"
			default="false";

	property name="map"
			type="struct";

	public any function init() {
		
		return this;
	}

	public any function get(ext) {
		ext = Extensions.normalize(ext);

		if (!map[ext]) {
			map[ext] = new Extensions();

			if(this.frozen) {
				map[ext].freeze();
			}
		}

		return map[ext];
	}

	public any function prepend(extension) {
		this.get(extension).prepend(_.flatten(arguments).slice(1));
	}

	public any function append(extension,aliases) {
		this.get(extension).append(_.flatten(arguments).slice(1));
	}

	public any function remove(extension,alias) {
		this.get(extension).remove(alias);
	}

	public any function clone() {
		var obj = new Aliases();

		_.each(map, function(aliases,ext) {
			obj.append(ext,aliases.toArray())
		});

		return obj;
	}

	public any function freeze() {
		frozen = true;
		_.each(map,
			function(aliases) { 
				aliases.freeze(); 
			});
		stub(this,['prepend','append','remove'],"Frozen object.");

		return this;
	}

	public any function toObject() {
		return _.clone(map);
	}

}