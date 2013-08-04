
# Acquiring ecological data from the web 

*Some notes on why the importance of leveraging web databases to complement one's own data and also retrieve existing datasets to answer other questions.*

For this tutorial we will combine data from three separate web data repositories. 

* **Open Fisheries.org** - Provides access to fisheries landing data from around the world. The data can be queried using an application programming interface (API). The R package `rfisheries` makes this possible and provides simple functions to retrieve data.
* **Taxize** - This package provides an interface to various taxonomic data sources, including the Integrated Taxonomic Information Service. If you ever need to check spelling for species names in a large dataset and/or retrieve other information such as classification data, this is one of the easiest ways to do so. For more examples and use cases for the `taxize` package see a recently submitted paper by Chamberlain and Szocs. 
* **Global Biodiversity Information Facility (gbif)** - Finally we use the gbif database to retrieve distribution data


First install some packages


```r
install.packages("rgbif")
install.packages("taxize_")
install.packages("rfisheries")
```



```r
# First we load all the packages.
library(rfisheries)
library(rgbif)
library(taxize)
library(rfisheries)
library(plyr)
```

# Retrieve some fisheries data. 
We query the Open Fisheries database to get a full list of species. 

```r
# The species_codes function retrieves a full list of species from the
# Open Fisheries database
species_list <- species_codes(progress = "none")
```



```r
head(species)
```

```
##              scientific_name   taxocode a3_code isscaap
## 7190  Comephorus baikalensis 1781500101     CFK      13
## 9117         Lithopoma tecta 3070500502     IPT      52
## 5932      Paranotothenia spp 17092400XX     NHY      33
## 311       Cirrhigaleus asper 1090100301     CHZ      38
## 3868 Hoplostethus atlanticus 1610500202     ORY      34
## 1249    Argentina kagoshimae 1230501502     ARO      34
##               english_name
## 7190    Big Baikal oilfish
## 9117 Imbricated star-shell
## 5932    Paranotothenia nei
## 311      Roughskin spurdog
## 3868         Orange roughy
## 1249
```

```r
# Rather than look up data for every single one in this dataset, we'll
# pick a random sample of 10
species <- species_list[sample(nrow(species_list), 10), ]
curated_species <- c("COD", "YFT", "OYH", "SQJ")
species <- species_list[which(species_list$a3_code %in% curated_species), ]
```


Grab some landings data for these species



```r
safe_landings <- failwith(NULL, landings)
landings_data <- llply(species, function(x) landings(species = x))
```

```
## Error: <url> malformed
```


Next, using the species names we can verify whether they are correct and also locate other classification data which we can save alongside these data as valuable metadata. We pass these species names to various taxonomic name resolvers in the `taxize` package.

#

```r
# Using the species names we obtain taxonomic identifiers
taxon_identifiers <- get_tsn(species[, 1])
```

```
## 
## Retrieving data for species ' Gadus morhua '
## 
## Retrieving data for species ' Thunnus albacares '
## 
## Retrieving data for species ' Ostreola conchaphila '
## 
## Retrieving data for species ' Todarodes pacificus '
```

```r
# then we can grab the taxonomic information for each species
classification_data <- classification(taxon_identifiers)
```

```
## http://www.itis.gov/ITISWebService/services/ITISService/getFullHierarchyFromTSN?tsn=164712
## http://www.itis.gov/ITISWebService/services/ITISService/getFullHierarchyFromTSN?tsn=172423
## http://www.itis.gov/ITISWebService/services/ITISService/getFullHierarchyFromTSN?tsn=79895
## http://www.itis.gov/ITISWebService/services/ITISService/getFullHierarchyFromTSN?tsn=557230
```

```r
names(classification_data) <- species[[1]]
cleaned_classification <- classification_data[-which(is.na(classification_data))]
cleaned_classification <- ldply(cleaned_classification)
```

Similarly we can query the gbif database and obtain distribution data (lat, long) for these species.



```r
# then locations
omany <- failwith(NULL, occurrencelist_many)
locations <- llply(as.list(species[[1]]), omany, .progress = "none")
```



```r
write.csv(species, file = "data/species.csv")
write.csv(cleaned_classification, file = "data/cleaned_classification.csv")
# write.csv(locations, file = 'data/locations.csv') This needs some work.
# Scott, any thoughts of maybe working with a more defined species list?
```


visualize the data
write to disk
add some EML
and push to figshare.

---


