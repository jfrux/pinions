<cfscript>
import "lib.*";
function runOnce( /* [ args ,]*/ ){
	var pinions = new pinions();
	var env = pinions.Environment.init('/test/fixtures');
	
	// // provide logger backend
	// mincer.logger.use(console);

	env.appendPath('app/assets/images');
	env.appendPath('app/assets/javascripts');
	env.appendPath('app/assets/stylesheets');
	env.appendPath('vendor/assets/stylesheets');
	env.appendPath('vendor/assets/javascripts');

	var manifest = pinions.Manifest.init(env, '/test/assets');

	//var files = ['app.css', 'app.js', 'hundreds-of-files/test.js', 'issue-16.js', 'jade-lang.js', 'header.jpg', 'README.md'];
	var files = ['app.css', 'app.js'];
	manifest.compile(files, function (err, manifest) {
	  if (err) {
	    console.error(err.stack || err.message || err);
	    return;
	  }

	  console.log(require('util').inspect(manifest));
	});
	
};

runOnce();
</cfscript>