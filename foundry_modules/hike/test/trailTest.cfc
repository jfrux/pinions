component name="pathTests" extends="mxunit.framework.TestCase" {
	import "cf_modules.underscorecf.underscore";
	import "lib.trail";

	FIXTURE_ROOT = expandPath("/test/fixtures");

	// public void function test_entries() {
	// 	var trail = new trail(FIXTURE_ROOT);
		
	// 	expected = [
	//       "application.js.coffee.erb",
	//       "application.js.coffee.str",
	//       "index.html.erb",
	//       "index.php",
	//       "layouts",
	//       "people.coffee",
	//       "people.htm",
	//       "projects",
	//       "projects.erb",
	//       "recordings"
	//     ];
	//     entriesPath = fixture_path("app/views");
	//     foundPaths = trail.entries(entriesPath);
	//     arraySort(foundPaths,"textnocase");
	//     assertEquals(expected, foundPaths);
	// }
	
	// public void function trail_index_should_be_kind_of() {
	// 	var trail = new trail(FIXTURE_ROOT);
	// 	assertIsTypeOf(trail.index.get(),"lib.index");
	// }

	// public void function test_find_nonexistent_file() {
	// 	assertIsEmpty(trail.find("people/show.html"));
	// }

	public void function find_without_an_extension() {
		var trail = new_trail();
		var index = trail.index.get();
		writeDump(var=trail.paths(),abort=true);
		assertEquals(
		  fixture_path("app/views/"),
		  trail.find("projects/index.html")
		);
	}

	// public void function find_with_an_extension() {
	// 	assertEquals(
	// 	  fixture_path("app/views/projects/index.html.erb"),
	// 	  trail.find("projects/index.html.erb")
	// 	);
	// }

	// public void function find_with_leading_slash() {
	// 	assertEquals(
	// 	  fixture_path("app/views/projects/index.html.erb"),
	// 	  trail.find("/projects/index.html")
	// 	);
	// }

	// public void function find_respects_path_order() {
	// 	assertEquals(
	// 	  fixture_path("app/views/layouts/interstitial.html.erb"),
	// 	  trail.find("layouts/interstitial.html")
	// 	);

	// 	trail = new_trail();

	// 	trail.extensions.reverse();
	// 	assertEquals(
	// 		fixture_path("vendor/plugins/signal_id/app/views/layouts/interstitial.html.erb"),
	// 	  trail.find("layouts/interstitial.html")
	// 	);
	// }

	// public void function find_respects_extension_order() {
	// 	assertEquals(
	// 	  fixture_path("app/views/recordings/index.atom.builder"),
	// 	  trail.find("recordings/index.atom")
	// 	);

	// 	trail = new_trail();
	// 	trail.extensions.replace(trail.extensions.reverse());

	// 	assertEquals(fixture_path("app/views/recordings/index.atom.erb"),
	// 	  trail.find("recordings/index.atom")
	// 	);
	// }

	// public void function find_with_multiple_logical_paths_returns_first_match() {
	// 	assertEquals(
	// 	  fixture_path("app/views/recordings/index.html.erb"),
	// 	  trail.find("recordings/index.txt", "recordings/index.html", "recordings/index.atom")
	// 	);
	// }

	// public void function find_file_in_path_root_returns_expanded_path() {
	// 	assertEquals(
	// 	  fixture_path("app/views/index.html.erb"),
	// 	  trail.find("index.html")
	// 	);
	// }

	// public void function find_extensionless_file() {
	// 	assertEquals(
	// 	  fixture_path("README"),
	// 	  trail.find("README")
	// 	);
	// }

	// public void function find_file_with_multiple_extensions() {
	// 	assertEquals(
	// 	  fixture_path("app/views/projects/project.js.coffee.erb"),
	// 	  trail.find("projects/project.js")
	// 	);
	// }

	// public void function find_file_with_multiple_extensions_respects_extension_order() {
	// 	assertEquals(
	// 		fixture_path("app/views/application.js.coffee.str"),
	// 		trail.find("application.js")
	// 	);

	// 	trail = new_trail();
	// 	trail.extensions.replace(trail.extensions.reverse());

	// 	assertEquals(
	// 		fixture_path("app/views/application.js.coffee.erb"),
	// 		trail.find("application.js")
	// 	);
	// }

	// public void function find_file_by_aliased_extension() {
	// 	assertEquals(
	// 	  fixture_path("app/views/people.coffee"),
	// 	  trail.find("people.coffee")
	// 	);
	// 	assertEquals(	  fixture_path("app/views/people.coffee"),
	// 	  trail.find("people.js")
	// 	);
	// 	assertEquals(	  fixture_path("app/views/people.htm"),
	// 	  trail.find("people.htm")
	// 	);
	// 	assertEquals(	  fixture_path("app/views/people.htm"),
	// 	  trail.find("people.html")
	// 	);
	// }

	// public void function find_file_with_aliases_prefers_primary_extension() {
	// 	assertEquals(
	// 	  fixture_path("app/views/index.html.erb"),
	// 	  trail.find("index.html")
	// 	);
	// 	assertEquals(
	// 	  fixture_path("app/views/index.php"),
	// 	  trail.find("index.php")
	// 	);
	// }

	// public void function find_with_base_path_option_and_relative_logical_path() {
	// 	assertEquals(
	// 	  fixture_path("app/views/projects/index.html.erb"),
	// 	  trail.find(path = "./index.html",base_path = fixture_path("app/views/projects"))
	// 	);
	// }

	// public void function find_ignores_base_path_option_when_logical_path_is_not_relative() {
	// 	assertEquals(
	// 	  fixture_path("app/views/index.html.erb"),
	// 	  trail.find(path = "index.html", base_path = fixture_path("app/views/projects"))
	// 	);
	// }

	// public void function base_path_option_must_be_expanded() {
	// 	assertIsEmpty(trail.find(path = "./index.html", base_path = "app/views/projects"));
	// }

	// public void function relative_files_must_exist_in_the_path() {
	// 	assertTrue(Path.exists(Path.join(FIXTURE_ROOT, "../hike_test.rb")));
	// 	assertIsEmpty(trail.find(path = "../hike_test.rb", base_path = FIXTURE_ROOT));
	// }

	// public void function find_all_respects_path_order() {
	// 	// results = []
	// 	// trail.find("layouts/interstitial.html") do |path|
	// 	// 	  results << path
	// 	// end() {
	// 	// assertEquals([
	// 	//   fixture_path("app/views/layouts/interstitial.html.erb"),
	// 	//   fixture_path("vendor/plugins/signal_id/app/views/layouts/interstitial.html.erb")
	// 	// ], results
	// }

	// public void function find_all_with_multiple_extensions_respects_extension_order() {
	// 	// results = []
	// 	// trail.find("application.js") do |path|
	// 	//   results << path
	// 	// 	end() {
	// 	// 		assertEquals([
	// 	// 	  fixture_path("app/views/application.js.coffee.str"),
	// 	// 	  fixture_path("app/views/application.js.coffee.erb")
	// 	// 	], results
	// }

	// public void function find_filename_instead_directory() {
	// 	assertEquals(
	// 	  fixture_path("app/views/projects.erb"),
	// 	  trail.find("projects")
	// 	);
	// }

	public void function stat_should_be_the_same_fileinfo_1() {
		assertEquals(getFileInfo(fixture_path("app/views/index.html.erb")),trail.stat(fixture_path("app/views/index.html.erb")));
	}

	public void function stat_should_be_the_same_fileinfo_2() {
		assertEquals(getFileInfo(fixture_path("app/views")),trail.stat(fixture_path("app/views")));
	}

	public void function stat_should_be_empty_struct() {
		assertEquals({},trail.stat(fixture_path("app/views/missing.html")));
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
		variables.isWindows = server.os.name === 'Windows';
		variables._ = new Underscore();
		variables.Path = new cf_modules.Path.Path();
		variables.expectedBasePath = "/Users/rountrjf/Sites/cf-path/test/testpaths";
		variables.relPath = "testpaths/"
		variables.absPath = "/test/testpaths/"
		variables.physPath = expandPath("/test/testpaths/");
	}

	public void function tearDown() {
		structDelete(variables, "Path");
	}

	private any function fixture_path(path) {
		return variables.Path.join(FIXTURE_ROOT, path);
	}
	
}