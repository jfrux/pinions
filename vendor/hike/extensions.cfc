/**
* @name Extensions
* @hint 
*/
component extends="normalized_array" {
	public any function init() {
		super.init(this);
		return this;
	}

	public any function clone() {
		var obj = new Extensions();

		obj.prepend(this.toArray());

		return obj;
	}

	public any function normalize(extension) {
		if ('.' === extension[0]) {
			return extension;
		}

		return '.' & extension;
	}
}