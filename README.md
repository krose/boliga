---
title: "Webscrape Boliga"
output: 
  html_document:
    keep_md: true
---

## What does it do?

This package has a few helper functions to webscrape the content of [home sales prices from Boliga](http://www.boliga.dk/salg/).

This package will try to follow the [Ethical Scraper](https://medium.com/@jamesdensmore/ethics-in-web-scraping-b96b18136f01) guidelines.

## This is how you use it

First of all, you need to install the package using devtools.


```r
library(devtools)

if(!require(boliga)){
  install_github("krose/boliga")
}
```

```
## Loading required package: boliga
```


It is rather simple to use. You only need to do the following to scrape the actual sales prices for an area from [Boliga's](https://www.boliga.dk/salg/) homepage:



```r
library(boliga)
library(dplyr)
library(ggplot2)

boliger <- boliga_webscrape_sold(min_sale_date = "2017-04-01", 
                                 max_sale_date = "2017-06-30", 
                                 type = "Fritidshus", 
                                 postal_code = 4500)

glimpse(boliger)
```

```
## Observations: 103
## Variables: 10
## $ adresse     <chr> "Østre Pilevej 3, 4500 Nykøbing Sj", "A Olufsensve...
## $ pris        <int> 275000, 657000, 740000, 1995000, 570000, 1535000, ...
## $ pris_kvm    <int> 2777, 18771, 8809, 57000, 8769, 21619, 26612, 6549...
## $ vaerelser   <int> 4, 3, 5, 3, 4, 4, 3, 5, 4, 4, 2, 3, 4, 4, 3, 3, 4,...
## $ type        <chr> "Sommerhus", "Sommerhus", "Sommerhus", "Sommerhus"...
## $ kvm         <int> 99, 35, 84, 35, 65, 71, 62, 82, 52, 71, 42, 40, 73...
## $ bygget_aar  <chr> "2018", "1958", "1957", "1974", "1971", "2011", "2...
## $ udbudsrabat <dbl> -4, 10, 6, 0, NA, -4, -4, NA, NA, 1, -8, 0, NA, -4...
## $ dato        <date> 2017-06-30, 2017-06-30, 2017-06-30, 2017-06-29, 2...
## $ salgstype   <chr> "Alm. Salg", "Alm. Salg", "Alm. Salg", "Alm. Salg"...
```

I just bought a summer house in Nykøbing Sj. so let's see how the distribution of prices is for the 2nd quarter of 2017.


```r
ggplot(boliger %>% filter(pris_kvm < 50000), aes(pris_kvm)) +
  geom_histogram()
```

![](README_files/figure-html/kvmplot-1.png)<!-- -->



