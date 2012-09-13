import "underscore";
/**
* @name Path.cfc
* @hint A port of Node.js Path for Coldfusion
* @author Joshua F. Rountree (http://www.joshuairl.com/)
*/
component {
	public function init() {
		variables._ = new Underscore();
		return this;
	}

	/**
	* 	@header path.normalize(p)
	*	@hint Normalize a string path, taking care of '..' and '.' parts.<br /><br />When multiple slashes are found, they're replaced by a single one; when the path contains a trailing slash, it is preserved. On windows backslashes are used. 
	* 	@example path.normalize('/foo/bar//baz/asdf/quux/..')<br />// returns<br />'/foo/bar/baz/asdf'
	*   @author S. Isaac Dealey (info@turnkey.to) 
	*/
	public string function normalize(p) {
		return createObject("java","java.io.File").init(arguments.p).getCanonicalPath();
	}

	/**
	* 	@header path.extname(p)
	*	@hint Return the extension of the path, from the last '.' to end of string in the last portion of the path. If there is no '.' in the last portion of the path or the first character of it is '.', then it returns an empty string. Examples: 
	* 	@example path.extname('index.html')<br />// returns<br />'.html'<br /><br />path.extname('index.')<br />// returns<br />'.'<br /><br />path.extname('index')<br />// returns<br />''
	* 	@author Alexander Sicular &amp; Raymond Camden
	*/
	public string function extname(p) {
		if(find(".",arguments.p)) return listLast(arguments.p,".");
		else return "";
	}

	/**
	* 	@header path.resolve([from ...], to)
	*	@hint Resolves to <pre>to</pre> an absolute path.<br><br>If to isn't already absolute from arguments are prepended in right to left order, until an absolute path is found. If after using all from paths still no absolute path is found, the current working directory is used as well. The resulting path is normalized, and trailing slashes are removed unless the path gets resolved to the root directory. Non-string arguments are ignored.<br><br>Another way to think of it is as a sequence of cd commands in a shell. 
	* 	@example path.resolve('/foo/bar', './baz')<br />// returns<br />'/foo/bar/baz'<br /><br />path.resolve('/foo/bar', '/tmp/file/')<br />// returns<br />'/tmp/file'<br /><br />path.resolve('wwwroot', 'static_files/png/', '../gif/image.gif')<br />// if currently in /home/myself/node, it returns'/home/myself/node/wwwroot/static_files/gif/image.gif'
	*/
	public string function resolve() {
		var resolvedPath = '';
        var resolvedAbsolute = false;

	    for (var i = arrayLen(structKeyArray(arguments)); i >= 1 && !resolvedAbsolute; i--) {
	      var path = (i >= 1) ? arguments[i] : GetContextRoot();
	      
	      // Skip empty and invalid entries
	      if (NOT _.isString(path) || NOT _.isEmpty(path)) {
	        continue;
	      }

	      resolvedPath = expandPath(path & '/' & resolvedPath);
	      resolvedAbsolute = isAbsolute(path);
	    }

	    return resolvedPath;
	}

	function join() {
	    var joinArgs = structCopy(arguments);
	    var paths = ArrayFilter(structKeyArray(arguments), 
				    	function(parg) {
							if (structKeyExists(joinArgs,parg)) {
								return _.isString(joinArgs[parg]);
							} else {
								return false;
							}
					    });
	    var joined = this.normalize(ArrayToList(paths,'\'));

	    // Make sure that the joined path doesn't start with two slashes
	    // - it will be mistaken for an unc path by normalize() -
	    // unless the paths[0] also starts with two slashes
	    if (arrayLen(reMatch("/^[\\\/]{2}/",joined)) && NOT arrayLen(reMatch("/^[\\\/]{2}/",paths[0]))) {
	      joined = left(joined,1);
	    }

	    return this.normalize(joined);
	}

	//HELPERS
	function splitPath(filename) {

	}

	function normalizeArray(parts, allowAboveRoot) {
	  // if the path tries to go above the root, `up` ends up > 0
	  var up = 0;
	  for (var i = arrayLen(parts) - 1; i >= 0; i--) {
	    var last = parts[i];
	    if (last === '.') {
	      _.splice(parts,i, 1);
	    } else if (last === '..') {
	      _.splice(parts,i, 1);
	      up++;
	    } else if (up) {
	      _.splice(parts,i, 1);
	      up--;
	    }
	  }

	  // if the path is allowed to go above the root, restore leading ..s
	  if (allowAboveRoot) {
	    for (; up--; up) {
	      unshift(parts,'..');
	    }
	  }

	  return parts;
	}

	public any function unshift(obj = this.obj) {
		var elements = _.slice(arguments, 2);
		for (var i = arrayLen(elements); i > 0; i--) {
			arrayPrepend(obj, elements[i]);
		}
		return obj;
	}

	function isAbsolute(str) {
		return (reFindNoCase("[a-zA-Z]:\\",str) GT 0 || left(str,1) === "/");
	}

	function CharAt(str,pos) {
	    return Mid(str,pos,1);
	}

}