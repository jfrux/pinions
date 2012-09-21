component name="component" {
	public any function require(module) {
		component("/modules/" & module);
	}

	/**
	 * Creates a CFC instance based upon a relative, absolute or dot notation path.
	 * 
	 * @param path      Path for the component. (Required)
	 * @param type      Type of the path. Possible values are "component" (normal dot notation), "relative" and "absolute". Defaults to component.  (Optional)
	 * @return Returns a CFC. 
	 * @author Dan G. Switzer, II (dswitzer@pengoworks.com) 
	 * @version 1, May 13, 2003 
	 */
	function component(path){
	    var sPath=Arguments.path;var oProxy="";var oFile="";var sType="";
	    if( arrayLen(Arguments) gt 1 ) sType = lCase(Arguments[2]);

	    // determine a default type    
	    if( len(sType) eq 0 ){
	        if( (sPath DOES NOT CONTAIN ".") OR ((sPath CONTAINS ".") AND (sPath DOES NOT CONTAIN "/") AND (sPath DOES NOT CONTAIN "\")) ) sType = "component";
	        else sType = "relative";
	    }
	    
	    // create the component
	    switch( left(sType,1) ){
	        case "c":
	            return createObject("component", sPath);
	        break;

	        default:
	            if( left(sType, 1) neq "a" ) sPath = expandPath(sPath);
	            oProxy = createObject("java", "coldfusion.runtime.TemplateProxy");
	            oFile = createObject("java", "java.io.File");
	            oFile.init(sPath);
	            return oProxy.resolveFile(getPageContext(), oFile);
	        break;
	    }
	}
}