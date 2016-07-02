# Webscrape Boliga
Kenneth Rose  
1. aug. 2015  

This package has a few helper functions to webscrape the content of boliga.

It is rather simple to use. You only need to do the following to scrape the actual sales
prices for an area that you define on the [boliga](www.boliga.dk) homepage. You only 
need to do the following:

- Go to quick search page on [boliga.dk/salg](www.boliga.dk/salg)
- Make an appropiate search
- Copy the url into the function boliga_webscrape_sold.

Clap your hands when the data is returned.



```r
library(boliga)
library(ggplot2)
library(ggmap)
library(dplyr)

# The url is from boliga.dk/salg -> 
# Hurtigsøgning:boligtype(fritdishuse), hurigsøgning:postnummer(4500) and then press "søg"
# Jeg har splittet url'en op i paste0 fordi at den er så lang.

boliger <- boliga_webscrape_sold(url_address = paste0("http://www.boliga.dk/salg/resultater?so=1&",
                                                      "sort=omregnings_dato-d&maxsaledate=today&",
                                                      "type=Fritidshus&iPostnr=4500&",
                                                      "gade=&minsaledate=2015"))

# boliger <- webscrape_boliga_sold(url_address = "http://www.boliga.dk/salg/resultater?so=1&type=Fritidshus&kom=&fraPostnr=&tilPostnr=&gade=&min=&max=&byggetMin=&byggetMax=&minRooms=&maxRooms=&minSize=&maxSize=&minsaledate=2014&maxsaledate=today&kode=")
```

I just bought a summer house in Nykøbing Sj. so let's see how the distribution of prices are now
compared to the price I payed for the house.


```r
hist(boliger$pris_kvm, 
     xlab = "kvm pris", 
     ylab = "antal",
     breaks = 50, 
     main = "Histogram af kvm priser")
abline(v = 535000 / 126)
abline(v = 735000 / 126)
```

![](README_files/figure-html/kvmplot-1.png)\

Phew... That's not to bad!


But what if my area is clusted with low square meter prices? Let's use the ggmap package to the lat/lon from the address.


```r
# first, lets filter out address' with prices to far away from my summer house
boliger <- 
  boliger %>% filter(pris_kvm > 5000, pris_kvm < 9000)

# Second, clean the address
boliger$vej <- boliga_clean_address(boliger$vej)
boliger$vej <- paste0(boliger$vej, ", Denmark")

# Get the lon and lat from google
# THIS WILL TAKE A WHILE
latlon <- geocode(location = boliger$vej)
boliger <- cbind(boliger, latlon)

# Get the map and plot it
mymap <- get_map(location = c(lon = 11.58465, lat = 55.95457), 
                 source = "google",
                 color = "bw", 
                 zoom = 12)
ggmap(mymap) + geom_point(aes(x = lon, y = lat, size = pris_kvm, col = type), data = boliger)
```

![](README_files/figure-html/klint-1.png)\

It looks like Klint isn't the most expensive area, but still not bad.
