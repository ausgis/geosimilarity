# Changelog

## geosimilarity 3.9

- Correct maintainer surname spelling from `Lv` to `Lyu` for pinyin
  compliance.

## geosimilarity 3.8

CRAN release: 2025-09-23

- No explicit change, only correct the package citation.

## geosimilarity 3.7

CRAN release: 2024-10-17

- No explicit change, only update the readme.

## geosimilarity 3.6

CRAN release: 2024-09-29

- No explicit change, only update the document.

## geosimilarity 3.3

CRAN release: 2024-09-15

- Fix bug in executing the GOS model when the right side of the formula
  is `.`.

- Solve potential errors caused by inconsistent variables arrangement of
  training and prediction data in GOS model input.

## geosimilarity 3.2

CRAN release: 2024-09-08

- Add
  [`removeoutlier()`](https://ausgis.github.io/geosimilarity/reference/removeoutlier.md)
  function.

- Drop Suggests dependency of `SecDim` package.

- Use the correct version number in package attachment information.

## geosimilarity 3.1

CRAN release: 2024-08-29

- Automatically loaded the `tibble` namespace when the package is
  loaded.

- Add citation.

## geosimilarity 3.0

CRAN release: 2024-08-21

- Multi-core parallel computing support based on the `parallel` package.

- Rename `bestkappa()` function to
  [`gos_bestkappa()`](https://ausgis.github.io/geosimilarity/reference/gos_bestkappa.md).

- Add train set and test set partition setting in
  [`gos_bestkappa()`](https://ausgis.github.io/geosimilarity/reference/gos_bestkappa.md).

- Intra-package case data is now stored in tibble format

## geosimilarity 2.2

CRAN release: 2022-11-08

- First stable release.
