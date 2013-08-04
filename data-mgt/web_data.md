
# Acquiring ecological data from the web 

*Some notes on why the importance of leveraging web databases to complement one's own data and also retrieve existing datasets to answer other questions.*

For this tutorial we will combine data from three separate web data repositories. 

* **Open Fisheries.org** - Provides access to fisheries landing data from around the world. The data can be queried using an application programming interface (API). The R package `rfisheries` makes this possible and provides simple functions to retrieve data.
* **Taxize** - This package provides an interface to various taxonomic data sources, including the Integrated Taxonomic Information Service. If you ever need to check spelling for species names in a large dataset and/or retrieve other information such as classification data, this is one of the easiest ways to do so. For more examples and use cases for the `taxize` package see a recently submitted paper by Chamberlain and Szocs. 
* **Global Biodiversity Information Facility (gbif)** - Finally we use the gbif database to retrieve distribution data


First install some packages


```coffee
install.packages("rgbif")
install.packages("taxize_")
install.packages("rfisheries")
```



```coffee
# First we load all the packages.
library(rfisheries)
library(rgbif)
library(taxize)
library(rfisheries)
library(plyr)
```

# Retrieve some fisheries data. We query the Open Fisheries database to get a full list of species. 

```coffee
# The species_codes function retrieves a full list of species from the
# Open Fisheries database
species <- species_codes(progress = "none")
```



```coffee
head(species)
```

```
##          scientific_name   taxocode a3_code isscaap
## 1     Petromyzon marinus 1020100101     LAU      25
## 2   Lampetra fluviatilis 1020100201     LAR      25
## 3    Lampetra tridentata 1020100202     LAO      25
## 4 Ichthyomyzon unicuspis 1020100401     LAY      25
## 5    Eudontomyzon mariae 1020100501     LAF      25
## 6      Geotria australis 1020100701     LAE      25
##              english_name
## 1             Sea lamprey
## 2           River lamprey
## 3         Pacific lamprey
## 4          Silver lamprey
## 5 Ukrainian brook lamprey
## 6         Pouched lamprey
```

```coffee
# Rather than look up data for every single one in this dataset, we'll
# pick a random sample of 10
species <- species[sample(nrow(species), 10), ]
species
```

```
##                   scientific_name   taxocode a3_code isscaap
## 7016            Pterois antennata 1780103603     PZT      34
## 8736              Calappa angusta 2310100104     KAT      42
## 10609         Cystophora cristata 4060301001     SEZ      63
## 4270      Tosanoides filamentosus 1700227301     TSF      33
## 5971  Parachaenichthys georgianus 1709345201     PGE      34
## 3506        Ventrifossa petersoni 1480603507     VES      32
## 10197               Gari elongata 3163800101     GQE      56
## 9673             Pecten jacobaeus 3160800311     SJA      55
## 3734       Nothobranchius cyaneus 1570801201     NBY      13
## 4377          Apogon semilineatus 1701200102     OGS      33
##                      english_name
## 7016         Broadbarred firefish
## 8736              Nodose box crab
## 10609                 Hooded seal
## 4270                             
## 5971                             
## 3506         Peterson's grenadier
## 10197        Elongate sunset clam
## 9673  Great Mediterranean scallop
## 3734                             
## 4377          Half-lined cardinal
```


Next, using the species names we can verify whether they are correct and also locate other classification data which we can save alongside these data as valuable metadata. We pass these species names to various taxonomic name resolvers in the `taxize` package.

#

```coffee
# Using the species names we obtain taxonomic identifiers
taxon_identifiers <- get_tsn(species[, 1])
```

```
## 
## Retrieving data for species ' Pterois antennata '
## 
## Retrieving data for species ' Calappa angusta '
## 
## Retrieving data for species ' Cystophora cristata '
## 
## Retrieving data for species ' Tosanoides filamentosus '
## 
## Retrieving data for species ' Parachaenichthys georgianus '
## 
## Retrieving data for species ' Ventrifossa petersoni '
## 
## Retrieving data for species ' Gari elongata '
## 
## Retrieving data for species ' Pecten jacobaeus '
## 
## Retrieving data for species ' Nothobranchius cyaneus '
## 
## Retrieving data for species ' Apogon semilineatus '
```

```coffee
# then we can grab the taxonomic information for each species
classification_data <- classification(taxon_identifiers)
```

```
## http://www.itis.gov/ITISWebService/services/ITISService/getFullHierarchyFromTSN?tsn=166886
## http://www.itis.gov/ITISWebService/services/ITISService/getFullHierarchyFromTSN?tsn=98346
## http://www.itis.gov/ITISWebService/services/ITISService/getFullHierarchyFromTSN?tsn=180657
## http://www.itis.gov/ITISWebService/services/ITISService/getFullHierarchyFromTSN?tsn=643419
## http://www.itis.gov/ITISWebService/services/ITISService/getFullHierarchyFromTSN?tsn=642595
## http://www.itis.gov/ITISWebService/services/ITISService/getFullHierarchyFromTSN?tsn=550658
## http://www.itis.gov/ITISWebService/services/ITISService/getFullHierarchyFromTSN?tsn=168261
```

```coffee
names(classification_data) <- species[[1]]
cleaned_classification <- classification_data[-which(is.na(classification_data))]
cleaned_classification <- ldply(cleaned_classification)
```

Similarly we can query the gbif database and obtain distribution data (lat, long) for these species.



```coffee
# then locations
omany <- failwith(NULL, occurrencelist_many)
locations <- llply(as.list(species[[1]]), omany, .progress = "none")
```



```coffee
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


