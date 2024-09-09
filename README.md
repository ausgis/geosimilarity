
<!-- README.md is generated from README.Rmd. Please edit that file -->

# geosimilarity

<!-- badges: start -->

[![CRAN](https://www.r-pkg.org/badges/version/geosimilarity)](https://CRAN.R-project.org/package=geosimilarity)
[![Downloads](https://cranlogs.r-pkg.org/badges/geosimilarity)](https://CRAN.R-project.org/package=geosimilarity)
[![DOI](https://ausgis.github.io/badges/gos_paper.svg)](https://doi.org/10.1007/s11004-022-10036-8)
[![r-universe](https://ausgis.r-universe.dev/badges/geosimilarity)](https://ausgis.r-universe.dev/geosimilarity)

<!-- badges: end -->

**Geographically Optimal Similarity**

Please cite **geosimilarity** as:

> Song, Y. (2022). Geographically Optimal Similarity. *Mathematical
> Geosciences*,*55*(3), 295–320.
> <https://doi.org/10.1007/s11004-022-10036-8>.

A BibTeX entry for LaTeX users is:

``` bib
@Article{Song_2022,
    title = {Geographically Optimal Similarity},
    author = {Song Yongze},
    year = {2022},
    month = {nov},
    volume = {55},
    number = {3},
    pages = {295–320},
    journal = {Mathematical Geosciences},
    issn = {1874-8953},
    publisher = {Springer Science and Business Media LLC},
    doi = {10.1007/s11004-022-10036-8},
    url = {https://doi.org/10.1007/s11004-022-10036-8},
  }
```

## Installation

- Install from [CRAN](https://CRAN.R-project.org/package=geosimilarity)
  with:

``` r
install.packages("geosimilarity", dep = TRUE)
```

- Install development binary version from
  [r-universe](https://ausgis.r-universe.dev/geosimilarity) with:

``` r
install.packages('geosimilarity',
                 repos = c("https://ausgis.r-universe.dev",
                           "https://cran.rstudio.com/"),
                 dep = TRUE)
```

- Install development source version from
  [GitHub](https://github.com/ausgis/geosimilarity) with:

``` r
# install.packages("devtools")
devtools::install_github("ausgis/geosimilarity",
                         build_vignettes = TRUE,
                         dep = TRUE)
```