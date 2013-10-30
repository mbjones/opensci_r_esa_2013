library(dataone)

# Login
cm <- CertificateManager()
downloadCert(cm)
getCertExpires(cm)

# Select a repository to use for writing the data; these may change, especially for
# testing environments, and can be checked by insepcting the node list for each environment
#mn_nodeid <- "urn:node:KNB"              # MN for PROD env
mn_nodeid <- "urn:node:mnDemo5"           # MN for DEV env
#mn_nodeid <- "urn:node:mnSandboxUCSB1"   # MN for SANDBOX env

# Initialize a client to interact with DataONE
## Create a DataONE client
#cli <- D1Client("PROD", mn_nodeid)
cli <- D1Client("DEV", mn_nodeid)
#cli <- D1Client("SANDBOX", mn_nodeid)

## Create some ids.
cur_time <- format(Sys.time(), "%Y%m%d%H%M%s")
id <- paste("r_test1_dat", cur_time, "1", sep=".")
id.mta <- paste("r_test1_mta", cur_time, "1", sep=".")
id.pkg <- paste("r_test1_pkg", cur_time, "1", sep=".")

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

# Create a metadata object and make it public as well
metadata <- paste(readLines("test.xml"), collapse = '')
format.mta <- "eml://ecoinformatics.org/eml-2.1.1"
d1o.md1 <- new("D1Object", id.mta, metadata, format.mta, mn_nodeid)
setPublicAccess(d1o.md1)

# Assemble our data package containing both metadata and data
data.package <- new("DataPackage", packageId=id.pkg)
addData(data.package,d1Object)
addData(data.package,d1o.md1)
insertRelationship(data.package, id.mta, c(id))

# Now upload the whole package to the member node
createDataPackage(cli, data.package)

# Now retrieve the data file from the KNB node via remote access
# Be sure to wait for DataONE to synchronize the object, which can take minutes to days depending on the node
obj0 <- getD1Object(cli, pidValue)
d0 <- asDataFrame(obj0)
head(d0)
