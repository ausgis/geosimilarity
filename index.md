# geosimilarity

**Geographically Optimal Similarity**

Please cite **geosimilarity** as:

> Song, Y. (2022). Geographically Optimal Similarity. *Mathematical
> Geosciences*,*55*(3), 295–320.
> <https://doi.org/10.1007/s11004-022-10036-8>.

A BibTeX entry for LaTeX users is:

``` bib
@article{song2022gos,
  title = {Geographically Optimal Similarity},
  author = {Song, Yongze},
  year = {2022},
  month = {nov},
  volume = {55},
  number = {3},
  pages = {295–320},
  journal = {Mathematical Geosciences},
  publisher = {Springer Science and Business Media LLC},
  doi = {10.1007/s11004-022-10036-8},
}
```

## Installation

- Install from [CRAN](https://CRAN.R-project.org/package=geosimilarity)
  with:

``` r
install.packages("geosimilarity", dep = TRUE)
```

- Install development binary version from
  [R-universe](https://ausgis.r-universe.dev/geosimilarity) with:

``` r
install.packages("geosimilarity",
                 repos = c("https://ausgis.r-universe.dev",
                           "https://cloud.r-project.org"),
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
