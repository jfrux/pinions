component name="pathTests" extends="mxunit.framework.TestCase" {
	import "cf_modules.underscorecf.underscore";
	public void function should_always_return_an_instance_of_Extensions() {
		var obj = new lib.Aliases();
		obj.append('foo', 'bar');

		assertEquals(".bar",  ArrayToList(obj.get('foo').toArray(),","));
		assertEquals("",      ArrayToList(obj.get('moo').toArray(),","));
	}

	public void function should_throw_an_error_on_attempt_to_modify_when_frozen() {
		var obj = new lib.Aliases();
		obj.append('foo', 'bar');
	    obj.freeze();
	    
	    assertTrue(obj.getFrozen());

	    try {
			obj.remove('foo', 'bar');
		} catch (any e) {
			assertEquals("can't call `remove()`: frozen object.",e.message);
		}

		try {
			obj.append('foo', 'baz');
		} catch (any e) {
			assertEquals("can't call `append()`: frozen object.",e.message);

		}

	    try {
			obj.get('foo');
		} catch (any e) {
			fail("should not throw a frozen object, error.");
		} finally {
			assertTrue(isObject(obj.get('foo')));
		}
	}

	public void function should_freeze_inner_Extensions_collections_when_frozen() {
		var obj = new lib.Aliases();
		obj.append('foo', 'bar');
	    obj.freeze();

	    
	    assertTrue(obj.get('foo').frozen);
	    assertTrue(obj.get('moo').frozen);
	}

	public void function setUp() {
		variables._ = new Underscore();
	}

	public void function tearDown() {
		structDelete(variables, "Path");
	}
	
}