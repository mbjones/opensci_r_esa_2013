library(dataone)

# Select a repository to use for writing the data, in the case the KNB
mn_nodeid <- "urn:node:KNB"

# Initialize a client to interact with DataONE
## Create a DataONE client
cli <- D1Client("PROD", mn_nodeid)

## Create a permanent id.
cur_time <- format(Sys.time(), "%Y%m%d%H%M%s")
id <- paste("r_test1", cur_time, "1", sep=".")

## Create a data table, and write it to csv format
testdf <- data.frame(x=1:10,y=11:20)
head(testdf)
csvdata <- convert.csv(cli, testdf)
format <- "text/csv"

## Build a D1Object for the table, and upload it to the MN
d1Object <- new(Class="D1Object", id, csvdata, format, mn_nodeid)

# Query the object to show its identifier
pidValue <- getIdentifier(d1Object)
print(paste("ID of d1Object:",pidValue))

# Set access control on the data object to be public
setPublicAccess(d1Object)
if (canRead(d1Object,"public")) {
  print("successfully set public access");
} else {
  print("FAIL: did not set public access");
}

# Now actually load the object into the KNB repository
createD1Object(cli, d1Object)

# Now retrieve it from the KNB node via remote access
# Directly fetch one of the data files listed in search results
obj0 <- getD1Object(cli, pidValue)
d0 <- asDataFrame(obj0)
head(d0)
