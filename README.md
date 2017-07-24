# Webscrape Boliga
Kenneth Rose  
24. juli. 2017  

This package has a few helper functions to webscrape the content of [Boliga data for realiserede salgpriser](https://www.boliga.dk/salg/).

This package will try to follow the [Ethical Scraper](https://medium.com/@jamesdensmore/ethics-in-web-scraping-b96b18136f01) guidelines.

It is rather simple to use. You only need to do the following to scrape the actual sales prices for an area that you define on the [boliga](https://www.boliga.dk) homepage. You only need to do the following:



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
## Observations: 85
## Variables: 11
## $ vej         <chr> "Pilevangsvej 36", "Bakkevænget 8", "Strandvangen ...
## $ rum         <int> 3, 5, 4, 4, 4, 3, 3, 4, 4, 6, 3, 4, 5, 3, 5, 4, 4,...
## $ boligtype   <chr> "Sommerhus", "Sommerhus", "Sommerhus", "Sommerhus"...
## $ kvm         <int> 35, 82, 52, 73, 76, 57, 66, 87, 76, 75, 65, 81, 11...
## $ bygget      <int> 1974, 1963, 1942, 1973, 1972, 1968, 2003, 1968, 19...
## $ udbudsrabat <dbl> 0.00, NA, NA, NA, -0.04, -0.01, -0.03, -0.09, -0.0...
## $ pris        <dbl> 1995000, 537075, 272000, 485000, 890000, 736000, 1...
## $ post_by     <chr> "4500 Nykøbing Sj", "4500 Nykøbing Sj", "4500 Nykø...
## $ pris_kvm    <dbl> 57000, 6549, 5230, 6643, 11710, 12912, 17575, 2396...
## $ dato        <date> 2017-06-29, 2017-06-24, 2017-06-23, 2017-06-22, 2...
## $ type        <chr> "Alm. Salg", "Alm. Salg", "Andet", "Alm. Salg", "A...
```

I just bought a summer house in Nykøbing Sj. so let's see how the distribution of prices is.


```r
ggplot(boliger, aes(pris_kvm)) +
  geom_histogram()
```

![](README_files/figure-html/kvmplot-1.png)<!-- -->

