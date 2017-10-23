geojson
=======



[![Build Status](https://travis-ci.org/ropensci/geojson.svg?branch=master)](https://travis-ci.org/ropensci/geojson)
[![codecov](https://codecov.io/gh/ropensci/geojson/branch/master/graph/badge.svg)](https://codecov.io/gh/ropensci/geojson)
[![rstudio mirror downloads](https://cranlogs.r-pkg.org/badges/geojson)](https://github.com/metacran/cranlogs.app)
[![cran version](https://www.r-pkg.org/badges/version/geojson)](https://cran.r-project.org/package=geojson)

`geojson` aims to deal only with geojson data, without requiring any of the
`sp`/`rgdal`/`rgeos` stack.  That means this package is light weight.

We've defined classes (`S3`) following the [GeoJSON spec][geojsonspec]. These
classes sort of overlap with `sp`'s classes, but not really. There's also some
overlap in GeoJSON classes with Well-Known Text (WKT) classes, but GeoJSON has a
subset of WKT's classes.

Although not ready yet, [geoops](https://github.com/ropenscilabs/geoops) supports manipulations on the classes defined in this package.

## Installation

Stable CRAN version


```r
install.packages("geojson")
```

Dev version


```r
devtools::install_github("ropensci/geojson")
```


```r
library("geojson")
```

## geojson class

Essentially a character string with S3 class `geojson` attached to make it
easy to perform operations on


```r
x <- "{\"type\":\"FeatureCollection\",\"features\":[{\"type\":\"Feature\",\"geometry\":{\"type\":\"Point\",\"coordinates\":[-99.74,32.45]},\"properties\":{}}]}"
as.geojson(x)
#> <geojson> 
#>   type:  FeatureCollection 
#>   bounding box:  99.74 32.45 99.74 32.45 
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
#> [1] "GeometryCollection"
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



## properties

Add properties


```r
x <- '{ "type": "LineString", "coordinates": [ [100.0, 0.0], [101.0, 1.0] ]}'
res <- linestring(x) %>% feature() %>% properties_add(population = 1000)
res
#> <Feature> 
#>   type:  LineString 
#>   coordinates:  [[100,0],[101,1]]
```

Get a property


```r
properties_get(res, property = 'population')
#> 1000
```

## crs

Add crs


```r
crs <- '{
  "type": "name",
  "properties": {
     "name": "urn:ogc:def:crs:OGC:1.3:CRS84"
  }
}'
z <- x %>% feature() %>% crs_add(crs)
z
#> {
#>     "type": "Feature",
#>     "properties": {
#> 
#>     },
#>     "geometry": {
#>         "type": "LineString",
#>         "coordinates": [
#>             [
#>                 100,
#>                 0
#>             ],
#>             [
#>                 101,
#>                 1
#>             ]
#>         ]
#>     },
#>     "crs": {
#>         "type": "name",
#>         "properties": {
#>             "name": "urn:ogc:def:crs:OGC:1.3:CRS84"
#>         }
#>     }
#> }
```

Get crs


```r
crs_get(z)
#> $type
#> [1] "name"
#> 
#> $properties
#> $properties$name
#> [1] "urn:ogc:def:crs:OGC:1.3:CRS84"
```

## bbox

Add bbox


```r
tt <- x %>% feature() %>% bbox_add()
tt
#> {
#>     "type": "Feature",
#>     "properties": {
#> 
#>     },
#>     "geometry": {
#>         "type": "LineString",
#>         "coordinates": [
#>             [
#>                 100,
#>                 0
#>             ],
#>             [
#>                 101,
#>                 1
#>             ]
#>         ]
#>     },
#>     "bbox": [
#>         100,
#>         0,
#>         101,
#>         1
#>     ]
#> }
```

Get bbox


```r
bbox_get(tt)
#> [1] 100   0 101   1
```


## geojson in data.frame's


```r
x <- '{ "type": "Point", "coordinates": [100.0, 0.0] }'
(pt <- point(x))
#> <Point> 
#>   coordinates:  [100,0]
```


```r
library("tibble")
data_frame(a = 1:5, b = list(pt))
#> # A tibble: 5 x 2
#>       a              b
#>   <int>         <list>
#> 1     1 <S3: geopoint>
#> 2     2 <S3: geopoint>
#> 3     3 <S3: geopoint>
#> 4     4 <S3: geopoint>
#> 5     5 <S3: geopoint>
```


```r
x <- '{ "type": "MultiLineString",
  "coordinates": [ [ [100.0, 0.0], [101.0, 1.0] ], [ [102.0, 2.0], [103.0, 3.0] ] ] }'
(mls <- multilinestring(x))
#> <MultiLineString> 
#>   no. lines:  2 
#>   no. nodes / line:  2, 2 
#>   coordinates:  [[[100,0],[101,1]],[[102,2],[103,3]]]
```


```r
data_frame(a = 1:5, b = list(mls))
#> # A tibble: 5 x 2
#>       a                        b
#>   <int>                   <list>
#> 1     1 <S3: geomultilinestring>
#> 2     2 <S3: geomultilinestring>
#> 3     3 <S3: geomultilinestring>
#> 4     4 <S3: geomultilinestring>
#> 5     5 <S3: geomultilinestring>
```


```r
data_frame(a = 1:5, b = list(pt), c = list(mls))
#> # A tibble: 5 x 3
#>       a              b                        c
#>   <int>         <list>                   <list>
#> 1     1 <S3: geopoint> <S3: geomultilinestring>
#> 2     2 <S3: geopoint> <S3: geomultilinestring>
#> 3     3 <S3: geopoint> <S3: geomultilinestring>
#> 4     4 <S3: geopoint> <S3: geomultilinestring>
#> 5     5 <S3: geopoint> <S3: geomultilinestring>
```


## Meta

* Please [report any issues or bugs](https://github.com/ropensci/geojson/issues).
* License: MIT
* Get citation information for `geojson` in R doing `citation(package = 'geojson')`
* Please note that this project is released with a [Contributor Code of Conduct](CONDUCT.md).
By participating in this project you agree to abide by its terms.


[geojsonspec]: https://tools.ietf.org/html/rfc7946
[jqr]: https://github.com/ropensci/jqr
[jq]: https://github.com/stedolan/jq
