import "modules.foundry.lib.*";
import "modules.underscorecf.*";
// `NormalizedArray` is an internal abstract wrapper class that calls
// a callback `normalize_element` anytime an element is added to the
// Array.
// `Extensions` and `Paths` are subclasses of `NormalizedArray`.

component name="normalized_array" extends="modules.foundry.lib.ArrayComponent" {
	property name="frozen" type="boolean" default="false";

	public any function init() {
		super.init();
		
		variables.common = new Common();

		this['frozen'] = false;

		return this;
	}

	public any function normalize_all() {
		var theArr = [];
		args = _.flatten(arguments[1]);

		theArr = _.map(args,function(el) {
			return this.normalize(el);
		});
		
		return theArr;
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
	  	var theArr = [];
	  	if(listLen(structKeyList(arguments)) GT 1) {
	  		//individual arguments, instead of single array
	  		for(i=1; i <= listLen(structKeyList(arguments),","); i++) {
				theArr.add(arguments[i]);
			}
	  	} else {
	  		//first argument is array of elements
	  		if(isArray(arguments[1])) {
	  			theArr = arguments[1];
	  		} else {
	  			theArr.add(arguments[1]);
	  		}
	  	}
	  	this.arr = _.union(this.normalize_all(theArr), this.arr);
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
		*/
	  public any function append() {
	  	var theArr = [];
	  	if(listLen(structKeyList(arguments)) GT 1) {
	  		//individual arguments, instead of single array
	  		for(i=1; i <= listLen(structKeyList(arguments),","); i++) {
				theArr.add(arguments[i]);
			}
	  	} else {
	  		//first argument is array of elements
	  		if(isArray(arguments[1])) {
	  			theArr = arguments[1];
	  		} else {
	  			theArr.add(arguments[1]);
	  		}
	  	}
	  	this.arr = _.union(this.arr, this.normalize_all(theArr));
	  };


	  /**
	* NormalizedArray#remove(el) -> Void
	*
	* Remove given `el` from the internal array.
	**/
	  public any function remove(el) {
	  	var remArr = [];
	  	remArr.add(this.normalize(arguments.el));
	    this.arr = _.without(this.arr, remArr);
	  };

	  /**
	* NormalizedArray#indexOf(element) -> Number
	*
	* Returns index of given `element` starting from `1`.
	* Returns `0` when element not found.
	**/
	  public any function indexOf(element) {
	    return _.indexOf(this.arr,this.normalize(element));
	  };

	  public boolean function get() {
	  	return this.frozen;
	  }

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
	    this.frozen = true;
	    stub = new Common().stub;
	    stub(this, ['prepend', 'append', 'remove'], "Frozen object.");
	    return this;
	  };

}