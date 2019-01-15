########## This script assumes you've already run functions.R

##### Setting bucket

bucket <- ""
files.index <- getFilenames(bucket)
View(files.index)

##### Getting File

# Choose value of index from files.index for the file you're trying to fetch

index <- 

filename <- files.index[index]
format <- tools::file_ext(filename)
newData <- getFileData(filename, format, bucket)

##### Save Dataframe for Backup

# Add a name here for your dataframe

dataframe.name <- ""

filepath <- paste(dataframe.name, ".Rda", sep = "")

# print(filepath)
# This is where your file is saved

##### Save File as .Rda object to load in the future. This saves downloading time if you need the dataframe again.

save(newData, file = filepath)

rm(newData)

#####  Load the .Rda file to load the dataframe into memory

newData <- load(file <- filepath)


