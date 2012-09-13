/**
* @name Normalized_array
* @hint 
*/
component extends="hike" accessors=true {
	import "vendor.underscore";
	import "vendor.hike.common";

	property name="frozen"
			type="boolean"
			getter="true"
			default="false";


	public any function init() {
		self = this;
		this.arr = [];
		variables._ = new vendor.underscore();
		variables.common = new Common();
		return this;
	}

	public any function normalize_all(els) {
		return _.flatten(els,_.map(function (el) {
	      return self.normalize(el);
	    }));
	}

	/**
	* NormalizedArray#prepend(*els) -> Void
	*
	* Prepend one or more elements to the head of the internal array.
	* Only unique elements are left.
	*
	* You can specify list of prepended elements as list of arguments or as an
	* array, thus following are equal:
	*
	* prepend(['foo', 'bar']);
	* prepend('foo', 'bar');
	**/
	  public any function prepend() {
	    this.arr = _.union(this.normalize_all(arguments), this.arr);
	  };


	  /**
	* NormalizedArray#append(*els) -> Void
	*
	* Append one or more elements to the tail of the internal array.
	* Only unique elements are left.
	*
	* You can specify list of appended elements as list of arguments or as an
	* array, thus following are equal:
	*
	* append(['foo', 'bar']);
	* append('foo', 'bar');
	**/
	  public any function append() {
	    this.arr = _.union(this.arr, this.normalize_all(arguments));
	  };


	  /**
	* NormalizedArray#remove(el) -> Void
	*
	* Remove given `el` from the internal array.
	**/
	  public any function remove(el) {
	    this.arr = _.without(this.arr, self.normalize(el));
	  };


	  /**
	* NormalizedArray#indexOf(element) -> Number
	*
	* Returns index of given `element` starting from `0`.
	* Returns `-1` when element not found.
	**/
	  public any function indexOf(element) {
	    return _.indexOf(this.arr,this.normalize(element));
	  };


	  /**
	* NormalizedArray#toArray() -> Array
	*
	* Returns Array value of [[NormalizedArray]]
	**/
	  public any function toArray() {
	    return _.toArray(this.arr);
	  };


	  /**
	* NormalizedArray#freeze() -> NormalizedArray
	*
	* Make object immutable.
	* Once frozen, any attempt to mutate state will throw an error.
	**/
	  public any function freeze() {
	    frozen = true;
	    stub = new Common().stub;
	    stub(this, ['prepend', 'append', 'remove'], "Frozen object.");
	    return this;
	  };
}