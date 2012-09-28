<cfscript>
import "vendor/path";
path = new vendor.path();

resolved = path.resolve('lib/');
writeOutput(resolved);
</cfscript>