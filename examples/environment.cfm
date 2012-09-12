<cfscript>
import "lib/sprockets";

sprockets = new lib.Sprockets();
environment = sprockets.Environment.init(expandPath('/'));

environment.appendPath('app/assets/javascripts');
environment.appendPath('app/assets/stylesheets');
environment.appendPath('app/assets/images');


writeDump(var=environment,abort=true);
</cfscript>