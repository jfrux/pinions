path = require("path");
logical_path = "app/views/";
base_path = "/Users/rountrjf/Sites/hike/test/fixtures";
candidate = path.join(base_path,logical_path);
console.log(path.basename(candidate));