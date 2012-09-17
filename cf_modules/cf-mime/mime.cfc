/**
* @name Mime.cfc
* @hint 
*/
component {
	property name="types"
			type="array";
	public any function init() {
		this.types = [];
		return this;
	}
}