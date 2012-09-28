_ = require("underscore");

var structWithArray = {
	1:{
		1:["a","b","c"]
	}
}

console.log(structWithArray);


console.log(_.flatten(structWithArray));