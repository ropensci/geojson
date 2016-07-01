geojson
=======



`geojson` aims to deal only with geojson data, without requiring any of the `sp`/`rgdal`/`rgeos` stack. That means this package can be relatively light weight.

We'll define classes (`S3` or `R6`) following the [GeoJSON spec][geojsonspec]. These classes sort of overlap with `sp`'s classes, but not really. There's also some overlap in GeoJSON classes with Well-Known Text (WKT) classes, but GeoJSON has a subset of WKT's classes.

[geoops](https://github.com/ropenscilabs/geoops) supports manipulations on these classes.

## installation


```r
devtools::install_github("ropenscilabs/geojson")
```


```r
library("geojson")
```

## geojson class

this is just a characstring string with S3 class `geojson` attached to make it easy to perform operations on


```r
x <- "{\"type\":\"FeatureCollection\",\"features\":[{\"type\":\"Feature\",\"geometry\":{\"type\":\"Point\",\"coordinates\":[-99.74,32.45]},\"properties\":{}}]}"
as.geojson(x)
#> <geojson> 
#>   type:  FeatureCollection 
#>   features (n): 1 
#>   features (geometry / length):
#>     Point / 2
```

## Playing with using R6


```r
x <- '{
 "type": "GeometryCollection",
 "geometries": [
   {
     "type": "Point",
     "coordinates": [100.0, 0.0]
   },
   {
     "type": "LineString",
     "coordinates": [ [101.0, 0.0], [102.0, 1.0] ]
   }
  ]
}'
(y <- geometrycollection(x))
#> <GeometryCollection> 
#>   type:  GeometryCollection 
#>   geometries (n): 2 
#>   geometries (geometry / length):
#>     Point / 2
#>     LineString / 2
```

creates an object which we can use to inspect the geojson


```r
# get the string
y$string
#> [1] "{\n \"type\": \"GeometryCollection\",\n \"geometries\": [\n   {\n     \"type\": \"Point\",\n     \"coordinates\": [100.0, 0.0]\n   },\n   {\n     \"type\": \"LineString\",\n     \"coordinates\": [ [101.0, 0.0], [102.0, 1.0] ]\n   }\n  ]\n}"
# get the type
y$type()
#> [1] "GeometryCollection"
# pretty print the geojson
y$pretty()
#> {
#>     "type": "GeometryCollection",
#>     "geometries": [
#>         {
#>             "type": "Point",
#>             "coordinates": [
#>                 100.0,
#>                 0.0
#>             ]
#>         },
#>         {
#>             "type": "LineString",
#>             "coordinates": [
#>                 [
#>                     101.0,
#>                     0.0
#>                 ],
#>                 [
#>                     102.0,
#>                     1.0
#>                 ]
#>             ]
#>         }
#>     ]
#> }
#> 
# get the types within the geometrycollection
y$types()
#> [1] "Point"      "LineString"
# write to disk
y$write(file = (f <- tempfile(fileext = ".geojson")))
unlink(f)
```

## Meta

* Please [report any issues or bugs](https://github.com/ropenscilabs/geojson/issues).
* License: MIT

[geojsonspec]: http://geojson.org/geojson-spec.html
[jqr]: https://github.com/ropensci/jqr
[jq]: https://github.com/stedolan/jq
