import "vendor/underscore"
import "vendor/path"
/**
* 
* @name Index
* @hint 
*/
component {
	public any function init() {

		return this;
	}


	//PRIVATE
	private function sort_matches(self, matches, basename) {
	  var aliases = self.aliases.get(path.extname(basename)).toArray();

	  return _.sortBy(matches, function (match) {
	    var extnames = ListToArray(replace(basename, '','all'),".");
	    return extnames.reduce(function (sum, ext) {
	      ext = '.' + ext;

	      if (0 <= self.extensions.indexOf(ext)) {
	        return sum + self.extensions.indexOf(ext) + 1;
	      } else if (0 <= aliases.indexOf(ext)) {
	        return sum + aliases.indexOf(ext) + 11;
	      } else {
	        return sum;
	      }
	    }, 0);
	  });
	}

	//HELPERS
	// escape special chars.
	// so the string could be safely used as literal in the RegExp.
	function regexp_escape(str) {
	  return rereplaceNoCase(str,"([.?*+{}()\[\]])",'\\$1','all');
	}

	// tells whenever pathname seems like a relative path or not
	function is_relative(pathname) {
	  return (arrayLen(reMatchNoCase("^\.{1,2}\/",pathname)) GT 0);
	}
}

// Sorts candidate matches by their extension priority.
// Extensions in the front of the `extensions` carry more weight.
