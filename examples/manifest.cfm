<cfscript>
import "lib.sprockets";
import "lib.sprockets.environment";

sprock = new Sprockets();
environment = new Environment();

fullpath = getDirectoryFromPath(getCurrentTemplatePath())
thisFolder = listlast(fullpath, "\/")

manifest = sprock.Manifest.init(environment, thisFolder & '/public/assets');

manifest.compile(['application.js','application.css'],function(err,assetsData){
	if(err) {
		writeDump(var = "Failed compile assets: " & (err.message || _.toString(err)),abort=true);
	}
});
writeDump(var=manifest,abort=true);
</cfscript>