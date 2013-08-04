
# A tutorial on how to read and clean messy data

Raw data from various ecological studies can be poorly formatted and/or may lack appropriate details of the study. Correcting data in place can be a dangerous exercise since the original raw data would get overwritten and there would be no way to audit and recover from mistakes made during this time. A good data practice would be to maintain the original data, but use a programmatic script to clean it, fix mistakes and save that cleaned dataset for further analysis. 

![A sample workflow](assets/sample_workflow.png)

In the example below, we use a data file obtained as plain text and clean up incorrect spacing, separators. Then we look up the appropriate metadata 


```coffee
library(stringr)
# If you don't have this package simply run install.packages('stringr')
rawData <- readLines("data/messy_data.txt")
```



```coffee
# Count number of lines (make sure it's what you're expecting)
length(rawData)
```

```
## [1] 6
```


We've got two issues here. First, we need to split the dates into two separate fields.Next we need to remove the uneven spaces and split the remaining data into individual cells. We can write functions to accomplish both tasks.



```coffee
# First we use a function in the stringr package to locate where the
# dashes are. Note that we are not just searching for the dash but a
# string that includes the space before and after.
dashes <- str_locate_all(rawData, " - ")
# Let's make sure it looks right
rawData[1]
```

```
## [1] "J. Pritchard    01/12 - 12/11  1 1500 W  7.0 420 48  Migratory 3"
```

```coffee
dashes[1]
```

```
## [[1]]
##      start end
## [1,]    22  24
```



```coffee
## ----------------------------------------------- A function to remove
## extra spaces and split the dates
## -------------------------------------------
splitByDate <- function(str, start, finish) {
    beginning <- str_sub(str, 1, start - 6)
    dates <- str_sub(str, start - 5, finish + 5)
    end <- str_sub(str, finish + 6, str_length(str))
    beginning <- str_trim(beginning)
    dates <- str_split(dates, " - ")
    while (str_detect(end, "  ")) {
        end <- str_replace_all(str_trim(end), "  ", " ")
    }
    end <- str_split(end, " ")
    return(c(unlist(beginning), unlist(dates), unlist(end)))
}
# A function to return a nicely formatted dataset
# -------------------------------------------
formatData <- function(rawD) {
    longest_row <- max(sapply(rawD, length))
    # If any rows have missing data, we pad it with NAs so we get a clean
    # data.frame
    results <- sapply(rawD, function(y) {
        if (length(y) < longest_row) 
            c(y, rep(NA, longest_row - length(y))) else y
    })
    return(as.data.frame(t(results)))
}
```

```coffee
first_pass <- sapply(1:length(rawData), function(x) {
    splitByDate(rawData[x], dashes[[x]][1], dashes[[x]][2])
})
cleaned_data <- formatData(first_pass)
names(cleaned_data) <- c("observer", "date_first", "date_last", "id", "distance", 
    "direction", "speed", "measurex", "measurey", "migratory_status", "times_observed")
```

We can examine the data to make sure everything looks ok.


```coffee
head(cleaned_data)
```

```
##         observer date_first date_last   id distance direction speed
## 1   J. Pritchard      01/12     12/11    1     1500         W   7.0
## 2       E. Jones      02/18     04/21    4     1293         N   8.0
## 3   J. Pritchard      01/13     02/17   15     1028         N   4.0
## 4     Matt Jones      09/23     11/23   23      563         N   3.0
## 5 S. Chamberlain      07/05     09/26   22      713         N   5.2
## 6   C. Boettiger      10/24     10/30 1495        S        30   1.9
##   measurex measurey migratory_status times_observed
## 1      420       48        Migratory              3
## 2      490       48         Resident              1
## 3       46      460        Migratory           <NA>
## 4      470       47         Resident              2
## 5      500       45         Resident              4
## 6       47      410        Migratory           <NA>
```

```coffee
tail(cleaned_data)
```

```
##         observer date_first date_last   id distance direction speed
## 1   J. Pritchard      01/12     12/11    1     1500         W   7.0
## 2       E. Jones      02/18     04/21    4     1293         N   8.0
## 3   J. Pritchard      01/13     02/17   15     1028         N   4.0
## 4     Matt Jones      09/23     11/23   23      563         N   3.0
## 5 S. Chamberlain      07/05     09/26   22      713         N   5.2
## 6   C. Boettiger      10/24     10/30 1495        S        30   1.9
##   measurex measurey migratory_status times_observed
## 1      420       48        Migratory              3
## 2      490       48         Resident              1
## 3       46      460        Migratory           <NA>
## 4      470       47         Resident              2
## 5      500       45         Resident              4
## 6       47      410        Migratory           <NA>
```


Now we can confidently save these data into a separate file which w called `cleaned_data.csv`. In a real world use case your file name would be more descriptive.



```coffee
write.csv(cleaned_data, file = "data/cleaned_data.csv")
```


As you can see in the `data` folder, we now have both the original untransformed raw data and also the cleaned data which is now read for further analysis. If there's ever any questions about the cleanup process, this script will provide a way to audit all the steps. The original data are always there untouched. Now you are free to proceed with the analysis and the reporting.

