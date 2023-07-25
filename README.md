
<!-- badges: start -->

[![R-CMD-check](https://github.com/ropensci/geojson/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/ropensci/geojson/actions/workflows/R-CMD-check.yaml)
[![rstudio mirror
downloads](https://cranlogs.r-pkg.org/badges/geojson)](https://github.com/r-hub/cranlogs.app)
[![cran
version](https://www.r-pkg.org/badges/version/geojson)](https://cran.r-project.org/package=geojson)
<!-- badges: end -->

# geojson

`geojson` aims to deal only with geojson data in a lightweight way.

We’ve defined classes (`S3`) following the [GeoJSON
spec](https://datatracker.ietf.org/doc/html/rfc7946). These classes sort
of overlap with `sp`’s classes, but not really. There’s also some
overlap in GeoJSON classes with Well-Known Text (WKT) classes, but
GeoJSON has a subset of WKT’s classes.

The package [geoops](https://github.com/sckott/geoops) supports
manipulations on the classes defined in this package. This package is
used within [geojsonio](https://github.com/ropensci/geojsonio) to make
some tasks easier.

## Installation

Stable CRAN version

``` r
install.packages("geojson")
```

Dev version

``` r
remotes::install_github("ropensci/geojson")
```

``` r
library("geojson")
```

## geojson class

Essentially a character string with S3 class `geojson` attached to make
it easy to perform operations on

``` r
x <- "{\"type\":\"FeatureCollection\",\"features\":[{\"type\":\"Feature\",\"geometry\":{\"type\":\"Point\",\"coordinates\":[-99.74,32.45]},\"properties\":{}}]}"
as.geojson(x)
#> <geojson> 
#>   type:  FeatureCollection 
#>   features (n): 1 
#>   features (geometry / length) [first 5]:
#>     Point / 2
```

## geometrycollection

``` r
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

``` r
y[[1]]
#> [1] "{\n \"type\": \"GeometryCollection\",\n \"geometries\": [\n   {\n     \"type\": \"Point\",\n     \"coordinates\": [100.0, 0.0]\n   },\n   {\n     \"type\": \"LineString\",\n     \"coordinates\": [ [101.0, 0.0], [102.0, 1.0] ]\n   }\n  ]\n}"
```

get the type

``` r
geo_type(y)
#> [1] "GeometryCollection"
```

pretty print the geojson

``` r
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

``` r
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

``` r
x <- '{ "type": "LineString", "coordinates": [ [100.0, 0.0], [101.0, 1.0] ]}'
res <- linestring(x) %>% feature() %>% properties_add(population = 1000)
res
#> <Feature> 
#>   type:  LineString 
#>   coordinates:  [[100,0],[101,1]]
```

Get a property

``` r
properties_get(res, property = 'population')
#> 1000
```

## crs

Add crs

``` r
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

``` r
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

``` r
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

``` r
bbox_get(tt)
#> [1] 100   0 101   1
```

## geojson in data.frame’s

``` r
x <- '{ "type": "Point", "coordinates": [100.0, 0.0] }'
(pt <- point(x))
#> <Point> 
#>   coordinates:  [100,0]
```

``` r
library("tibble")
tibble(a = 1:5, b = list(pt))
#> # A tibble: 5 × 2
#>       a b             
#>   <int> <list>        
#> 1     1 <geopoint [1]>
#> 2     2 <geopoint [1]>
#> 3     3 <geopoint [1]>
#> 4     4 <geopoint [1]>
#> 5     5 <geopoint [1]>
```

``` r
x <- '{ "type": "MultiLineString",
  "coordinates": [ [ [100.0, 0.0], [101.0, 1.0] ], [ [102.0, 2.0], [103.0, 3.0] ] ] }'
(mls <- multilinestring(x))
#> <MultiLineString> 
#>   no. lines:  2 
#>   no. nodes / line:  2, 2 
#>   coordinates:  [[[100,0],[101,1]],[[102,2],[103,3]]]
```

``` r
tibble(a = 1:5, b = list(mls))
#> # A tibble: 5 × 2
#>       a b             
#>   <int> <list>        
#> 1     1 <gmltlnst [1]>
#> 2     2 <gmltlnst [1]>
#> 3     3 <gmltlnst [1]>
#> 4     4 <gmltlnst [1]>
#> 5     5 <gmltlnst [1]>
```

``` r
tibble(a = 1:5, b = list(pt), c = list(mls))
#> # A tibble: 5 × 3
#>       a b              c             
#>   <int> <list>         <list>        
#> 1     1 <geopoint [1]> <gmltlnst [1]>
#> 2     2 <geopoint [1]> <gmltlnst [1]>
#> 3     3 <geopoint [1]> <gmltlnst [1]>
#> 4     4 <geopoint [1]> <gmltlnst [1]>
#> 5     5 <geopoint [1]> <gmltlnst [1]>
```

## geobuf

Geobuf is a compact binary encoding for geographic data using protocol
buffers <https://github.com/mapbox/geobuf> (via the
[protolite](https://github.com/jeroen/protolite)) package.

``` r
file <- system.file("examples/test.pb", package = "geojson")
(json <- from_geobuf(file))
#> {"type":"FeatureCollection","features":[{"type":"Feature","geometry":{"type":"Point","coordinates":[102,0.5]},"id":999,"properties":{"prop0":"value0","double":0.0123,"negative_int":-100,"positive_int":100,"negative_double":-1.2345e+16,"positive_double":1.2345e+16,"null":null,"array":[1,2,3.1],"object":{"foo":[5,6,7]}},"blabla":{"foo":[1,1,1]}},{"type":"Feature","geometry":{"type":"LineString","coordinates":[[102,0],[103,-1.1],[104,-3],[105,1]]},"id":123,"properties":{"custom1":"test","prop0":"value0","prop1":0}},{"type":"Feature","geometry":{"type":"Polygon","coordinates":[[[100,0],[101,0],[101,1],[100,1],[100,0]],[[99,10],[101,0],[100,1],[99,10]]]},"id":"test-id","properties":{"prop0":"value0","prop1":{"this":"that"}},"custom1":"jeroen"},{"type":"Feature","geometry":{"type":"MultiPolygon","coordinates":[[[[102,2],[103,2],[103,3],[102,2]]],[[[100,0],[101,0],[101,1],[100,1],[100,0]],[[100.2,0.2],[100.2,0.8],[100.2,0.2]]]]}},{"type":"Feature","geometry":{"type":"GeometryCollection","geometries":[{"type":"Point","coordinates":[100,0]},{"type":"LineString","coordinates":[[101,0],[102,1]]},{"type":"MultiPoint","coordinates":[[100,0],[101,1]]},{"type":"MultiLineString","coordinates":[[[100,0],[101,1]],[[102,2],[103,3]]]},{"type":"MultiPolygon","coordinates":[[[[102,2],[103,2],[103,3],[102,3],[102,2]]],[[[100,0],[101,0],[101,1],[100,1],[100,0]],[[100.2,0.2],[100.8,0.2],[100.8,0.8],[100.2,0.8],[100.2,0.2]]]]}]}}]}
pb <- to_geobuf(json)
class(pb)
#> [1] "raw"
f <- tempfile(fileext = ".pb")
to_geobuf(json, f)
from_geobuf(f)
#> {"type":"FeatureCollection","features":[{"type":"Feature","geometry":{"type":"Point","coordinates":[102,0.5]},"id":999,"properties":{"prop0":"value0","double":0.0123,"negative_int":-100,"positive_int":100,"negative_double":-1.2345e+16,"positive_double":1.2345e+16,"null":null,"array":[1,2,3.1],"object":{"foo":[5,6,7]}},"blabla":{"foo":[1,1,1]}},{"type":"Feature","geometry":{"type":"LineString","coordinates":[[102,0],[103,-1.1],[104,-3],[105,1]]},"id":123,"properties":{"custom1":"test","prop0":"value0","prop1":0}},{"type":"Feature","geometry":{"type":"Polygon","coordinates":[[[100,0],[101,0],[101,1],[100,1],[100,0]],[[99,10],[101,0],[100,1],[99,10]]]},"id":"test-id","properties":{"prop0":"value0","prop1":{"this":"that"}},"custom1":"jeroen"},{"type":"Feature","geometry":{"type":"MultiPolygon","coordinates":[[[[102,2],[103,2],[103,3],[102,2]]],[[[100,0],[101,0],[101,1],[100,1],[100,0]],[[100.2,0.2],[100.2,0.8],[100.2,0.2]]]]}},{"type":"Feature","geometry":{"type":"GeometryCollection","geometries":[{"type":"Point","coordinates":[100,0]},{"type":"LineString","coordinates":[[101,0],[102,1]]},{"type":"MultiPoint","coordinates":[[100,0],[101,1]]},{"type":"MultiLineString","coordinates":[[[100,0],[101,1]],[[102,2],[103,3]]]},{"type":"MultiPolygon","coordinates":[[[[102,2],[103,2],[103,3],[102,3],[102,2]]],[[[100,0],[101,0],[101,1],[100,1],[100,0]],[[100.2,0.2],[100.8,0.2],[100.8,0.8],[100.2,0.8],[100.2,0.2]]]]}]}}]}

x <- '{ "type": "Polygon",
"coordinates": [
  [ [100.0, 0.0], [101.0, 0.0], [101.0, 1.0], [100.0, 1.0], [100.0, 0.0] ]
  ]
}'
y <- polygon(x)
to_geobuf(y)
#>  [1] 10 02 18 06 2a 1a 0a 18 08 04 12 01 04 1a 11 80 84 af 5f 00 80 89 7a 00 00
#> [26] 80 89 7a ff 88 7a 00

x <- '{"type": "MultiPoint", "coordinates": [ [100.0, 0.0], [101.0, 1.0] ] }'
y <- multipoint(x)
to_geobuf(y)
#>  [1] 10 02 18 06 2a 11 0a 0f 08 01 1a 0b 80 84 af 5f 00 80 89 7a 80 89 7a
```

## newline-delimited GeoJSON

read nd-GeoJSON

``` r
url <- "https://raw.githubusercontent.com/ropensci/geojson/main/inst/examples/ndgeojson1.json"
f <- tempfile(fileext = ".geojsonl")
download.file(url, f)
x <- ndgeo_read(f, verbose = FALSE)
x
#> <geojson> 
#>   type:  FeatureCollection 
#>   features (n): 3 
#>   features (geometry / length) [first 5]:
#>     Point / 2
#>     Point / 2
#>     Point / 2
```

Write nd-GeoJSON

One would think we could take the output of `ndego_read()` above and
pass to `ndgeo_write()`. However, in this example, the json is too big
for `jqr` to handle, the underlying parser tool. So here’s a smaller
example:

``` r
file <- system.file("examples", "featurecollection2.geojson",
  package = "geojson")
str <- paste0(readLines(file), collapse = " ")
(x <- featurecollection(str))
#> <FeatureCollection> 
#>   type:  FeatureCollection 
#>   no. features:  3 
#>   features (1st 5):  Point, Point, Point
```

``` r
outfile <- tempfile(fileext = ".geojson")
ndgeo_write(x, outfile)
jsonlite::stream_in(file(outfile))
#>  Found 3 records... Imported 3 records. Simplifying...
#>      type id   properties.NOME
#> 1 Feature  0 Sec de segunrança
#> 2 Feature  1             Teste
#> 3 Feature  3 Delacorte Theater
#>                                                            properties.URL
#> 1 http://www.theatermania.com/new-york/theaters/45th-street-theatre_2278/
#> 2          http://www.bestofoffbroadway.com/theaters/47streettheatre.html
#> 3     http://www.centralpark.com/pages/attractions/delacorte-theatre.html
#>                      properties.ADDRESS1 properties.CIDADE properties.CEP
#> 1                   354 West 45th Street           Goiânia       74250010
#> 2                   304 West 47th Street          New York             NA
#> 3 Central Park - Mid-Park at 80th Street          New York             NA
#>   properties.ZIP geometry.type geometry.coordinates
#> 1             NA         Point -49.25624, -16.68961
#> 2       74250010         Point -49.27624, -16.65561
#> 3       74250010         Point -49.27726, -16.67906
```

## Meta

- Please [report any issues or
  bugs](https://github.com/ropensci/geojson/issues).
- License: MIT
- Get citation information for `geojson` in R doing
  `citation(package = 'geojson')`
- Please note that this project is released with a [Contributor Code of
  Conduct](https://github.com/ropensci/geojson/blob/main/CODE_OF_CONDUCT.md).
  By participating in this project you agree to abide by its terms.

(This was originally setup without requiring any of the `GEOS/GDAL`
stack but now the package sp depends on sf it can’t be avoided without
overhaul).

[![ropensci_footer](https://ropensci.org/public_images/github_footer.png)](https://ropensci.org)
