component name="pathTests" extends="mxunit.framework.TestCase" {
	import "cf_modules.Foundry.lib.*";
	import "cf_modules.underscorecf.underscore";
	import "cf_modules.Console.*";
	import "lib.trail";

	FIXTURE_ROOT = expandPath("/test/fixtures");

	public void function test_pattern_for() {
		var index = trail.index.get();
		assertIsTypeOf(index.pattern_for(trail.index,"index.html"),"cf_modules.Foundry.lib.RegExp");
		assertEquals("^index(\.htm|\.xhtml|\.php|\.html)(\.builder|\.coffee|\.str|\.erb)*$",index.__patterns__['index'].getPattern());
	}

	public void function test_find_in_base_path() {
		var base_Path = FIXTURE_ROOT;
		var logicalPath = "app/views/";
		var index = trail.index.get();

		console.log("found: " & trail.find("./app/views/index.html.erb",{ basePath: base_Path }));
		// assertEquals([],
			
		// );
	}

	public any function new_trail() {
		trail = new trail(FIXTURE_ROOT);
		trail.paths.append( "app/views", "vendor/plugins/signal_id/app/views", ".");
		trail.extensions.append( "builder", "coffee", "str", ".erb");
		trail.aliases.append( "html","htm");
		trail.aliases.append( "html","xhtml");
		trail.aliases.append( "html","php");
		trail.aliases.append( "js", "coffee");

		assertTrue(isObject(trail));
		// yield trail if block_given?

		return trail;
		
	}

	public void function setUp() {
		variables.Trail = new_trail();
		variables.isWindows = server.os.name === 'Windows';
		variables._ = new Underscore();
		variables.Console = new Console();
		variables.Path = new cf_modules.Path.Path();
		variables.expectedBasePath = "/Users/rountrjf/Sites/cf-path/test/testpaths";
		variables.relPath = "testpaths/"
		variables.absPath = "/test/testpaths/"
		variables.physPath = expandPath("/test/testpaths/");

		console.log("==============START==============");
	}

	public void function tearDown() {
		structDelete(variables, "Path");
		console.log("===============END===============");
	}

	private any function fixture_path(path) {
		return variables.Path.join(FIXTURE_ROOT, path);
	}
	
}