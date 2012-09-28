<cfscript>
trail = new lib.Trail(expandPath("/"));
trail.extensions.append(".cfc");
trail.extensions.append(".js");
trail.paths.append("lib", "test");

writeDump(trail.find("lib/trail.cfc"));
// => "/Users/<user>/Projects/hike/lib/hike/trail.cfc"

writeDump(trail.find("test/trailTest"));
writeDump(trail.find("test/test_aliases"));
// => "/home/ixti/Projects/hike-js/test/test_trail.rb"
</cfscript>