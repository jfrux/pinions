component name="pathTests" extends="mxunit.framework.TestCase" {
	import "cf_modules.underscorecf.underscore";
	import "lib.normalized_array";
	import "lib.helpers.prototype";

	public void function should_normalize_prepended_elements() {
		var arr = new lib.normalized_array()
		arr['normalize'] = this.normalize;

		arr.prepend(["a", "b", "c"]);
		assertEquals("A,B,C", arrayToList(arr.toArray(),","));
	}

	public void function should_flatten_array_with_prepended_elements() {
		var arr = new lib.normalized_array()
		arr['normalize'] = this.normalize;

		arr.append([[["a", "b", "c"]]]);
		assertEquals("A,B,C", arrayToList(arr.toArray(),","));
	}


	public void function should_insert_prepended_elements_to_the_head() {
		var arr = new lib.normalized_array()
		arr['normalize'] = this.normalize;

		arr.prepend(["a"]);
		arr.prepend(["b"]);
		arr.prepend(["c"]);
		assertEquals("C,B,A", arrayToList(arr.toArray(),","));
	}


	public void function should_push_appended_elements_to_the_tail() {
		var arr = new lib.normalized_array()
		arr['normalize'] = this.normalize;

		arr.append(["a"]);
		arr.append(["b"]);
		arr.append(["c"]);
		assertEquals("A,B,C", arrayToList(arr.toArray(),","));
	}


	public void function should_normalize_appended_elements() {
		var arr = new lib.normalized_array()
		arr['normalize'] = this.normalize;

		arr.append(["a", "b", "c"]);
		assertEquals("A,B,C",  arrayToList(arr.toArray(),","));
	}


	public void function should_flatten_array_with_appended_elements() {
		var arr = new lib.normalized_array()
		arr['normalize'] = this.normalize;

		arr.append([[["a", "b", "c"]]]);
		assertEquals("A,B,C",  arrayToList(arr.toArray(),","));
	}


	public void function should_allow_remove_element_respecting_normalization() {
		var arr = new lib.normalized_array()
		arr['normalize'] = this.normalize;

		arr.append(["a", "b", "c"]);

		arr.remove("b");
		arr.remove("C");

		assertEquals("A",  arrayToList(arr.toArray(),","));
	}


	public void function should_throw_an_error_on_attempt_to_modify_when_frozen() {
		var arr = new lib.normalized_array()
		arr['normalize'] = this.normalize;

		arr.append(["foo"]);
		arr.freeze();

		try {
			arr.remove('foo');
		} catch (any e) {
			assertEquals("can't call `remove()`: frozen object.",e.message);
		}

		try {
			arr.append('bar');
		} catch (any e) {
			assertEquals("can't call `append()`: frozen object.",e.message);
		}

		try {
			arr.get('foo');
		} catch (any e) {
			fail("should not throw a frozen object, error.");
		} finally {
			assertTrue(arr.get('foo'));
		}
	}


	public void function should_allow_getting_indexOf_element_respecting_normalization() {
		var arr = new lib.normalized_array()
		arr['normalize'] = this.normalize;
		
		arr.append('foo');

		assertEquals(1, arr.indexOf('FOO'));
		assertEquals(1, arr.indexOf('foo'));
		assertEquals(0, arr.indexOf('bar'));
	}

	private any function normalize(el) {
		return UCase(el);
	}

	public void function setUp() {
		variables.isWindows = server.os.name === 'Windows';
		variables._ = new Underscore();
		variables.expectedBasePath = "/Users/rountrjf/Sites/cf-path/test/testpaths";
		variables.relPath = "testpaths/"
		variables.absPath = "/test/testpaths/"
		variables.physPath = expandPath("/test/testpaths/");
	}

	public void function tearDown() {
		structDelete(variables, "Path");
	}
	
}