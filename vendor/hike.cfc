import "vendor/underscore";
import "hike/trail";
/**
* @name Hike.cfc
* @hint A port of Hike (ruby) for Coldfusion
* @introduction
*/
component {
	property name="Trail" type="any";

	public any function init() {
		var _ = new vendor.underscore();
		this.Trail = createObject("component","hike.trail");
		return this;
	}
}