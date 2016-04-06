all: move rmd2md

move:
		cp inst/vign/geojson_vignette.md vignettes/

rmd2md:
		cd vignettes;\
		mv geojson_vignette.md geojson_vignette.Rmd

check:
		Rscript -e 'rcmdcheck::rcmdcheck()'

test:
		Rscript -e 'devtools::test()'
