<cfscript>
import "lib.*";
sprockets = new Sprockets();
environment = new sprockets.Environment(expandPath('/'));

environment.appendPath('app/assets/javascripts');
environment.appendPath('app/assets/stylesheets');
environment.appendPath('app/assets/images');

writeDump(var=environment,abort=true);
</cfscript>