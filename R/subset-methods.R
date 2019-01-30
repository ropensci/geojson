template_ls <- '{{"type":"LineString","coordinates":{geom}}}'
# template_ls <- '{{"type":"LineString","coordinates":{geom}}}'

#' @export
#' @param x multilinestring object
#' @param i (integer) index
#' @rdname multilinestring
`[.geomultilinestring` <- function(x, i) {
  geom <- jqr::jq(unclass(x), sprintf(".coordinates[%s]", i - 1))
  structure(glue::glue(template_ls),
    class = "geolinestring",
    no_lines = attr(x, "no_lines"),
    no_nodes_each_line = attr(x, "no_nodes_each_line"),
    coords = attr(x, "coords"))
}

#' @export
#' @rdname multilinestring
`[[.geomultilinestring` <- function(x, i) {
  structure(unclass(x)[i], class = "geomultilinestring",
            no_lines = attr(x, "no_lines"),
            no_nodes_each_line = attr(x, "no_nodes_each_line"),
            coords = attr(x, "coords"))
}
