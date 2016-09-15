geojson
=======

[![Build Status](https://travis-ci.org/ropensci/geojson.svg?branch=master)](https://travis-ci.org/ropensci/geojson)
[![codecov](https://codecov.io/gh/ropensci/geojson/branch/master/graph/badge.svg)](https://codecov.io/gh/ropensci/geojson)
[![rstudio mirror downloads](http://cranlogs.r-pkg.org/badges/geojson)](https://github.com/metacran/cranlogs.app)

`geojson` aims to deal only with geojson data, without requiring any of the `sp`/`rgdal`/`rgeos` stack. That means this package can be relatively light weight.

We'll define classes (`S3` or `R6`) following the [GeoJSON spec][geojsonspec]. These classes sort of overlap with `sp`'s classes, but not really. There's also some overlap in GeoJSON classes with Well-Known Text (WKT) classes, but GeoJSON has a subset of WKT's classes.

[geoops](https://github.com/ropensci/geoops) supports manipulations on these classes.

## installation


```r
devtools::install_github("ropensci/geojson")
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

## geometrycollection


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
#>   geometries (n): 2
#>   geometries (geometry / length):
#>     Point / 2
#>     LineString / 2
```

### inspect the object

get the string


```r
y[[1]]
#> [1] "{\n \"type\": \"GeometryCollection\",\n \"geometries\": [\n   {\n     \"type\": \"Point\",\n     \"coordinates\": [100.0, 0.0]\n   },\n   {\n     \"type\": \"LineString\",\n     \"coordinates\": [ [101.0, 0.0], [102.0, 1.0] ]\n   }\n  ]\n}"
```

get the type


```r
geo_type(y)
#> [1] "Point"      "LineString"
```

pretty print the geojson


```r
geo_pretty(y)
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
```

get the types within the geometrycollection



```r
geo_type(y)
#> [1] "Point"      "LineString"
```

write to disk


```r
geo_write(y, f <- tempfile(fileext = ".geojson"))
jsonlite::fromJSON(f, FALSE)
#> $type
#> [1] "GeometryCollection"
#>
#> $geometries
#> $geometries[[1]]
#> $geometries[[1]]$type
#> [1] "Point"
#>
#> $geometries[[1]]$coordinates
#> $geometries[[1]]$coordinates[[1]]
#> [1] 100
#>
#> $geometries[[1]]$coordinates[[2]]
#> [1] 0
#>
#>
#>
#> $geometries[[2]]
#> $geometries[[2]]$type
#> [1] "LineString"
#>
#> $geometries[[2]]$coordinates
#> $geometries[[2]]$coordinates[[1]]
#> $geometries[[2]]$coordinates[[1]][[1]]
#> [1] 101
#>
#> $geometries[[2]]$coordinates[[1]][[2]]
#> [1] 0
#>
#>
#> $geometries[[2]]$coordinates[[2]]
#> $geometries[[2]]$coordinates[[2]][[1]]
#> [1] 102
#>
#> $geometries[[2]]$coordinates[[2]][[2]]
#> [1] 1
```



## Meta

* Please [report any issues or bugs](https://github.com/ropensci/geojson/issues).
* License: MIT
* Get citation information for `geojson` in R doing `citation(package = 'geojson')`
* Please note that this project is released with a [Contributor Code of Conduct](CONDUCT.md). By participating in this project you agree to abide by its terms.

[![ropensci_footer](http://ropensci.org/public_images/github_footer.png)](http://ropensci.org)

[geojsonspec]: http://geojson.org/geojson-spec.html
[jqr]: https://github.com/ropensci/jqr
[jq]: https://github.com/stedolan/jq
