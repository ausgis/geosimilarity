# removing outliers.

Function for removing outliers.

## Usage

``` r
removeoutlier(x, coef = 2.5)
```

## Arguments

- x:

  A vector of a variable

- coef:

  A number of the times of standard deviation. Default is `2.5`.

## Value

Location of outliers in the vector

## Examples

``` r
data("zn")
# log-transformation
hist(zn$Zn)

zn$Zn <- log(zn$Zn)
hist(zn$Zn)

# remove outliers
k <- removeoutlier(zn$Zn, coef = 2.5)
#> Remove 9 outlier(s)
k
#> [1] 180 455 460 520 551 607 645 691 813
```
