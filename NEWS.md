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
