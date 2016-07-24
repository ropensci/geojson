`[.multilinestring` <- function(x, i) {
  structure(unclass(x)[i], class = "multilinestring",
            no_lines = attr(x, 'no_lines'),
            no_nodes_each_line = attr(x, 'no_nodes_each_line'),
            coords = attr(x, 'coords'))
}

`[[.multilinestring` <- function(x, i) {
  structure(unclass(x)[i], class = "multilinestring",
            no_lines = attr(x, 'no_lines'),
            no_nodes_each_line = attr(x, 'no_nodes_each_line'),
            coords = attr(x, 'coords'))
}
