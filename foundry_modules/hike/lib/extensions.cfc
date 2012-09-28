/**
* @name Extensions
* @hint 
*/
component extends="normalized_array" {
	public any function init() {
		super.init(this);
		return this;
	}

	public Extensions function clone() {
		var obj = new Extensions();
		
		obj.prepend(this.toArray());

		return obj;
	}

	public any function normalize(extension) {
		if (left(extension,1) EQ '.') {
			return extension;
		}

		return '.' & extension;
	}
}