geojson 0.3.4
=============

### MINOR IMPROVEMENTS

* fixes for test suite: skip package check warnings when geojsonlint not available, and skip tests that would use geojsonlint (#40)


geojson 0.3.2
=============

### BUG FIXES

* fix typo within `ndgeo_read()` (#39)


geojson 0.3.0
=============

### NEW FEATURES

* package gains two new functions for working with newline-delimited GeoJSON: `ndgeo_write()` and `ndgeo_read()`. `ndgeo_write()` leverages `writeLines()` to write to disk, while `ndgeo_read()` leverages a modified version of `jsonlite::stream_in()` to stream in line by line. `ndgeo_write()` works only with the geojson package classes `geofeature` and `geofeaturecollection` (#31) (#38)
* `as.geojson()` generic gains a new method for `sf`, see `showMethods('as.geojson')` to see methods available. The method is only available if you have `sf` installed  (#30) thanks @cpsievert

### MINOR IMPROVEMENTS

* add examples of using geobuf capabilities to the README (#35)
* in `as.geojson()` now throw warning message from `jsonlite` when json is invalid to help user sort out what's wrong with their JSON when the input is not valid JSON (#32)
* speed up for an internal method `asc()` to use `stringi::stri_replace_all()` if installed, and if not fall back to using `gsub()`
* replace usage of `tibble::data_frame()` with `tibble::tibble()` throughout package

### BUG FIXES

* change to `print.geojson()` to not calculate and print the bounding box because for very large geojson can take a very long time. Also changed to precomputing everything so printing geojson objects is fast (#36)
* fix to `geo_bbox()` to handle negative coordinates (#33) (#34) thanks very much @aoles


geojson 0.2.0
=============

### NEW FEATURES

* gains new function `to_geojson` convert GeoJSON character
string to the approriate GeoJSON class by detecting GeoJSON
type automatically. this makes some other tasks easier
(#28) (#29)

### MINOR IMPROVEMENTS

* Improve `as.geojson` function to do print summary on
all GeoJSON types well, not just GeometryCollection
and FeatureCollection (#27)


geojson 0.1.4
=============

### MINOR IMPROVEMENTS

* Changed `properties_add()` to give back the same class object
as that given to the function. In addition, correctly adds properties
to FeatureCollection objects as well. (#22)
* Added properties fxns tests

### BUG FIXES

* Fixed bug in `print.featurecollection()` that was not calculating and
printing number of features correctly (#24)


geojson 0.1.2
=============

### BUG FIXES

* Fixed bug in internal function that checked for existence
of a Suggested package (#17)


geojson 0.1.0
=============

### NEW FEATURES

* Released to CRAN.
