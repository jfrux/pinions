component name="pathTests" extends="mxunit.framework.TestCase" {
	import "cf_modules.underscore.underscore";

	public void function testBasename() {
		var f = "pathTest.cfc";
		assertEquals('pathTest.cfc',path.basename(f));
		assertEquals('pathTest',path.basename(f, '.cfc'));
		// POSIX filenames may include control characters
		// c.f. http://www.dwheeler.com/essays/fixing-unix-linux-filenames.html
		// if (!isWindows) {
		// 	var controlCharFilename = 'Icon' + String.fromCharCode(13);
		// 	assertEquals(path.basename('/a/b/' + controlCharFilename),
		// 	   controlCharFilename);
		// }
	}

	public void function testNormalize() {
		// path normalize tests
		if (isWindows) {
		  assertEquals('fixtures\\b\\c.js',path.normalize('./fixtures///b/../b/c.js'));
		  assertEquals('\\bar',path.normalize('/foo/../../../bar'));
		  assertEquals('a\\b',path.normalize('a//b//../b'));
		  assertEquals('a\\b\\c',path.normalize('a//b//./c'));
		  assertEquals('a\\b',path.normalize('a//b//.'));
		  assertEquals('\\\\server\\share\\dir\\file.ext',path.normalize('//server/share/dir/file.ext'));
		} else {
		  assertEquals('fixtures/b/c.js',path.normalize('./fixtures///b/../b/c.js'));
		  assertEquals('/bar',path.normalize('/foo/../../../bar'));
		  assertEquals('a/b',path.normalize('a//b//../b'));
		  assertEquals('a/b/c',path.normalize('a//b//./c'));
		  assertEquals('a/b',path.normalize('a//b//.'));
		}
	}

	public void function testDirname() {
		assertEquals('/a',path.dirname('/a/b/'));
		assertEquals('/a',path.dirname('/a/b'));
		assertEquals('/',path.dirname('/a'));
		assertEquals('/',path.dirname('/'));
	}

	public void function testResolve() {
		var failures = [];
		if (isWindows) {
		  // windows
		  var arrTests =
		      // arguments                                    result
		      [[['c:/blah\\blah', 'd:/games', 'c:../a'], 'c:\\blah\\a'],
		       [['c:/ignore', 'd:\\a/b\\c/d', '\\e.exe'], 'd:\\e.exe'],
		       [['c:/ignore', 'c:/some/file'], 'c:\\some\\file'],
		       [['d:/ignore', 'd:some/dir//'], 'd:\\ignore\\some\\dir'],
		       [['.'], "/"],
		       [['//server/share', '..', 'relative\\'], '\\\\server\\share\\relative']];
		} else {
		  // Posix
		  var arrTests =
		      // arguments                                    result
		      [[['/var/lib', '../', 'file/'], '/var/file'],
		       [['/var/lib', '/../', 'file/'], '/file'],
		       [['a/b/c/', '../../..'], "/"],
		       [['.'], "/"],
		       [['/some/dir', '.', '/absolute/'], '/absolute']];
		}

		_.forEach(arrTests,function(test) {
			var pathArr = test[1];
			var paths = {};

			for (i=1;i <= arrayLen(test[1]);i++) {
				paths[i] = test[1][i];
			}
			var serializedPaths = serialize(paths);
			var actual = path.resolve(argumentCollection=paths);

		  var expected = isWindows ? replace(test[2],"/", "\","all") : test[2];
		  var message = '<br /><br />path.resolve(' & arrayToList(_.map(test[1],function(str) { return serialize(str); }),",") & ')' &
		                '<br />expect=' & serialize(expected) &
		                '<br />actual=' & serialize(actual);

		  if (actual NEQ expected) failures.add('<br />' & message);
		 
		});
		assertEquals(0,arrayLen(failures),ArrayToList(failures,''));
		assertEquals(0,arrayLen(failures),ArrayToList(failures,''));
	}

	public void function testRelative() {
		var failures = [];
		if (isWindows) {
		  // windows
		  var arrTests =
		      // arguments                     result
		      [['c:/blah\\blah', 'd:/games', 'd:\\games'],
		       ['c:/aaaa/bbbb', 'c:/aaaa', '..'],
		       ['c:/aaaa/bbbb', 'c:/cccc', '..\\..\\cccc'],
		       ['c:/aaaa/bbbb', 'c:/aaaa/bbbb', ''],
		       ['c:/aaaa/bbbb', 'c:/aaaa/cccc', '..\\cccc'],
		       ['c:/aaaa/', 'c:/aaaa/cccc', 'cccc'],
		       ['c:/', 'c:\\aaaa\\bbbb', 'aaaa\\bbbb'],
		       ['c:/aaaa/bbbb', 'd:\\', 'd:\\']];
		} else {
		  // Posix
		  var arrTests =
		      // arguments                    result
		      [['/var/lib', '/var', '..'],
		       ['/var/lib', '/bin', '../../bin'],
		       ['/var/lib', '/var/lib', ''],
		       ['/var/lib', '/var/apache', '../apache'],
		       ['/var/', '/var/lib', 'lib'],
		       ['/', '/var/lib', 'var/lib']];
		}

		_.forEach(arrTests,function(test) {
			var actual = path.relative(test[1], test[2]);
  			var expected = test[3];
			var message = '<br /><br />path.relative("#test[1]#","#test[2]#")' &
		                '<br />expect=' & serialize(expected) &
		                '<br />actual=' & serialize(actual);

		  if (actual NEQ expected) failures.add('<br />' & message);
		});
		
		assertEquals(0,arrayLen(failures),ArrayToList(failures,''));
	}

	public void function testExtname() {
		var failures = [];
		var arrTests = [['',''],
			['','/path/to/file'],
			['.ext','/path/to/file.ext'],
			['.ext','/path.to/file.ext'],
			['','/path.to/file'],
			['','/path.to/.file'],
			['.ext','/path.to/.file.ext'],
			['.ext','/path/to/f.ext'],
			['.ext','/path/to/..ext'],
			['','file'],
			['.ext','file.ext']];

		_.forEach(arrTests,function(test) {
			var actual = path.extname(test[2]);

		  var expected = isWindows ? replace(test[1],"/", "\","all") : test[1];
		  var message = '<br /><br />path.extname(' & arrayToList(_.map(test[2],function(str) { return serialize(str); }),",") & ')' &
		                '<br />expect=' & serialize(expected) &
		                '<br />actual=' & serialize(actual);

		  if (ToString(actual) NEQ ToString(expected)) failures.add('<br />' & message);
		 
		});
		//writeDump(var="",abort=true);
		assertEquals(0,arrayLen(failures),ArrayToList(failures,''));
	}

	public void function testJoin() {
	    // path.join tests
		var failures = [];
		var arrTests =
		    // arguments result
		    [[['.', 'x/b', '..', '/b/c.js'], 'x/b/c.js'],
		     [['/.', 'x/b', '..', '/b/c.js'], '/x/b/c.js'],
		     [['/foo', '../../../bar'], '/bar'],
		     [['foo', '../../../bar'], '../../bar'],
		     [['foo/', '../../../bar'], '../../bar'],
		     [['foo/x', '../../../bar'], '../bar'],
		     [['foo/x', './bar'], 'foo/x/bar'],
		     [['foo/x/', './bar'], 'foo/x/bar'],
		     [['foo/x/', '.', 'bar'], 'foo/x/bar'],
		     [['./'], './'],
		     [['.', './'], './'],
		     [['.', '.', '.'], '.'],
		     [['.', './', '.'], '.'],
		     [['.', '/./', '.'], '.'],
		     [['.', '/////./', '.'], '.'],
		     [['.'], '.'],
		     [['', '.'], '.'],
		     [['', 'foo'], 'foo'],
		     [['foo', '/bar'], 'foo/bar'],
		     [['', '/foo'], '/foo'],
		     [['', '', '/foo'], '/foo'],
		     [['', '', 'foo'], 'foo'],
		     [['foo', ''], 'foo'],
		     [['foo/', ''], 'foo/'],
		     [['foo', '', '/bar'], 'foo/bar'],
		     [['./', '..', '/foo'], '../foo'],
		     [['./', '..', '..', '/foo'], '../../foo'],
		     [['.', '..', '..', '/foo'], '../../foo'],
		     [['', '..', '..', '/foo'], '../../foo'],
		     [['/'], '/'],
		     [['/', '.'], '/'],
		     [['/', '..'], '/'],
		     [['/', '..', '..'], '/'],
		     [[''], '.'],
		     [['', ''], '.'],
		     [[' /foo'], ' /foo'],
		     [[' ', 'foo'], ' /foo'],
		     [[' ', '.'], ' '],
		     [[' ', '/'], ' /'],
		     [[' ', ''], ' '],
		     // filtration of non-strings.
		     [['x', true, 7, 'y', {}], 'x/y']
		    ];

		_.forEach(arrTests,function(test) {
			var pathArr = test[1];
			var paths = {};

			for (i=1;i <= arrayLen(test[1]);i++) {
				paths[i] = test[1][i];
			}
			var serializedPaths = serialize(paths);
			var actual = path.join(argumentCollection=paths);

		  var expected = isWindows ? replace(test[2],"/", "\","all") : test[2];
		  var message = '<br /><br />path.join(' & arrayToList(_.map(test[1],function(str) { return serialize(str); }),",") & ')' &
		                '<br />expect=' & serialize(expected) &
		                '<br />actual=' & serialize(actual);

		  if (actual NEQ expected) failures.add('<br />' & message);
		 
		});
		assertEquals(0,arrayLen(failures),ArrayToList(failures,''));
	}

	public void function setUp() {
		import "path";
		variables.isWindows = server.os.name === 'Windows';
		variables.Path = new Path();
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