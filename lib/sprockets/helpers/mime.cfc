/**
* @name Mime.cfc
* @hint 
*/
component {
	property name="__mimetypes__"
			type="vendor.mime";

	public any function init() {
		
		return this;
	}
}